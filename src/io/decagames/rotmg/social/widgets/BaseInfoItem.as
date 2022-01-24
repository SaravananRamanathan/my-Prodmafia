package io.decagames.rotmg.social.widgets {
    import flash.display.Sprite;
    
    import io.decagames.rotmg.ui.sliceScaling.SliceScalingBitmap;
    import io.decagames.rotmg.ui.texture.TextureParser;
    
    public class BaseInfoItem extends Sprite {
        
        
        public function BaseInfoItem(_arg_1: int, _arg_2: int) {
            super();
            this._width = _arg_1;
            this._height = _arg_2;
            this.intit();
        }
        
        protected var _width: int;
        protected var _height: int;
        
        private function intit(): void {
            this.createBackground();
        }
        
        private function createBackground(): void {
            var _local1: SliceScalingBitmap = TextureParser.instance.getSliceScalingBitmap("UI", "listitem_content_background");
            _local1.height = this._height;
            _local1.width = this._width;
            addChild(_local1);
        }
    }
}
