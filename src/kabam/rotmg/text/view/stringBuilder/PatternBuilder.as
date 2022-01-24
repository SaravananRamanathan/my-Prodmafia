package kabam.rotmg.text.view.stringBuilder {
import kabam.rotmg.language.model.StringMap;

public class PatternBuilder implements StringBuilder {


    private const PATTERN:RegExp = /(\{([^\{]+?)\})/gi;

    public function PatternBuilder() {
        super();
    }
    private var pattern:String = "";
    private var keys:Array;
    private var provider:StringMap;

    public function setPattern(_arg_1:String):PatternBuilder {
        this.pattern = _arg_1;
        return this;
    }

    public function setStringMap(_arg_1:StringMap):void {
        this.provider = _arg_1;
    }

    public function getString():String {
        var _local2:* = null;
        this.keys = this.pattern.match(this.PATTERN);
        var _local1:String = this.pattern;
        var _local4:int = 0;
        var _local3:* = this.keys;
        for each(_local2 in this.keys) {
            _local1 = _local1.replace(_local2, this.provider.getValue(_local2.substr(1, _local2.length - 2)));
        }
        return _local1.replace(/\\n/g, "\n");
    }
}
}
