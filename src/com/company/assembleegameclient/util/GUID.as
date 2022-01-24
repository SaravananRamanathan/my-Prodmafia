package com.company.assembleegameclient.util {
public class GUID {

    private static var counter:Number = 0;

    public static function create():String {
        var _local2:Date = new Date();
        var _local1:int = _local2.getTime();
        return "A" + Math.random() * 0xFFFFFFFF + "B" + _local1;
    }

    public static function str_b64(_arg_1:String):String {
        return binb2b64(str2binb_2(_arg_1));
    }

    private static function calculate(_arg_1:String):String {
        return hex_sha1(_arg_1);
    }

    private static function hex_sha1(_arg_1:String):String {
        return binb2hex(core_sha1(str2binb(_arg_1), _arg_1.length * 8));
    }

    private static function core_sha1(_arg_1:Array, _arg_2:Number):Array {
        var _local9:Number = NaN;
        var _local15:Number = NaN;
        var _local10:Number = NaN;
        var _local6:Number = NaN;
        var _local4:Number = NaN;
        var _local12:* = NaN;
        var _local13:Number = NaN;
        _arg_1[_arg_2 >> 5] = _arg_1[_arg_2 >> 5] | 128 << 24 - _arg_2 % 32;
        _arg_1[(_arg_2 + 64 >> 9 << 4) + 15] = _arg_2;
        var _local11:Array = new Array(80);
        var _local3:* = 1732584193;
        var _local5:* = -271733879;
        var _local16:* = -1732584194;
        var _local14:* = 271733878;
        var _local8:* = -1009589776;
        var _local7:* = 0;
        while (_local7 < _arg_1.length) {
            _local9 = _local3;
            _local15 = _local5;
            _local10 = _local16;
            _local6 = _local14;
            _local4 = _local8;
            _local12 = 0;
            while (_local12 < 80) {
                if (_local12 < 16) {
                    _local11[_local12] = _arg_1[_local7 + _local12];
                } else {
                    _local11[_local12] = rol(_local11[_local12 - 3] ^ _local11[_local12 - 8] ^ _local11[_local12 - 14] ^ _local11[_local12 - 16], 1);
                }
                _local13 = safe_add(safe_add(rol(_local3, 5), sha1_ft(_local12, _local5, _local16, _local14)), safe_add(safe_add(_local8, _local11[_local12]), sha1_kt(_local12)));
                _local8 = _local14;
                _local14 = _local16;
                _local16 = rol(_local5, 30);
                _local5 = _local3;
                _local3 = _local13;
                _local12++;
            }
            _local3 = safe_add(_local3, _local9);
            _local5 = safe_add(_local5, _local15);
            _local16 = safe_add(_local16, _local10);
            _local14 = safe_add(_local14, _local6);
            _local8 = safe_add(_local8, _local4);
            _local7 = _local7 + 16;
        }
        return [_local3, _local5, _local16, _local14, _local8];
    }

    private static function sha1_ft(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number):Number {
        if (_arg_1 < 20) {
            return _arg_2 & _arg_3 | ~_arg_2 & _arg_4;
        }
        if (_arg_1 < 40) {
            return _arg_2 ^ _arg_3 ^ _arg_4;
        }
        if (_arg_1 < 60) {
            return _arg_2 & _arg_3 | _arg_2 & _arg_4 | _arg_3 & _arg_4;
        }
        return _arg_2 ^ _arg_3 ^ _arg_4;
    }

    private static function sha1_kt(_arg_1:Number):Number {
        return _arg_1 < 20 ? 1518500249 : Number(_arg_1 < 40 ? 1859775393 : Number(_arg_1 < 60 ? -1894007588 : -899497514));
    }

    private static function safe_add(_arg_1:Number, _arg_2:Number):Number {
        var _local4:Number = (_arg_1 & 65535) + (_arg_2 & 65535);
        var _local3:Number = (_arg_1 >> 16) + (_arg_2 >> 16) + (_local4 >> 16);
        return _local3 << 16 | _local4 & 65535;
    }

    private static function rol(_arg_1:Number, _arg_2:Number):Number {
        return _arg_1 << _arg_2 | _arg_1 >>> 32 - _arg_2;
    }

    private static function str2binb_2(_arg_1:String):Array {
        var _local6:int = 0;
        var _local4:* = undefined;
        var _local3:* = undefined;
        var _local2:* = [];
        _local6 = 0;
        while (_local6 < _arg_1.length * 8) {
            _local4 = _local6 >> 5;
            _local3 = _local2[_local4] | (_arg_1.charCodeAt(_local6 / 8) & 255) << 24 - _local6 % 32;
            _local2[_local4] = _local3;
            _local6 = _local6 + 8;
        }
        return _local2;
    }

    private static function str2binb(_arg_1:String):Array {
        var _local2:* = [];
        var _local3:* = 0;
        while (_local3 < _arg_1.length * 8) {
            _local2[_local3 >> 5] = _local2[_local3 >> 5] | (_arg_1.charCodeAt(_local3 / 8) & 128) << 24 - _local3 % 32;
            _local3 = _local3 + 8;
        }
        return _local2;
    }

    private static function binb2hex(_arg_1:Array):String {
        var _local2:String = "";
        var _local3:int = 0;
        while (_local3 < _arg_1.length * 4) {
            _local2 = _local2 + ("0123456789abcdef".charAt(_arg_1[_local3 >> 2] >> (3 - _local3 % 4) * 8 + 4 & 15) + "0123456789abcdef".charAt(_arg_1[_local3 >> 2] >> (3 - _local3 % 4) * 8 & 15));
            _local3++;
        }
        return _local2;
    }

    private static function binb2b64(_arg_1:Array):String {
        var _local4:int = 0;
        var _local6:* = 0;
        var _local3:int = 0;
        var _local2:String = "";
        _local4 = 0;
        while (_local4 < _arg_1.length * 4) {
            _local6 = (_arg_1[_local4 >> 2] >> 8 * (3 - _local4 % 4) & 255) << 16 | (_arg_1[_local4 + 1 >> 2] >> 8 * (3 - (_local4 + 1) % 4) & 255) << 8 | _arg_1[_local4 + 2 >> 2] >> 8 * (3 - (_local4 + 2) % 4) & 255;
            _local3 = 0;
            while (_local3 < 4) {
                if (_local4 * 8 + _local3 * 6 > _arg_1.length * 32) {
                    _local2 = _local2 + "=";
                } else {
                    _local2 = _local2 + "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/".charAt(_local6 >> 6 * (3 - _local3) & 63);
                }
                _local3++;
            }
            _local4 = _local4 + 3;
        }
        return _local2;
    }

    public function GUID() {
        super();
    }
}
}
