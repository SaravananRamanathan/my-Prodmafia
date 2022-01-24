package io.decagames.rotmg.utils.colors {
    import flash.display.BitmapData;
    import flash.display.DisplayObject;
    import flash.filters.ColorMatrixFilter;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    
    public class GreyScale {
        
        
        public static function setGreyScale(_arg_1: BitmapData): BitmapData {
            var _local3: * = [0.2225, 0.7169, 0.0606, 0, 0, 0.2225, 0.7169, 0.0606, 0, 0, 0.2225, 0.7169, 0.0606, 0, 0, 0, 0, 0, 1, 0];
            var _local5: ColorMatrixFilter = new ColorMatrixFilter(_local3);
            _arg_1.applyFilter(_arg_1, new Rectangle(0, 0, _arg_1.width, _arg_1.height), new Point(0, 0), _local5);
            return _arg_1;
        }
        
        public static function greyScaleToDisplayObject(_arg_1: DisplayObject, _arg_2: Boolean): void {
            var _local5: * = [0.2225, 0.7169, 0.0606, 0, 0, 0.2225, 0.7169, 0.0606, 0, 0, 0.2225, 0.7169, 0.0606, 0, 0, 0, 0, 0, 1, 0];
            var _local4: ColorMatrixFilter = new ColorMatrixFilter(_local5);
            if (_arg_2) {
                _arg_1.filters = [_local4];
            } else {
                _arg_1.filters = [];
            }
        }
        
        public function GreyScale() {
            super();
        }
    }
}
