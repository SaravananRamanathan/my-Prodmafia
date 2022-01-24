package com.company.util {
public class MoreObjectUtil {


    public static function addToObject(_arg_1:Object, _arg_2:Object):void {
        var _local3:* = undefined;
        var _local5:int = 0;
        var _local4:* = _arg_2;
        for (_local3 in _arg_2) {
            _arg_1[_local3] = _arg_2[_local3];
        }
    }

    public function MoreObjectUtil() {
        super();
    }
}
}
