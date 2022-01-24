package com.company.assembleegameclient.tutorial {
    import com.company.util.ConversionUtil;

    import flash.display.Graphics;
    import flash.geom.Point;
    import flash.geom.Rectangle;

    public class UIDrawBox {

        public const ANIMATION_MS:int = 500;
        public const ORIGIN:Point = new Point(250, 200);
        public var rect_:Rectangle;
        public var color_:uint;

        public function UIDrawBox(_arg_1:XML) {
            super();
            this.rect_ = ConversionUtil.toRectangle(_arg_1);
            this.color_ = uint(_arg_1.@color);
        }


        public function draw(_arg_1:int, _arg_2:Graphics, _arg_3:int):void {
            var _local4:Number = NaN;
            var _local7:Number = NaN;
            var _local6:Number = this.rect_.width - _arg_1;
            var _local5:Number = this.rect_.height - _arg_1;
            if (_arg_3 < 500) {
                _local4 = this.ORIGIN.x + (this.rect_.x - this.ORIGIN.x) * _arg_3 / 500;
                _local7 = this.ORIGIN.y + (this.rect_.y - this.ORIGIN.y) * _arg_3 / 500;
                _local6 = _local6 * (_arg_3 / 500);
                _local5 = _local5 * (_arg_3 / 500);
            } else {
                _local4 = this.rect_.x + _arg_1 / 2;
                _local7 = this.rect_.y + _arg_1 / 2;
            }
            _arg_2.lineStyle(_arg_1, this.color_);
            _arg_2.drawRect(_local4, _local7, _local6, _local5);
        }
    }
}
