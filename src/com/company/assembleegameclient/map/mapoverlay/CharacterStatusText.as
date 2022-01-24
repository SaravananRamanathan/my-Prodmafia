package com.company.assembleegameclient.map.mapoverlay {
    import com.company.assembleegameclient.map.Camera;
    import com.company.assembleegameclient.objects.GameObject;
    import com.company.ui.BaseSimpleText;
    
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Sprite;
    import flash.filters.GlowFilter;
    import flash.geom.Matrix;
    import flash.geom.Point;
    
    public class CharacterStatusText extends Sprite implements IMapOverlayElement {
        
        private const GLOW_FILTER: GlowFilter = new GlowFilter(0, 1, 4, 4, 2, 1);
        public const MAX_DRIFT: int = 40;
    
        public var go_: GameObject;
        public var offset_: Point;
        public var color_: uint;
        public var lifetime_: int;
        public var offsetTime_: int;
        public var textDisplay: BaseSimpleText;
        private var startTime_: int = 0;
        
        public function CharacterStatusText(character: GameObject, color: uint, lifetime: int, offset: int = 0) {
            super();
            this.go_ = character;
            this.offset_ = new Point(0, -character.texture.height * (character.size_ * 0.01) * 5 - 20);
            this.color_ = color;
            this.lifetime_ = lifetime;
            this.offsetTime_ = offset;
            this.textDisplay = new BaseSimpleText(20, color);
            this.textDisplay.setBold(true);
            this.textDisplay.filters = [GLOW_FILTER];
            this.textDisplay.x = -this.textDisplay.width * 0.5;
            this.textDisplay.y = -this.textDisplay.height * 0.5;
            addChild(this.textDisplay);
            visible = false;
        }
    
        public function rgbToDecimal(color: Array): int {
            var r: int = color[0];
            var g: int = color[1];
            var b: int = color[2];
        
            var result: int = (r << 16) + (g << 8) + b;
            return result;
        }
        
        public function draw(_arg_1: Camera, _arg_2: int): Boolean {
            if (this.startTime_ == 0) {
                this.startTime_ = _arg_2 + this.offsetTime_;
            }
            if (_arg_2 < this.startTime_) {
                visible = false;
                return true;
            }
            var _local3: int = _arg_2 - this.startTime_;
            if (this.lifetime_ != -1 && _local3 > this.lifetime_ || this.go_ && this.go_.map_ == null) {
                return false;
            }
            if (this.go_ == null || !this.go_.drawn_) {
                visible = false;
                return true;
            }
            visible = true;
            x = (!!this.go_ ? this.go_.posS_[0] : 0) + (!!this.offset_ ? this.offset_.x : 0);
            if (this.lifetime_ == -1) {
                y = (!!this.go_ ? this.go_.posS_[1] : 0) + 26;
            } else {
                y = (!!this.go_ ? this.go_.posS_[1] : 0) + (!!this.offset_ ? this.offset_.y : 0) - _local3 / this.lifetime_ * 40;
            }
            return true;
        }
        
        public function getGameObject(): GameObject {
            return this.go_;
        }
        
        public function dispose(): void {
            this.go_ = null;
            if (parent) {
                parent.removeChild(this);
            }
        }
        
        public function setText(text: String): void {
            this.textDisplay.setText(text);
            this.textDisplay.updateMetrics();
            
            var _local1: BitmapData = new BitmapData(this.textDisplay.width, this.textDisplay.height, true, 0);
            var _local2: Bitmap = new Bitmap(_local1);
            _local1.draw(this.textDisplay, new Matrix());
            _local2.x = _local2.x - _local2.width * 0.5;
            _local2.y = _local2.y - _local2.height * 0.5;
            addChild(_local2);
            removeChild(this.textDisplay);
            this.textDisplay = null;
        }
    }
}
