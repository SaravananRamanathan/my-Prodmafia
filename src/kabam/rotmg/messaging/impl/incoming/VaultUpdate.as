package kabam.rotmg.messaging.impl.incoming {
    import flash.utils.IDataInput;
    
    import kabam.rotmg.messaging.impl.data.CompressedInt;
    
    public class VaultUpdate extends IncomingMessage {
        
        public function VaultUpdate(param1: uint, param2: Function) {
            this.vaultContents = new Vector.<int>();
            this.giftContents = new Vector.<int>();
            this.potionContents = new Vector.<int>();
            super(param1, param2);
        }
        public var vaultContents: Vector.<int>;
        public var giftContents: Vector.<int>;
        public var potionContents: Vector.<int>;
        public var vaultUpgradeCost: int;
        public var potionUpgradeCost: int;
        public var currentPotionMax: int;
        public var nextPotionMax: int;
        
        override public function parseFromInput(packet: IDataInput): void {
            trace(CompressedInt.Read(packet));
            trace(CompressedInt.Read(packet));
            trace(CompressedInt.Read(packet));
            trace(CompressedInt.Read(packet));
            
            var _loc3_: int = CompressedInt.Read(packet);
            var counter: int = 0;
            while (counter < _loc3_) {
                this.vaultContents.push(CompressedInt.Read(packet));
                counter++;
            }
            var _loc5_: int = CompressedInt.Read(packet);
            counter = 0;
            while (counter < _loc5_) {
                this.giftContents.push(CompressedInt.Read(packet));
                counter++;
            }
            var _loc2_: int = CompressedInt.Read(packet);
            counter = 0;
            while (counter < _loc2_) {
                this.potionContents.push(CompressedInt.Read(packet));
                counter++;
            }
            this.vaultUpgradeCost = packet.readShort();
            this.potionUpgradeCost = packet.readShort();
            this.currentPotionMax = packet.readShort();
            this.nextPotionMax = packet.readShort();
        }
        
        override public function toString(): String {
            return formatToString("VAULT_UPDATE", "vaultContents", "giftContents", "potionContents", "vaultUpgradeCost", "potionUpgradeCost", "currentPotionMax", "nextPotionMax");
        }
    }
}
