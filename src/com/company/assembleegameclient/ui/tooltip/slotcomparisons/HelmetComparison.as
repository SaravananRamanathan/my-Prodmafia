package com.company.assembleegameclient.ui.tooltip.slotcomparisons {
import com.company.assembleegameclient.ui.tooltip.TooltipHelper;

import kabam.rotmg.text.model.TextKey;
import kabam.rotmg.text.view.stringBuilder.AppendingLineBuilder;

public class HelmetComparison extends SlotComparison {


    public function HelmetComparison() {
        super();
    }
    private var berserk:XML;
    private var speedy:XML;
    private var otherBerserk:XML;
    private var otherSpeedy:XML;
    private var armored:XML;
    private var otherArmored:XML;

    override protected function compareSlots(_arg_1:XML, _arg_2:XML):void {
        this.extractDataFromXML(_arg_1, _arg_2);
        comparisonStringBuilder = new AppendingLineBuilder();
        this.handleBerserk();
        this.handleSpeedy();
        this.handleArmored();
    }

    private function extractDataFromXML(_arg_1:XML, _arg_2:XML):void {
        this.berserk = this.getAuraTagByType(_arg_1, "Berserk");
        this.speedy = this.getSelfTagByType(_arg_1, "Speedy");
        this.armored = this.getSelfTagByType(_arg_1, "Armored");
        this.otherBerserk = this.getAuraTagByType(_arg_2, "Berserk");
        this.otherSpeedy = this.getSelfTagByType(_arg_2, "Speedy");
        this.otherArmored = this.getSelfTagByType(_arg_2, "Armored");
    }

    private function getAuraTagByType(_arg_1:XML, _arg_2:String):XML {
        var _local3:* = null;
        var _local4:* = null;
        var _local6:* = _arg_1;
        var _local5:* = _arg_2;
        var _local7:* = _local6.Activate;
        var _local8:int = 0;
        var _local10:* = new XMLList("");
        _local3 = _local6.Activate.(text() == "ConditionEffectAura");
        var _local12:int = 0;
        var _local11:* = _local3;
        for each(_local4 in _local3) {
            if (_local4.@effect == _local5) {
                return _local4;
            }
        }
        return null;
    }

    private function getSelfTagByType(_arg_1:XML, _arg_2:String):XML {
        var _local3:* = null;
        var _local4:* = null;
        var _local6:* = _arg_1;
        var _local5:* = _arg_2;
        var _local7:* = _local6.Activate;
        var _local8:int = 0;
        var _local10:* = new XMLList("");
        _local3 = _local6.Activate.(text() == "ConditionEffectSelf");
        var _local12:int = 0;
        var _local11:* = _local3;
        for each(_local4 in _local3) {
            if (_local4.@effect == _local5) {
                return _local4;
            }
        }
        return null;
    }

    private function handleBerserk():void {
        if (this.berserk == null || this.otherBerserk == null) {
            return;
        }
        var _local6:Number = this.berserk.@range;
        var _local2:Number = this.otherBerserk.@range;
        var _local1:Number = this.berserk.@duration;
        var _local3:Number = this.otherBerserk.@duration;
        var _local8:Number = 0.5 * _local6 + 0.5 * _local1;
        var _local5:Number = 0.5 * _local2 + 0.5 * _local3;
        var _local4:uint = getTextColor(_local8 - _local5);
        var _local7:AppendingLineBuilder = new AppendingLineBuilder();
        _local7.pushParams("EquipmentToolTip.withinSqrs", {"range": _local6.toString()}, TooltipHelper.getOpenTag(_local4), TooltipHelper.getCloseTag());
        _local7.pushParams("EquipmentToolTip.effectForDuration", {
            "effect": TextKey.wrapForTokenResolution("activeEffect.Berserk"),
            "duration": _local1.toString()
        }, TooltipHelper.getOpenTag(_local4), TooltipHelper.getCloseTag());
        comparisonStringBuilder.pushParams("EquipmentToolTip.partyEffect", {"effect": _local7});
        processedTags[this.berserk.toXMLString()] = true;
    }

    private function handleSpeedy():void {
        var _local1:Number = NaN;
        var _local2:Number = NaN;
        if (this.speedy != null && this.otherSpeedy != null) {
            _local1 = this.speedy.@duration;
            _local2 = this.otherSpeedy.@duration;
            comparisonStringBuilder.pushParams("EquipmentToolTip.effectOnSelf", {"effect": ""});
            comparisonStringBuilder.pushParams("EquipmentToolTip.effectForDuration", {
                "effect": TextKey.wrapForTokenResolution("activeEffect.Speedy"),
                "duration": _local1.toString()
            }, TooltipHelper.getOpenTag(getTextColor(_local1 - _local2)), TooltipHelper.getCloseTag());
            processedTags[this.speedy.toXMLString()] = true;
        } else if (this.speedy != null && this.otherSpeedy == null) {
            comparisonStringBuilder.pushParams("EquipmentToolTip.effectOnSelf", {"effect": ""});
            comparisonStringBuilder.pushParams("EquipmentToolTip.effectForDuration", {
                "effect": TextKey.wrapForTokenResolution("activeEffect.Speedy"),
                "duration": this.speedy.@duration
            }, TooltipHelper.getOpenTag(0xff00), TooltipHelper.getCloseTag());
            processedTags[this.speedy.toXMLString()] = true;
        }
    }

    private function handleArmored():void {
        if (this.armored != null) {
            comparisonStringBuilder.pushParams("EquipmentToolTip.effectOnSelf", {"effect": ""});
            comparisonStringBuilder.pushParams("EquipmentToolTip.effectForDuration", {
                "effect": TextKey.wrapForTokenResolution("activeEffect.Armored"),
                "duration": this.armored.@duration
            }, TooltipHelper.getOpenTag(9055202), TooltipHelper.getCloseTag());
            processedTags[this.armored.toXMLString()] = true;
        }
    }
}
}
