package io.decagames.rotmg.pets.utils {
    import io.decagames.rotmg.pets.data.rarity.PetRarityEnum;
    import io.decagames.rotmg.pets.data.vo.PetVO;
    
    public class FusionCalculator {
        
        private static var ranges: Object = makeRanges();
        
        public static function getStrengthPercentage(_arg_1: PetVO, _arg_2: PetVO): Number {
            var _local4: Number = getRarityPointsPercentage(_arg_1);
            var _local3: Number = getRarityPointsPercentage(_arg_2);
            return average(_local4, _local3);
        }
        
        private static function makeRanges(): Object {
            ranges = {};
            ranges[PetRarityEnum.COMMON.rarityKey] = 30;
            ranges[PetRarityEnum.UNCOMMON.rarityKey] = 20;
            ranges[PetRarityEnum.RARE.rarityKey] = 20;
            ranges[PetRarityEnum.LEGENDARY.rarityKey] = 20;
            return ranges;
        }
        
        private static function average(_arg_1: Number, _arg_2: Number): Number {
            return (_arg_1 + _arg_2) / 2;
        }
        
        private static function getRarityPointsPercentage(_arg_1: PetVO): Number {
            var _local2: int = ranges[_arg_1.rarity.rarityKey];
            var _local4: int = _arg_1.maxAbilityPower - _local2;
            var _local3: int = _arg_1.abilityList[0].level - _local4;
            return _local3 / _local2;
        }
        
        public function FusionCalculator() {
            super();
        }
    }
}
