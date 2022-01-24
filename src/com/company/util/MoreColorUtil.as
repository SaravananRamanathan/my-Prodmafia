package com.company.util {
import flash.geom.ColorTransform;

public class MoreColorUtil {

    public static const greyscaleFilterMatrix:Array = [0.3, 0.59, 0.11, 0, 0, 0.3, 0.59, 0.11, 0, 0, 0.3, 0.59, 0.11, 0, 0, 0, 0, 0, 1, 0];

    public static const redFilterMatrix:Array = [0.3, 0.59, 0.11, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0];

    public static const identity:ColorTransform = new ColorTransform();

    public static const invisible:ColorTransform = new ColorTransform(1, 1, 1, 0, 0, 0, 0, 0);

    public static const transparentCT:ColorTransform = new ColorTransform(1, 1, 1, 0.3, 0, 0, 0, 0);

    public static const slightlyTransparentCT:ColorTransform = new ColorTransform(1, 1, 1, 0.7, 0, 0, 0, 0);

    public static const greenCT:ColorTransform = new ColorTransform(0.6, 1, 0.6, 1, 0, 0, 0, 0);

    public static const lightGreenCT:ColorTransform = new ColorTransform(0.8, 1, 0.8, 1, 0, 0, 0, 0);

    public static const veryGreenCT:ColorTransform = new ColorTransform(0.2, 1, 0.2, 1, 0, 100, 0, 0);

    public static const transparentGreenCT:ColorTransform = new ColorTransform(0.5, 1, 0.5, 0.3, 0, 0, 0, 0);

    public static const transparentVeryGreenCT:ColorTransform = new ColorTransform(0.3, 1, 0.3, 0.5, 0, 0, 0, 0);

    public static const redCT:ColorTransform = new ColorTransform(1, 0.5, 0.5, 1, 0, 0, 0, 0);

    public static const lightRedCT:ColorTransform = new ColorTransform(1, 0.7, 0.7, 1, 0, 0, 0, 0);

    public static const veryRedCT:ColorTransform = new ColorTransform(1, 0.2, 0.2, 1, 100, 0, 0, 0);

    public static const transparentRedCT:ColorTransform = new ColorTransform(1, 0.5, 0.5, 0.3, 0, 0, 0, 0);

    public static const transparentVeryRedCT:ColorTransform = new ColorTransform(1, 0.3, 0.3, 0.5, 0, 0, 0, 0);

    public static const blueCT:ColorTransform = new ColorTransform(0.5, 0.5, 1, 1, 0, 0, 0, 0);

    public static const lightBlueCT:ColorTransform = new ColorTransform(0.7, 0.7, 1, 1, 0, 0, 100, 0);

    public static const veryBlueCT:ColorTransform = new ColorTransform(0.3, 0.3, 1, 1, 0, 0, 100, 0);

    public static const transparentBlueCT:ColorTransform = new ColorTransform(0.5, 0.5, 1, 0.3, 0, 0, 0, 0);

    public static const transparentVeryBlueCT:ColorTransform = new ColorTransform(0.3, 0.3, 1, 0.5, 0, 0, 0, 0);

    public static const purpleCT:ColorTransform = new ColorTransform(1, 0.5, 1, 1, 0, 0, 0, 0);

    public static const veryPurpleCT:ColorTransform = new ColorTransform(1, 0.2, 1, 1, 100, 0, 100, 0);

    public static const darkCT:ColorTransform = new ColorTransform(0.6, 0.6, 0.6, 1, 0, 0, 0, 0);

    public static const veryDarkCT:ColorTransform = new ColorTransform(0.4, 0.4, 0.4, 1, 0, 0, 0, 0);

    public static const makeWhiteCT:ColorTransform = new ColorTransform(1, 1, 1, 1, 255, 255, 255, 0);

    public static function hsvToRgb(_arg_1:Number, _arg_2:Number, _arg_3:Number):int {
        var _local4:* = NaN;
        var _local9:* = NaN;
        var _local7:* = NaN;
        var _local11:int = int(_arg_1 / 60) % 6;
        var _local10:Number = _arg_1 / 60 - Math.floor(_arg_1 / 60);
        var _local8:Number = _arg_3 * (1 - _arg_2);
        var _local6:Number = _arg_3 * (1 - _local10 * _arg_2);
        var _local5:Number = _arg_3 * (1 - (1 - _local10) * _arg_2);
        switch (int(_local11)) {
            case 0:
                _local4 = _arg_3;
                _local9 = _local5;
                _local7 = _local8;
                break;
            case 1:
                _local4 = _local6;
                _local9 = _arg_3;
                _local7 = _local8;
                break;
            case 2:
                _local4 = _local8;
                _local9 = _arg_3;
                _local7 = _local5;
                break;
            case 3:
                _local4 = _local8;
                _local9 = _local6;
                _local7 = _arg_3;
                break;
            case 4:
                _local4 = _local5;
                _local9 = _local8;
                _local7 = _arg_3;
                break;
            case 5:
                _local4 = _arg_3;
                _local9 = _local8;
                _local7 = _local6;
        }
        return Math.min(255, Math.floor(_local4 * 255)) << 16 | Math.min(255, Math.floor(_local9 * 255)) << 8 | Math.min(255, Math.floor(_local7 * 255));
    }

    public static function randomColor():uint {
        return uint(16777215 * Math.random());
    }

    public static function randomColor32():uint {
        return uint(16777215 * Math.random()) | 4278190080;
    }

    public static function transformColor(_arg_1:ColorTransform, _arg_2:uint):uint {
        var _local5:int = ((_arg_2 & 16711680) >> 16) * _arg_1.redMultiplier + _arg_1.redOffset;
        _local5 = _local5 < 0 ? 0 : _local5 > 255 ? 255 : _local5;
        var _local4:int = ((_arg_2 & 65280) >> 8) * _arg_1.greenMultiplier + _arg_1.greenOffset;
        _local4 = _local4 < 0 ? 0 : _local4 > 255 ? 255 : _local4;
        var _local3:int = (_arg_2 & 255) * _arg_1.blueMultiplier + _arg_1.blueOffset;
        _local3 = _local3 < 0 ? 0 : _local3 > 255 ? 255 : _local3;
        return _local5 << 16 | _local4 << 8 | _local3;
    }

    public static function copyColorTransform(_arg_1:ColorTransform):ColorTransform {
        return new ColorTransform(_arg_1.redMultiplier, _arg_1.greenMultiplier, _arg_1.blueMultiplier, _arg_1.alphaMultiplier, _arg_1.redOffset, _arg_1.greenOffset, _arg_1.blueOffset, _arg_1.alphaOffset);
    }

    public static function lerpColorTransform(_arg_1:ColorTransform, _arg_2:ColorTransform, _arg_3:Number):ColorTransform {
        if (_arg_1 == null) {
            _arg_1 = identity;
        }
        if (_arg_2 == null) {
            _arg_2 = identity;
        }
        var _local5:Number = 1 - _arg_3;
        var _local4:ColorTransform = new ColorTransform(_arg_1.redMultiplier * _local5 + _arg_2.redMultiplier * _arg_3, _arg_1.greenMultiplier * _local5 + _arg_2.greenMultiplier * _arg_3, _arg_1.blueMultiplier * _local5 + _arg_2.blueMultiplier * _arg_3, _arg_1.alphaMultiplier * _local5 + _arg_2.alphaMultiplier * _arg_3, _arg_1.redOffset * _local5 + _arg_2.redOffset * _arg_3, _arg_1.greenOffset * _local5 + _arg_2.greenOffset * _arg_3, _arg_1.blueOffset * _local5 + _arg_2.blueOffset * _arg_3, _arg_1.alphaOffset * _local5 + _arg_2.alphaOffset * _arg_3);
        return _local4;
    }

    public static function lerpColor(_arg_1:uint, _arg_2:uint, _arg_3:Number):uint {
        var _local4:Number = 1 - _arg_3;
        var _local6:uint = _arg_1 >> 24 & 255;
        var _local17:uint = _arg_1 >> 16 & 255;
        var _local15:uint = _arg_1 >> 8 & 255;
        var _local8:uint = _arg_1 & 255;
        var _local11:uint = _arg_2 >> 24 & 255;
        var _local10:uint = _arg_2 >> 16 & 255;
        var _local5:uint = _arg_2 >> 8 & 255;
        var _local16:uint = _arg_2 & 255;
        var _local9:uint = _local6 * _local4 + _local11 * _arg_3;
        var _local7:uint = _local17 * _local4 + _local10 * _arg_3;
        var _local13:uint = _local15 * _local4 + _local5 * _arg_3;
        var _local14:uint = _local8 * _local4 + _local16 * _arg_3;
        var _local12:uint = _local9 << 24 | _local7 << 16 | _local13 << 8 | _local14;
        return _local12;
    }

    public static function transformAlpha(_arg_1:ColorTransform, _arg_2:Number):Number {
        var _local4:uint = _arg_2 * 255;
        var _local3:uint = _local4 * _arg_1.alphaMultiplier + _arg_1.alphaOffset;
        _local3 = _local3 < 0 ? 0 : _local3 > 255 ? 255 : _local3;
        return _local3 / 255;
    }

    public static function multiplyColor(_arg_1:uint, _arg_2:Number):uint {
        var _local5:int = ((_arg_1 & 16711680) >> 16) * _arg_2;
        _local5 = _local5 < 0 ? 0 : _local5 > 255 ? 255 : _local5;
        var _local4:int = ((_arg_1 & 65280) >> 8) * _arg_2;
        _local4 = _local4 < 0 ? 0 : _local4 > 255 ? 255 : _local4;
        var _local3:int = (_arg_1 & 255) * _arg_2;
        _local3 = _local3 < 0 ? 0 : _local3 > 255 ? 255 : _local3;
        return _local5 << 16 | _local4 << 8 | _local3;
    }

    public static function adjustBrightness(_arg_1:uint, _arg_2:Number):uint {
        var _local6:uint = _arg_1 & 4278190080;
        var _local4:int = ((_arg_1 & 16711680) >> 16) + _arg_2 * 255;
        _local4 = _local4 < 0 ? 0 : _local4 > 255 ? 255 : _local4;
        var _local3:int = ((_arg_1 & 65280) >> 8) + _arg_2 * 255;
        _local3 = _local3 < 0 ? 0 : _local3 > 255 ? 255 : _local3;
        var _local5:int = (_arg_1 & 255) + _arg_2 * 255;
        _local5 = _local5 < 0 ? 0 : _local5 > 255 ? 255 : _local5;
        return _local6 | _local4 << 16 | _local3 << 8 | _local5;
    }

    public static function colorToShaderParameter(_arg_1:uint):Array {
        var _local2:Number = (_arg_1 >> 24 & 255) / 256;
        return [_local2 * ((_arg_1 >> 16 & 255) / 256), _local2 * ((_arg_1 >> 8 & 255) / 256), _local2 * ((_arg_1 & 255) / 256), _local2];
    }

    public static function singleColorFilterMatrix(_arg_1:uint):Array {
        return [0, 0, 0, 0, (_arg_1 & 16711680) >> 16, 0, 0, 0, 0, (_arg_1 & 65280) >> 8, 0, 0, 0, 0, _arg_1 & 255, 0, 0, 0, 1, 0];
    }

    public function MoreColorUtil(_arg_1:StaticEnforcer_3719) {
        super();
    }
}
}

class StaticEnforcer_3719 {


    function StaticEnforcer_3719() {
        super();
    }
}
