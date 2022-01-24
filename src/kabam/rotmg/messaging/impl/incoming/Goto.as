package kabam.rotmg.messaging.impl.incoming {
    import flash.utils.IDataInput;
    
    import kabam.rotmg.messaging.impl.data.WorldPosData;
    
    public class Goto extends IncomingMessage {
        
        
        public function Goto(packetType: uint, callback: Function) {
            this.pos_ = new WorldPosData();
            super(packetType, callback);
        }
        public var objectId_: int;
        public var pos_: WorldPosData;
        
        override public function parseFromInput(packet: IDataInput): void {
            this.objectId_ = packet.readInt();
            this.pos_.parseFromInput(packet);
        }
        
        override public function toString(): String {
            return formatToString("GOTO", "objectId_", "pos_");
        }
    }
}
