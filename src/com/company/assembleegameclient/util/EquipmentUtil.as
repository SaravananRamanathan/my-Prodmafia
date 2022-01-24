package com.company.assembleegameclient.util {
import flash.display.Bitmap;
import flash.display.BitmapData;

import kabam.rotmg.constants.ItemConstants;

public class EquipmentUtil {

    public static const NUM_SLOTS:uint = 4;

    public static function getEquipmentBackground(_arg_1:int, _arg_2:Number = 1):Bitmap {
        var _local4:* = null;
        var _local3:BitmapData = ItemConstants.itemTypeToBaseSprite(_arg_1);
        if (_local3 != null) {
            _local4 = new Bitmap(_local3);
            _local4.scaleX = _arg_2;
            _local4.scaleY = _arg_2;
        }
        return _local4;
    }

    public function EquipmentUtil() {
        super();
    }
}
}
