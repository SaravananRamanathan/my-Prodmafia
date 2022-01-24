package com.company.assembleegameclient.util {
import flash.display.BitmapData;
import flash.utils.Dictionary;

public class BloodComposition {

    public static var idDict_:Dictionary = new Dictionary();

    public static var imageDict_:Dictionary = new Dictionary();

    public static function getBloodComposition(_arg_1:int, _arg_2:BitmapData, _arg_3:Number, _arg_4:uint):Vector.<uint> {
        var _local5:int = 0;
        var _local6:Vector.<uint> = idDict_[_arg_1];
        if (_local6) {
            return _local6;
        }
        _local6 = new Vector.<uint>();
        var _local7:Vector.<uint> = getColors(_arg_2);
        _local5 = 0;
        while (_local5 < _local7.length) {
            if (Math.random() < _arg_3) {
                _local6.push(_arg_4);
            } else {
                _local6.push(_local7[int(_local7.length * Math.random())]);
            }
            _local5++;
        }
        return _local6;
    }

    public static function getColors(_arg_1:BitmapData):Vector.<uint> {
        var _local2:Vector.<uint> = imageDict_[_arg_1];
        if (_local2 == null) {
            _local2 = buildColors(_arg_1);
            imageDict_[_arg_1] = _local2;
        }
        return _local2;
    }

    private static function buildColors(_arg_1:BitmapData):Vector.<uint> {
        var _local5:int = 0;
        var _local4:int = 0;
        var _local2:* = 0;
        var _local3:Vector.<uint> = new Vector.<uint>();
        _local5 = 0;
        while (_local5 < _arg_1.width) {
            _local4 = 0;
            while (_local4 < _arg_1.height) {
                _local2 = uint(_arg_1.getPixel32(_local5, _local4));
                if ((_local2 & 4278190080) != 0) {
                    _local3.push(_local2);
                }
                _local4++;
            }
            _local5++;
        }
        return _local3;
    }

    public function BloodComposition() {
        super();
    }
}
}
