package kabam.rotmg.messaging.impl.incoming {
    import flash.utils.IDataInput;
    
    public class GuildResult extends IncomingMessage {
        
        public function GuildResult(packetType: uint, callback: Function) {
            super(packetType, callback);
        }
        public var success_: Boolean;
        public var lineBuilderJSON: String;
        
        override public function parseFromInput(param1: IDataInput): void {
            this.success_ = param1.readBoolean();
            this.lineBuilderJSON = param1.readUTF();
        }
        
        override public function toString(): String {
            return formatToString("CREATEGUILDRESULT", "success_", "lineBuilderJSON");
        }
    }
}
