package com.company.assembleegameclient.ui.tooltip.slotcomparisons {
import com.company.assembleegameclient.ui.tooltip.TooltipHelper;

import kabam.rotmg.text.model.TextKey;
import kabam.rotmg.text.view.stringBuilder.AppendingLineBuilder;
import kabam.rotmg.text.view.stringBuilder.LineBuilder;

public class TomeComparison extends SlotComparison {


    public function TomeComparison() {
        super();
    }

    override protected function compareSlots(_arg_1:XML, _arg_2:XML):void {
        var _local6:* = null;
        var _local9:Number = NaN;
        var _local13:Number = NaN;
        var _local11:Number = NaN;
        var _local4:Number = NaN;
        var _local14:Number = NaN;
        var _local12:Number = NaN;
        var _local3:* = null;
        var _local7:* = null;
        var _local5:* = null;
        var _local10:* = _arg_1;
        var _local8:* = _arg_2;
        var _local15:* = _local10.Activate;
        var _local16:int = 0;
        var _local18:* = new XMLList("");
        _local7 = _local10.Activate.(text() == "HealNova");
        var _local19:* = _local8.Activate;
        var _local20:int = 0;
        _local15 = new XMLList("");
        _local5 = _local8.Activate.(text() == "HealNova");
        comparisonStringBuilder = new AppendingLineBuilder();
        if (_local7.length() == 1 && _local5.length() == 1) {
            if ("@damage" in _local7 && int(_local7.@damage) > 0) {
                comparisonStringBuilder.pushParams(TooltipHelper.wrapInFontTag("{damage} damage within {range} sqrs", "#" + 0xffff8f.toString(16)), {
                    "damage": _local7.@damage,
                    "range": _local7.@range
                });
            }
            _local9 = _local7.@range;
            _local13 = _local5.@range;
            _local11 = _local7.@amount;
            _local4 = _local5.@amount;
            _local14 = 0.5 * _local9 + 0.5 * _local11;
            _local12 = 0.5 * _local13 + 0.5 * _local4;
            _local3 = new LineBuilder().setParams("EquipmentToolTip.partyHealAmount", {
                "amount": _local11.toString(),
                "range": _local9.toString()
            }).setPrefix(TooltipHelper.getOpenTag(getTextColor(_local14 - _local12))).setPostfix(TooltipHelper.getCloseTag());
            comparisonStringBuilder.pushParams("EquipmentToolTip.partyHeal", {"effect": _local3});
            processedTags[_local7.toXMLString()] = true;
        }
        if (_local10.@id == "Tome of Purification") {
            var _local21:* = _local10.Activate;
            var _local22:int = 0;
            _local18 = new XMLList("");
            _local6 = _local10.Activate.(text() == "RemoveNegativeConditions")[0];
            comparisonStringBuilder.pushParams("EquipmentToolTip.removesNegative", {}, TooltipHelper.getOpenTag(9055202), TooltipHelper.getCloseTag());
            processedTags[_local6.toXMLString()] = true;
        } else if (_local10.@id == "Tome of Holy Protection") {
            var _local23:* = _local10.Activate;
            var _local24:int = 0;
            _local19 = new XMLList("");
            _local6 = _local10.Activate.(text() == "ConditionEffectSelf")[0];
            comparisonStringBuilder.pushParams("EquipmentToolTip.effectOnSelf", {"effect": ""});
            comparisonStringBuilder.pushParams("EquipmentToolTip.effectForDuration", {
                "effect": TextKey.wrapForTokenResolution("activeEffect.Armored"),
                "duration": _local6.@duration
            }, TooltipHelper.getOpenTag(9055202), TooltipHelper.getCloseTag());
            processedTags[_local6.toXMLString()] = true;
        }
    }
}
}
