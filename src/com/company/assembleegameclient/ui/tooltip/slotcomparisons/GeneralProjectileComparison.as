package com.company.assembleegameclient.ui.tooltip.slotcomparisons {
import com.company.assembleegameclient.ui.tooltip.TooltipHelper;

import kabam.rotmg.text.view.stringBuilder.AppendingLineBuilder;

public class GeneralProjectileComparison extends SlotComparison {


    public function GeneralProjectileComparison() {
        super();
    }
    private var itemXML:XML;
    private var curItemXML:XML;
    private var projXML:XML;
    private var otherProjXML:XML;

    override protected function compareSlots(_arg_1:XML, _arg_2:XML):void {
        this.itemXML = _arg_1;
        this.curItemXML = _arg_2;
        comparisonStringBuilder = new AppendingLineBuilder();
        if ("NumProjectiles" in _arg_1) {
            this.addNumProjectileText();
            processedTags[_arg_1.NumProjectiles.toXMLString()] = true;
        }
        if ("Projectile" in _arg_1) {
            this.addProjectileText();
            processedTags[_arg_1.Projectile.toXMLString()] = true;
        }
        this.buildRateOfFireText();
    }

    private function addProjectileText():void {
        this.addDamageText();
        var _local3:Number = this.projXML.Speed * this.projXML.LifetimeMS / 10000;
        var _local2:Number = this.otherProjXML.Speed * this.otherProjXML.LifetimeMS / 10000;
        var _local1:String = _local3.toFixed(2);
        comparisonStringBuilder.pushParams("EquipmentToolTip.range", {"range": wrapInColoredFont(_local1, getTextColor(_local3 - _local2))});
        if ("MultiHit" in this.projXML) {
            comparisonStringBuilder.pushParams("GeneralProjectileComparison.multiHit", {}, TooltipHelper.getOpenTag(0xffff8f), TooltipHelper.getCloseTag());
        }
        if ("PassesCover" in this.projXML) {
            comparisonStringBuilder.pushParams("GeneralProjectileComparison.passesCover", {}, TooltipHelper.getOpenTag(0xffff8f), TooltipHelper.getCloseTag());
        }
        if ("ArmorPiercing" in this.projXML) {
            comparisonStringBuilder.pushParams("GeneralProjectileComparison.armorPiercing", {}, TooltipHelper.getOpenTag(0xffff8f), TooltipHelper.getCloseTag());
        }
    }

    private function addNumProjectileText():void {
        var _local3:int = this.itemXML.NumProjectiles;
        var _local2:int = this.curItemXML.NumProjectiles;
        var _local1:uint = getTextColor(_local3 - _local2);
        comparisonStringBuilder.pushParams("EquipmentToolTip.shots", {"numShots": wrapInColoredFont(_local3.toString(), _local1)});
    }

    private function addDamageText():void {
        this.projXML = XML(this.itemXML.Projectile);
        var _local6:int = this.projXML.MinDamage;
        var _local2:int = this.projXML.MaxDamage;
        var _local1:Number = (_local2 + _local6) / 2;
        this.otherProjXML = XML(this.curItemXML.Projectile);
        var _local3:int = this.otherProjXML.MinDamage;
        var _local7:int = this.otherProjXML.MaxDamage;
        var _local5:Number = (_local7 + _local3) / 2;
        var _local4:String = (_local6 == _local2 ? _local6 : _local6 + " - " + _local2).toString();
        comparisonStringBuilder.pushParams("EquipmentToolTip.damage", {"damage": wrapInColoredFont(_local4, getTextColor(_local1 - _local5))});
    }

    private function buildRateOfFireText():void {
        if (this.itemXML.RateOfFire.length() == 0 || this.curItemXML.RateOfFire.length() == 0) {
            return;
        }
        var _local6:Number = this.curItemXML.RateOfFire[0];
        var _local2:Number = this.itemXML.RateOfFire[0];
        var _local1:int = _local2 / _local6 * 100;
        var _local4:int = _local1 - 100;
        if (_local4 == 0) {
            return;
        }
        var _local3:uint = getTextColor(_local4);
        var _local5:String = _local4.toString();
        if (_local4 > 0) {
            _local5 = "+" + _local5;
        }
        _local5 = wrapInColoredFont(_local5 + "%", _local3);
        comparisonStringBuilder.pushParams("EquipmentToolTip.rateOfFire", {"data": _local5});
        // §§push(processedTags[this.itemXML.RateOfFire[0].toXMLString()]);
    }
}
}
