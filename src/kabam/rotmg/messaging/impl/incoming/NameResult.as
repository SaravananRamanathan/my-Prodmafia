package kabam.rotmg.messaging.impl.incoming {
    import flash.utils.IDataInput;
    
    public class NameResult extends IncomingMessage {
        
        
        public function NameResult(packetType: uint, callback: Function) {
            super(packetType, callback);
        }
        public var success_: Boolean;
        public var errorText_: String;
        
        override public function parseFromInput(param1: IDataInput): void {
            this.success_ = param1.readBoolean();
            this.errorText_ = param1.readUTF();
        }
        
        override public function toString(): String {
            return formatToString("NAMERESULT", "success_", "errorText_");
        }
    }
}
