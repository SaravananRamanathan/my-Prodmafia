package kabam.rotmg.text.view {
import flash.text.TextField;

import kabam.rotmg.language.model.DebugStringMap;

public class DebugTextField extends TextField {

    public static const WRONG_LANGUAGE_COLOR:uint = 977663;

    public static const INVALID_KEY_COLOR:uint = 15874138;

    public function DebugTextField() {
        super();
    }
    public var debugStringMap:DebugStringMap;

    override public function set text(_arg_1:String):void {
        super.text = this.getText(_arg_1);
    }

    override public function set htmlText(_arg_1:String):void {
        super.htmlText = this.getText(_arg_1);
    }

    public function getText(_arg_1:String):String {
        var _local2:* = null;
        if (this.debugStringMap.debugTextInfos.length) {
            _local2 = this.debugStringMap.debugTextInfos[0];
            if (_local2.hasKey) {
                this.setBackground(977663);
            } else {
                this.setBackground(15874138);
            }
            return _local2.key;
        }
        return _arg_1;
    }

    private function setBackground(_arg_1:uint):void {
        background = true;
        backgroundColor = _arg_1;
    }
}
}
