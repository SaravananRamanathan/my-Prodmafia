package com.company.assembleegameclient.ui.tooltip.slotcomparisons {
import com.company.assembleegameclient.ui.tooltip.TooltipHelper;

import kabam.rotmg.text.model.TextKey;
import kabam.rotmg.text.view.stringBuilder.AppendingLineBuilder;

public class CloakComparison extends SlotComparison {


    public function CloakComparison() {
        super();
    }

    override protected function compareSlots(_arg_1:XML, _arg_2:XML):void {
        var _local3:Number = NaN;
        var _local5:Number = NaN;
        var _local6:* = null;
        var _local4:* = null;
        _local6 = this.getInvisibleTag(_arg_1);
        _local4 = this.getInvisibleTag(_arg_2);
        comparisonStringBuilder = new AppendingLineBuilder();
        if (_local6 != null && _local4 != null) {
            _local3 = _local6.@duration;
            _local5 = _local4.@duration;
            this.appendDurationText(_local3, _local5);
            processedTags[_local6.toXMLString()] = true;
        }
        this.handleExceptions(_arg_1);
    }

    private function handleExceptions(_arg_1:XML):void {
        var _local3:* = null;
        var _local2:* = _arg_1;
        if (_local2.@id == "Cloak of the Planewalker") {
            comparisonStringBuilder.pushParams("EquipmentToolTip.teleportToTarget", {}, TooltipHelper.getOpenTag(9055202), TooltipHelper.getCloseTag());
            var _local4:* = _local2.Activate;
            var _local5:int = 0;
            var _local7:* = new XMLList("");
            _local3 = XML(_local2.Activate.(text() == "Teleport"))[0];
            processedTags[_local3.toXMLString()] = true;
        }
    }

    private function getInvisibleTag(_arg_1:XML):XML {
        var _local4:* = null;
        var _local3:* = null;
        var _local2:* = _arg_1;
        var _local5:* = _local2.Activate;
        var _local6:int = 0;
        var _local8:* = new XMLList("");
        _local4 = _local2.Activate.(text() == "ConditionEffectSelf");
        var _local12:int = 0;
        var _local11:* = _local4;
        for each(_local3 in _local4) {
            var _local9:* = _local3;
            var _local10:int = 0;
            _local5 = new XMLList("");
            if (_local3.(@effect == "Invisible")) {
                return _local3;
            }
        }
        return null;
    }

    private function appendDurationText(_arg_1:Number, _arg_2:Number):void {
        var _local3:uint = getTextColor(_arg_1 - _arg_2);
        comparisonStringBuilder.pushParams("EquipmentToolTip.effectOnSelf", {"effect": ""});
        comparisonStringBuilder.pushParams("EquipmentToolTip.effectForDuration", {
            "effect": TextKey.wrapForTokenResolution("activeEffect.Invisible"),
            "duration": _arg_1.toString()
        }, TooltipHelper.getOpenTag(_local3), TooltipHelper.getCloseTag());
    }
}
}
