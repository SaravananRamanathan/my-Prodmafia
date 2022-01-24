package kabam.lib.net.impl {
import flash.utils.IDataInput;
import flash.utils.IDataOutput;

public class Message {

    public var pool:MessagePool;
    public var prev:Message;
    public var next:Message;
    public var id:uint;
    public var callback:Function;
    private var isCallback:Boolean;

    public function Message(packetId: uint, callback: Function = null) {
        super();
        this.id = packetId;
        this.isCallback = callback != null;
        this.callback = callback;
    }

    public function parseFromInput(input: IDataInput) : void {
    }

    public function writeToOutput(input: IDataInput) : void {
    }

    public function toString() : String {
        return this.formatToString("MESSAGE", "id");
    }

    public function consume() : void {
        this.isCallback && this.callback(this);
        this.prev = null;
        this.next = null;
        this.pool.append(this);
    }

    protected function formatToString(message: String, ...args) : String {
        var counter: int = 0;
        var newString: String = "[" + message;
        var argLen: uint = args.length;

        while (counter < argLen) {
            newString = newString + (" " + args[counter] + "=\"" + this[args[counter]] + "\"");
            counter++;
        }
        return newString + "]";
    }
}
}
