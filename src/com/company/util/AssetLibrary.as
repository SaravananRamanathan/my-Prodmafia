package com.company.util {
import flash.display.BitmapData;
import flash.media.Sound;
import flash.media.SoundTransform;
import flash.utils.Dictionary;

public class AssetLibrary {

    public static var imageSets_:Dictionary = new Dictionary();

    private static var images_:Dictionary = new Dictionary();

    private static var sounds_:Dictionary = new Dictionary();

    private static var imageLookup_:Dictionary = new Dictionary();

    public static function addImage(_arg_1:String, _arg_2:BitmapData):void {
        images_[_arg_1] = _arg_2;
        imageLookup_[_arg_2] = _arg_1;
    }

    public static function addImageSet(_arg_1:String, _arg_2:BitmapData, _arg_3:int, _arg_4:int):void {
        var _local6:int = 0;
        images_[_arg_1] = _arg_2;
        var _local5:ImageSet = new ImageSet();
        _local5.addFromBitmapData(_arg_2, _arg_3, _arg_4);
        imageSets_[_arg_1] = _local5;
        while (_local6 < _local5.images.length) {
            imageLookup_[_local5.images[_local6]] = [_arg_1, _local6];
            _local6++;
        }
    }

    public static function addToImageSet(_arg_1:String, _arg_2:BitmapData):void {
        var _local4:ImageSet = imageSets_[_arg_1];
        if (_local4 == null) {
            _local4 = new ImageSet();
            imageSets_[_arg_1] = _local4;
        }
        _local4.add(_arg_2);
        var _local3:int = _local4.images.length - 1;
        imageLookup_[_local4.images[_local3]] = [_arg_1, _local3];
    }

    public static function addSound(_arg_1:String, _arg_2:Class):void {
        var _local3:Array = sounds_[_arg_1];
        if (_local3 == null) {
            sounds_[_arg_1] = [];
        }
        sounds_[_arg_1].push(_arg_2);
    }

    public static function lookupImage(_arg_1:BitmapData):Object {
        return imageLookup_[_arg_1];
    }

    public static function getImage(_arg_1:String):BitmapData {
        return images_[_arg_1];
    }

    public static function getImageSet(_arg_1:String):ImageSet {
        return imageSets_[_arg_1];
    }

    public static function getImageFromSet(_arg_1:String, _arg_2:int):BitmapData {
        var _local3:ImageSet = imageSets_[_arg_1];
        return _local3.images[_arg_2];
    }

    public static function getSound(_arg_1:String):Sound {
        var _local2:Array = sounds_[_arg_1];
        var _local3:int = Math.random() * _local2.length;
        return new sounds_[_arg_1][_local3]();
    }

    public static function playSound(_arg_1:String, _arg_2:Number = 1):void {
        var _local5:* = null;
        var _local6:Array = sounds_[_arg_1];
        var _local4:int = Math.random() * _local6.length;
        var _local3:Sound = new sounds_[_arg_1][_local4]();
        if (_arg_2 != 1) {
            _local5 = new SoundTransform(_arg_2);
        }
        _local3.play(0, 0, _local5);
    }

    public function AssetLibrary(_arg_1:StaticEnforcer_1918) {
        super();
    }
}
}

class StaticEnforcer_1918 {


    function StaticEnforcer_1918() {
        super();
    }
}
