package kabam.rotmg.messaging.impl.incoming {
    import flash.utils.IDataInput;
    
    public class ExaltationUpdate extends IncomingMessage {
        
        public function ExaltationUpdate(param1: uint, param2: Function) {
            super(param1, param2);
        }
        private var objType: int;
        private var attackProgress: int;
        private var defenseProgress: int;
        private var speedProgress: int;
        private var dexterityProgress: int;
        private var vitalityProgress: int;
        private var wisdomProgress: int;
        private var healthProgress: int;
        private var manaProgress: int;
        
        override public function parseFromInput(param1: IDataInput): void {
            this.objType = param1.readShort();
            this.dexterityProgress = param1.readByte();
            this.speedProgress = param1.readByte();
            this.vitalityProgress = param1.readByte();
            this.wisdomProgress = param1.readByte();
            this.defenseProgress = param1.readByte();
            this.attackProgress = param1.readByte();
            this.manaProgress = param1.readByte();
            this.healthProgress = param1.readByte();
        }
        
        override public function toString(): String {
            return formatToString("EXALTATION_UPDATE", "objType", "attackProgress", "defenseProgress", "speedProgress", "dexterityProgress", "vitalityProgress", "wisdomProgress", "healthProgress", "manaProgress");
        }
    }
}
