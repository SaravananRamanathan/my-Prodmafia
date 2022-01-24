package kabam.rotmg.text.view.stringBuilder {
import kabam.rotmg.core.StaticInjectorContext;
import kabam.rotmg.language.model.StringMap;

public class LineBuilder implements StringBuilder {


    public static function fromJSON(_arg_1:String):LineBuilder {
        var _local2:Object = JSON.parse(_arg_1);
        return new LineBuilder().setParams(_local2.key, _local2.tokens);
    }

    public static function getLocalizedStringFromKey(_arg_1:String, _arg_2:Object = null):String {
        var _local4:LineBuilder = new LineBuilder();
        _local4.setParams(_arg_1, _arg_2);
        var _local3:StringMap = StaticInjectorContext.getInjector().getInstance(StringMap);
        _local4.setStringMap(_local3);
        return _local4.getString() == "" ? _arg_1 : _local4.getString();
    }

    public static function getLocalizedStringFromJSON(_arg_1:String):String {
        var _local2:* = null;
        var _local3:* = null;
        if (_arg_1.charAt(0) == "{") {
            _local2 = LineBuilder.fromJSON(_arg_1);
            _local3 = StaticInjectorContext.getInjector().getInstance(StringMap);
            _local2.setStringMap(_local3);
            return _local2.getString();
        }
        return _arg_1;
    }

    public static function returnStringReplace(_arg_1:String, _arg_2:Object = null, _arg_3:String = "", _arg_4:String = ""):String {
        var _local6:* = undefined;
        var _local7:* = undefined;
        var _local5:* = null;
        var _local8:String = stripCurlyBrackets(_arg_1);
        var _local10:int = 0;
        var _local9:* = _arg_2;
        for (_local6 in _arg_2) {
            _local5 = _arg_2[_local6];
            _local7 = "{" + _local6 + "}";
            while (_local8.indexOf(_local7) != -1) {
                _local8 = _local8.replace(_local7, _local5);
            }
        }
        _local8 = _local8.replace(/\\n/g, "\n");
        return _arg_3 + _local8 + _arg_4;
    }

    public static function getLocalizedString2(_arg_1:String, _arg_2:Object = null):String {
        var _local4:LineBuilder = new LineBuilder();
        _local4.setParams(_arg_1, _arg_2);
        var _local3:StringMap = StaticInjectorContext.getInjector().getInstance(StringMap);
        _local4.setStringMap(_local3);
        return _local4.getString();
    }

    private static function stripCurlyBrackets(_arg_1:String):String {
        var _local2:Boolean = _arg_1 != null && _arg_1.charAt(0) == "{" && _arg_1.charAt(_arg_1.length - 1) == "}";
        return !!_local2 ? _arg_1.substr(1, _arg_1.length - 2) : _arg_1;
    }

    public function LineBuilder() {
        super();
    }
    public var key:String;
    public var tokens:Object;
    private var postfix:String = "";
    private var prefix:String = "";
    private var map:StringMap;

    public function toJson():String {
        return JSON.stringify({
            "key": this.key,
            "tokens": this.tokens
        });
    }

    public function setParams(_arg_1:String, _arg_2:Object = null):LineBuilder {
        this.key = _arg_1 || "";
        this.tokens = _arg_2;
        return this;
    }

    public function setPrefix(_arg_1:String):LineBuilder {
        this.prefix = _arg_1;
        return this;
    }

    public function setPostfix(_arg_1:String):LineBuilder {
        this.postfix = _arg_1;
        return this;
    }

    public function setStringMap(_arg_1:StringMap):void {
        this.map = _arg_1;
    }

    public function getString():String {
        var _local1:* = undefined;
        var _local3:* = undefined;
        var _local4:String = null;
        var _local5:String = stripCurlyBrackets(this.key);
        var _local2:String = this.map.getValue(_local5) || "";
        var _local7:int = 0;
        var _local6:* = this.tokens;
        for (_local1 in this.tokens) {
            _local4 = this.tokens[_local1];
            if (_local4.charAt(0) == "{" && _local4.charAt(_local4.length - 1) == "}") {
                _local4 = this.map.getValue(_local4.substr(1, _local4.length - 2));
            }
            _local3 = "{" + _local1 + "}";
            while (_local2.indexOf(_local3) != -1) {
                _local2 = _local2.replace(_local3, _local4);
            }
        }
        _local2 = _local2.replace(/\\n/g, "\n");
        return this.prefix + _local2 + this.postfix;
    }
}
}
