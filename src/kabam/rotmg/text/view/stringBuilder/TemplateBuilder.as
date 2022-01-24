package kabam.rotmg.text.view.stringBuilder {
import kabam.rotmg.language.model.StringMap;

public class TemplateBuilder implements StringBuilder {


    public function TemplateBuilder() {
        super();
    }
    private var template:String;
    private var tokens:Object;
    private var postfix:String = "";
    private var prefix:String = "";
    private var provider:StringMap;

    public function setTemplate(_arg_1:String, _arg_2:Object = null):TemplateBuilder {
        this.template = _arg_1;
        this.tokens = _arg_2;
        return this;
    }

    public function setPrefix(_arg_1:String):TemplateBuilder {
        this.prefix = _arg_1;
        return this;
    }

    public function setPostfix(_arg_1:String):TemplateBuilder {
        this.postfix = _arg_1;
        return this;
    }

    public function setStringMap(_arg_1:StringMap):void {
        this.provider = _arg_1;
    }

    public function getString():String {
        var _local2:* = undefined;
        var _local1:* = null;
        var _local3:String = this.template;
        var _local5:int = 0;
        var _local4:* = this.tokens;
        for (_local2 in this.tokens) {
            _local1 = this.tokens[_local2];
            if (_local1.charAt(0) == "{" && _local1.charAt(_local1.length - 1) == "}") {
                _local1 = this.provider.getValue(_local1.substr(1, _local1.length - 2));
            }
            _local3 = _local3.replace("{" + _local2 + "}", _local1);
        }
        _local3 = _local3.replace(/\\n/g, "\n");
        return this.prefix + _local3 + this.postfix;
    }
}
}
