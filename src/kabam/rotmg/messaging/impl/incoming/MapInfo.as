package kabam.rotmg.messaging.impl.incoming {
    import flash.utils.ByteArray;
    import flash.utils.IDataInput;
    
    public class MapInfo extends IncomingMessage {
        
        public function MapInfo(packetType: uint, callback: Function) {
            this.clientXML_ = new Vector.<String>();
            this.extraXML_ = new Vector.<String>();
            super(packetType, callback);
        }
        public var width_: int;
        public var height_: int;
        public var name_: String;
        public var displayName_: String;
        public var realmName_: String;
        public var difficulty_: int;
        public var fp_: uint;
        public var background_: int;
        public var allowPlayerTeleport_: Boolean;
        public var showDisplays_: Boolean;
        public var maxPlayers_: int;
        public var clientXML_: Vector.<String>;
        public var extraXML_: Vector.<String>;
        public var connectionGuid_: String;
        public var gameOpenedTime_: int;
        
        override public function parseFromInput(param1: IDataInput): void {
            this.parseProperties(param1);
            this.parseXML(param1);
        }
        
        override public function toString(): String {
            return formatToString("MAPINFO", "width_", "height_", "name_", "displayName_", "realmName_", "fp_", "background_", "allowPlayerTeleport_", "showDisplays_", "clientXML_", "extraXML_", "maxPlayers_", "connectionGuid_", "gameOpenedTime_");
        }
        
        public function createHash(): ByteArray {
            var _local1: ByteArray = new ByteArray();
            return _local1;
        }
        
        private function parseProperties(packet: IDataInput): void {
            this.width_ = packet.readInt();
            this.height_ = packet.readInt();
            this.name_ = packet.readUTF();
            this.displayName_ = packet.readUTF();
            this.realmName_ = packet.readUTF();
            this.fp_ = packet.readUnsignedInt();
            this.background_ = packet.readInt();
            this.difficulty_ = packet.readInt();
            this.allowPlayerTeleport_ = packet.readBoolean();
            this.showDisplays_ = packet.readBoolean();
            this.maxPlayers_ = packet.readShort();
            this.connectionGuid_ = packet.readUTF();
            this.gameOpenedTime_ = packet.readUnsignedInt();
        }
        
        private function parseXML(packet: IDataInput): void {
            var length: int = 0;
            var counter: int = 0;
            var size: int = 0;
            length = packet.readShort();
            this.clientXML_.length = 0;
            counter = 0;
            while (counter < length) {
                size = packet.readInt();
                this.clientXML_.push(packet.readUTFBytes(size));
                counter++;
            }
            length = packet.readShort();
            this.extraXML_.length = 0;
            counter = 0;
            while (counter < length) {
                size = packet.readInt();
                this.extraXML_.push(packet.readUTFBytes(size));
                counter++;
            }
        }
    }
}
