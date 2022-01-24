package com.company.assembleegameclient.util {
public class RandomUtil {

    internal static const chars:String = "abcdefghijkmnopqrstuvwxyz";

    public static function randomString(_arg_1:int):String {
        var _local2:int = 0;
        var _local3:String = "abcdefghijkmnopqrstuvwxyz".charAt(Math.floor(Math.random() * 25));
        _local2 = 1;
        while (_local2 < _arg_1) {
            _local3 = _local3 + "abcdefghijkmnopqrstuvwxyz".charAt(Math.floor(Math.random() * 25));
            _local2++;
        }
        return _local3;
    }

    public static function plusMinus(_arg_1:Number):Number {
        return Math.random() * _arg_1 * 2 - _arg_1;
    }

    public static function randomRange(_arg_1:Number, _arg_2:Number):Number {
        return Math.ceil(Math.random() * (_arg_2 - _arg_1)) + _arg_1;
    }

    public function RandomUtil() {
        super();
    }
}
}
