package io.decagames.rotmg.shop.genericBox {
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Sprite;
    
    import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
    import io.decagames.rotmg.ui.labels.UILabel;
    
    import kabam.rotmg.assets.services.IconFactory;
    
    public class SalePriceTag extends Sprite {
        
        
        public function SalePriceTag(_arg_1: int, _arg_2: int) {
            var _local4: * = null;
            super();
            var _local5: UILabel = new UILabel();
            DefaultLabelFormat.originalPriceButtonLabel(_local5);
            _local5.text = _arg_1.toString();
            _local4 = new Sprite();
            var _local3: BitmapData = _arg_2 == 0 ? IconFactory.makeCoin(35) : IconFactory.makeFame(35);
            this.coinBitmap = new Bitmap(_local3);
            this.coinBitmap.y = 0;
            addChild(this.coinBitmap);
            addChild(_local5);
            this.coinBitmap.x = _local5.textWidth + 5;
            addChild(_local4);
            _local4.graphics.lineStyle(2, 16711722, 0.6);
            _local4.graphics.lineTo(this.width, 0);
            _local4.y = (_local5.textHeight + 2) / 2;
        }
        
        private var coinBitmap: Bitmap;
        
        public function dispose(): void {
            this.coinBitmap.bitmapData.dispose();
        }
    }
}
