package io.decagames.rotmg.pets.data {
    import com.company.assembleegameclient.appengine.SavedCharacter;
    import com.company.assembleegameclient.map.AbstractMap;
    import com.company.assembleegameclient.objects.ObjectLibrary;
    
    import flash.utils.Dictionary;
    
    import io.decagames.rotmg.pets.data.rarity.PetRarityEnum;
    import io.decagames.rotmg.pets.data.vo.PetVO;
    import io.decagames.rotmg.pets.data.vo.SkinVO;
    import io.decagames.rotmg.pets.data.yard.PetYardEnum;
    import io.decagames.rotmg.pets.signals.NotifyActivePetUpdated;
    import io.decagames.rotmg.seasonalEvent.data.SeasonalEventModel;
    
    import kabam.rotmg.assets.EmbeddedData_PetsCXML;
    import kabam.rotmg.core.model.PlayerModel;
    
    public class PetsModel {
        
        private static var petsDataXML: Class = EmbeddedData_PetsCXML;
        
        public function PetsModel() {
            hash = {};
            pets = new Vector.<PetVO>();
            skins = new Dictionary();
            familySkins = new Dictionary();
            ownedSkinsIDs = new Vector.<int>();
            super();
        }
        
        [Inject]
        public var notifyActivePetUpdated: NotifyActivePetUpdated;
        [Inject]
        public var seasonalEventModel: SeasonalEventModel;
        [Inject]
        public var playerModel: PlayerModel;
        private var petsData: XMLList;
        private var hash: Object;
        private var pets: Vector.<PetVO>;
        private var skins: Dictionary;
        private var familySkins: Dictionary;
        private var yardXmlData: XML;
        private var type: int;
        private var activePet: PetVO;
        private var _wardrobePet: PetVO;
        private var ownedSkinsIDs: Vector.<int>;
        
        private var _totalPetsSkins: int = 0;
        
        public function get totalPetsSkins(): int {
            return this._totalPetsSkins;
        }
        
        private var _activeUIVO: PetVO;
        
        public function get activeUIVO(): PetVO {
            return this._activeUIVO;
        }
        
        public function set activeUIVO(_arg_1: PetVO): void {
            this._activeUIVO = _arg_1;
        }
        
        public function get totalOwnedPetsSkins(): int {
            return this.ownedSkinsIDs.length;
        }
        
        public function destroy(): void {
        }
        
        public function setPetYardType(_arg_1: int): void {
            this.type = _arg_1;
            this.yardXmlData = ObjectLibrary.getXMLfromId(ObjectLibrary.getIdFromType(_arg_1));
        }
        
        public function getPetYardRarity(): uint {
            return PetYardEnum.selectByValue(this.yardXmlData.@id).rarity.ordinal;
        }
        
        public function getPetYardType(): int {
            return !this.yardXmlData ? 1 : PetYardEnum.selectByValue(this.yardXmlData.@id).ordinal;
        }
        
        public function isMapNameYardName(_arg_1: AbstractMap): Boolean {
            return _arg_1.name_ && _arg_1.name_.substr(0, 8) == "Pet Yard";
        }
        
        public function getPetYardUpgradeFamePrice(): int {
            return !!this.seasonalEventModel.isChallenger ? 0 : this.yardXmlData.Fame;
        }
        
        public function getPetYardUpgradeGoldPrice(): int {
            return !!this.seasonalEventModel.isChallenger ? 0 : this.yardXmlData.Price;
        }
        
        public function getPetYardObjectID(): int {
            return this.type;
        }
        
        public function deletePet(_arg_1: int): void {
            var _local2: int = this.getPetIndex(_arg_1);
            if (_local2 >= 0) {
                this.pets.splice(this.getPetIndex(_arg_1), 1);
                if (this._activeUIVO && this._activeUIVO.getID() == _arg_1) {
                    this._activeUIVO = null;
                }
                if (this.activePet && this.activePet.getID() == _arg_1) {
                    this.removeActivePet();
                }
            }
        }
        
        public function clearPets(): void {
            this.hash = {};
            this.pets = new Vector.<PetVO>();
            this.petsData = null;
            this.skins = new Dictionary();
            this.familySkins = new Dictionary();
            this._totalPetsSkins = 0;
            this.ownedSkinsIDs = new Vector.<int>();
            this.removeActivePet();
        }
        
        public function parsePetsData(): void {
            var _local4: * = 0;
            var _local2: int = 0;
            var _local1: * = null;
            var _local3: * = null;
            if (this.petsData == null) {
                this.petsData = XML(new petsDataXML()).Object;
                _local4 = uint(this.petsData.length());
                _local2 = 0;
                while (_local2 < _local4) {
                    _local1 = this.petsData[_local2];
                    if (_local1.hasOwnProperty("PetSkin")) {
                        if (_local1.@type != "0x8090") {
                            _local3 = SkinVO.parseFromXML(_local1);
                            _local3.isOwned = this.ownedSkinsIDs.indexOf(_local3.skinType) >= 0;
                            this.skins[_local3.skinType] = _local3;
                            this._totalPetsSkins++;
                            if (!this.familySkins[_local3.family]) {
                                this.familySkins[_local3.family] = new Vector.<SkinVO>();
                            }
                            this.familySkins[_local3.family].push(_local3);
                        }
                    }
                    _local2++;
                }
            }
        }
        
        public function unlockSkin(_arg_1: int): void {
            this.skins[_arg_1].isNew = true;
            this.skins[_arg_1].isOwned = true;
            if (this.ownedSkinsIDs.indexOf(_arg_1) == -1) {
                this.ownedSkinsIDs.push(_arg_1);
            }
        }
        
        public function getSkinVOById(_arg_1: int): SkinVO {
            return this.skins[_arg_1];
        }
        
        public function hasSkin(_arg_1: int): Boolean {
            return this.ownedSkinsIDs.indexOf(_arg_1) != -1;
        }
        
        public function parseOwnedSkins(_arg_1: XML): void {
            if (_arg_1.toString() != "") {
                this.ownedSkinsIDs = Vector.<int>(_arg_1.toString().split(","));
            }
        }
        
        public function getPetVO(_arg_1: int): PetVO {
            var _local2: * = null;
            if (this.hash[_arg_1] != null) {
                return this.hash[_arg_1];
            }
            _local2 = new PetVO(_arg_1);
            this.pets.push(_local2);
            this.hash[_arg_1] = _local2;
            return _local2;
        }
        
        public function getPetsSkinsFromFamily(_arg_1: String): Vector.<SkinVO> {
            return this.familySkins[_arg_1];
        }
        
        public function getCachedVOOnly(_arg_1: int): PetVO {
            return this.hash[_arg_1];
        }
        
        public function getAllPets(_arg_1: String = "", _arg_2: PetRarityEnum = null): Vector.<PetVO> {
            _arg_1 = _arg_1;
            _arg_2 = _arg_2;
            var param1: String = _arg_1;
            var param2: PetRarityEnum = _arg_2;
            var family: String = param1;
            var rarity: PetRarityEnum = param2;
            var petsList: Vector.<PetVO> = this.pets;
            if (family != "") {
                petsList = petsList.filter(function (param1: PetVO, param2: int, param3: Vector.<PetVO>): Boolean {
                    return param1.family == family;
                });
            }
            if (rarity != null) {
                petsList = petsList.filter(function (param1: PetVO, param2: int, param3: Vector.<PetVO>): Boolean {
                    return param1.rarity == rarity;
                });
            }
            return petsList;
        }
        
        public function addPet(_arg_1: PetVO): void {
            this.pets.push(_arg_1);
        }
        
        public function setActivePet(_arg_1: PetVO): void {
            this.activePet = _arg_1;
            var _local2: SavedCharacter = this.playerModel.getCharacterById(this.playerModel.currentCharId);
            if (_local2) {
                _local2.setPetVO(this.activePet);
            }
            this.notifyActivePetUpdated.dispatch();
        }
        
        public function getActivePet(): PetVO {
            return this.activePet;
        }
        
        public function removeActivePet(): void {
            if (this.activePet == null) {
                return;
            }
            var _local1: SavedCharacter = this.playerModel.getCharacterById(this.playerModel.currentCharId);
            if (_local1) {
                _local1.setPetVO(null);
            }
            this.activePet = null;
            this.notifyActivePetUpdated.dispatch();
        }
        
        public function getPet(_arg_1: int): PetVO {
            var _local2: int = this.getPetIndex(_arg_1);
            if (_local2 == -1) {
                return null;
            }
            return this.pets[_local2];
        }
        
        private function petNodeIsSkin(_arg_1: XML): Boolean {
            return _arg_1.hasOwnProperty("PetSkin");
        }
        
        private function getPetIndex(_arg_1: int): int {
            var _local2: * = null;
            var _local3: int = 0;
            while (_local3 < this.pets.length) {
                _local2 = this.pets[_local3];
                if (_local2.getID() == _arg_1) {
                    return _local3;
                }
                _local3++;
            }
            return -1;
        }
        
        private function selectPetInWardrobe(_arg_1: PetVO): void {
            this._wardrobePet = _arg_1;
        }
    }
}
