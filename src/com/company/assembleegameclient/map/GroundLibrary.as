package com.company.assembleegameclient.map {
import com.company.assembleegameclient.objects.TextureDataConcrete;
import com.company.util.BitmapUtil;

import flash.display.BitmapData;
import flash.utils.Dictionary;

public class GroundLibrary {

    public static const propsLibrary_:Dictionary = new Dictionary();

    public static const xmlLibrary_:Dictionary = new Dictionary();

    public static const typeToTextureData_:Dictionary = new Dictionary();

    public static var defaultProps_:GroundProperties;

    public static var GROUND_CATEGORY:String = "Ground";

    public static var idToType_:Dictionary = new Dictionary();

    private static var tileTypeColorDict_:Dictionary = new Dictionary();

    public static function parseFromXML(_arg_1:XML):void {
        var _local3:int = 0;
        var _local2:* = null;
        var _local5:int = 0;
        var _local4:* = _arg_1.Ground;
        for each(_local2 in _arg_1.Ground) {
            _local3 = _local2.@type;
            propsLibrary_[_local3] = new GroundProperties(_local2);
            xmlLibrary_[_local3] = _local2;
            typeToTextureData_[_local3] = new TextureDataConcrete(_local2);
            idToType_[_local2.@id] = _local3;
        }
        defaultProps_ = propsLibrary_[255];
    }

    public static function getIdFromType(_arg_1:int):String {
        var _local2:GroundProperties = propsLibrary_[_arg_1];
        if (_local2 == null) {
            return null;
        }
        return _local2.id_;
    }

    public static function getPropsFromId(_arg_1:String):GroundProperties {
        return propsLibrary_[idToType_[_arg_1]];
    }

    public static function getBitmapData(_arg_1:int, _arg_2:int = 0):BitmapData {
        return typeToTextureData_[_arg_1].getTexture(_arg_2);
    }

    public static function getColor(_arg_1:int):uint {
        var _local2:* = null;
        var _local4:* = 0;
        var _local3:* = null;
        if (!(_arg_1 in tileTypeColorDict_)) {
            _local2 = xmlLibrary_[_arg_1];
            if ("Color" in _local2) {
                _local4 = uint(_local2.Color);
            } else {
                _local3 = getBitmapData(_arg_1);
                _local4 = uint(BitmapUtil.mostCommonColor(_local3));
            }
            tileTypeColorDict_[_arg_1] = _local4;
        }
        return tileTypeColorDict_[_arg_1];
    }

    public function GroundLibrary() {
        super();
    }
}
}
