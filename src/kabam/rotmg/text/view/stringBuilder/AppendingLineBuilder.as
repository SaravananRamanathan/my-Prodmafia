package kabam.rotmg.text.view.stringBuilder {
import kabam.rotmg.language.model.StringMap;

public class AppendingLineBuilder implements StringBuilder {


    public function AppendingLineBuilder() {
        temper = new Vector.<String>();
        data = new Vector.<LineData>();
        super();
    }
    private var delimiter:String = "\n";
    private var provider:StringMap;
    private var temper:Vector.<String>;
    private var data:Vector.<LineData>;

    public function pushParams(_arg_1:String, _arg_2:Object = null, _arg_3:String = "", _arg_4:String = ""):AppendingLineBuilder {
        this.data.push(new LineData().setKey(_arg_1).setTokens(_arg_2).setOpeningTags(_arg_3).setClosingTags(_arg_4));
        return this;
    }

    public function setDelimiter(_arg_1:String):AppendingLineBuilder {
        this.delimiter = _arg_1;
        return this;
    }

    public function setStringMap(_arg_1:StringMap):void {
        this.provider = _arg_1;
    }

    public function getString():String {
        temper.length = 0;
        for each(var _local1:LineData in this.data) {
            temper.push(_local1.getString(this.provider));
        }
        return temper.join(this.delimiter);
    }

    public function hasLines():Boolean {
        return this.data.length != 0;
    }

    public function clear():void {
        this.data = new Vector.<LineData>();
    }
}
}

import kabam.rotmg.language.model.StringMap;
import kabam.rotmg.text.model.TextKey;
import kabam.rotmg.text.view.stringBuilder.StringBuilder;

class LineData {


    function LineData() {
        super();
    }
    public var key:String;
    public var tokens:Object;
    public var openingHTMLTags:String = "";
    public var closingHTMLTags:String = "";

    public function setKey(_arg_1:String):LineData {
        this.key = _arg_1;
        return this;
    }

    public function setTokens(_arg_1:Object):LineData {
        this.tokens = _arg_1;
        return this;
    }

    public function setOpeningTags(_arg_1:String):LineData {
        this.openingHTMLTags = _arg_1;
        return this;
    }

    public function setClosingTags(_arg_1:String):LineData {
        this.closingHTMLTags = _arg_1;
        return this;
    }

    public function getString(_arg1:StringMap):String {
        var _local3:String;
        var _local4:String;
        var _local5:StringBuilder;
        var _local6:String;
        var _local2:String = this.openingHTMLTags;
        _local3 = _arg1.getValue(TextKey.stripCurlyBrackets(this.key));
        if (_local3 == null) {
            _local3 = this.key;
        }
        _local2 = _local2.concat(_local3);
        for (_local4 in this.tokens) {
            if ((this.tokens[_local4] is StringBuilder)) {
                _local5 = StringBuilder(this.tokens[_local4]);
                _local5.setStringMap(_arg1);
                _local2 = _local2.replace((("{" + _local4) + "}"), _local5.getString());
            } else {
                _local6 = this.tokens[_local4];
                if ((((((_local6.length > 0)) && ((_local6.charAt(0) == "{")))) && ((_local6.charAt((_local6.length - 1)) == "}")))) {
                    _local6 = _arg1.getValue(_local6.substr(1, (_local6.length - 2)));
                }
                _local2 = _local2.replace((("{" + _local4) + "}"), _local6);
            }
        }
        _local2 = _local2.replace(/\\n/g, "\n");
        return (_local2.concat(this.closingHTMLTags));
    }
}
