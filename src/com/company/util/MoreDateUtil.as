package com.company.util {
public class MoreDateUtil {


    public static function getDayStringInPT():String {
        var _local3:Date = new Date();
        var _local2:Number = _local3.getTime();
        _local2 = _local2 + (_local3.timezoneOffset - 420) * 60 * 1000;
        _local3.setTime(_local2);
        var _local1:DateFormatterReplacement = new DateFormatterReplacement();
        _local1.formatString = "MMMM D, YYYY";
        return _local1.format(_local3);
    }

    public function MoreDateUtil() {
        super();
    }
}
}
