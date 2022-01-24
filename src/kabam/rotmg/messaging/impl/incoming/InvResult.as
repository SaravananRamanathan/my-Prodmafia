package kabam.rotmg.messaging.impl.incoming {
    import flash.utils.IDataInput;
    
    public class InvResult extends IncomingMessage {
        
        
        public function InvResult(packetType: uint, callback: Function) {
            super(packetType, callback);
        }
        public var result_: int;
        
        override public function parseFromInput(packet: IDataInput): void {
            this.result_ = packet.readInt();
        }
        
        override public function toString(): String {
            return formatToString("INVRESULT", "result_");
        }
    }
}
