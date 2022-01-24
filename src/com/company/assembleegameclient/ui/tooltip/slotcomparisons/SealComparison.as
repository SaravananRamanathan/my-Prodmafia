package com.company.assembleegameclient.ui.tooltip.slotcomparisons {
import com.company.assembleegameclient.ui.tooltip.TooltipHelper;

import kabam.rotmg.text.model.TextKey;
import kabam.rotmg.text.view.stringBuilder.AppendingLineBuilder;

public class SealComparison extends SlotComparison {


    public function SealComparison() {
        super();
    }
    private var healingTag:XML;
    private var damageTag:XML;
    private var otherHealingTag:XML;
    private var otherDamageTag:XML;

    override protected function compareSlots(_arg_1:XML, _arg_2:XML):void {
        var _local3:* = null;
        var _local5:* = _arg_1;
        var _local4:* = _arg_2;
        comparisonStringBuilder = new AppendingLineBuilder();
        this.healingTag = this.getEffectTag(_local5, "Healing");
        this.damageTag = this.getEffectTag(_local5, "Damaging");
        this.otherHealingTag = this.getEffectTag(_local4, "Healing");
        this.otherDamageTag = this.getEffectTag(_local4, "Damaging");
        if (this.canCompare()) {
            this.handleHealingText();
            this.handleDamagingText();
            if (_local5.@id == "Seal of Blasphemous Prayer") {
                var _local6:* = _local5.Activate;
                var _local7:int = 0;
                var _local9:* = new XMLList("");
                _local3 = _local5.Activate.(text() == "ConditionEffectSelf")[0];
                comparisonStringBuilder.pushParams("EquipmentToolTip.effectOnSelf", {"effect": ""});
                comparisonStringBuilder.pushParams("EquipmentToolTip.effectForDuration", {
                    "effect": TextKey.wrapForTokenResolution("activeEffect.Invulnerable"),
                    "duration": _local3.@duration
                }, TooltipHelper.getOpenTag(9055202), TooltipHelper.getCloseTag());
                processedTags[_local3.toXMLString()] = true;
            }
        }
    }

    private function canCompare():Boolean {
        return this.healingTag != null && this.damageTag != null && this.otherHealingTag != null && this.otherDamageTag != null;
    }

    private function getEffectTag(_arg_1:XML, _arg_2:String):XML {
        var _local4:* = null;
        var _local5:* = null;
        var _local6:* = _arg_1;
        var _local3:* = _arg_2;
        var _local7:* = _local6.Activate;
        var _local8:int = 0;
        var _local10:* = new XMLList("");
        _local4 = _local6.Activate.(text() == "ConditionEffectAura");
        var _local12:int = 0;
        var _local11:* = _local4;
        for each(_local5 in _local4) {
            if (_local5.@effect == _local3) {
                return _local5;
            }
        }
        return null;
    }

    private function handleHealingText():void {
        var _local6:int = this.healingTag.@duration;
        var _local2:int = this.otherHealingTag.@duration;
        var _local1:Number = this.healingTag.@range;
        var _local3:Number = this.otherHealingTag.@range;
        var _local8:Number = 0.5 * _local6 * 0.5 * _local1;
        var _local5:Number = 0.5 * _local2 * 0.5 * _local3;
        var _local4:uint = getTextColor(_local8 - _local5);
        var _local7:AppendingLineBuilder = new AppendingLineBuilder();
        _local7.pushParams("EquipmentToolTip.withinSqrs", {"range": this.healingTag.@range}, TooltipHelper.getOpenTag(_local4), TooltipHelper.getCloseTag());
        _local7.pushParams("EquipmentToolTip.effectForDuration", {
            "effect": TextKey.wrapForTokenResolution("activeEffect.Healing"),
            "duration": _local6.toString()
        }, TooltipHelper.getOpenTag(_local4), TooltipHelper.getCloseTag());
        comparisonStringBuilder.pushParams("EquipmentToolTip.partyEffect", {"effect": _local7});
        processedTags[this.healingTag.toXMLString()] = true;
    }

    private function handleDamagingText():void {
        var _local6:int = this.damageTag.@duration;
        var _local2:int = this.otherDamageTag.@duration;
        var _local1:Number = this.damageTag.@range;
        var _local3:Number = this.otherDamageTag.@range;
        var _local8:Number = 0.5 * _local6 * 0.5 * _local1;
        var _local5:Number = 0.5 * _local2 * 0.5 * _local3;
        var _local4:uint = getTextColor(_local8 - _local5);
        var _local7:AppendingLineBuilder = new AppendingLineBuilder();
        _local7.pushParams("EquipmentToolTip.withinSqrs", {"range": this.damageTag.@range}, TooltipHelper.getOpenTag(_local4), TooltipHelper.getCloseTag());
        _local7.pushParams("EquipmentToolTip.effectForDuration", {
            "effect": TextKey.wrapForTokenResolution("activeEffect.Damaging"),
            "duration": _local6.toString()
        }, TooltipHelper.getOpenTag(_local4), TooltipHelper.getCloseTag());
        comparisonStringBuilder.pushParams("EquipmentToolTip.partyEffect", {"effect": _local7});
        processedTags[this.damageTag.toXMLString()] = true;
    }
}
}
