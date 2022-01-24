package io.decagames.rotmg.pets.utils {
    import flash.utils.Dictionary;
    
    import io.decagames.rotmg.pets.data.rarity.PetRarityEnum;
    
    public class FeedFuseCostModel {
        
        private static const feedCosts: Dictionary = makeFeedDictionary();
        
        private static const fuseCosts: Dictionary = makeFuseDictionary();
        
        public static function getFuseGoldCost(_arg_1: PetRarityEnum): int {
            return !fuseCosts[_arg_1] ? 0 : fuseCosts[_arg_1].gold;
        }
        
        public static function getFuseFameCost(_arg_1: PetRarityEnum): int {
            return !fuseCosts[_arg_1] ? 0 : fuseCosts[_arg_1].fame;
        }
        
        public static function getFeedGoldCost(_arg_1: PetRarityEnum): int {
            return feedCosts[_arg_1].gold;
        }
        
        public static function getFeedFameCost(_arg_1: PetRarityEnum): int {
            return feedCosts[_arg_1].fame;
        }
        
        private static function makeFuseDictionary(): Dictionary {
            var _local1: Dictionary = new Dictionary();
            _local1[PetRarityEnum.COMMON] = {
                "gold": 100,
                "fame": 5 * 60
            };
            _local1[PetRarityEnum.UNCOMMON] = {
                "gold": 4 * 60,
                "fame": 1000
            };
            _local1[PetRarityEnum.RARE] = {
                "gold": 10 * 60,
                "fame": 0xfa0
            };
            _local1[PetRarityEnum.LEGENDARY] = {
                "gold": 30 * 60,
                "fame": 250 * 60
            };
            return _local1;
        }
        
        private static function makeFeedDictionary(): Dictionary {
            var _local1: Dictionary = new Dictionary();
            _local1[PetRarityEnum.COMMON] = {
                "gold": 5,
                "fame": 10
            };
            _local1[PetRarityEnum.UNCOMMON] = {
                "gold": 12,
                "fame": 30
            };
            _local1[PetRarityEnum.RARE] = {
                "gold": 30,
                "fame": 100
            };
            _local1[PetRarityEnum.LEGENDARY] = {
                "gold": 60,
                "fame": 350
            };
            _local1[PetRarityEnum.DIVINE] = {
                "gold": 150,
                "fame": 1000
            };
            return _local1;
        }
        
        public function FeedFuseCostModel() {
            super();
        }
    }
}
