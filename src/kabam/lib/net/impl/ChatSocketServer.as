package kabam.lib.net.impl {
import com.hurlant.crypto.symmetric.ICipher;

import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.events.TimerEvent;
import flash.net.Socket;
import flash.utils.ByteArray;
import flash.utils.Timer;

import kabam.lib.net.api.MessageProvider;

import org.osflash.signals.Signal;

public class ChatSocketServer {

    public static const MESSAGE_LENGTH_SIZE_IN_BYTES:int = 4;
    public const chatConnected:Signal = new Signal();
    public const chatClosed:Signal = new Signal();
    public const chatError:Signal = new Signal(String);
    private const unsentPlaceholder:Message = new Message(0);
    private const data:ByteArray = new ByteArray();
    [Inject]
    public var messages:MessageProvider;
    [Inject]
    public var chatSocket:Socket;
    [Inject]
    public var chatSocketServerModel:ChatSocketServerModel;
    public var delayTimer:Timer;
    private var head:Message;
    private var tail:Message;
    private var messageLen:int = -1;
    private var outgoingCipher:ICipher;
    private var incomingCipher:ICipher;
    private var server:String;
    private var port:int;
    private var _isConnecting:Boolean;

    public function ChatSocketServer() {
        head = unsentPlaceholder;
        tail = unsentPlaceholder;
        super();
    }

    public function set isConnecting(toggle: Boolean):void {
        this._isConnecting = toggle;
    }

    public function setOutgoingCipher(cipher: ICipher):ChatSocketServer {
        this.outgoingCipher = cipher;
        return this;
    }

    public function setIncomingCipher(cipher: ICipher):ChatSocketServer {
        this.incomingCipher = cipher;
        return this;
    }

    public function connect(server: String, port: int):void {
        this.server = server;
        this.port = port;
        if (!this.chatSocket.hasEventListener("connect")) {
            this.addListeners();
        }
        this.messageLen = -1;
        if (this.chatSocketServerModel.connectDelayMS) {
            this.connectWithDelay();
        } else {
            this.chatSocket.connect(server, port);
        }
    }

    public function dispose():void {
        if (this.delayTimer) {
            this.delayTimer.stop();
            this.delayTimer.removeEventListener("timerComplete", this.onTimerComplete);
        }
        this.removeListeners();
        if (this.chatSocket) {
            this.chatSocket.close();
            this.chatSocket = null;
        }
    }

    public function chatDisconnect():void {
        if (this.chatSocket) {
            this.chatSocket.close();
            this.removeListeners();
        }
        this.chatClosed.dispatch();
    }

    public function sendMessage(packet: Message):void {
        this.tail.next = packet;
        this.tail = packet;
    }

    public function isChatConnected():Boolean {
        return this.chatSocket.connected;
    }

    private function addListeners():void {
        this.chatSocket.addEventListener("connect", this.onConnect);
        this.chatSocket.addEventListener("close", this.onClose);
        this.chatSocket.addEventListener("socketData", this.onSocketData);
        this.chatSocket.addEventListener("ioError", this.onIOError);
        this.chatSocket.addEventListener("securityError", this.onSecurityError);
    }

    private function connectWithDelay():void {
        this.delayTimer = new Timer(this.chatSocketServerModel.connectDelayMS, 1);
        this.delayTimer.addEventListener("timerComplete", this.onTimerComplete);
        this.delayTimer.start();
    }

    private function removeListeners():void {
        this.chatSocket.removeEventListener("connect", this.onConnect);
        this.chatSocket.removeEventListener("close", this.onClose);
        this.chatSocket.removeEventListener("socketData", this.onSocketData);
        this.chatSocket.removeEventListener("ioError", this.onIOError);
        this.chatSocket.removeEventListener("securityError", this.onSecurityError);
    }

    private function sendPendingMessages():void {
        var packet: Message = this.head.next;
        var packetRef: * = packet;
        while (packetRef) {
            this.data.clear();
            packetRef.writeToOutput(this.data);
            this.data.position = 0;
            if (this.outgoingCipher != null) {
                this.outgoingCipher.encrypt(this.data);
                this.data.position = 0;
            }
            this.chatSocket.writeInt(this.data.bytesAvailable + 5);
            this.chatSocket.writeByte(packet.id);
            this.chatSocket.writeBytes(this.data);
            packetRef.consume();
            packetRef = packetRef.next;
        }
        this.chatSocket.flush();
        this.unsentPlaceholder.next = null;
        this.unsentPlaceholder.prev = null;
        var nullPacket: * = this.unsentPlaceholder;
        this.tail = nullPacket;
        this.head = nullPacket;
    }

    private function logErrorAndClose(_arg_1:String, _arg_2:Array = null):void {
        this.chatError.dispatch(this.parseString(_arg_1, _arg_2));
        this.chatDisconnect();
    }

    private function parseString(_arg_1:String, _arg_2:Array):String {
        var _local3:int = 0;
        var _local4:int = _arg_2.length;
        while (_local3 < _local4) {
            _arg_1 = _arg_1.replace("{" + _local3 + "}", _arg_2[_local3]);
            _local3++;
        }
        return _arg_1;
    }

    private function onTimerComplete(event: TimerEvent):void {
        this.delayTimer.removeEventListener("timerComplete", this.onTimerComplete);
        this.chatSocket.connect(this.server, this.port);
    }

    private function onConnect(event: Event):void {
        this.sendPendingMessages();
        this.chatConnected.dispatch();
    }

    private function onClose(event: Event):void {
        if (!this._isConnecting) {
            this.chatClosed.dispatch();
        }
    }

    private function onIOError(error: IOErrorEvent):void {
        var errorMsg: String = this.parseString("[Chat] Socket-Server IO Error: {0}", [error.text]);
        this.chatError.dispatch(errorMsg);
        this.chatClosed.dispatch();
    }

    private function onSecurityError(error: SecurityErrorEvent):void {
        var errorMsg: String = this.parseString("[Chat] Socket-Server Security: {0}. Please open port 2050 in your firewall and/or router settings and try again", [error.text]);
        this.chatError.dispatch(errorMsg);
        this.chatClosed.dispatch();
    }

    private function onSocketData(event: ProgressEvent = null):void {
        var firstByte: * = 0;
        var packet: * = null;
        var byteArray:* = null;

        for (; !(this.chatSocket == null || !this.chatSocket.connected); packet.consume()) {
            if (this.messageLen == -1) {
                if (this.chatSocket.bytesAvailable >= 4) {
                    try {
                        this.messageLen = this.chatSocket.readInt();
                    } catch (e: Error) {
                        var errorMsg: String = parseString("[Chat] Socket-Server Data Error: {0}: {1}", [e.name, e.message]);
                        chatError.dispatch(errorMsg);
                        messageLen = -1;
                        return;
                    }
                }
                break;
            }

            if (this.chatSocket.bytesAvailable >= this.messageLen - 4) {
                firstByte = uint(this.chatSocket.readUnsignedByte());
                packet = this.messages.require(firstByte);
                byteArray = new ByteArray();

                if (this.messageLen - 5 > 0) {
                    this.chatSocket.readBytes(byteArray, 0, this.messageLen - 5);
                }
                byteArray.position = 0;

                if (this.incomingCipher != null) {
                    this.incomingCipher.decrypt(byteArray);
                    byteArray.position = 0;
                }
                this.messageLen = -1;

                if (packet == null) {
                    this.logErrorAndClose("[Chat] Socket-Server Protocol Error: Unknown message");
                    return;
                }

                try {
                    packet.parseFromInput(byteArray);
                    packet.consume();
                    continue;
                } catch (error: Error) {
                    logErrorAndClose("[Chat] Socket-Server Protocol Error: {0}", [error.toString()]);
                    return;
                }
                packet.consume();
                continue;
            }
            break;
        }
    }
}
}
