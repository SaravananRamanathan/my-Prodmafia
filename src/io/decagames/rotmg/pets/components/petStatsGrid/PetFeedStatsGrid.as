package io.decagames.rotmg.pets.components.petStatsGrid {
    import flash.display.Sprite;
    
    import io.decagames.rotmg.pets.data.ability.AbilitiesUtil;
    import io.decagames.rotmg.pets.data.vo.AbilityVO;
    import io.decagames.rotmg.pets.data.vo.IPetVO;
    import io.decagames.rotmg.ui.PetFeedProgressBar;
    import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
    import io.decagames.rotmg.ui.gird.UIGrid;
    import io.decagames.rotmg.ui.labels.UILabel;
    
    public class PetFeedStatsGrid extends UIGrid {
        
        
        public function PetFeedStatsGrid(_arg_1: int, _arg_2: IPetVO) {
            super(_arg_1, 1, 3);
            this._petVO = _arg_2;
            this.init();
        }
        
        private var abilityBars: Vector.<PetFeedProgressBar>;
        private var _labelContainer: Sprite;
        private var _plusLabels: Vector.<UILabel>;
        private var _currentLevels: Vector.<int>;
        private var _maxLevel: int;
        
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
                this.abilityBars.length = 0;
                this._labelContainer.visible = false;
                clearGrid();
            }
            this._petVO = _arg_1;
            if (this._petVO != null) {
                this.refreshAbilities(_arg_1);
            }
        }
        
        private function init(): void {
            this.abilityBars = new Vector.<PetFeedProgressBar>();
            this._currentLevels = new Vector.<int>(0);
            this._labelContainer = new Sprite();
            this._labelContainer.x = -2;
            this._labelContainer.y = -13;
            this._labelContainer.visible = false;
            addChild(this._labelContainer);
            this.createLabels();
            this.createPlusLabels();
            if (this._petVO) {
                this._maxLevel = this._petVO.maxAbilityPower;
                this.refreshAbilities(this._petVO);
            }
        }
        
        private function createPlusLabels(): void {
            var _local1: int = 0;
            var _local2: * = null;
            this._plusLabels = new Vector.<UILabel>(0);
            _local1 = 0;
            while (_local1 < 3) {
                _local2 = new UILabel();
                DefaultLabelFormat.petStatLabelRight(_local2, 6538829);
                _local2.x = 203;
                _local2.y = _local1 * 23;
                _local2.visible = false;
                addChild(_local2);
                this._plusLabels.push(_local2);
                _local1++;
            }
        }
        
        private function createLabels(): void {
            var _local2: * = null;
            var _local1: UILabel = new UILabel();
            DefaultLabelFormat.petStatLabelLeftSmall(_local1, 0xa2a2a2);
            _local1.text = "Ability";
            _local1.y = -3;
            this._labelContainer.addChild(_local1);
            _local2 = new UILabel();
            DefaultLabelFormat.petStatLabelRightSmall(_local2, 0xa2a2a2);
            _local2.text = "Level";
            _local2.x = 195 - _local2.width + 4;
            _local2.y = -3;
            this._labelContainer.addChild(_local2);
        }
        
        private function refreshAbilities(_arg_1: IPetVO): void {
            var _local2: int = 0;
            var _local3: * = null;
            this._currentLevels.length = 0;
            this._maxLevel = this._petVO.maxAbilityPower;
            this._labelContainer.visible = true;
            _local2 = 0;
            var _local5: int = 0;
            var _local4: * = _arg_1.abilityList;
            for each(_local3 in _arg_1.abilityList) {
                this._currentLevels.push(_local3.level);
                this._plusLabels[_local2].text = "";
                this._plusLabels[_local2].visible = false;
                this.renderAbility(_local3, _local2);
                _local2++;
            }
        }
        
        private function renderAbilitySimulation(_arg_1: AbilityVO, _arg_2: int): void {
            var _local3: * = null;
            if (_arg_1.getUnlocked()) {
                _local3 = this.abilityBars[_arg_2];
                _local3.maxLevel = this._maxLevel;
                _local3.simulatedValue = _arg_1.points;
                if (_arg_1.level - this._currentLevels[_arg_2] > 0) {
                    this._plusLabels[_arg_2].text = "+" + (_arg_1.level - this._currentLevels[_arg_2]);
                    this._plusLabels[_arg_2].visible = true;
                } else {
                    this._plusLabels[_arg_2].visible = false;
                }
            }
        }
        
        private function renderAbility(_arg_1: AbilityVO, _arg_2: int): void {
            var _local4: * = null;
            var _local3: int = AbilitiesUtil.abilityPowerToMinPoints(_arg_1.level + 1);
            if (this.abilityBars.length > _arg_2) {
                _local4 = this.abilityBars[_arg_2];
                if (_arg_1.getUnlocked()) {
                    if (_local4.maxValue != _local3 || _local4.value != _arg_1.points) {
                        this.updateProgressBarValues(_local4, _arg_1, _local3);
                    }
                }
            } else {
                _local4 = new PetFeedProgressBar(195, 4, _arg_1.name, _local3, !_arg_1.getUnlocked() ? 0 : _arg_1.points, _arg_1.level, this._maxLevel, 0x545454, 15306295, 6538829);
                _local4.showMaxLabel = true;
                _local4.maxColor = 6538829;
                DefaultLabelFormat.petStatLabelLeft(_local4.abilityLabel, 0xffffff);
                DefaultLabelFormat.petStatLabelRight(_local4.levelLabel, 0xffffff);
                DefaultLabelFormat.petStatLabelRight(_local4.maxLabel, 6538829, true);
                _local4.simulatedValueTextFormat = DefaultLabelFormat.createTextFormat(12, 6538829, "right", true);
                this.abilityBars.push(_local4);
                addGridElement(_local4);
            }
            if (!_arg_1.getUnlocked()) {
                _local4.alpha = 0.4;
            } else {
                if (_local4.alpha != 1) {
                    _local4.maxValue = _local3;
                    _local4.value = _arg_1.points;
                }
                _local4.alpha = 1;
            }
        }
        
        private function updateProgressBarValues(_arg_1: PetFeedProgressBar, _arg_2: AbilityVO, _arg_3: int): void {
            _arg_1.maxLevel = this._maxLevel;
            _arg_1.currentLevel = _arg_2.level;
            _arg_1.maxValue = _arg_3;
            _arg_1.value = _arg_2.points;
        }
    }
}
