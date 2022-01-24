package io.decagames.rotmg.pets.components.selectedPetSkinInfo {
    import io.decagames.rotmg.pets.components.petInfoSlot.PetInfoSlot;
    import io.decagames.rotmg.shop.ShopBuyButton;
    import io.decagames.rotmg.ui.buttons.SliceScalingButton;
    import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
    import io.decagames.rotmg.ui.labels.UILabel;
    
    public class SelectedPetSkinInfo extends PetInfoSlot {
        
        
        public function SelectedPetSkinInfo(_arg_1: int, _arg_2: Boolean) {
            super(_arg_1, false, false, false, false, _arg_2);
            this._actionLabel = new UILabel();
            this._actionLabel.y = 140;
            DefaultLabelFormat.petInfoLabel(this._actionLabel, 0xffffff);
        }
        
        private var _actionLabel: UILabel;
        private var actionButtonMargin: int = 8;
        
        private var _goldActionButton: SliceScalingButton;
        
        public function get goldActionButton(): SliceScalingButton {
            return this._goldActionButton;
        }
        
        private var _fameActionButton: SliceScalingButton;
        
        public function get fameActionButton(): SliceScalingButton {
            return this._fameActionButton;
        }
        
        private var _actionButtonType: int;
        
        public function get actionButtonType(): int {
            return this._actionButtonType;
        }
        
        public function set actionButtonType(_arg_1: int): void {
            this._actionButtonType = _arg_1;
            this.updateButton();
        }
        
        private function updateButton(): void {
            var _local2: int = 0;
            var _local1: * = undefined;
            if (this._goldActionButton) {
                removeChild(this._goldActionButton);
                this._goldActionButton = null;
            }
            if (this._fameActionButton) {
                removeChild(this._fameActionButton);
                this._fameActionButton = null;
            }
            if (this._actionLabel.parent) {
                removeChild(this._actionLabel);
            }
            switch (int(this._actionButtonType) - 2) {
            case 0:
                this._fameActionButton = new ShopBuyButton(200, 1);
                this._goldActionButton = new ShopBuyButton(20);
                this._actionLabel.text = "Change Skin";
                break;
            case 1:
                this._actionLabel.text = "Change Family";
                this._goldActionButton = new ShopBuyButton(100);
                this._fameActionButton = new ShopBuyButton(1000, 1);
            }
            if (this._actionButtonType != 1) {
                this._actionLabel.x = Math.round(slotWidth / 2 - this._actionLabel.textWidth / 2);
                this._goldActionButton.width = 90;
                this._fameActionButton.width = 90;
                _local1 = 155;
                this._fameActionButton.y = _local1;
                this._goldActionButton.y = _local1;
                _local2 = (slotWidth - (this._goldActionButton.width + this._fameActionButton.width + this.actionButtonMargin)) / 2;
                this._goldActionButton.x = _local2;
                this._fameActionButton.x = this._goldActionButton.x + this._goldActionButton.width + this.actionButtonMargin;
                addChild(this._goldActionButton);
                addChild(this._fameActionButton);
                addChild(this._actionLabel);
            }
        }
    }
}
