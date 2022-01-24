package com.company.assembleegameclient.ui.dialogs {
import flash.events.Event;

import kabam.rotmg.core.StaticInjectorContext;
import kabam.rotmg.dialogs.control.CloseDialogsSignal;

public class ConfirmDialog extends StaticDialog {


    public function ConfirmDialog(_arg_1:String, _arg_2:String, _arg_3:Function) {
        this._callback = _arg_3;
        super(_arg_1, _arg_2, "Cancel", "OK", null);
        addEventListener("dialogLeftButton", this.onCancel);
        addEventListener("dialogRightButton", this.onConfirm);
    }
    private var _callback:Function;

    private function onConfirm(_arg_1:Event):void {
        this._callback();
        var _local2:CloseDialogsSignal = StaticInjectorContext.getInjector().getInstance(CloseDialogsSignal);
        _local2.dispatch();
    }

    private function onCancel(_arg_1:Event):void {
        var _local2:CloseDialogsSignal = StaticInjectorContext.getInjector().getInstance(CloseDialogsSignal);
        _local2.dispatch();
    }
}
}
