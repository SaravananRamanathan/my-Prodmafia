package io.decagames.rotmg.pets.data.vo {
    import com.company.assembleegameclient.objects.ObjectLibrary;
    
    import io.decagames.rotmg.pets.data.PetsModel;
    import io.decagames.rotmg.pets.data.rarity.PetRarityEnum;
    import io.decagames.rotmg.pets.data.skin.PetSkinRenderer;
    
    import kabam.rotmg.core.StaticInjectorContext;
    
    import org.osflash.signals.Signal;
    
    public class PetVO extends PetSkinRenderer implements IPetVO {
        
        
        public static function clone(_arg_1: PetVO): PetVO {
            return new PetVO(_arg_1.id);
        }
        
        private static function getPetDataDescription(_arg_1: int): String {
            return ObjectLibrary.getPetDataXMLByType(_arg_1).Description;
        }
        
        private static function getPetDataDisplayId(_arg_1: int): String {
            return ObjectLibrary.getPetDataXMLByType(_arg_1).@id;
        }
        
        public function PetVO(_arg_1: int = undefined) {
            _abilityList = [new AbilityVO(), new AbilityVO(), new AbilityVO()];
            _updated = new Signal();
            _abilityUpdated = new Signal();
            super();
            this.id = _arg_1;
            this.staticData = <data/>
            ;
            this.listenToAbilities();
        }
        
        private var staticData: XML;
        private var id: int;
        private var type: int;
        
        private var _rarity: PetRarityEnum;
        
        public function get rarity(): PetRarityEnum {
            return this._rarity;
        }
        
        private var _name: String;
        
        public function get name(): String {
            return this._name;
        }
        
        private var _maxAbilityPower: int;
        
        public function get maxAbilityPower(): int {
            return this._maxAbilityPower;
        }
        
        private var _abilityList: Array;
        
        public function get abilityList(): Array {
            return this._abilityList;
        }
        
        public function set abilityList(_arg_1: Array): void {
            this._abilityList = _arg_1;
        }
        
        private var _updated: Signal;
        
        public function get updated(): Signal {
            return this._updated;
        }
        
        private var _abilityUpdated: Signal;
        
        public function get abilityUpdated(): Signal {
            return this._abilityUpdated;
        }
        
        private var _ownedSkin: Boolean;
        
        public function get ownedSkin(): Boolean {
            return this._ownedSkin;
        }
        
        public function set ownedSkin(_arg_1: Boolean): void {
            this._ownedSkin = _arg_1;
        }
        
        private var _family: String = "";
        
        public function get family(): String {
            var _local1: SkinVO = this.skinVO;
            if (_local1) {
                return _local1.family;
            }
            return this.staticData.Family;
        }
        
        public function get totalMaxAbilitiesLevel(): int {
            var _local2: * = null;
            var _local1: int = 0;
            var _local4: int = 0;
            var _local3: * = this._abilityList;
            for each(_local2 in this._abilityList) {
                if (_local2.getUnlocked()) {
                    _local1 = _local1 + this._maxAbilityPower;
                }
            }
            return _local1;
        }
        
        public function get skinVO(): SkinVO {
            return StaticInjectorContext.getInjector().getInstance(PetsModel).getSkinVOById(_skinType);
        }
        
        public function get skinType(): int {
            return _skinType;
        }
        
        public function get isOwned(): Boolean {
            return false;
        }
        
        public function get isNew(): Boolean {
            return false;
        }
        
        public function set isNew(_arg_1: Boolean): void {
        }
        
        public function maxedAvailableAbilities(): Boolean {
            var _local1: * = null;
            var _local3: int = 0;
            var _local2: * = this._abilityList;
            for each(_local1 in this._abilityList) {
                if (_local1.getUnlocked() && _local1.level < this.maxAbilityPower) {
                    return false;
                }
            }
            return true;
        }
        
        public function totalAbilitiesLevel(): int {
            var _local2: * = null;
            var _local1: int = 0;
            var _local4: int = 0;
            var _local3: * = this._abilityList;
            for each(_local2 in this._abilityList) {
                if (_local2.getUnlocked() && _local2.level) {
                    _local1 = _local1 + _local2.level;
                }
            }
            return _local1;
        }
        
        public function maxedAllAbilities(): Boolean {
            var _local2: * = null;
            var _local1: int = 0;
            var _local4: int = 0;
            var _local3: * = this._abilityList;
            for each(_local2 in this._abilityList) {
                if (_local2.getUnlocked() && _local2.level == this.maxAbilityPower) {
                    _local1++;
                }
            }
            return _local1 == this._abilityList.length;
        }
        
        public function apply(_arg_1: XML): void {
            this.extractBasicData(_arg_1);
            this.extractAbilityData(_arg_1);
        }
        
        public function extractAbilityData(_arg_1: XML): void {
            var _local2: int = 0;
            var _local4: * = null;
            var _local3: int = 0;
            var _local5: uint = this._abilityList.length;
            _local2 = 0;
            while (_local2 < _local5) {
                _local4 = this._abilityList[_local2];
                _local3 = _arg_1.Abilities.Ability[_local2].@type;
                _local4.name = getPetDataDisplayId(_local3);
                _local4.description = getPetDataDescription(_local3);
                _local4.level = _arg_1.Abilities.Ability[_local2].@power;
                _local4.points = _arg_1.Abilities.Ability[_local2].@points;
                _local2++;
            }
        }
        
        public function setID(_arg_1: int): void {
            this.id = _arg_1;
        }
        
        public function getID(): int {
            return this.id;
        }
        
        public function setType(_arg_1: int): void {
            this.type = _arg_1;
            this.staticData = ObjectLibrary.xmlLibrary_[this.type];
        }
        
        public function getType(): int {
            return this.type;
        }
        
        public function setRarity(_arg_1: uint): void {
            this._rarity = PetRarityEnum.selectByOrdinal(_arg_1);
            this.unlockAbilitiesBasedOnPetRarity(_arg_1);
            switch (this._rarity) {
            case PetRarityEnum.COMMON:
                this._maxAbilityPower = 30;
                break;
            case PetRarityEnum.UNCOMMON:
                this._maxAbilityPower = 50;
                break;
            case PetRarityEnum.RARE:
                this._maxAbilityPower = 70;
                break;
            case PetRarityEnum.LEGENDARY:
                this._maxAbilityPower = 90;
                break;
            case PetRarityEnum.DIVINE:
                this._maxAbilityPower = 100;
                break;
            }
            this._updated.dispatch();
        }
        
        public function setName(_arg_1: String): void {
            this._name = ObjectLibrary.typeToDisplayId_[_skinType];
            if (this._name == null || this._name == "") {
                this._name = ObjectLibrary.typeToDisplayId_[this.getType()];
            }
            this._updated.dispatch();
        }
        
        public function setMaxAbilityPower(_arg_1: int): void {
            this._maxAbilityPower = _arg_1;
            this._updated.dispatch();
        }
        
        public function setSkin(_arg_1: int): void {
            _skinType = _arg_1;
            this._updated.dispatch();
        }
        
        public function setFamily(_arg_1: String): void {
            this._family = _arg_1;
        }
        
        private function listenToAbilities(): void {
            var _local1: * = null;
            var _local3: int = 0;
            var _local2: * = this._abilityList;
            for each(_local1 in this._abilityList) {
                _local1.updated.add(this.onAbilityUpdate);
            }
        }
        
        private function onAbilityUpdate(_arg_1: AbilityVO): void {
            this._updated.dispatch();
            this._abilityUpdated.dispatch();
        }
        
        private function extractBasicData(_arg_1: XML): void {
            _arg_1.@instanceId && this.setID(_arg_1.@instanceId);
            _arg_1.@type && this.setType(_arg_1.@type);
            _arg_1.@skin && this.setSkin(_arg_1.@skin);
            _arg_1.@name && this.setName(_arg_1.@name);
            _arg_1.@rarity && this.setRarity(_arg_1.@rarity);
        }
        
        private function unlockAbilitiesBasedOnPetRarity(_arg_1: uint): void {
            this._abilityList[0].setUnlocked(true);
            this._abilityList[1].setUnlocked(_arg_1 >= PetRarityEnum.UNCOMMON.ordinal);
            this._abilityList[2].setUnlocked(_arg_1 >= PetRarityEnum.LEGENDARY.ordinal);
        }
    }
}
