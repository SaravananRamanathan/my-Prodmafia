package com.company.util {
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.geom.Vector3D;

public class ConversionUtil {


    public static function toIntArray(_arg_1:Object, _arg_2:String = ","):Array {
        if (_arg_1 == null) {
            return [];
        }
        return _arg_1.toString().split(_arg_2).map(mapParseInt);
    }

    public static function toNumberArray(_arg_1:Object, _arg_2:String = ","):Array {
        if (_arg_1 == null) {
            return [];
        }
        return _arg_1.toString().split(_arg_2).map(mapParseFloat);
    }

    public static function toIntVector(_arg_1:Object, _arg_2:String = ","):Vector.<int> {
        if (_arg_1 == null) {
            return new Vector.<int>();
        }
        return Vector.<int>(_arg_1.toString().split(_arg_2).map(mapParseInt));
    }

    public static function toNumberVector(_arg_1:Object, _arg_2:String = ","):Vector.<Number> {
        if (_arg_1 == null) {
            return new Vector.<Number>();
        }
        return Vector.<Number>(_arg_1.toString().split(_arg_2).map(mapParseFloat));
    }

    public static function toStringArray(_arg_1:Object, _arg_2:String = ","):Array {
        if (_arg_1 == null) {
            return [];
        }
        return _arg_1.toString().split(_arg_2);
    }

    public static function toRectangle(_arg_1:Object, _arg_2:String = ","):Rectangle {
        if (_arg_1 == null) {
            return new Rectangle();
        }
        var _local3:Array = _arg_1.toString().split(_arg_2).map(mapParseFloat);
        return _local3 == null || _local3.length < 4 ? new Rectangle() : new Rectangle(_local3[0], _local3[1], _local3[2], _local3[3]);
    }

    public static function toPoint(_arg_1:Object, _arg_2:String = ","):Point {
        if (_arg_1 == null) {
            return new Point();
        }
        var _local3:Array = _arg_1.toString().split(_arg_2).map(ConversionUtil.mapParseFloat);
        return _local3 == null || _local3.length < 2 ? new Point() : new Point(_local3[0], _local3[1]);
    }

    public static function toPointPair(_arg_1:Object, _arg_2:String = ","):Array {
        var _local4:* = [];
        if (_arg_1 == null) {
            _local4.push(new Point());
            _local4.push(new Point());
            return _local4;
        }
        var _local3:Array = _arg_1.toString().split(_arg_2).map(ConversionUtil.mapParseFloat);
        if (_local3 == null || _local3.length < 4) {
            _local4.push(new Point());
            _local4.push(new Point());
            return _local4;
        }
        _local4.push(new Point(_local3[0], _local3[1]));
        _local4.push(new Point(_local3[2], _local3[3]));
        return _local4;
    }

    public static function toVector3D(_arg_1:Object, _arg_2:String = ","):Vector3D {
        if (_arg_1 == null) {
            return new Vector3D();
        }
        var _local3:Array = _arg_1.toString().split(_arg_2).map(ConversionUtil.mapParseFloat);
        return _local3 == null || _local3.length < 3 ? new Vector3D() : new Vector3D(_local3[0], _local3[1], _local3[2]);
    }

    public static function toCharCodesVector(_arg_1:Object, _arg_2:String = ","):Vector.<int> {
        if (_arg_1 == null) {
            return new Vector.<int>();
        }
        return Vector.<int>(_arg_1.toString().split(_arg_2).map(mapParseCharCode));
    }

    public static function addToNumberVector(_arg_1:Object, _arg_2:Vector.<Number>, _arg_3:String = ","):void {
        var _local4:Number = NaN;
        if (_arg_1 == null) {
            return;
        }
        var _local5:Array = _arg_1.toString().split(_arg_3).map(mapParseFloat);
        var _local7:int = 0;
        var _local6:* = _local5;
        for each(_local4 in _local5) {
            _arg_2.push(_local4);
        }
    }

    public static function addToIntVector(_arg_1:Object, _arg_2:Vector.<int>, _arg_3:String = ","):void {
        var _local4:int = 0;
        if (_arg_1 == null) {
            return;
        }
        var _local5:Array = _arg_1.toString().split(_arg_3).map(mapParseFloat);
        var _local7:int = 0;
        var _local6:* = _local5;
        for each(_local4 in _local5) {
            _arg_2.push(_local4);
        }
    }

    public static function mapParseFloat(_arg_1:*, ...rest):Number {
        return parseFloat(_arg_1);
    }

    public static function mapParseInt(_arg_1:*, ...rest):Number {
        return parseInt(_arg_1);
    }

    public static function mapParseCharCode(_arg_1:*, ...rest):Number {
        return String(_arg_1).charCodeAt();
    }

    public static function vector3DToShaderParameter(_arg_1:Vector3D):Array {
        return [_arg_1.x, _arg_1.y, _arg_1.z];
    }

    public function ConversionUtil(_arg_1:StaticEnforcer_3938) {
        super();
    }
}
}

class StaticEnforcer_3938 {


    function StaticEnforcer_3938() {
        super();
    }
}
