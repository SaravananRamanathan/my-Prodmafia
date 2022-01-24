package com.company.util {
    import flash.display.GraphicsEndFill;
    import flash.display.GraphicsPath;
    import flash.display.GraphicsSolidFill;
    import flash.display.GraphicsStroke;
    import flash.geom.Matrix;
    
    public class GraphicsUtil {
        
        public static const END_FILL: GraphicsEndFill = new GraphicsEndFill();
        
        public static const QUAD_COMMANDS: Vector.<int> = new <int>[1, 2, 2, 2];
        
        public static const DEBUG_STROKE: GraphicsStroke = new GraphicsStroke(1, false, "normal", "none", "round", 3, new GraphicsSolidFill(0xff0000));
        
        public static const END_STROKE: GraphicsStroke = new GraphicsStroke();
        
        public static const ALL_CUTS: Array = [true, true, true, true];
        
        public static function clearPath(path: GraphicsPath): void {
            path.commands.length = 0;
            path.data.length = 0;
        }
        
        public static function getRectPath(oldX: int, oldY: int, newX: int, newY: int): GraphicsPath {
            return new GraphicsPath(QUAD_COMMANDS, new <Number>[oldX, oldY, oldX + newX, oldY, oldX + newX, oldY + newY, oldX, oldY + newY]);
        }
        
        public static function getGradientMatrix(_arg_1: Number, _arg_2: Number, _arg_3: Number = 0, _arg_4: Number = 0, _arg_5: Number = 0): Matrix {
            var _local6: Matrix = new Matrix();
            _local6.createGradientBox(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5);
            return _local6;
        }
        
        public static function drawRect(_arg_1: int, _arg_2: int, _arg_3: int, _arg_4: int, _arg_5: GraphicsPath): void {
            _arg_5.moveTo(_arg_1, _arg_2);
            _arg_5.lineTo(_arg_1 + _arg_3, _arg_2);
            _arg_5.lineTo(_arg_1 + _arg_3, _arg_2 + _arg_4);
            _arg_5.lineTo(_arg_1, _arg_2 + _arg_4);
        }
        
        public static function drawCircle(_arg_1: Number, _arg_2: Number, _arg_3: Number, _arg_4: GraphicsPath, _arg_5: int = 8): void {
            var _local6: Number = NaN;
            var _local9: Number = NaN;
            var _local8: Number = NaN;
            var _local12: Number = NaN;
            var _local10: Number = NaN;
            var _local7: Number = NaN;
            var _local13: Number = 1 + 1 / (_arg_5 * 1.75);
            _arg_4.moveTo(_arg_1 + _arg_3, _arg_2);
            var _local11: int = 1;
            while (_local11 <= _arg_5) {
                _local6 = 6.28318530717959 * _local11 / _arg_5;
                _local9 = 6.28318530717959 * (_local11 - 0.5) / _arg_5;
                _local8 = _arg_1 + _arg_3 * Math.cos(_local6);
                _local12 = _arg_2 + _arg_3 * Math.sin(_local6);
                _local10 = _arg_1 + _arg_3 * _local13 * Math.cos(_local9);
                _local7 = _arg_2 + _arg_3 * _local13 * Math.sin(_local9);
                _arg_4.curveTo(_local10, _local7, _local8, _local12);
                _local11++;
            }
        }
        
        public static function drawCutEdgeRect(_arg_1: int, _arg_2: int, _arg_3: int, _arg_4: int, _arg_5: int, _arg_6: Array, _arg_7: GraphicsPath): void {
            if (_arg_6[0] != 0) {
                _arg_7.moveTo(_arg_1, _arg_2 + _arg_5);
                _arg_7.lineTo(_arg_1 + _arg_5, _arg_2);
            } else {
                _arg_7.moveTo(_arg_1, _arg_2);
            }
            if (_arg_6[1] != 0) {
                _arg_7.lineTo(_arg_1 + _arg_3 - _arg_5, _arg_2);
                _arg_7.lineTo(_arg_1 + _arg_3, _arg_2 + _arg_5);
            } else {
                _arg_7.lineTo(_arg_1 + _arg_3, _arg_2);
            }
            if (_arg_6[2] != 0) {
                _arg_7.lineTo(_arg_1 + _arg_3, _arg_2 + _arg_4 - _arg_5);
                _arg_7.lineTo(_arg_1 + _arg_3 - _arg_5, _arg_2 + _arg_4);
            } else {
                _arg_7.lineTo(_arg_1 + _arg_3, _arg_2 + _arg_4);
            }
            if (_arg_6[3] != 0) {
                _arg_7.lineTo(_arg_1 + _arg_5, _arg_2 + _arg_4);
                _arg_7.lineTo(_arg_1, _arg_2 + _arg_4 - _arg_5);
            } else {
                _arg_7.lineTo(_arg_1, _arg_2 + _arg_4);
            }
            if (_arg_6[0] != 0) {
                _arg_7.lineTo(_arg_1, _arg_2 + _arg_5);
            } else {
                _arg_7.lineTo(_arg_1, _arg_2);
            }
        }
        
        public static function drawDiamond(_arg_1: Number, _arg_2: Number, _arg_3: Number, _arg_4: GraphicsPath): void {
            _arg_4.moveTo(_arg_1, _arg_2 - _arg_3);
            _arg_4.lineTo(_arg_1 + _arg_3, _arg_2);
            _arg_4.lineTo(_arg_1, _arg_2 + _arg_3);
            _arg_4.lineTo(_arg_1 - _arg_3, _arg_2);
        }
        
        public function GraphicsUtil() {
            super();
        }
    }
}
