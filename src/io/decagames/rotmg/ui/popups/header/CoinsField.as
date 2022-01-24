package io.decagames.rotmg.ui.popups.header {
    import com.company.assembleegameclient.util.TextureRedrawer;
    import com.company.util.AssetLibrary;
    
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Sprite;
    
    import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
    import io.decagames.rotmg.ui.labels.UILabel;
    import io.decagames.rotmg.ui.sliceScaling.SliceScalingBitmap;
    import io.decagames.rotmg.ui.texture.TextureParser;
    
    public class CoinsField extends Sprite {
        
        
        public function CoinsField(_arg_1: int) {
            super();
            this.coinsFieldBackground = TextureParser.instance.getSliceScalingBitmap("UI", "bordered_field", _arg_1);
            this._label = new UILabel();
            DefaultLabelFormat.coinsFieldLabel(this._label);
            addChild(this.coinsFieldBackground);
            addChild(this._label);
            var _local2: BitmapData = AssetLibrary.getImageFromSet("lofiObj3", 225);
            _local2 = TextureRedrawer.resize(_local2, null, 34, true, 0, 0, 5);
            this.coinBitmap = new Bitmap(_local2);
            this.coinBitmap.y = -4;
            this.coinBitmap.x = _arg_1 - 40;
            addChild(this.coinBitmap);
        }
        
        private var coinsFieldBackground: SliceScalingBitmap;
        private var coinBitmap: Bitmap;
        
        private var _label: UILabel;
        
        public function get label(): UILabel {
            return this._label;
        }
        
        public function set coinsAmount(_arg_1: int): void {
            this._label.text = _arg_1.toString();
            this._label.x = (this.coinsFieldBackground.width - this._label.textWidth) / 2 - 5;
            this._label.y = (this.coinsFieldBackground.height - this._label.height) / 2 + 2;
        }
        
        public function dispose(): void {
            this.coinsFieldBackground.dispose();
            this.coinBitmap.bitmapData.dispose();
        }
    }
}
