package com.company.assembleegameclient.ui.dialogs {
import flash.events.Event;

import org.osflash.signals.Signal;

public class CloseDialogComponent {


    private const closeSignal:Signal = new Signal();

    public function CloseDialogComponent() {
        types = new Vector.<String>();
        super();
    }
    private var dialog:DialogCloser;
    private var types:Vector.<String>;

    public function add(_arg_1:DialogCloser, _arg_2:String):void {
        this.dialog = _arg_1;
        this.types.push(_arg_2);
        _arg_1.addEventListener(_arg_2, this.onButtonType);
    }

    public function getCloseSignal():Signal {
        return this.closeSignal;
    }

    private function onButtonType(_arg_1:Event):void {
        var _local2:* = null;
        var _local4:int = 0;
        var _local3:* = this.types;
        for each(_local2 in this.types) {
            this.dialog.removeEventListener(_local2, this.onButtonType);
        }
        this.dialog.getCloseSignal().dispatch();
    }
}
}
