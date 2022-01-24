package com.company.assembleegameclient.util {
public class ColorUtil {


    public static function rangeRandomSmart(_arg_1:uint, _arg_2:uint):Number {
        var _local8:uint = _arg_1 >> 16 & 255;
        var _local11:uint = _arg_1 >> 8 & 255;
        var _local10:uint = _arg_1 & 255;
        var _local7:uint = _arg_2 >> 16 & 255;
        var _local6:uint = _arg_2 >> 8 & 255;
        var _local9:uint = _arg_2 & 255;
        var _local3:uint = _local7 + Math.random() * (_local8 - _local7);
        var _local4:uint = _local6 + Math.random() * (_local11 - _local6);
        var _local5:uint = _local9 + Math.random() * (_local10 - _local9);
        return _local3 << 16 | _local4 << 8 | _local5;
    }

    public static function randomSmart(_arg_1:uint):Number {
        var _local2:uint = _arg_1 >> 16 & 255;
        var _local6:uint = _arg_1 >> 8 & 255;
        var _local3:uint = _arg_1 & 255;
        var _local7:uint = Math.max(0, Math.min(255, _local2 + RandomUtil.plusMinus(_local2 * 0.05)));
        var _local5:uint = Math.max(0, Math.min(255, _local6 + RandomUtil.plusMinus(_local6 * 0.05)));
        var _local4:uint = Math.max(0, Math.min(255, _local3 + RandomUtil.plusMinus(_local3 * 0.05)));
        return _local7 << 16 | _local5 << 8 | _local4;
    }

    public static function rangeRandomMix(_arg_1:uint, _arg_2:uint):Number {
        var _local9:uint = _arg_1 >> 16 & 255;
        var _local11:uint = _arg_1 >> 8 & 255;
        var _local10:uint = _arg_1 & 255;
        var _local8:uint = _arg_2 >> 16 & 255;
        var _local6:uint = _arg_2 >> 8 & 255;
        var _local4:uint = _arg_2 & 255;
        var _local5:Number = Math.random();
        var _local3:uint = _local8 + _local5 * (_local9 - _local8);
        var _local12:uint = _local6 + _local5 * (_local11 - _local6);
        var _local7:uint = _local4 + _local5 * (_local10 - _local4);
        return _local3 << 16 | _local12 << 8 | _local7;
    }

    public static function rangeRandom(_arg_1:uint, _arg_2:uint):Number {
        return _arg_2 + Math.random() * (_arg_1 - _arg_2);
    }

    public function ColorUtil() {
        super();
    }
}
}
