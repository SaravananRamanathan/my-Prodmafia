package com.company.assembleegameclient.util {
import flash.display.DisplayObject;

public class DisplayHierarchy {


    public static function getParentWithType(_arg_1:DisplayObject, _arg_2:Class):DisplayObject {
        while (_arg_1 && !(_arg_1 is _arg_2)) {
            _arg_1 = _arg_1.parent;
        }
        return _arg_1;
    }

    public static function getParentWithTypeArray(_arg_1:DisplayObject, ...rest):DisplayObject {
        var _local3:* = null;
        while (_arg_1) {
            var _local5:int = 0;
            var _local4:* = rest;
            for each(_local3 in rest) {
                if (_arg_1 is _local3) {
                    return _arg_1;
                }
            }
            _arg_1 = _arg_1.parent;
        }
        return _arg_1;
    }

    public function DisplayHierarchy() {
        super();
    }
}
}
