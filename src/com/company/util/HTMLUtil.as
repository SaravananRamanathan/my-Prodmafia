package com.company.util {
import flash.external.ExternalInterface;
import flash.xml.XMLDocument;
import flash.xml.XMLNode;

public class HTMLUtil {


    public static function unescape(_arg_1:String):String {
        return new XMLDocument(_arg_1).firstChild.nodeValue;
    }

    public static function escape(_arg_1:String):String {
        return XML(new XMLNode(3, _arg_1)).toXMLString();
    }

    public static function refreshPageNoParams():void {
        var _local3:* = null;
        var _local2:* = null;
        var _local1:* = null;
        if (ExternalInterface.available) {
            _local3 = ExternalInterface.call("window.location.toString");
            _local2 = _local3.split("?");
            if (_local2.length > 0) {
                _local1 = _local2[0];
                if (_local1.indexOf("www.kabam") != -1) {
                    _local1 = "http://www.realmofthemadgod.com";
                }
                ExternalInterface.call("window.location.assign", _local1);
            }
        }
    }

    public function HTMLUtil() {
        super();
    }
}
}
