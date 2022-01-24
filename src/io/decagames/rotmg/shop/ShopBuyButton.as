package io.decagames.rotmg.shop {
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    
    import io.decagames.rotmg.ui.buttons.SliceScalingButton;
    import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
    import io.decagames.rotmg.ui.labels.UILabel;
    import io.decagames.rotmg.ui.texture.TextureParser;
    
    import kabam.rotmg.assets.services.IconFactory;
    
    public class ShopBuyButton extends SliceScalingButton {
        public function ShopBuyButton(_arg_1: int, _arg_2: int = 0) {
            super(TextureParser.instance.getSliceScalingBitmap("UI", "generic_green_button"));
            this._price = _arg_1;
            this._priceLabel = new UILabel();
            this._priceLabel.text = _arg_1.toString();
            this._priceLabel.y = 7;
            this._currency = _arg_2;
            var _local3: BitmapData = _arg_2 == 0 ? IconFactory.makeCoin() : IconFactory.makeFame();
            this.coinBitmap = new Bitmap(_local3);
            this.coinBitmap.y = Math.round(this.coinBitmap.height / 2) - 3;
            DefaultLabelFormat.priceButtonLabel(this._priceLabel);
            addChild(this._priceLabel);
            addChild(this.coinBitmap);
        }
        
        private var coinBitmap: Bitmap;
        
        override public function set width(_arg_1: Number): void {
            super.width = _arg_1;
            this.updateLabelPosition();
        }
        
        private var _priceLabel: UILabel;
        
        public function get priceLabel(): UILabel {
            return this._priceLabel;
        }
        
        private var _price: int;
        
        public function get price(): int {
            return this._price;
        }
        
        public function set price(_arg_1: int): void {
            this._price = _arg_1;
            if (!this._soldOut) {
                this.priceLabel.text = _arg_1.toString();
                this.updateLabelPosition();
            }
        }
        
        private var _soldOut: Boolean;
        
        public function get soldOut(): Boolean {
            return this._soldOut;
        }
        
        public function set soldOut(_arg_1: Boolean): void {
            this._soldOut = _arg_1;
            disabled = _arg_1;
            if (_arg_1) {
                this._priceLabel.text = "Sold out";
                if (this.coinBitmap && this.coinBitmap.parent) {
                    removeChild(this.coinBitmap);
                }
            } else {
                this._priceLabel.text = this._price.toString();
                addChild(this.coinBitmap);
            }
            this.updateLabelPosition();
        }
        
        private var _currency: int;
        
        public function get currency(): int {
            return this._currency;
        }
        
        private var _showCampaignTooltip: Boolean;
        
        public function get showCampaignTooltip(): Boolean {
            return this._showCampaignTooltip;
        }
        
        public function set showCampaignTooltip(_arg_1: Boolean): void {
            this._showCampaignTooltip = _arg_1;
        }
        
        override public function dispose(): void {
            this.coinBitmap.bitmapData.dispose();
            super.dispose();
        }
        
        private function updateLabelPosition(): void {
            if (this.coinBitmap.parent) {
                this._priceLabel.x = bitmap.width - 38 - this._priceLabel.textWidth;
            } else {
                this._priceLabel.x = (bitmap.width - this._priceLabel.textWidth) / 2;
            }
            this.coinBitmap.x = bitmap.width - this.coinBitmap.width - 15;
        }
    }
}
