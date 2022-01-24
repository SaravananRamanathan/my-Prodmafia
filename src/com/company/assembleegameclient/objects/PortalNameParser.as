package com.company.assembleegameclient.objects {
import kabam.rotmg.text.view.stringBuilder.PatternBuilder;
import kabam.rotmg.text.view.stringBuilder.StringBuilder;

public class PortalNameParser {

    public static const NAME_PARSER:RegExp = /(.+)\s\((.+)\)/;


    public function PortalNameParser() {
        super();
    }

    public function parse(_arg_1:String):String {
        if (!_arg_1)
            return "";
        var _local2:Array = _arg_1.match(NAME_PARSER);
        if (_local2 == null) {
            return this.wrapNameWithBracesIfRequired(_arg_1);
        }
        return this.makePatternFromParts(_local2);
    }

    public function makeBuilder(_arg_1:String):StringBuilder {
        return new PatternBuilder().setPattern(this.parse(_arg_1));
    }

    private function wrapNameWithBracesIfRequired(_arg_1:String):String {
        if (_arg_1.charAt(0) == "{" && _arg_1.charAt(_arg_1.length - 1) == "}") {
            return _arg_1;
        }
        return "{" + _arg_1 + "}";
    }

    private function makePatternFromParts(_arg_1:Array):String {
        var _local2:* = "{" + _arg_1[1] + "}";
        if (_arg_1.length > 1) {
            _local2 = _local2 + (" (" + _arg_1[2] + ")");
        }
        return _local2;
    }
}
}
