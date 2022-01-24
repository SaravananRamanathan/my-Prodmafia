package io.decagames.rotmg.fame.data {
    import com.company.assembleegameclient.appengine.SavedCharacter;
    
    import io.decagames.rotmg.characterMetrics.tracker.CharactersMetricsTracker;
    import io.decagames.rotmg.fame.data.bonus.FameBonus;
    import io.decagames.rotmg.fame.data.bonus.FameBonusConfig;
    
    import kabam.rotmg.core.model.PlayerModel;
    import kabam.rotmg.ui.model.HUDModel;
    
    public class FameTracker {
        
        
        public function FameTracker() {
            super();
        }
        
        [Inject]
        public var metrics: CharactersMetricsTracker;
        [Inject]
        public var hudModel: HUDModel;
        [Inject]
        public var player: PlayerModel;
        
        public function getCurrentTotalFame(_arg_1: int): TotalFame {
            var _local2: TotalFame = new TotalFame(this.currentFame(_arg_1));
            var _local6: int = this.getCharacterLevel(_arg_1);
            var _local3: int = this.getCharacterType(_arg_1);
            if (this.player.getTotalFame() == 0) {
                _local2.addBonus(this.getFameBonus(_arg_1, 20, _local2.currentFame));
            }
            if (this.metrics.getCharacterStat(_arg_1, 5) == 0) {
                _local2.addBonus(this.getFameBonus(_arg_1, 1, _local2.currentFame));
            }
            if (this.metrics.getCharacterStat(_arg_1, 1) == 0) {
                _local2.addBonus(this.getFameBonus(_arg_1, 2, _local2.currentFame));
            }
            if (this.metrics.getCharacterStat(_arg_1, 2) == 0) {
                _local2.addBonus(this.getFameBonus(_arg_1, 3, _local2.currentFame));
            }
            if (this.metrics.getCharacterStat(_arg_1, 4) == 0) {
                _local2.addBonus(this.getFameBonus(_arg_1, 4, _local2.currentFame));
            }
            if (this.metrics.getCharacterStat(_arg_1, 13) > 0 && this.metrics.getCharacterStat(_arg_1, 14) > 0 && this.metrics.getCharacterStat(_arg_1, 15) > 0 && this.metrics.getCharacterStat(_arg_1, 16) > 0 && this.metrics.getCharacterStat(_arg_1, 17) > 0 && this.metrics.getCharacterStat(_arg_1, 18) > 0 && this.metrics.getCharacterStat(_arg_1, 21) > 0 && this.metrics.getCharacterStat(_arg_1, 22) > 0 && this.metrics.getCharacterStat(_arg_1, 23) > 0 && this.metrics.getCharacterStat(_arg_1, 24) > 0) {
                _local2.addBonus(this.getFameBonus(_arg_1, 5, _local2.currentFame));
            }
            var _local8: int = this.metrics.getCharacterStat(_arg_1, 6);
            var _local5: int = this.metrics.getCharacterStat(_arg_1, 8);
            if (_local8 + _local5 > 0) {
                if (_local5 / (_local8 + _local5) > 0.1) {
                    _local2.addBonus(this.getFameBonus(_arg_1, 6, _local2.currentFame));
                }
                if (_local5 / (_local8 + _local5) > 0.5) {
                    _local2.addBonus(this.getFameBonus(_arg_1, 7, _local2.currentFame));
                }
            }
            if (this.metrics.getCharacterStat(_arg_1, 11) > 0) {
                _local2.addBonus(this.getFameBonus(_arg_1, 8, _local2.currentFame));
            }
            var _local4: int = this.metrics.getCharacterStat(_arg_1, 0);
            var _local7: int = this.metrics.getCharacterStat(_arg_1, 1);
            if (_local7 > 0 && _local4 > 0) {
                if (_local7 / _local4 > 0.25) {
                    _local2.addBonus(this.getFameBonus(_arg_1, 9, _local2.currentFame));
                }
                if (_local7 / _local4 > 0.5) {
                    _local2.addBonus(this.getFameBonus(_arg_1, 10, _local2.currentFame));
                }
                if (_local7 / _local4 > 0.75) {
                    _local2.addBonus(this.getFameBonus(_arg_1, 11, _local2.currentFame));
                }
            }
            if (this.metrics.getCharacterStat(_arg_1, 3) > 1000000) {
                _local2.addBonus(this.getFameBonus(_arg_1, 12, _local2.currentFame));
            }
            if (this.metrics.getCharacterStat(_arg_1, 3) > 4000000) {
                _local2.addBonus(this.getFameBonus(_arg_1, 13, _local2.currentFame));
            }
            if (this.metrics.getCharacterStat(_arg_1, 10) == 0) {
                _local2.addBonus(this.getFameBonus(_arg_1, 14, _local2.currentFame));
            }
            if (this.metrics.getCharacterStat(_arg_1, 19) > 100) {
                _local2.addBonus(this.getFameBonus(_arg_1, 18, _local2.currentFame));
            }
            if (this.metrics.getCharacterStat(_arg_1, 19) > 1000) {
                _local2.addBonus(this.getFameBonus(_arg_1, 19, _local2.currentFame));
            }
            if (this.metrics.getCharacterStat(_arg_1, 12) > 1000) {
                _local2.addBonus(this.getFameBonus(_arg_1, 21, _local2.currentFame));
            }
            _local2.addBonus(this.getWellEquippedBonus(this.getCharacterFameBonus(_arg_1), _local2.currentFame));
            if (_local2.currentFame > this.player.getBestCharFame()) {
                _local2.addBonus(this.getFameBonus(_arg_1, 16, _local2.currentFame));
            }
            return _local2;
        }
        
        public function currentFame(_arg_1: int): int {
            var _local3: int = this.metrics.getCharacterStat(_arg_1, 20);
            var _local4: int = this.getCharacterExp(_arg_1);
            var _local2: int = this.getCharacterLevel(_arg_1);
            if (this.hasMapPlayer()) {
                _local4 = _local4 + (_local2 - 1) * (_local2 - 1) * 50;
            }
            return this.calculateBaseFame(_local4, _local3);
        }
        
        public function calculateBaseFame(_arg_1: int, _arg_2: int): int {
            var _local3: * = 0;
            _local3 = _local3 + Math.max(0, Math.min(20000, _arg_1)) * 0.001;
            _local3 = _local3 + Math.max(0, Math.min(0xb090, _arg_1) - 20000) * 0.002;
            _local3 = _local3 + Math.max(0, Math.min(80000, _arg_1) - 45200) * 0.003;
            _local3 = _local3 + Math.max(0, Math.min(101200, _arg_1) - 80000) * 0.002;
            _local3 = _local3 + Math.max(0, _arg_1 - 101200) * 0.0005;
            _local3 = _local3 + Math.min(Math.floor(_arg_2 / 6), 30);
            return Math.floor(_local3);
        }
        
        private function getFameBonus(_arg_1: int, _arg_2: int, _arg_3: int): FameBonus {
            var _local5: FameBonus = FameBonusConfig.getBonus(_arg_2);
            var _local4: int = this.getCharacterLevel(_arg_1);
            if (_local4 < _local5.level) {
                return null;
            }
            _local5.fameAdded = Math.floor(_local5.added * _arg_3 / 100 + _local5.numAdded);
            return _local5;
        }
        
        private function getWellEquippedBonus(_arg_1: int, _arg_2: int): FameBonus {
            var _local3: FameBonus = FameBonusConfig.getBonus(22);
            _local3.fameAdded = Math.floor(_arg_1 * _arg_2 / 100);
            return _local3;
        }
        
        private function hasMapPlayer(): Boolean {
            return this.hudModel.gameSprite && this.hudModel.gameSprite.map && this.hudModel.gameSprite.map.player_;
        }
        
        private function getSavedCharacter(_arg_1: int): SavedCharacter {
            return this.player.getCharacterById(_arg_1);
        }
        
        private function getCharacterExp(_arg_1: int): int {
            if (this.hasMapPlayer()) {
                return this.hudModel.gameSprite.map.player_.exp_;
            }
            return this.getSavedCharacter(_arg_1).xp();
        }
        
        private function getCharacterLevel(_arg_1: int): int {
            if (this.hasMapPlayer()) {
                return this.hudModel.gameSprite.map.player_.level_;
            }
            return this.getSavedCharacter(_arg_1).level();
        }
        
        private function getCharacterType(_arg_1: int): int {
            if (this.hasMapPlayer()) {
                return this.hudModel.gameSprite.map.player_.objectType_;
            }
            return this.getSavedCharacter(_arg_1).objectType();
        }
        
        private function getCharacterFameBonus(_arg_1: int): int {
            if (this.hasMapPlayer()) {
                return this.hudModel.gameSprite.map.player_.getFameBonus();
            }
            return this.getSavedCharacter(_arg_1).fameBonus();
        }
    }
}
