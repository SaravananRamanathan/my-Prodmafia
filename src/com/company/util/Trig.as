package com.company.util {
public class Trig {

    public static const toDegrees:Number = 57.2957795130823;

    public static const toRadians:Number = 0.0174532925199433;

    public static function slerp(_arg_1:Number, _arg_2:Number, _arg_3:Number):Number {
        var _local4:* = Infinity;
        if (_arg_1 > _arg_2) {
            if (_arg_1 - _arg_2 > 3.14159265358979) {
                _local4 = _arg_1 * (1 - _arg_3) + (_arg_2 + 6.28318530717959) * _arg_3;
            } else {
                _local4 = _arg_1 * (1 - _arg_3) + _arg_2 * _arg_3;
            }
        } else if (_arg_2 - _arg_1 > 3.14159265358979) {
            _local4 = (_arg_1 + 6.28318530717959) * (1 - _arg_3) + _arg_2 * _arg_3;
        } else {
            _local4 = _arg_1 * (1 - _arg_3) + _arg_2 * _arg_3;
        }
        if (_local4 < -3.14159265358979 || _local4 > 3.14159265358979) {
            _local4 = boundToPI(_local4);
        }
        return _local4;
    }

    public static function angleDiff(_arg_1:Number, _arg_2:Number):Number {
        if (_arg_1 > _arg_2) {
            if (_arg_1 - _arg_2 > 3.14159265358979) {
                return _arg_2 + 6.28318530717959 - _arg_1;
            }
            return _arg_1 - _arg_2;
        }
        if (_arg_2 - _arg_1 > 3.14159265358979) {
            return _arg_1 + 6.28318530717959 - _arg_2;
        }
        return _arg_2 - _arg_1;
    }

    public static function sin(_arg_1:Number):Number {
        var _local2:Number = NaN;
        if (_arg_1 < -3.14159265358979 || _arg_1 > 3.14159265358979) {
            _arg_1 = boundToPI(_arg_1);
        }
        if (_arg_1 < 0) {
            _local2 = 1.27323954 * _arg_1 + 0.405284735 * _arg_1 * _arg_1;
            if (_local2 < 0) {
                _local2 = 0.225 * (_local2 * -_local2 - _local2) + _local2;
            } else {
                _local2 = 0.225 * (_local2 * _local2 - _local2) + _local2;
            }
        } else {
            _local2 = 1.27323954 * _arg_1 - 0.405284735 * _arg_1 * _arg_1;
            if (_local2 < 0) {
                _local2 = 0.225 * (_local2 * -_local2 - _local2) + _local2;
            } else {
                _local2 = 0.225 * (_local2 * _local2 - _local2) + _local2;
            }
        }
        return _local2;
    }

    public static function cos(_arg_1:Number):Number {
        return sin(_arg_1 + 1.5707963267949);
    }

    public static function atan2(_arg_1:Number, _arg_2:Number):Number {
        var _local3:Number = NaN;
        if (_arg_2 == 0) {
            if (_arg_1 < 0) {
                return -1.5707963267949;
            }
            if (_arg_1 > 0) {
                return 1.5707963267949;
            }
            return undefined;
        }
        if (_arg_1 == 0) {
            if (_arg_2 < 0) {
                return 3.14159265358979;
            }
            return 0;
        }
        if ((_arg_2 > 0 ? _arg_2 : Number(-_arg_2)) > (_arg_1 > 0 ? _arg_1 : Number(-_arg_1))) {
            _local3 = (_arg_2 < 0 ? -3.14159265358979 : 0) + atan2Helper(_arg_1, _arg_2);
        } else {
            _local3 = (_arg_1 > 0 ? 1.5707963267949 : -1.5707963267949) - atan2Helper(_arg_2, _arg_1);
        }
        if (_local3 < -3.14159265358979 || _local3 > 3.14159265358979) {
            _local3 = boundToPI(_local3);
        }
        return _local3;
    }

    public static function atan2Helper(_arg_1:Number, _arg_2:Number):Number {
        var _local6:Number = _arg_1 / _arg_2;
        var _local3:* = _local6;
        var _local7:* = _local6;
        var _local5:* = 1;
        var _local4:int = 1;
        do {
            _local5 = _local5 + 2;
            _local4 = _local4 > 0 ? -1 : 1;
            _local7 = _local7 * _local6 * _local6;
            _local3 = _local3 + _local4 * _local7 / _local5;
        }
        while ((_local7 > 0.01 || _local7 < -0.01) && _local5 <= 11);

        return _local3;
    }

    public static function boundToPI(_arg_1:Number):Number {
        var _local2:int = 0;
        if (_arg_1 < -3.14159265358979) {
            _local2 = (int(_arg_1 / -3.14159265358979) + 1) * 0.5;
            _arg_1 = _arg_1 + _local2 * 6.28318530717959;
        } else if (_arg_1 > 3.14159265358979) {
            _local2 = (int(_arg_1 / 3.14159265358979) + 1) * 0.5;
            _arg_1 = _arg_1 - _local2 * 6.28318530717959;
        }
        return _arg_1;
    }

    public static function boundTo180(_arg_1:Number):Number {
        var _local2:int = 0;
        if (_arg_1 < -180) {
            _local2 = (int(_arg_1 / -180) + 1) * 0.5;
            _arg_1 = _arg_1 + _local2 * 360;
        } else if (_arg_1 > 3 * 60) {
            _local2 = (int(_arg_1 / 180) + 1) * 0.5;
            _arg_1 = _arg_1 - _local2 * 360;
        }
        return _arg_1;
    }

    public static function unitTest():Boolean {
        trace("STARTING UNITTEST: Trig");
        var _local1:Boolean = testFunc1(Math.sin, sin) && testFunc1(Math.cos, cos) && testFunc2(Math.atan2, atan2);
        if (!_local1) {
            trace("Trig Unit Test FAILED!");
        }
        trace("FINISHED UNITTEST: Trig");
        return _local1;
    }

    public static function testFunc1(_arg_1:Function, _arg_2:Function):Boolean {
        var _local3:Number = NaN;
        var _local5:Number = NaN;
        var _local4:int = 0;
        var _local6:Random = new Random();
        while (_local4 < 1000) {
            _local3 = _local6.nextInt() % 2000 - 1000 + _local6.nextDouble();
            _local5 = Math.abs(_arg_1(_local3) - _arg_2(_local3));
            if (_local5 > 0.1) {
                return false;
            }
            _local4++;
        }
        return true;
    }

    public static function testFunc2(_arg_1:Function, _arg_2:Function):Boolean {
        var _local7:Number = NaN;
        var _local5:Number = NaN;
        var _local4:Number = NaN;
        var _local3:int = 0;
        var _local6:Random = new Random();
        while (_local3 < 1000) {
            _local7 = _local6.nextInt() % 2000 - 1000 + _local6.nextDouble();
            _local5 = _local6.nextInt() % 2000 - 1000 + _local6.nextDouble();
            _local4 = Math.abs(_arg_1(_local7, _local5) - _arg_2(_local7, _local5));
            if (_local4 > 0.1) {
                return false;
            }
            _local3++;
        }
        return true;
    }

    public function Trig(_arg_1:StaticEnforcer_2846) {
        super();
    }
}
}

class StaticEnforcer_2846 {


    function StaticEnforcer_2846() {
        super();
    }
}
