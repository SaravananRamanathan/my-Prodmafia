package io.decagames.rotmg.pets.windows.yard.fuse {
    import io.decagames.rotmg.pets.components.petItem.PetItem;
    import io.decagames.rotmg.shop.ShopBuyButton;
    import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
    import io.decagames.rotmg.ui.gird.UIGrid;
    import io.decagames.rotmg.ui.gird.UIGridElement;
    import io.decagames.rotmg.ui.labels.UILabel;
    import io.decagames.rotmg.ui.tabs.UITab;
    
    import kabam.rotmg.text.view.stringBuilder.LineBuilder;
    
    public class FuseTab extends UITab {
        
        public static const MAXED_COLOR: uint = 6735914;
        
        public static const BAD_COLOR: uint = 14948352;
        
        public static const DEFAULT_COLOR: uint = 15032832;
        
        public static const LOW: String = "FusionStrength.Low";
        
        public static const BAD: String = "FusionStrength.Bad";
        
        public static const GOOD: String = "FusionStrength.Good";
        
        public static const GREAT: String = "FusionStrength.Great";
        
        public static const FANTASTIC: String = "FusionStrength.Fantastic";
        
        public static const MAXED: String = "FusionStrength.Maxed";
        
        public static const NONE: String = "FusionStrength.None";
        
        private static function getKeyFor(_arg_1: Number): String {
            if (isMaxed(_arg_1)) {
                return "FusionStrength.Maxed";
            }
            if (_arg_1 > 0.8) {
                return "FusionStrength.Fantastic";
            }
            if (_arg_1 > 0.6) {
                return "FusionStrength.Great";
            }
            if (_arg_1 > 0.4) {
                return "FusionStrength.Good";
            }
            if (_arg_1 > 0.2) {
                return "FusionStrength.Low";
            }
            return "FusionStrength.Bad";
        }
        
        private static function isMaxed(_arg_1: Number): Boolean {
            return Math.abs(_arg_1 - 1) < 0.001;
        }
        
        private static function isBad(_arg_1: Number): Boolean {
            return _arg_1 < 0.2;
        }
        
        public function FuseTab(_arg_1: int) {
            var _local2: int = 0;
            super("Fuse");
            this.petsGrid = new UIGrid(220, 5, 5, 85, 5);
            this.petsGrid.x = Math.round((_arg_1 - this.gridWidth - 17) / 2);
            this.petsGrid.y = 15;
            addChild(this.petsGrid);
            this.fusionStrengthLabel = new UILabel();
            DefaultLabelFormat.fusionStrengthLabel(this.fusionStrengthLabel, 0, 0);
            this.fusionStrengthLabel.width = _arg_1;
            this.fusionStrengthLabel.wordWrap = true;
            this.fusionStrengthLabel.y = 102;
            addChild(this.fusionStrengthLabel);
            this._fuseGoldButton = new ShopBuyButton(0, 0);
            this._fuseFameButton = new ShopBuyButton(0, 1);
            var _local3: int = 100;
            this._fuseFameButton.width = _local3;
            this._fuseGoldButton.width = _local3;
            _local3 = 125;
            this._fuseFameButton.y = _local3;
            this._fuseGoldButton.y = _local3;
            _local2 = (_arg_1 - (this._fuseGoldButton.width + this._fuseFameButton.width + this.fuseButtonsMargin)) / 2;
            this._fuseGoldButton.x = _local2;
            this._fuseFameButton.x = this._fuseGoldButton.x + this._fuseGoldButton.width + _local2;
            addChild(this._fuseGoldButton);
            addChild(this._fuseFameButton);
        }
        
        private var petsGrid: UIGrid;
        private var gridWidth: int = 220;
        private var fusionStrengthLabel: UILabel;
        private var fuseButtonsMargin: int = 20;
        
        private var _fuseGoldButton: ShopBuyButton;
        
        public function get fuseGoldButton(): ShopBuyButton {
            return this._fuseGoldButton;
        }
        
        private var _fuseFameButton: ShopBuyButton;
        
        public function get fuseFameButton(): ShopBuyButton {
            return this._fuseFameButton;
        }
        
        public function setStrengthPercentage(_arg_1: Number, _arg_2: Boolean = false): void {
            var _local3: * = null;
            if (_arg_2) {
                this.fusionStrengthLabel.text = "This pet is at its highest Rarity";
            } else if (_arg_1 == -1) {
                this.fusionStrengthLabel.text = "Select a Pet to Fuse";
            } else {
                _local3 = LineBuilder.getLocalizedStringFromKey(getKeyFor(_arg_1));
                this.fusionStrengthLabel.text = _local3 + " Fusion";
                DefaultLabelFormat.fusionStrengthLabel(this.fusionStrengthLabel, this.colorText(_arg_1), _local3.length);
            }
        }
        
        public function clearGrid(): void {
            this.petsGrid.clearGrid();
        }
        
        public function addPet(_arg_1: PetItem): void {
            var _local2: UIGridElement = new UIGridElement();
            _local2.addChild(_arg_1);
            this.petsGrid.addGridElement(_local2);
        }
        
        private function colorText(_arg_1: Number): uint {
            if (isMaxed(_arg_1)) {
                return 6735914;
            }
            if (isBad(_arg_1)) {
                return 14948352;
            }
            return 15032832;
        }
    }
}
