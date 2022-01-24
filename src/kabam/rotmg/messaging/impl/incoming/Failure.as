package kabam.rotmg.messaging.impl.incoming {
    import flash.utils.IDataInput;
    
    public class Failure extends IncomingMessage {
        
        public static const INCORRECT_VERSION: int = 4;
        
        public static const BAD_KEY: int = 5;
        
        public static const INVALID_TELEPORT_TARGET: int = 6;
        
        public static const EMAIL_VERIFICATION_NEEDED: int = 7;
        
        public static const TELEPORT_REALM_BLOCK: int = 9;
        
        public static const WRONG_SERVER_ENTERED: int = 10;
        
        //todo: implement exalt style server queueing
        public static const SERVER_QUEUE_FULL: int = 15;
        
        //todo: implement packet rate limit fail checks
        public static const PACKET_RATE_LIMIT: int = 16;
        
        public static const OTHER_FAIL: int = 0;
        
        public function Failure(param1: uint, param2: Function) {
            super(param1, param2);
        }
        public var errorId_: int;
        public var errorDescription_: String;
        public var errorPlace_: String;
        public var errorConnectionId_: String;
        
        override public function parseFromInput(packet: IDataInput): void {
            this.errorId_ = packet.readInt();
            this.errorDescription_ = packet.readUTF();
            this.errorPlace_ = packet.readUTF();
            this.errorConnectionId_ = packet.readUTF();
        }
        
        override public function toString(): String {
            return formatToString("FAILURE", "errorId_", "errorDescription_", "errorPlace_", "errorConnectionId_");
        }
    }
}
