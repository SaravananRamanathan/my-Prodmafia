package com.company.assembleegameclient.objects {
import com.company.util.AssetLibrary;

import flash.display.BitmapData;

public class ImageFactory {


    public function ImageFactory() {
        super();
    }

    public function getImageFromSet(_arg_1:String, _arg_2:int):BitmapData {
        return AssetLibrary.getImageFromSet(_arg_1, _arg_2);
    }

    public function getTexture(_arg_1:int, _arg_2:int):BitmapData {
        var _local4:Number = NaN;
        var _local3:* = null;
        var _local5:BitmapData = ObjectLibrary.getBitmapData(_arg_1);
        if (_local5) {
            _local4 = (_arg_2 - 24) / _local5.width;
            _local3 = ObjectLibrary.getRedrawnTextureFromType(_arg_1, 100, true, false, _local4);
            return _local3;
        }
        return new BitmapData(_arg_2, _arg_2, true, 0);
    }
}
}
