package kabam.lib.net.impl {
import com.company.assembleegameclient.parameters.Parameters;
import com.hurlant.crypto.symmetric.ICipher;

import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.events.TimerEvent;
import flash.net.Socket;
import flash.utils.ByteArray;
import flash.utils.Timer;
import flash.utils.clearInterval;
import flash.utils.setInterval;

import kabam.lib.net.api.MessageProvider;
import kabam.rotmg.account.core.Account;
import kabam.rotmg.appengine.api.AppEngineClient;
import kabam.rotmg.core.StaticInjectorContext;

import org.osflash.signals.Signal;

public class SocketServer {

    public static const MESSAGE_LENGTH_SIZE_IN_BYTES:int = 4;
    public const connected:Signal = new Signal();
    public const closed:Signal = new Signal();
    public const error:Signal = new Signal(String);
    private const unsentPlaceholder:Message = new Message(0);
    private const data:ByteArray = new ByteArray();
    [Inject]
    public var messages:MessageProvider;
    [Inject]
    public var socket:Socket;
    [Inject]
    public var socketServerModel:SocketServerModel;
    public var delayTimer:Timer;
    private var head:Message;
    private var tail:Message;
    private var messageLen:int = -1;
    private var outgoingCipher:ICipher;
    private var incomingCipher:ICipher;
    private var server:String;
    private var port:int;
    private var previousSendFL:int;
    private var previousRecvFL:int;
    private var currSendIV:uint;
    private var currRecvIV:int;

    public function SocketServer() {
        this.head = this.unsentPlaceholder;
        this.tail = this.unsentPlaceholder;
        super();
    }

    public function setOutgoingCipher(cipher: ICipher):SocketServer {
        this.outgoingCipher = cipher;
        return this;
    }

    public function setIncomingCipher(cipher: ICipher):SocketServer {
        this.incomingCipher = cipher;
        return this;
    }

    public function connect(address: String, port: int) : void {
        this.server = address;
        this.port = port;
        this.addListeners();
        this.messageLen = -1;
        if (this.socketServerModel.connectDelayMS) {
            this.connectWithDelay();
        } else {
            this.socket.connect(address, port);
        }
    }

    public function disconnect() : void {
        try {
            this.socket.close();
        }
        catch (error:Error) { }
        this.removeListeners();
        this.closed.dispatch();
    }

    public function isConnected() : Boolean {
        return this.socket.connected;
    }

    private function addListeners() : void {
        this.socket.addEventListener(Event.CONNECT, this.onConnect);
        this.socket.addEventListener(Event.CLOSE, this.onClose);
        this.socket.addEventListener(ProgressEvent.SOCKET_DATA, this.socketBuffer);
        this.socket.addEventListener(IOErrorEvent.IO_ERROR, this.onIOError);
        this.socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onSecurityError);
    }

    private function removeListeners() : void {
        this.socket.removeEventListener(Event.CONNECT, this.onConnect);
        this.socket.removeEventListener(Event.CLOSE, this.onClose);
        this.socket.removeEventListener(ProgressEvent.SOCKET_DATA, this.socketBuffer);
        this.socket.removeEventListener(IOErrorEvent.IO_ERROR, this.onIOError);
        this.socket.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onSecurityError);
    }

    private function socketBuffer(event: Event) : void {
        if(this.previousSendFL == Parameters.data.fakeLag) {
            if(Parameters.data.fakeLag == 0) {
                this.onSocketData(null);
            }
            return;
        }

        if(this.currRecvIV != 0) {
            clearInterval(this.currRecvIV);
        }

        if(Parameters.data.fakeLag != 0) {
            this.currRecvIV = setInterval(this.onSocketData,Parameters.data.fakeLag);
        }
        this.previousRecvFL = Parameters.data.fakeLag;
    }

    private function connectWithDelay() : void {
        this.delayTimer = new Timer(this.socketServerModel.connectDelayMS, 1);
        this.delayTimer.addEventListener(TimerEvent.TIMER_COMPLETE, this.onTimerComplete);
        this.delayTimer.start();
    }

    private function onTimerComplete(timer: TimerEvent) : void {
        this.delayTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, this.onTimerComplete);
        this.socket.connect(this.server, this.port);
    }

    public function sendMessage(packet: Message) : void {
        if(!Parameters.data.noClip) {
            this.tail.next = packet;
            this.tail = packet;
        }

        if(packet.id == 1) {
            this.sendPending(null);
            return;
        }

        if(this.previousSendFL == Parameters.data.fakeLag) {
            if(Parameters.data.fakeLag == 0) {
                this.sendPending(null);
            }
            return;
        }

        if(this.currSendIV != 0) {
            clearInterval(this.currSendIV);
        }

        if(Parameters.data.fakeLag != 0) {
            this.currSendIV = setInterval(this.sendPending,Parameters.data.fakeLag);
        }
        this.previousSendFL = Parameters.data.fakeLag;
    }

    public function queueMessage(packet: Message) : void {
        if(Parameters.data.noClip) {
            return;
        }
        this.tail.next = packet;
        this.tail = packet;
    }

    private function sendPending(event: Event) : void {
        if(Parameters.data.noClip) {
            return;
        }
        this.socket.connected && this.sendPendingMessages();
    }

    private function sendPendingMessages() : void {
        var temp: Message = this.head.next;
        var msg: Message = temp;

        if (!this.socket.connected) {
            return;
        }

        var i: int = 0;
        while (msg) {
            this.data.position = 0;
            this.data.length = 0;
            msg.writeToOutput(this.data);
            this.data.position = 0;
            if (this.outgoingCipher != null) {
                this.outgoingCipher.encrypt(this.data);
                this.data.position = 0;
            }
            this.socket.writeInt(this.data.bytesAvailable + 5);
            this.socket.writeByte(msg.id);
            this.socket.writeBytes(this.data);
            temp = msg;
            msg = msg.next;
            temp.consume();
            i++;
        }
        if (i > 0) {
            this.socket.flush();
        }
        this.unsentPlaceholder.next = null;
        this.unsentPlaceholder.prev = null;
        this.head = (this.tail = this.unsentPlaceholder);
    }

    private function onConnect(event: Event) : void {
        this.connected.dispatch();
    }

    private function onClose(event: Event) : void {
        this.closed.dispatch();
    }

    private function onSocketData(event: Event) : void {
        var messageId: uint;
        var message: Message;
        var errorMessage: String;

        while (true) {
            if (this.socket == null || !this.socket.connected) break;

            if (this.messageLen == -1) {
                if (this.socket.bytesAvailable < 4) break;

                try {
                    this.messageLen = this.socket.readInt();
                }
                catch (e: Error) {
                    errorMessage = parseString("Socket-Server Data Error: {0}: {1}", [e.name, e.message]);
                    error.dispatch(errorMessage);
                    messageLen = -1;
                    return;
                }
            }
            if (this.socket.bytesAvailable < this.messageLen - MESSAGE_LENGTH_SIZE_IN_BYTES) break;
            messageId = this.socket.readUnsignedByte();
            message = this.messages.require(messageId);
            data.position = 0;
            data.length = 0;
            if (this.messageLen - 5 > 0) {
                this.socket.readBytes(data, 0, this.messageLen - 5);
            }
            data.position = 0;
            if (this.incomingCipher != null) {
                this.incomingCipher.decrypt(data);
                data.position = 0;
            }
            this.messageLen = -1;
            if (message == null) {
                this.logErrorAndClose("Socket-Server Protocol Error: Unknown message");
                return;
            }
            try {
                message.parseFromInput(data);
            }
            catch (error:Error) {
                logErrorAndClose("Socket-Server Protocol Error: {0}", [error.toString()]);
                return;
            }
            message.consume();
            sendPendingMessages();
        }
    }

    private function logErrorAndClose(errorPrefix: String, errMsgs: Array = null) : void {
        this.error.dispatch(this.parseString(errorPrefix, errMsgs));
        this.disconnect();
    }

    private function onIOError(evt:IOErrorEvent) : void {
        var errMsg:String = this.parseString("Socket-Server IO Error: {0}", [evt.text]);
        this.error.dispatch(errMsg);
        this.closed.dispatch();
    }

    private function onSecurityError(evt:SecurityErrorEvent) : void {
        var errMsg:String = this.parseString(
                "Socket-Server Security: {0}. Please open port " + Parameters.PORT +
                " in your firewall and/or router settings and try again", [evt.text]);
        this.error.dispatch(errMsg);
        this.closed.dispatch();
    }

    private function parseString(msgTemplate: String, msgs: Array) : String {
        var numMsgs:int = msgs.length;
        for (var i: int = 0; i < numMsgs; i++) {
            msgTemplate = msgTemplate.replace("{" + i + "}", msgs[i]);
            i++;
        }
        return msgTemplate;
    }
}
}