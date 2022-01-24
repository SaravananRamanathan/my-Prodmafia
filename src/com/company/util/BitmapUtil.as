package com.company.util {
    import flash.display.BitmapData;
    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.utils.Dictionary;

    public class BitmapUtil {

        internal static const zeroPoint:Point = new Point(0, 0);

        internal static var rect:Rectangle = new Rectangle();

        public static function mirror(_arg_1:BitmapData, _arg_2:int = 0):BitmapData {
            var _local5:int = 0;
            var _local6:int = 0;
            if (_arg_2 == 0) {
                _arg_2 = _arg_1.width;
            }
            var _local4:int = _arg_1.height;
            var _local3:BitmapData = new BitmapData(_arg_1.width, _local4, true, 0);
            while (_local6 < _arg_2) {
                _local5 = 0;
                while (_local5 < _local4) {
                    _local3.setPixel32(_arg_2 - _local6 - 1, _local5, _arg_1.getPixel32(_local6, _local5));
                    _local5++;
                }
                _local6++;
            }
            return _local3;
        }

        public static function rotateBitmapData(_arg_1:BitmapData, _arg_2:int):BitmapData {
            var _local4:Matrix = new Matrix();
            _local4.translate(-_arg_1.width * 0.5, -_arg_1.height * 0.5);
            _local4.rotate(_arg_2 * 1.5707963267949);
            _local4.translate(_arg_1.height * 0.5, _arg_1.width * 0.5);
            var _local3:BitmapData = new BitmapData(_arg_1.height, _arg_1.width, true, 0);
            _local3.draw(_arg_1, _local4);
            return _local3;
        }

        public static function cropToBitmapData(_arg_1:BitmapData, _arg_2:int, _arg_3:int, _arg_4:int, _arg_5:int):BitmapData {
            var _local6:BitmapData = new BitmapData(_arg_4, _arg_5);
            rect.x = _arg_2;
            rect.y = _arg_3;
            rect.width = _arg_4;
            rect.height = _arg_5;
            _local6.copyPixels(_arg_1, rect, zeroPoint);
            return _local6;
        }

        public static function amountTransparent(_arg_1:BitmapData):Number {
            var _local5:int = 0;
            var _local4:* = 0;
            var _local2:int = 0;
            var _local6:int = 0;
            var _local3:int = _arg_1.width;
            var _local7:int = _arg_1.height;
            while (_local6 < _local3) {
                _local5 = 0;
                while (_local5 < _local7) {
                    _local4 = uint(_arg_1.getPixel32(_local6, _local5) & 4278190080);
                    if (_local4 == 0) {
                        _local2++;
                    }
                    _local5++;
                }
                _local6++;
            }
            return _local2 / (_local3 * _local7);
        }

        public static function mostCommonColor(_arg1:BitmapData):uint {
            var _local3:uint;
            var _local7:String;
            var _local8:int;
            var _local9:int;
            var _local2:Dictionary = new Dictionary();
            var _local4:int;
            while (_local4 < _arg1.width) {
                _local8 = 0;
                while (_local8 < _arg1.width) {
                    _local3 = _arg1.getPixel32(_local4, _local8);
                    if ((_local3 & 0xFF000000) != 0) {
                        if (!_local2.hasOwnProperty(_local3.toString())) {
                            _local2[_local3] = 1;
                        } else {
                            var _local10:Dictionary = _local2;
                            var _local11:uint = _local3;
                            var _local12:uint = (_local10[_local11] + 1);
                            _local10[_local11] = _local12;
                        }
                    }
                    _local8++;
                }
                _local4++;
            }
            var _local5:uint;
            var _local6:uint;
            for (_local7 in _local2) {
                _local3 = parseInt(_local7);
                _local9 = _local2[_local7];
                if ((((_local9 > _local6)) || ((((_local9 == _local6)) && ((_local3 > _local5)))))) {
                    _local5 = _local3;
                    _local6 = _local9;
                }
            }
            return (_local5);
        }

        public static function lineOfSight(_arg_1:BitmapData, _arg_2:IntPoint, _arg_3:IntPoint):Boolean {
            var _local18:* = 0;
            var _local17:int = 0;
            var _local15:int = 0;
            var _local5:int = 0;
            var _local11:* = int(_arg_1.width);
            var _local6:* = int(_arg_1.height);
            var _local10:* = int(_arg_2.x());
            var _local8:* = int(_arg_2.y());
            var _local14:* = int(_arg_3.x());
            var _local13:* = int(_arg_3.y());
            var _local7:* = (_local8 > _local13 ? _local8 - _local13 : Number(_local13 - _local8)) > (_local10 > _local14 ? _local10 - _local14 : Number(_local14 - _local10));
            if (_local7) {
                _local18 = _local10;
                _local10 = _local8;
                _local8 = _local18;
                _local18 = _local14;
                _local14 = _local13;
                _local13 = _local18;
                _local18 = _local11;
                _local11 = _local6;
                _local6 = _local18;
            }
            if (_local10 > _local14) {
                _local18 = _local10;
                _local10 = _local14;
                _local14 = _local18;
                _local18 = _local8;
                _local8 = _local13;
                _local13 = _local18;
            }
            var _local16:int = _local14 - _local10;
            var _local20:int = _local8 > _local13 ? _local8 - _local13 : Number(_local13 - _local8);
            var _local19:int = -(_local16 + 1) * 0.5;
            var _local9:int = _local8 > _local13 ? -1 : 1;
            var _local21:int = _local14 > _local11 - 1 ? _local11 - 1 : _local14;
            var _local4:* = _local8;
            var _local12:* = _local10;
            if (_local12 < 0) {
                _local19 = _local19 + _local20 * -_local12;
                if (_local19 >= 0) {
                    _local17 = _local19 / _local16 + 1;
                    _local4 = _local4 + _local9 * _local17;
                    _local19 = _local19 - _local17 * _local16;
                }
                _local12 = 0;
            }
            if (_local9 > 0 && _local4 < 0 || _local9 < 0 && _local4 >= _local6) {
                _local15 = _local9 > 0 ? -_local4 - 1 : Number(_local4 - _local6);
                _local19 = _local19 - _local16 * _local15;
                _local5 = -_local19 / _local20;
                _local12 = _local12 + _local5;
                _local19 = _local19 + _local5 * _local20;
                _local4 = _local4 + _local15 * _local9;
            }
            while (_local12 <= _local21) {
                if (!(_local9 > 0 && _local4 >= _local6 || _local9 < 0 && _local4 < 0)) {
                    if (_local7) {
                        if (_local4 >= 0 && _local4 < _local6 && _arg_1.getPixel(_local4, _local12) == 0) {
                            return false;
                        }
                    } else if (_local4 >= 0 && _local4 < _local6 && _arg_1.getPixel(_local12, _local4) == 0) {
                        return false;
                    }
                    _local19 = _local19 + _local20;
                    if (_local19 >= 0) {
                        _local4 = _local4 + _local9;
                        _local19 = _local19 - _local16;
                    }
                    _local12++;
                    continue;
                }
                break;
            }
            return true;
        }

        public function BitmapUtil(_arg_1:StaticEnforcer_2478) {
            super();
        }
    }
}

class StaticEnforcer_2478 {
    function StaticEnforcer_2478() {
        super();
    }
}
