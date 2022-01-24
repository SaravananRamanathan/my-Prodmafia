package com.company.assembleegameclient.util {
import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
import io.decagames.rotmg.ui.labels.UILabel;

public class TierUtil {


    public static function getTierTag(_arg_1:XML, _arg_2:int = 12):UILabel {
        var _local3:* = null;
        var _local9:* = NaN;
        var _local6:* = null;
        var _local8:* = isPet(_arg_1) == false;
        var _local11:* = _arg_1.hasOwnProperty("Consumable") == false;
        var _local10:* = _arg_1.hasOwnProperty("InvUse") == false;
        var _local7:* = _arg_1.hasOwnProperty("Treasure") == false;
        var _local5:* = _arg_1.hasOwnProperty("PetFood") == false;
        var _local4:Boolean = _arg_1.hasOwnProperty("Tier");
        if (_local8 && _local11 && _local10 && _local7 && _local5) {
            _local3 = new UILabel();
            if (_local4) {
                _local9 = 16777215;
                _local6 = "T" + _arg_1.Tier;
            } else if (_arg_1.hasOwnProperty("@setType")) {
                _local9 = 16750848;
                _local6 = "ST";
            } else {
                _local9 = 9055202;
                _local6 = "UT";
            }
            _local3.text = _local6;
            DefaultLabelFormat.tierLevelLabel(_local3, _arg_2, _local9);
            return _local3;
        }
        return null;
    }

    public static function isPet(_arg_1:XML):Boolean {
        var _local2:* = null;
        var _local3:* = _arg_1;
        var _local4:* = _local3.Activate;
        var _local5:int = 0;
        var _local7:* = new XMLList("");
        _local2 = _local3.Activate.(text() == "PermaPet");
        return _local2.length() >= 1;
    }

    public function TierUtil() {
        super();
    }
}
}
