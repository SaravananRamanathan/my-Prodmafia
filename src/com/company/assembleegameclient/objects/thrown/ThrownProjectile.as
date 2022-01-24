package com.company.assembleegameclient.objects.thrown {
    import com.company.assembleegameclient.objects.ObjectLibrary;
    import com.company.assembleegameclient.util.TextureRedrawer;

    import flash.display.BitmapData;
    import flash.geom.Point;

    public class ThrownProjectile extends BitmapParticle {


        public function ThrownProjectile(_arg_1:uint, _arg_2:int, _arg_3:Point, _arg_4:Point) {
            this.bitmapData = ObjectLibrary.getTextureFromType(_arg_1);
            this.bitmapData = TextureRedrawer.redraw(this.bitmapData, ObjectLibrary.propsLibrary_[_arg_1].minSize_, true, 0, false);
            _rotationDelta = 0.2;
            super(this.bitmapData, 0);
            var _local5:* = _arg_2;
            this.timeLeft_ = _local5;
            this.lifetime_ = _local5;
            this.start_ = _arg_3;
            this.end_ = _arg_4;
            this.dx_ = (this.end_.x - this.start_.x) / this.timeLeft_;
            this.dy_ = (this.end_.y - this.start_.y) / this.timeLeft_;
            x_ = this.start_.x;
            this.pathX_ = this.start_.x;
            y_ = this.start_.y;
            this.pathY_ = this.start_.y;
        }
        public var lifetime_:int;
        public var timeLeft_:int;
        public var start_:Point;
        public var end_:Point;
        public var dx_:Number;
        public var dy_:Number;
        public var pathX_:Number;
        public var pathY_:Number;
        private var bitmapData:BitmapData;

        override public function update(_arg_1:int, _arg_2:int):Boolean {
            this.timeLeft_ = this.timeLeft_ - _arg_2;
            if (this.timeLeft_ <= 0) {
                return false;
            }
            z_ = Math.sin(this.timeLeft_ / this.lifetime_ * 3.14159265358979) * 2;
            setSize(z_);
            this.pathX_ = this.pathX_ + this.dx_ * _arg_2;
            this.pathY_ = this.pathY_ + this.dy_ * _arg_2;
            moveTo(this.pathX_, this.pathY_);
            return true;
        }
    }
}
