package io.decagames.rotmg.ui.scroll {
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    
    import io.decagames.rotmg.ui.sliceScaling.SliceScalingBitmap;
    import io.decagames.rotmg.ui.texture.TextureParser;
    
    public class UIScrollbar extends Sprite {
        
        public static const SCROLL_SLIDER_MINIMUM_HEIGHT: int = 39;
        
        public static const SCROLL_SLIDER_WIDTH: int = 17;
        
        public static const SCROLL_SLIDER_SCALE_FACTOR: Number = 0.5;
        
        public function UIScrollbar(_arg_1: int) {
            super();
            this.contentHeight = _arg_1;
            this.background = TextureParser.instance.getSliceScalingBitmap("UI", "scrollbar_background", 17);
            this.background.height = _arg_1;
            addChild(this.background);
            this._slider = new Sprite();
            this.sliderAsset = TextureParser.instance.getSliceScalingBitmap("UI", "scrollbar_slider");
            this.sliderAsset.height = 10;
            this._slider.addChild(this.sliderAsset);
            this._slider.x = 1;
            this._slider.y = 1;
            addChild(this._slider);
        }
        
        private var background: SliceScalingBitmap;
        private var sliderAsset: SliceScalingBitmap;
        private var contentHeight: int;
        private var percent: Number;
        private var initalPosition: int = 0;
        
        private var _slider: Sprite;
        
        public function get slider(): Sprite {
            return this._slider;
        }
        
        private var _content: DisplayObject;
        
        public function get content(): DisplayObject {
            return this._content;
        }
        
        public function set content(_arg_1: DisplayObject): void {
            this._content = _arg_1;
            this.initalPosition = this._content.y;
            this.update();
        }
        
        private var _scrollObject: DisplayObject;
        
        public function get scrollObject(): DisplayObject {
            if (this._scrollObject) {
                return this._scrollObject;
            }
            return this._content;
        }
        
        public function set scrollObject(_arg_1: DisplayObject): void {
            this._scrollObject = _arg_1;
        }
        
        private var _mouseRollSpeedFactor: Number = 1.3;
        
        public function get mouseRollSpeedFactor(): Number {
            return this._mouseRollSpeedFactor;
        }
        
        public function set mouseRollSpeedFactor(_arg_1: Number): void {
            this._mouseRollSpeedFactor = _arg_1;
        }
        
        public function update(): void {
            var _local1: int = 0;
            if (this._content.height <= this.contentHeight) {
                this.sliderAsset.height = this.contentHeight;
                this._slider.y = 1;
            } else {
                this.percent = (this._content.height - this.contentHeight) / this.contentHeight;
                _local1 = (1 - this.percent * 0.5) * this.contentHeight;
                if (_local1 < 39) {
                    _local1 = 39;
                }
                this.sliderAsset.height = _local1;
            }
        }
        
        public function updatePosition(_arg_1: Number): void {
            this._slider.y = this._slider.y + Math.round(_arg_1);
            if (this._slider.y < 0) {
                this._slider.y = 0;
            }
            var _local2: int = this.contentHeight - this._slider.height;
            if (this._slider.y > _local2) {
                this._slider.y = _local2;
            }
            if (_local2 > 0) {
                this._content.y = this.initalPosition + -Math.round((this._content.height - this.contentHeight) * this._slider.y / _local2);
            }
        }
        
        public function dispose(): void {
            this.background.dispose();
            this.sliderAsset.dispose();
        }
    }
}
