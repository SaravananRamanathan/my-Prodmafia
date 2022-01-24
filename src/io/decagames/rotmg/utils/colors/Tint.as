package io.decagames.rotmg.utils.colors {
    import flash.display.DisplayObject;
    import flash.geom.ColorTransform;
    
    public class Tint {
        
        
        public static function add(_arg_1: DisplayObject, _arg_2: uint, _arg_3: Number): void {
            var _local6: ColorTransform = _arg_1.transform.colorTransform;
            _local6.color = _arg_2;
            var _local5: Number = _arg_3 / (1 - (_local6.redMultiplier + _local6.greenMultiplier + _local6.blueMultiplier) / 3);
            _local6.redOffset = _local6.redOffset * _local5;
            _local6.greenOffset = _local6.greenOffset * _local5;
            _local6.blueOffset = _local6.blueOffset * _local5;
            var _local4: * = 1 - _arg_3;
            _local6.blueMultiplier = _local4;
            _local6.greenMultiplier = _local4;
            _local6.redMultiplier = _local4;
            _arg_1.transform.colorTransform = _local6;
        }
        
        public function Tint() {
            super();
        }
    }
}
