package com.company.util {
import flash.geom.Point;

public class LineSegmentUtil {


    public static function intersection(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Number, _arg_6:Number, _arg_7:Number, _arg_8:Number):Point {
        var _local11:Number = (_arg_8 - _arg_6) * (_arg_3 - _arg_1) - (_arg_7 - _arg_5) * (_arg_4 - _arg_2);
        if (_local11 == 0) {
            return null;
        }
        var _local9:Number = ((_arg_7 - _arg_5) * (_arg_2 - _arg_6) - (_arg_8 - _arg_6) * (_arg_1 - _arg_5)) / _local11;
        var _local10:Number = ((_arg_3 - _arg_1) * (_arg_2 - _arg_6) - (_arg_4 - _arg_2) * (_arg_1 - _arg_5)) / _local11;
        if (_local9 > 1 || _local9 < 0 || _local10 > 1 || _local10 < 0) {
            return null;
        }
        var _local12:Point = new Point(_arg_1 + _local9 * (_arg_3 - _arg_1), _arg_2 + _local9 * (_arg_4 - _arg_2));
        return _local12;
    }

    public static function pointDistance(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Number, _arg_6:Number):Number {
        var _local8:* = NaN;
        var _local11:* = NaN;
        var _local12:Number = NaN;
        var _local10:Number = _arg_5 - _arg_3;
        var _local7:Number = _arg_6 - _arg_4;
        var _local9:Number = _local10 * _local10 + _local7 * _local7;
        if (_local9 < 0.001) {
            _local8 = _arg_3;
            _local11 = _arg_4;
        } else {
            _local12 = ((_arg_1 - _arg_3) * _local10 + (_arg_2 - _arg_4) * _local7) / _local9;
            if (_local12 < 0) {
                _local8 = _arg_3;
                _local11 = _arg_4;
            } else if (_local12 > 1) {
                _local8 = _arg_5;
                _local11 = _arg_6;
            } else {
                _local8 = Number(_arg_3 + _local12 * _local10);
                _local11 = Number(_arg_4 + _local12 * _local7);
            }
        }
        _local10 = _arg_1 - _local8;
        _local7 = _arg_2 - _local11;
        return Math.sqrt(_local10 * _local10 + _local7 * _local7);
    }

    public function LineSegmentUtil() {
        super();
    }
}
}
