package com.company.util {
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;

public class RectangleUtil {


    public static function pointDist(_arg_1:Rectangle, _arg_2:Number, _arg_3:Number):Number {
        var _local5:* = _arg_2;
        var _local4:* = _arg_3;
        if (_local5 < _arg_1.x) {
            _local5 = _arg_1.x;
        } else if (_local5 > _arg_1.right) {
            _local5 = _arg_1.right;
        }
        if (_local4 < _arg_1.y) {
            _local4 = _arg_1.y;
        } else if (_local4 > _arg_1.bottom) {
            _local4 = _arg_1.bottom;
        }
        if (_local5 == _arg_2 && _local4 == _arg_3) {
            return 0;
        }
        return PointUtil.distanceXY(_local5, _local4, _arg_2, _arg_3);
    }

    public static function pointDistSquared(_arg_1:Rectangle, _arg_2:Number, _arg_3:Number):Number {
        var _local5:* = _arg_2;
        var _local4:* = _arg_3;
        if (_local5 < _arg_1.x) {
            _local5 = _arg_1.x;
        } else if (_local5 > _arg_1.right) {
            _local5 = _arg_1.right;
        }
        if (_local4 < _arg_1.y) {
            _local4 = _arg_1.y;
        } else if (_local4 > _arg_1.bottom) {
            _local4 = _arg_1.bottom;
        }
        if (_local5 == _arg_2 && _local4 == _arg_3) {
            return 0;
        }
        return PointUtil.distanceSquaredXY(_local5, _local4, _arg_2, _arg_3);
    }

    public static function closestPoint(_arg_1:Rectangle, _arg_2:Number, _arg_3:Number):Point {
        var _local5:* = _arg_2;
        var _local4:* = _arg_3;
        if (_local5 < _arg_1.x) {
            _local5 = _arg_1.x;
        } else if (_local5 > _arg_1.right) {
            _local5 = _arg_1.right;
        }
        if (_local4 < _arg_1.y) {
            _local4 = _arg_1.y;
        } else if (_local4 > _arg_1.bottom) {
            _local4 = _arg_1.bottom;
        }
        return new Point(_local5, _local4);
    }

    public static function lineSegmentIntersectsXY(_arg_1:Rectangle, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Number):Boolean {
        var _local6:Number = NaN;
        var _local9:Number = NaN;
        var _local8:* = NaN;
        var _local12:* = NaN;
        if (_arg_1.left > _arg_2 && _arg_1.left > _arg_4 || _arg_1.right < _arg_2 && _arg_1.right < _arg_4 || _arg_1.top > _arg_3 && _arg_1.top > _arg_5 || _arg_1.bottom < _arg_3 && _arg_1.bottom < _arg_5) {
            return false;
        }
        if (_arg_1.left < _arg_2 && _arg_2 < _arg_1.right && _arg_1.top < _arg_3 && _arg_3 < _arg_1.bottom || _arg_1.left < _arg_4 && _arg_4 < _arg_1.right && _arg_1.top < _arg_5 && _arg_5 < _arg_1.bottom) {
            return true;
        }
        var _local10:Number = (_arg_5 - _arg_3) / (_arg_4 - _arg_2);
        var _local11:Number = _arg_3 - _local10 * _arg_2;
        if (_local10 > 0) {
            _local6 = _local10 * _arg_1.left + _local11;
            _local9 = _local10 * _arg_1.right + _local11;
        } else {
            _local6 = _local10 * _arg_1.right + _local11;
            _local9 = _local10 * _arg_1.left + _local11;
        }
        if (_arg_3 < _arg_5) {
            _local12 = _arg_3;
            _local8 = _arg_5;
        } else {
            _local12 = _arg_5;
            _local8 = _arg_3;
        }
        var _local13:Number = _local6 > _local12 ? _local6 : Number(_local12);
        var _local7:Number = _local9 < _local8 ? _local9 : Number(_local8);
        return _local13 < _local7 && !(_local7 < _arg_1.top || _local13 > _arg_1.bottom);
    }

    public static function lineSegmentIntersectXY(_arg_1:Rectangle, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Number, _arg_6:Point):Boolean {
        var _local10:Number = NaN;
        var _local9:Number = NaN;
        var _local7:Number = NaN;
        var _local8:Number = NaN;
        if (_arg_4 <= _arg_1.x) {
            _local10 = (_arg_5 - _arg_3) / (_arg_4 - _arg_2);
            _local9 = _arg_3 - _arg_2 * _local10;
            _local7 = _local10 * _arg_1.x + _local9;
            if (_local7 >= _arg_1.y && _local7 <= _arg_1.y + _arg_1.height) {
                _arg_6.x = _arg_1.x;
                _arg_6.y = _local7;
                return true;
            }
        } else if (_arg_4 >= _arg_1.x + _arg_1.width) {
            _local10 = (_arg_5 - _arg_3) / (_arg_4 - _arg_2);
            _local9 = _arg_3 - _arg_2 * _local10;
            _local7 = _local10 * (_arg_1.x + _arg_1.width) + _local9;
            if (_local7 >= _arg_1.y && _local7 <= _arg_1.y + _arg_1.height) {
                _arg_6.x = _arg_1.x + _arg_1.width;
                _arg_6.y = _local7;
                return true;
            }
        }
        if (_arg_5 <= _arg_1.y) {
            _local10 = (_arg_4 - _arg_2) / (_arg_5 - _arg_3);
            _local9 = _arg_2 - _arg_3 * _local10;
            _local8 = _local10 * _arg_1.y + _local9;
            if (_local8 >= _arg_1.x && _local8 <= _arg_1.x + _arg_1.width) {
                _arg_6.x = _local8;
                _arg_6.y = _arg_1.y;
                return true;
            }
        } else if (_arg_5 >= _arg_1.y + _arg_1.height) {
            _local10 = (_arg_4 - _arg_2) / (_arg_5 - _arg_3);
            _local9 = _arg_2 - _arg_3 * _local10;
            _local8 = _local10 * (_arg_1.y + _arg_1.height) + _local9;
            if (_local8 >= _arg_1.x && _local8 <= _arg_1.x + _arg_1.width) {
                _arg_6.x = _local8;
                _arg_6.y = _arg_1.y + _arg_1.height;
                return true;
            }
        }
        return false;
    }

    public static function lineSegmentIntersect(_arg_1:Rectangle, _arg_2:IntPoint, _arg_3:IntPoint):Point {
        var _local4:Number = NaN;
        var _local7:Number = NaN;
        var _local6:Number = NaN;
        var _local5:Number = NaN;
        if (_arg_3.x() <= _arg_1.x) {
            _local4 = (_arg_3.y() - _arg_2.y()) / (_arg_3.x() - _arg_2.x());
            _local7 = _arg_2.y() - _arg_2.x() * _local4;
            _local6 = _local4 * _arg_1.x + _local7;
            if (_local6 >= _arg_1.y && _local6 <= _arg_1.y + _arg_1.height) {
                return new Point(_arg_1.x, _local6);
            }
        } else if (_arg_3.x() >= _arg_1.x + _arg_1.width) {
            _local4 = (_arg_3.y() - _arg_2.y()) / (_arg_3.x() - _arg_2.x());
            _local7 = _arg_2.y() - _arg_2.x() * _local4;
            _local6 = _local4 * (_arg_1.x + _arg_1.width) + _local7;
            if (_local6 >= _arg_1.y && _local6 <= _arg_1.y + _arg_1.height) {
                return new Point(_arg_1.x + _arg_1.width, _local6);
            }
        }
        if (_arg_3.y() <= _arg_1.y) {
            _local4 = (_arg_3.x() - _arg_2.x()) / (_arg_3.y() - _arg_2.y());
            _local7 = _arg_2.x() - _arg_2.y() * _local4;
            _local5 = _local4 * _arg_1.y + _local7;
            if (_local5 >= _arg_1.x && _local5 <= _arg_1.x + _arg_1.width) {
                return new Point(_local5, _arg_1.y);
            }
        } else if (_arg_3.y() >= _arg_1.y + _arg_1.height) {
            _local4 = (_arg_3.x() - _arg_2.x()) / (_arg_3.y() - _arg_2.y());
            _local7 = _arg_2.x() - _arg_2.y() * _local4;
            _local5 = _local4 * (_arg_1.y + _arg_1.height) + _local7;
            if (_local5 >= _arg_1.x && _local5 <= _arg_1.x + _arg_1.width) {
                return new Point(_local5, _arg_1.y + _arg_1.height);
            }
        }
        return null;
    }

    public static function getRotatedRectExtents2D(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Number):Extents2D {
        var _local6:* = null;
        var _local11:int = 0;
        var _local7:int = 0;
        var _local8:Matrix = new Matrix();
        _local8.translate(-_arg_4 * 0.5, -_arg_5 * 0.5);
        _local8.rotate(_arg_3);
        _local8.translate(_arg_1, _arg_2);
        var _local10:Extents2D = new Extents2D();
        var _local9:Point = new Point();
        while (_local7 <= 1) {
            _local11 = 0;
            while (_local11 <= 1) {
                _local9.x = _local7 * _arg_4;
                _local9.y = _local11 * _arg_5;
                _local6 = _local8.transformPoint(_local9);
                _local10.add(_local6.x, _local6.y);
                _local11++;
            }
            _local7++;
        }
        return _local10;
    }

    public function RectangleUtil() {
        super();
    }
}
}
