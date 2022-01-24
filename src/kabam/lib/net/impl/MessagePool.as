package kabam.lib.net.impl {

public class MessagePool {

    public function MessagePool(packetId: int, packetType: Class, callback: Function) {
        super();
        this.type = packetType;
        this.id = packetId;
        this.callback = callback;
    }
    public var type:Class;
    public var callback:Function;
    public var id:int;
    private var tail:Message;
    private var count:int = 0;

    public function populate(amount: int):MessagePool {
        var _local2:Message;
        this.count = (this.count + amount);

        while (amount--) {
            _local2 = new this.type(this.id, this.callback);
            _local2.pool = this;
            ((this.tail) && ((this.tail.next = _local2)));
            _local2.prev = this.tail;
            this.tail = _local2;
        }
        return (this);
    }

    public function require():Message {
        var _local1:Message = this.tail;
        if (_local1) {
            this.tail = this.tail.prev;
            _local1.prev = null;
            _local1.next = null;
        } else {
            _local1 = new this.type(this.id, this.callback);
            _local1.pool = this;
            this.count++;
        }
        return _local1;
    }

    public function getCount():int {
        return this.count;
    }

    public function dispose():void {
        this.tail = null;
    }

    internal function append(packet: Message):void {
        ((this.tail) && ((this.tail.next = packet)));
        packet.prev = this.tail;
        this.tail = packet;
    }
}
}
