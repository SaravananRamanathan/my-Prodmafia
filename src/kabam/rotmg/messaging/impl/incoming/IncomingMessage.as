package kabam.rotmg.messaging.impl.incoming {
    import flash.utils.IDataInput;
    
    import kabam.lib.net.impl.Message;
    
    public class IncomingMessage extends Message {
        
        public function IncomingMessage(packetType: uint, callback: Function) {
            super(packetType, callback);
        }
        
        override public final function writeToOutput(input: IDataInput): void {
            throw new Error("Client should not send " + id + " messages");
        }
    }
}
