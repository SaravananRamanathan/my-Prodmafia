package io.decagames.rotmg.pets.data.vo {
    import com.company.assembleegameclient.objects.ObjectLibrary;
    
    import org.osflash.signals.Signal;
    
    public class AbilityVO {
        
        
        public const updated: Signal = new Signal(AbilityVO);
        
        public function AbilityVO() {
            super();
        }
        
        public var level: int;
        public var points: int;
        public var name: String;
        public var description: String;
        private var _staticData: XML;
        private var unlocked: Boolean;
        
        private var _type: uint;
        
        public function set type(_arg_1: uint): void {
            this._type = _arg_1;
            this._staticData = ObjectLibrary.getPetDataXMLByType(this._type);
            this.name = this._staticData.DisplayId == undefined ? this._staticData.@id : this._staticData.DisplayId;
            this.description = this._staticData.Description;
        }
        
        public function setUnlocked(_arg_1: Boolean): void {
            this.unlocked = _arg_1;
        }
        
        public function getUnlocked(): Boolean {
            return this.unlocked;
        }
        
        public function clone(): AbilityVO {
            var _local1: AbilityVO = new AbilityVO();
            _local1.type = this._type;
            _local1.level = this.level;
            _local1.points = this.points;
            _local1.setUnlocked(this.getUnlocked());
            return _local1;
        }
        
        public function toString(): String {
            return "[AbilityVO] Name: " + this.name + ", level:" + this.level + ", unlocked? " + (!this.getUnlocked() ? "no" : "yes");
        }
    }
}
