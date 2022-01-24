package kabam.rotmg.ui.view {
import com.adobe.utils.DictionaryUtil;

import flash.utils.Dictionary;

import org.osflash.signals.Signal;

public class SignalWaiter {


    public function SignalWaiter() {
        complete = new Signal();
        texts = new Dictionary();
        super();
    }
    public var complete:Signal;
    private var texts:Dictionary;

    public function push(_arg_1:Signal):SignalWaiter {
        this.texts[_arg_1] = true;
        this.listenTo(_arg_1);
        return this;
    }

    public function pushArgs(...rest):SignalWaiter {
        var _local2:* = null;
        var _local4:int = 0;
        var _local3:* = rest;
        for each(_local2 in rest) {
            this.push(_local2);
        }
        return this;
    }

    public function isEmpty():Boolean {
        return DictionaryUtil.getKeys(this.texts).length == 0;
    }

    private function listenTo(_arg_1:Signal):void {
        _arg_1 = _arg_1;
        var param1:Signal = _arg_1;
        var value:Signal = param1;
        var onTextChanged:Function = function ():void {
            delete texts[value];
            checkEmpty();
        };
        value.addOnce(onTextChanged);
    }

    private function checkEmpty():void {
        if (this.isEmpty()) {
            this.complete.dispatch();
        }
    }
}
}
