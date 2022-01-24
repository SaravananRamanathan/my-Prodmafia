package io.decagames.rotmg.pets.components.petStatsGrid {
    import io.decagames.rotmg.pets.data.vo.AbilityVO;
    import io.decagames.rotmg.pets.data.vo.IPetVO;
    import io.decagames.rotmg.ui.ProgressBar;
    import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
    import io.decagames.rotmg.ui.gird.UIGrid;
    
    public class PetStatsGrid extends UIGrid {
        
        
        public function PetStatsGrid(_arg_1: int, _arg_2: IPetVO) {
            super(_arg_1, 1, 3);
            this.abilityBars = new Vector.<ProgressBar>();
            this._petVO = _arg_2;
            if (_arg_2) {
                this.refreshAbilities(_arg_2);
            }
        }
        
        private var abilityBars: Vector.<ProgressBar>;
        
        private var _petVO: IPetVO;
        
        public function get petVO(): IPetVO {
            return this._petVO;
        }
        
        public function renderSimulation(_arg_1: Array): void {
            var _local3: * = null;
            var _local2: int = 0;
            var _local5: int = 0;
            var _local4: * = _arg_1;
            for each(_local3 in _arg_1) {
                this.renderAbilitySimulation(_local3, _local2);
                _local2++;
            }
        }
        
        public function updateVO(_arg_1: IPetVO): void {
            if (this._petVO != _arg_1) {
                this.abilityBars = new Vector.<ProgressBar>();
                clearGrid();
            }
            this._petVO = _arg_1;
            if (this._petVO != null) {
                this.refreshAbilities(_arg_1);
            }
        }
        
        private function refreshAbilities(_arg_1: IPetVO): void {
            var _local3: * = null;
            var _local2: int = 0;
            var _local5: int = 0;
            var _local4: * = _arg_1.abilityList;
            for each(_local3 in _arg_1.abilityList) {
                this.renderAbility(_local3, _local2);
                _local2++;
            }
        }
        
        private function renderAbilitySimulation(_arg_1: AbilityVO, _arg_2: int): void {
            if (_arg_1.getUnlocked()) {
                this.abilityBars[_arg_2].simulatedValue = _arg_1.level;
            }
        }
        
        private function renderAbility(_arg_1: AbilityVO, _arg_2: int): void {
            var _local3: * = null;
            if (this.abilityBars.length > _arg_2) {
                _local3 = this.abilityBars[_arg_2];
                if (_local3.maxValue != this._petVO.maxAbilityPower && _arg_1.getUnlocked()) {
                    _local3.maxValue = this._petVO.maxAbilityPower;
                    _local3.value = _arg_1.level;
                }
                if (_local3.value != _arg_1.level && _arg_1.getUnlocked()) {
                    _local3.dynamicLabelString = "Lvl. {X}/{M}";
                    _local3.value = _arg_1.level;
                }
            } else {
                _local3 = new ProgressBar(150, 4, _arg_1.name, !_arg_1.getUnlocked() ? "" : "Lvl. {X}/{M}", 0, this._petVO.maxAbilityPower, !_arg_1.getUnlocked() ? 0 : _arg_1.level, 0x545454, 15306295, 6538829);
                _local3.showMaxLabel = true;
                _local3.maxColor = 6538829;
                DefaultLabelFormat.petStatLabelLeft(_local3.staticLabel, 0xffffff);
                DefaultLabelFormat.petStatLabelRight(_local3.dynamicLabel, 0xffffff);
                DefaultLabelFormat.petStatLabelRight(_local3.maxLabel, 6538829, true);
                _local3.simulatedValueTextFormat = DefaultLabelFormat.createTextFormat(12, 6538829, "right", true);
                this.abilityBars.push(_local3);
                addGridElement(_local3);
            }
            if (!_arg_1.getUnlocked()) {
                _local3.alpha = 0.4;
            } else {
                if (_local3.alpha != 1) {
                    _local3.dynamicLabelString = "Lvl. {X}/{M}";
                    _local3.maxValue = this._petVO.maxAbilityPower;
                    _local3.value = _arg_1.level;
                }
                _local3.alpha = 1;
            }
        }
    }
}
