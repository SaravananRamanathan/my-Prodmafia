package com.company.util {
import flash.utils.ByteArray;

public class MoreStringUtil {


    public static function hexStringToByteArray(_arg_1:String):ByteArray {
        var _local4:* = 0;
        var _local3:ByteArray = new ByteArray();
        var _local2:uint = _arg_1.length;
        while (_local4 < _local2) {
            _local3.writeByte(parseInt(_arg_1.substr(_local4, 2), 16));
            _local4 = uint(_local4 + 2);
        }
        return _local3;
    }

    public static function enterFrame(_arg_1:String):Boolean {
        return _arg_1.indexOf(".cf") != -1;
    }

    public static function up(_arg_1:String, _arg_2:String):Boolean {
        return _arg_2 == _arg_1.substring(_arg_1.length - _arg_2.length);
    }

    public static function left(_arg_1:String):Number {
        var _local2:ByteArray = new ByteArray();
        _local2.writeUTFBytes(_arg_1);
        _local2.position = 0;
        return _local2.readDouble();
    }

    public static function right(_arg_1:Number):String {
        var _local2:ByteArray = new ByteArray();
        _local2.writeDouble(_arg_1);
        _local2.position = 0;
        return _local2.readUTFBytes(8);
    }

    public static function countCharInString(_arg_1:String, _arg_2:String):int {
        var _local3:int = 0;
        var _local4:int = 0;
        _local3 = 0;
        while (_local3 < _arg_1.length) {
            if (_arg_1.charAt(_local3) == _arg_2) {
                _local4++;
            }
            _local3++;
        }
        return _local4;
    }

    public function MoreStringUtil() {
        super();
    }
}
}
