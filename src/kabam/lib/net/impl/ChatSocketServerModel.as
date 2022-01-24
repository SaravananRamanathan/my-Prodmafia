package kabam.lib.net.impl {

public class ChatSocketServerModel {

    private var _connectDelayMS:int;
    private var _chatToken:String;
    private var _server:String;
    private var _port:int;

    public function ChatSocketServerModel() {
        super();
    }

    public function get chatToken():String {
        return this._chatToken;
    }

    public function set chatToken(token: String):void {
        this._chatToken = token;
    }

    public function get port():int {
        return this._port;
    }

    public function set port(port: int):void {
        this._port = port;
    }

    public function get server():String {
        return this._server;
    }

    public function set server(serverName: String):void {
        this._server = serverName;
    }

    public function get connectDelayMS():int {
        return this._connectDelayMS == 0 ? 1000 : this._connectDelayMS;
    }

    public function set connectDelayMS(delay: int):void {
        this._connectDelayMS = delay;
    }
}
}
