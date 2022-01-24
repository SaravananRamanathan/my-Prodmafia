package io.decagames.rotmg.pets.data.ability {
    import io.decagames.rotmg.pets.data.rarity.PetRarityEnum;
    import io.decagames.rotmg.pets.data.vo.IPetVO;
    
    public class AbilitiesUtil {
        
        
        public static function isActiveAbility(_arg_1: PetRarityEnum, _arg_2: int): Boolean {
            if (_arg_1.ordinal >= PetRarityEnum.LEGENDARY.ordinal) {
                return true;
            }
            if (_arg_1.ordinal >= PetRarityEnum.UNCOMMON.ordinal) {
                return _arg_2 <= 1;
            }
            return _arg_2 == 0;
        }
        
        public static function abilityPowerToMinPoints(_arg_1: int): int {
            return Math.ceil(20 * (1 - Math.pow(1.08, _arg_1 - 1)) / -0.0800000000000001);
        }
        
        public static function abilityPointsToLevel(_arg_1: int): int {
            var _local2: Number = _arg_1 * 0.0800000000000001 / 20 + 1;
            return int(Math.log(_local2) / Math.log(1.08)) + 1;
        }
        
        public static function simulateAbilityUpgrade(_arg_1: IPetVO, _arg_2: int): Array {
            var _local3: * = null;
            var _local5: int = 0;
            var _local4: int = 0;
            var _local6: * = [];
            while (_local4 < 3) {
                _local3 = _arg_1.abilityList[_local4].clone();
                if (AbilitiesUtil.isActiveAbility(_arg_1.rarity, _local4) && _local3.level < _arg_1.maxAbilityPower) {
                    _local3.points = _local3.points + _arg_2 * AbilityConfig.ABILITY_INDEX_TO_POINT_MODIFIER[_local4];
                    _local5 = abilityPointsToLevel(_local3.points);
                    if (_local5 > _arg_1.maxAbilityPower) {
                        _local5 = _arg_1.maxAbilityPower;
                        _local3.points = abilityPowerToMinPoints(_local5);
                    }
                    _local3.level = _local5;
                }
                _local6.push(_local3);
                _local4++;
            }
            return _local6;
        }
        
        public function AbilitiesUtil() {
            super();
        }
    }
}
