package com.company.assembleegameclient.account.ui.components {
public class SelectionGroup {


    public function SelectionGroup(_arg_1:Vector.<Selectable>) {
        super();
        this.selectables = _arg_1;
    }
    private var selectables:Vector.<Selectable>;
    private var selected:Selectable;

    public function setSelected(_arg_1:String):void {
        var _local2:* = null;
        var _local4:int = 0;
        var _local3:* = this.selectables;
        for each(_local2 in this.selectables) {
            if (_local2.getValue() == _arg_1) {
                this.replaceSelected(_local2);
                return;
            }
        }
    }

    public function getSelected():Selectable {
        return this.selected;
    }

    private function replaceSelected(_arg_1:Selectable):void {
        if (this.selected != null) {
            this.selected.setSelected(false);
        }
        this.selected = _arg_1;
        this.selected.setSelected(true);
    }
}
}
