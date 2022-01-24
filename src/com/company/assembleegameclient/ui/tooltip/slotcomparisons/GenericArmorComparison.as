package com.company.assembleegameclient.ui.tooltip.slotcomparisons {
import kabam.rotmg.text.view.stringBuilder.AppendingLineBuilder;

public class GenericArmorComparison extends SlotComparison {

    private static const DEFENSE_STAT:String = "21";

    public function GenericArmorComparison() {
        super();
        comparisonStringBuilder = new AppendingLineBuilder();
    }
    private var defTags:XMLList;
    private var otherDefTags:XMLList;

    override protected function compareSlots(_arg_1:XML, _arg_2:XML):void {
        var _local5:int = 0;
        var _local6:int = 0;
        var _local4:* = _arg_1;
        var _local3:* = _arg_2;
        var _local7:* = _local4.ActivateOnEquip;
        var _local8:int = 0;
        var _local10:* = new XMLList("");
        this.defTags = _local4.ActivateOnEquip.(@stat == "21");
        var _local11:* = _local3.ActivateOnEquip;
        var _local12:int = 0;
        _local7 = new XMLList("");
        this.otherDefTags = _local3.ActivateOnEquip.(@stat == "21");
        if (this.defTags.length() == 1 && this.otherDefTags.length() == 1) {
            _local5 = this.defTags.@amount;
            _local6 = this.otherDefTags.@amount;
        }
    }

    private function compareDefense(_arg_1:int, _arg_2:int):String {
        var _local3:uint = getTextColor(_arg_1 - _arg_2);
        return wrapInColoredFont("+" + _arg_1 + " Defense", _local3);
    }
}
}
