package com.company.assembleegameclient.ui.tooltip.slotcomparisons {
import com.company.assembleegameclient.ui.tooltip.TooltipHelper;

import kabam.rotmg.text.model.TextKey;
import kabam.rotmg.text.view.stringBuilder.AppendingLineBuilder;
import kabam.rotmg.text.view.stringBuilder.LineBuilder;

public class OrbComparison extends SlotComparison {


    public function OrbComparison() {
        super();
    }

    override protected function compareSlots(_arg_1:XML, _arg_2:XML):void {
        var _local7:int = 0;
        var _local5:int = 0;
        var _local4:* = 0;
        var _local6:* = null;
        var _local3:* = null;
        _local6 = this.getStasisBlastTag(_arg_1);
        _local3 = this.getStasisBlastTag(_arg_2);
        comparisonStringBuilder = new AppendingLineBuilder();
        if (_local6 != null && _local3 != null) {
            _local7 = _local6.@duration;
            _local5 = _local3.@duration;
            _local4 = uint(getTextColor(_local7 - _local5));
            comparisonStringBuilder.pushParams("EquipmentToolTip.stasisGroup", {"stasis": new LineBuilder().setParams("EquipmentToolTip.secsCount", {"duration": _local7}).setPrefix(TooltipHelper.getOpenTag(_local4)).setPostfix(TooltipHelper.getCloseTag())});
            processedTags[_local6.toXMLString()] = true;
            this.handleExceptions(_arg_1);
        }
    }

    private function getStasisBlastTag(_arg_1:XML):XML {
        var _local3:* = null;
        var _local2:* = _arg_1;
        var _local4:* = _local2.Activate;
        var _local5:int = 0;
        var _local7:* = new XMLList("");
        _local3 = _local2.Activate.(text() == "StasisBlast");
        return _local3.length() == 1 ? _local3[0] : null;
    }

    private function handleExceptions(_arg_1:XML):void {
        var _local3:* = null;
        var _local2:* = null;
        var _local5:* = null;
        var _local4:* = _arg_1;
        if (_local4.@id == "Orb of Conflict") {
            var _local6:* = _local4.Activate;
            var _local7:int = 0;
            var _local9:* = new XMLList("");
            _local3 = _local4.Activate.(text() == "ConditionEffectSelf");
            var _local10:* = _local3;
            var _local11:int = 0;
            _local6 = new XMLList("");
            _local2 = _local3.(@effect == "Speedy")[0];
            var _local12:* = _local3;
            var _local13:int = 0;
            _local9 = new XMLList("");
            _local5 = _local3.(@effect == "Damaging")[0];
            comparisonStringBuilder.pushParams("EquipmentToolTip.effectOnSelf", {"effect": ""});
            comparisonStringBuilder.pushParams("EquipmentToolTip.effectForDuration", {
                "effect": TextKey.wrapForTokenResolution("activeEffect.Speedy"),
                "duration": _local2.@duration
            }, TooltipHelper.getOpenTag(9055202), TooltipHelper.getCloseTag());
            comparisonStringBuilder.pushParams("EquipmentToolTip.effectOnSelf", {"effect": ""});
            comparisonStringBuilder.pushParams("EquipmentToolTip.effectForDuration", {
                "effect": TextKey.wrapForTokenResolution("activeEffect.Damaging"),
                "duration": _local5.@duration
            }, TooltipHelper.getOpenTag(9055202), TooltipHelper.getCloseTag());
            processedTags[_local2.toXMLString()] = true;
            processedTags[_local5.toXMLString()] = true;
        }
    }
}
}
