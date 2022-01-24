package com.company.assembleegameclient.tutorial {
    import com.company.util.ConversionUtil;
    import com.company.util.PointUtil;

    import flash.display.Graphics;
    import flash.geom.Point;

    public class UIDrawArrow {


        public const ANIMATION_MS:int = 500;
        public var p0_:Point;
        public var p1_:Point;
        public var color_:uint;

        public function UIDrawArrow(_arg_1:XML) {
            super();
            var _local2:Array = ConversionUtil.toPointPair(_arg_1);
            this.p0_ = _local2[0];
            this.p1_ = _local2[1];
            this.color_ = uint(_arg_1.@color);
        }
        

        public function draw(_arg_1:int, _arg_2:Graphics, _arg_3:int):void {
            var _local6:* = null;
            var _local5:Point = new Point();
            if (_arg_3 < 500) {
                _local5.x = this.p0_.x + (this.p1_.x - this.p0_.x) * _arg_3 / 500;
                _local5.y = this.p0_.y + (this.p1_.y - this.p0_.y) * _arg_3 / 500;
            } else {
                _local5.x = this.p1_.x;
                _local5.y = this.p1_.y;
            }
            _arg_2.lineStyle(_arg_1, this.color_);
            _arg_2.moveTo(this.p0_.x, this.p0_.y);
            _arg_2.lineTo(_local5.x, _local5.y);
            var _local4:Number = PointUtil.angleTo(_local5, this.p0_);
            _local6 = PointUtil.pointAt(_local5, _local4 + 0.392699081698724, 30);
            _arg_2.lineTo(_local6.x, _local6.y);
            _local6 = PointUtil.pointAt(_local5, _local4 - 0.392699081698724, 30);
            _arg_2.moveTo(_local5.x, _local5.y);
            _arg_2.lineTo(_local6.x, _local6.y);
        }
    }
}
