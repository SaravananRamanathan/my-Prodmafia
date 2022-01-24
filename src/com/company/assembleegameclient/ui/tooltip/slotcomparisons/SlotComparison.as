package com.company.assembleegameclient.ui.tooltip.slotcomparisons {
import flash.utils.Dictionary;

import kabam.rotmg.text.view.stringBuilder.AppendingLineBuilder;

public class SlotComparison {

    internal static const BETTER_COLOR:uint = 65280;

    internal static const WORSE_COLOR:uint = 16711680;

    internal static const NO_DIFF_COLOR:uint = 16777103;

    internal static const LABEL_COLOR:uint = 11776947;

    internal static const UNTIERED_COLOR:uint = 9055202;

    public function SlotComparison() {
        super();
    }
    public var processedTags:Dictionary;
    public var processedActivateOnEquipTags:AppendingLineBuilder;
    public var comparisonStringBuilder:AppendingLineBuilder;

    public function compare(_arg_1:XML, _arg_2:XML):void {
        this.resetFields();
        this.compareSlots(_arg_1, _arg_2);
    }

    protected function compareSlots(_arg_1:XML, _arg_2:XML):void {
    }

    protected function getTextColor(_arg_1:Number):uint {
        if (_arg_1 < 0) {
            return 0xff0000;
        }
        if (_arg_1 > 0) {
            return 0xff00;
        }
        return 0xffff8f;
    }

    protected function wrapInColoredFont(_arg_1:String, _arg_2:uint = 16777103):String {
        return "<font color=\"#" + _arg_2.toString(16) + "\">" + _arg_1 + "</font>";
    }

    protected function getMpCostText(_arg_1:String):String {
        return this.wrapInColoredFont("MP Cost: ", 0xb3b3b3) + this.wrapInColoredFont(_arg_1, 0xffff8f) + "\n";
    }

    private function resetFields():void {
        this.processedTags = new Dictionary();
        this.processedActivateOnEquipTags = new AppendingLineBuilder();
    }
}
}
