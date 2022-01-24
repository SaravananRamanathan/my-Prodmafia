package kabam.rotmg.messaging.impl.incoming {
    import flash.utils.IDataInput;
    
    public class InvitedToGuild extends IncomingMessage {
        
        
        public function InvitedToGuild(packetType: uint, callback: Function) {
            super(packetType, callback);
        }
        public var name_: String;
        public var guildName_: String;
        
        override public function parseFromInput(packet: IDataInput): void {
            this.name_ = packet.readUTF();
            this.guildName_ = packet.readUTF();
        }
        
        override public function toString(): String {
            return formatToString("INVITEDTOGUILD", "name_", "guildName_");
        }
    }
}
