package io.decagames.rotmg.pets.popup.upgradeYard {
    import io.decagames.rotmg.pets.data.rarity.PetRarityEnum;
    import io.decagames.rotmg.shop.ShopBuyButton;
    import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
    import io.decagames.rotmg.ui.labels.UILabel;
    import io.decagames.rotmg.ui.popups.modal.ModalPopup;
    import io.decagames.rotmg.ui.texture.TextureParser;
    
    import kabam.rotmg.text.view.stringBuilder.LineBuilder;
    
    public class PetYardUpgradeDialog extends ModalPopup {
        
        
        public function PetYardUpgradeDialog(_arg_1: PetRarityEnum, _arg_2: int, _arg_3: int) {
            var _local4: * = null;
            var _local8: * = null;
            var _local6: * = null;
            super(270, 0, "Upgrade Pet Yard");
            _local4 = TextureParser.instance.getSliceScalingBitmap("UI", "petYard_" + LineBuilder.getLocalizedStringFromKey("{" + _arg_1.rarityKey + "}"));
            _local4.x = Math.round((contentWidth - _local4.width) / 2);
            addChild(_local4);
            _local8 = new UILabel();
            DefaultLabelFormat.petYardUpgradeInfo(_local8);
            _local8.x = 50;
            _local8.y = _local4.height + 10;
            _local8.width = 170;
            _local8.wordWrap = true;
            _local8.text = LineBuilder.getLocalizedStringFromKey("YardUpgraderView.info");
            addChild(_local8);
            _local6 = new UILabel();
            DefaultLabelFormat.petYardUpgradeRarityInfo(_local6);
            _local6.y = _local8.y + _local8.textHeight + 8;
            _local6.width = contentWidth;
            _local6.wordWrap = true;
            _local6.text = LineBuilder.getLocalizedStringFromKey("{" + _arg_1.rarityKey + "}");
            addChild(_local6);
            this._upgradeGoldButton = new ShopBuyButton(_arg_2, 0);
            this._upgradeFameButton = new ShopBuyButton(_arg_3, 1);
            var _local7: * = 2 * 60;
            this._upgradeFameButton.width = _local7;
            this._upgradeGoldButton.width = _local7;
            _local7 = _local6.y + _local6.height + 15;
            this._upgradeFameButton.y = _local7;
            this._upgradeGoldButton.y = _local7;
            var _local5: int = (contentWidth - (this._upgradeGoldButton.width + this._upgradeFameButton.width + this.upgradeButtonsMargin)) / 2;
            this._upgradeGoldButton.x = _local5;
            this._upgradeFameButton.x = this._upgradeGoldButton.x + this._upgradeGoldButton.width + this.upgradeButtonsMargin;
            addChild(this._upgradeGoldButton);
            addChild(this._upgradeFameButton);
        }
        
        private var upgradeButtonsMargin: int = 20;
        
        private var _upgradeGoldButton: ShopBuyButton;
        
        public function get upgradeGoldButton(): ShopBuyButton {
            return this._upgradeGoldButton;
        }
        
        private var _upgradeFameButton: ShopBuyButton;
        
        public function get upgradeFameButton(): ShopBuyButton {
            return this._upgradeFameButton;
        }
    }
}
