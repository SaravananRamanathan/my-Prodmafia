package com.company.assembleegameclient.ui.tooltip {
import com.company.assembleegameclient.game.events.KeyInfoResponseSignal;
import com.company.assembleegameclient.objects.ObjectLibrary;
import com.company.assembleegameclient.objects.Player;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.ui.LineBreakDesign;
import com.company.assembleegameclient.util.FilterUtil;
import com.company.assembleegameclient.util.MathUtil;
import com.company.assembleegameclient.util.TierUtil;
import com.company.util.BitmapUtil;
import com.company.util.KeyCodes;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.filters.DropShadowFilter;
import flash.utils.Dictionary;

import io.decagames.rotmg.ui.labels.UILabel;

import kabam.rotmg.messaging.impl.data.StatData;
import kabam.rotmg.messaging.impl.incoming.KeyInfoResponse;
import kabam.rotmg.text.view.TextFieldDisplayConcrete;
import kabam.rotmg.text.view.stringBuilder.AppendingLineBuilder;
import kabam.rotmg.text.view.stringBuilder.LineBuilder;
import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;
import kabam.rotmg.text.view.stringBuilder.StringBuilder;

public class EquipmentToolTip extends ToolTip {

    private static const MAX_WIDTH:int = 230;

    public static var keyInfo:Dictionary = new Dictionary();

    public function EquipmentToolTip(_arg_1:int, _arg_2:Player, _arg_3:int, _arg_4:String) {
        var _local8:Boolean = false;
        uniqueEffects = new Vector.<Effect>();
        this.objectType = _arg_1;
        this.originalObjectType = this.objectType;
        this.player = _arg_2;
        this.invType = _arg_3;
        this.inventoryOwnerType = _arg_4;
        this.isInventoryFull = !!_arg_2 ? _arg_2.isInventoryFull() : false;
        this.playerCanUse = !!_arg_2 ? ObjectLibrary.isUsableByPlayer(this.objectType, _arg_2) : false;
        var _local7:int = this.playerCanUse || this.player == null ? 0x363636 : 6036765;
        var _local6:int = this.playerCanUse || _arg_2 == null ? 0x9b9b9b : 10965039;
        super(_local7, 1, _local6, 1, true);
        var _local5:int = !!_arg_2 ? ObjectLibrary.getMatchingSlotIndex(this.objectType, _arg_2) : -1;
        this.slotTypeToTextBuilder = new SlotComparisonFactory();
        this.objectXML = ObjectLibrary.xmlLibrary_[this.objectType];
        this.objectPatchXML = ObjectLibrary.xmlPatchLibrary_[this.objectType];
        this.isEquippable = _local5 != -1;
        this.setInfo = new Vector.<Effect>();
        this.effects = new Vector.<Effect>();
        this.itemSlotTypeId = this.objectXML.SlotType;
        this.itemSlotTypeId = this.objectXML.SlotType;
        if (this.player) {
            if (this.isEquippable) {
                if (this.player.equipment_[_local5] != -1) {
                    this.curItemXML = ObjectLibrary.xmlLibrary_[this.player.equipment_[_local5]];
                }
            } else {
                _local8 = false;
                if ("Tex1" in objectXML) {
                    _arg_2.fakeTex1 = this.objectXML.Tex1;
                    _local8 = true;
                }
                if ("Tex2" in objectXML) {
                    _arg_2.fakeTex2 = this.objectXML.Tex2;
                    _local8 = true;
                }
                if (_local8) {
                    _arg_2.clearTextureCache();
                }
            }
        } else {
            this.curItemXML = this.objectXML;
        }
        this.addIcon();
        this.addTitle();
        this.addDescriptionText();
        this.addTierText();
        this.handleWisMod();
        this.buildCategorySpecificText();
        this.addUniqueEffectsToList();
        this.sameActivateEffect = false;
        this.addActivateTagsToEffectsList();
        this.addNumProjectiles();
        this.addProjectileTagsToEffectsList();
        this.addRateOfFire();
        this.addActivateOnEquipTagsToEffectsList();
        this.addDoseTagsToEffectsList();
        this.addMpCostTagToEffectsList();
        this.addFameBonusTagToEffectsList();
        this.addCooldown();
        this.addSetInfo();
        this.makeSetInfoText();
        this.makeEffectsList();
        this.makeLineTwo();
        this.makeRestrictionList();
        this.makeRestrictionText();
        this.makeItemPowerText();
        this.makeSupporterPointsText();
    }
    public var titleText:TextFieldDisplayConcrete;
    public var player:Player;
    private var icon:Bitmap;
    private var tierText:UILabel;
    private var descText:TextFieldDisplayConcrete;
    private var line1:LineBreakDesign;
    private var effectsText:TextFieldDisplayConcrete;
    private var line2:LineBreakDesign;
    private var line3:LineBreakDesign;
    private var restrictionsText:TextFieldDisplayConcrete;
    private var setInfoText:TextFieldDisplayConcrete;
    private var isEquippable:Boolean = false;
    private var objectType:int;
    private var titleOverride:String;
    private var descriptionOverride:String;
    private var curItemXML:XML = null;
    private var objectXML:XML = null;
    private var objectPatchXML:XML = null;
    private var slotTypeToTextBuilder:SlotComparisonFactory;
    private var restrictions:Vector.<Restriction>;
    private var setInfo:Vector.<Effect>;
    private var effects:Vector.<Effect>;
    private var uniqueEffects:Vector.<Effect>;
    private var itemSlotTypeId:int;
    private var invType:int;
    private var inventorySlotID:uint;
    private var inventoryOwnerType:String;
    private var isInventoryFull:Boolean;
    private var playerCanUse:Boolean;
    private var comparisonResults:SlotComparisonResult;
    private var powerText:TextFieldDisplayConcrete;
    private var supporterPointsText:TextFieldDisplayConcrete;
    private var keyInfoResponse:KeyInfoResponseSignal;
    private var originalObjectType:int;
    private var sameActivateEffect:Boolean;
    private var itemIDText:TextFieldDisplayConcrete;

    override protected function alignUI():void {
        this.icon.width; this.icon.height;
        this.titleText.x = this.icon.width + 4;
        this.titleText.y = this.icon.height / 2 - this.titleText.height / 2;
        if (this.tierText) {
            this.tierText.y = this.icon.height / 2 - this.tierText.height / 2;
            this.tierText.x = 200;
        }
        this.descText.x = 4;
        this.descText.y = this.icon.height + 2;
        this.descText.y; this.descText.height;
        if (contains(this.line1)) {
            this.line1.x = 8;
            this.line1.y = this.descText.y + this.descText.height + 8;
            this.line1.y;
            this.effectsText.x = 4;
            this.effectsText.y = this.line1.y + 8;
            this.effectsText.y; this.effectsText.height;
        } else {
            this.line1.y = this.descText.y + this.descText.height;
            this.line1.y;
            this.effectsText.y = this.line1.y;
            this.effectsText.y; this.effectsText.height;
        }
        if (this.setInfoText) {
            this.line3.x = 8;
            this.line3.y = this.effectsText.y + this.effectsText.height + 8;
            this.line3.y;
            this.setInfoText.x = 4;
            this.setInfoText.y = this.line3.y + 8;
            this.setInfoText.y; this.setInfoText.height;
            this.line2.x = 8;
            this.line2.y = this.setInfoText.y + this.setInfoText.height + 8;
        } else {
            this.line2.x = 8;
            this.line2.y = this.effectsText.y + this.effectsText.height + 8;
            this.line2.y;
        }
        var _local1:uint = this.line2.y + 8;
        if (this.restrictionsText) {
            this.restrictionsText.x = 4;
            this.restrictionsText.y = _local1;
            this.restrictionsText.height;
            _local1 = _local1 + this.restrictionsText.height;
        }
        if (this.powerText) {
            if (contains(this.powerText)) {
                this.powerText.x = 4;
                this.powerText.y = _local1;
                this.powerText.height;
                _local1 = _local1 + this.powerText.height;
            }
        }
        if (this.supporterPointsText) {
            if (contains(this.supporterPointsText)) {
                this.supporterPointsText.x = 4;
                this.supporterPointsText.y = _local1;
            }
        }
    }

    private function makeItemIDText():void {
        var _local1:int = this.playerCanUse || this.player == null ? 0xffffff : 16549442;
        this.itemIDText = new TextFieldDisplayConcrete().setSize(12).setColor(_local1).setBold(true);
        this.itemIDText.setStringBuilder(new StaticStringBuilder().setString("Item ID: " + this.objectType));
        this.itemIDText.filters = [new DropShadowFilter(0, 0, 0, 0.5, 12, 12)];
        addChild(this.itemIDText);
    }

    private function addSetInfo():void {
        if (!this.objectXML.hasOwnProperty("@setType")) {
            return;
        }
        var _local1:int = this.objectXML.attribute("setType");
        this.setInfo.push(new Effect("{name} ", {"name": "<b>" + this.objectXML.attribute("setName") + "</b>"}).setColor(0xff9900).setReplacementsColor(0xff9900));
        this.addSetActivateOnEquipTagsToEffectsList(_local1);
    }

    private function addSetActivateOnEquipTagsToEffectsList(_arg_1:int):void {
        var _local3:* = null;
        var _local9:* = 0;
        var _local5:* = 0;
        var _local4:* = null;
        var _local8:* = null;
        var _local7:* = null;
        var _local6:int = 0;
        var _local2:XML = ObjectLibrary.getSetXMLFromType(_arg_1);
        var _local11:int = 0;
        var _local10:* = _local2.Setpiece;
        for each(_local3 in _local2.Setpiece) {
            if (_local3.toString() == "Equipment") {
                if (this.player != null && this.player.equipment_[int(_local3.@slot)] == int(_local3.@itemtype)) {
                    _local6++;
                }
            }
        }
        _local9 = 6835752;
        _local5 = 0xffff8f;
        if (_local2.hasOwnProperty("ActivateOnEquip2")) {
            _local9 = uint(_local6 >= 2 ? 0xff9900 : 6835752);
            _local5 = uint(_local6 >= 2 ? 0xffff8f : 6842444);
            this.setInfo.push(new Effect("2 Pieces", null).setColor(_local9).setReplacementsColor(_local9));
            var _local13:int = 0;
            var _local12:* = _local2.ActivateOnEquip2;
            for each(_local4 in _local2.ActivateOnEquip2) {
                this.makeSetEffectLine(_local4, _local5);
            }
        }
        if (_local2.hasOwnProperty("ActivateOnEquip3")) {
            _local9 = uint(_local6 >= 3 ? 0xff9900 : 6835752);
            _local5 = uint(_local6 >= 3 ? 0xffff8f : 6842444);
            this.setInfo.push(new Effect("3 Pieces", null).setColor(_local9).setReplacementsColor(_local9));
            var _local15:int = 0;
            var _local14:* = _local2.ActivateOnEquip3;
            for each(_local8 in _local2.ActivateOnEquip3) {
                this.makeSetEffectLine(_local8, _local5);
            }
        }
        if (_local2.hasOwnProperty("ActivateOnEquipAll")) {
            _local9 = uint(_local6 >= 4 ? 0xff9900 : 6835752);
            _local5 = uint(_local6 >= 4 ? 0xffff8f : 6842444);
            this.setInfo.push(new Effect("Full Set", null).setColor(_local9).setReplacementsColor(_local9));
            var _local17:int = 0;
            var _local16:* = _local2.ActivateOnEquipAll;
            for each(_local7 in _local2.ActivateOnEquipAll) {
                this.makeSetEffectLine(_local7, _local5);
            }
        }
    }

    private function makeSetEffectLine(_arg_1:XML, _arg_2:uint):void {
        if (_arg_1.toString() == "IncrementStat") {
            this.setInfo.push(new Effect("EquipmentToolTip.incrementStat", this.getComparedStatText(_arg_1)).setColor(_arg_2).setReplacementsColor(_arg_2));
        }
    }

        private function makeItemPowerText():void {
        var _local1:int = 0;
        var _local2:int = 0;
        if (this.objectXML.hasOwnProperty("feedPower")) {
            _local1 = this.objectXML.feedPower;
            _local2 = this.playerCanUse || this.player == null ? 0xffffff : 16549442;
            this.powerText = new TextFieldDisplayConcrete().setSize(12).setColor(_local2).setBold(true).setTextWidth(230 - this.icon.width - 4 - 30).setWordWrap(true);
            this.powerText.setStringBuilder(new StaticStringBuilder().setString("Feed Power: " + _local1));
            this.powerText.filters = FilterUtil.getStandardDropShadowFilter();
            waiter.push(this.powerText.textChanged);
            addChild(this.powerText);
        }
    }

    private function makeSupporterPointsText():void {
        var _local2:* = null;
        var _local1:* = null;
        var _local4:int = 0;
        var _local3:* = this.objectXML.Activate;
        for each(_local2 in this.objectXML.Activate) {
            _local1 = _local2.toString();
            if (_local1 == "GrantSupporterPoints") {
                this.supporterPointsText = new TextFieldDisplayConcrete().setSize(12).setColor(0xffffff).setBold(true).setTextWidth(230 - this.icon.width - 4 - 30).setWordWrap(true);
                this.supporterPointsText.setStringBuilder(new StaticStringBuilder().setString("Campaign points: " + _local2.@amount));
                this.supporterPointsText.filters = FilterUtil.getStandardDropShadowFilter();
                waiter.push(this.supporterPointsText.textChanged);
                addChild(this.supporterPointsText);
            }
        }
    }

    private function onKeyInfoResponse(_arg_1:KeyInfoResponse):void {
        this.keyInfoResponse.remove(this.onKeyInfoResponse);
        this.removeTitle();
        this.removeDesc();
        this.titleOverride = _arg_1.name;
        this.descriptionOverride = _arg_1.description;
        keyInfo[this.originalObjectType] = [_arg_1.name, _arg_1.description, _arg_1.creator];
        this.addTitle();
        this.addDescriptionText();
    }

    private function addUniqueEffectsToList():void {
        var _local1:* = null;
        var _local2:* = null;
        var _local3:* = null;
        var _local4:* = null;
        var _local5:* = null;
        var _local6:* = null;
        if (this.objectXML.hasOwnProperty("ExtraTooltipData")) {
            _local1 = this.objectXML.ExtraTooltipData.EffectInfo;
            var _local8:int = 0;
            var _local7:* = _local1;
            for each(_local2 in _local1) {
                _local3 = _local2.attribute("name");
                _local4 = _local2.attribute("description");
                _local5 = _local3 && _local4 ? ": " : "\n";
                _local6 = new AppendingLineBuilder();
                if (_local3) {
                    _local6.pushParams(_local3);
                }
                if (_local4) {
                    _local6.pushParams(_local4, {}, TooltipHelper.getOpenTag(0xffff8f), TooltipHelper.getCloseTag());
                }
                _local6.setDelimiter(_local5);
                this.uniqueEffects.push(new Effect("blank", {"data": _local6}));
            }
        }
    }

    private function isEmptyEquipSlot():Boolean {
        return this.isEquippable && this.curItemXML == null;
    }

    private function addIcon():void {
        var _local1:XML = ObjectLibrary.xmlLibrary_[this.objectType];
        var _local2:int = 5;
        if (this.objectType == 4874 || this.objectType == 4618) {
            _local2 = 8;
        }
        if (_local1.hasOwnProperty("ScaleValue")) {
            _local2 = _local1.ScaleValue;
        }
        var _local3:BitmapData = ObjectLibrary.getRedrawnTextureFromType(this.objectType, 60, true, true, _local2);
        _local3 = BitmapUtil.cropToBitmapData(_local3, 4, 4, _local3.width - 8, _local3.height - 8);
        this.icon = new Bitmap(_local3);
        addChild(this.icon);
    }

    private function addTierText():void {
        this.tierText = TierUtil.getTierTag(this.objectXML, 16);
        if (this.tierText) {
            addChild(this.tierText);
        }
    }

    private function isPet():Boolean {
        var _local1:* = null;
        var _local2:* = this.objectXML.Activate;
        var _local3:int = 0;
        var _local5:* = new XMLList("");
        _local1 = this.objectXML.Activate.(text() == "PermaPet");
        return _local1.length() >= 1;
    }

    private function removeTitle():void {
        removeChild(this.titleText);
    }

    private function removeDesc():void {
        removeChild(this.descText);
    }

    private function addTitle():void {
        var _local1:int = this.playerCanUse || this.player == null ? 0xffffff : 16549442;
        this.titleText = new TextFieldDisplayConcrete().setSize(16).setColor(_local1).setBold(true).setTextWidth(230 - this.icon.width - 4 - 30).setWordWrap(true);
        if (this.titleOverride) {
            this.titleText.setStringBuilder(new StaticStringBuilder(this.titleOverride));
        } else {
            this.titleText.setStringBuilder(new LineBuilder().setParams(ObjectLibrary.typeToDisplayId_[this.objectType]));
        }
        this.titleText.filters = FilterUtil.getStandardDropShadowFilter();
        waiter.push(this.titleText.textChanged);
        addChild(this.titleText);
    }

    private function buildUniqueTooltipData():String {
        var _local2:* = undefined;
        var _local1:* = null;
        var _local3:* = null;
        if (this.objectXML.hasOwnProperty("ExtraTooltipData")) {
            _local1 = this.objectXML.ExtraTooltipData.EffectInfo;
            _local2 = new Vector.<Effect>();
            var _local5:int = 0;
            var _local4:* = _local1;
            for each(_local3 in _local1) {
                _local2.push(new Effect(_local3.attribute("name"), _local3.attribute("description")));
            }
        }
        return "";
    }

    private function makeEffectsList():void {
        var _local1:* = null;
        if (this.effects.length != 0 || this.comparisonResults.lineBuilder != null || this.objectXML.hasOwnProperty("ExtraTooltipData")) {
            this.line1 = new LineBreakDesign(218, 0);
            this.effectsText = new TextFieldDisplayConcrete().setSize(14).setColor(0xb3b3b3).setTextWidth(230).setWordWrap(true).setHTML(true);
            _local1 = this.getEffectsStringBuilder();
            this.effectsText.setStringBuilder(_local1);
            this.effectsText.filters = FilterUtil.getStandardDropShadowFilter();
            if (_local1.hasLines()) {
                addChild(this.line1);
                addChild(this.effectsText);
                waiter.push(this.effectsText.textChanged);
            }
        }
    }

    private function getEffectsStringBuilder():AppendingLineBuilder {
        var _local1:AppendingLineBuilder = new AppendingLineBuilder();
        this.appendEffects(this.uniqueEffects, _local1);
        if (this.comparisonResults.lineBuilder.hasLines()) {
            _local1.pushParams("blank", {"data": this.comparisonResults.lineBuilder});
        }
        this.appendEffects(this.effects, _local1);
        return _local1;
    }

    private function appendEffects(_arg_1:Vector.<Effect>, _arg_2:AppendingLineBuilder):void {
        var _local3:* = null;
        var _local4:* = null;
        var _local5:* = null;
        var _local7:int = 0;
        var _local6:* = _arg_1;
        for each(_local3 in _arg_1) {
            _local4 = "";
            _local5 = "";
            if (_local3.color_) {
                _local4 = "<font color=\"#" + _local3.color_.toString(16) + "\">";
                _local5 = "</font>";
            }
            _arg_2.pushParams(_local3.name_, _local3.getValueReplacementsWithColor(), _local4, _local5);
        }
    }

    private function addFameBonusTagToEffectsList():void {
        var _local1:int = 0;
        var _local2:* = 0;
        var _local3:int = 0;
        if (this.objectXML.hasOwnProperty("FameBonus")) {
            _local1 = this.objectXML.FameBonus;
            _local2 = uint(!!this.playerCanUse ? 0xff00 : 16777103);
            if (this.curItemXML != null && this.curItemXML.hasOwnProperty("FameBonus")) {
                _local3 = this.curItemXML.FameBonus.text();
                _local2 = uint(TooltipHelper.getTextColor(_local1 - _local3));
            }
            this.effects.push(new Effect("EquipmentToolTip.fameBonus", {"percent": this.objectXML.FameBonus + "%"}).setReplacementsColor(_local2));
        }
    }

    private function addMpCostTagToEffectsList():void {
        var _local1:* = 0;
        var _local2:int = 0;
        if (this.objectXML.hasOwnProperty("MpEndCost")) {
            _local2 = this.objectXML.MpEndCost;
            _local1 = _local2;
            if (this.curItemXML && this.curItemXML.hasOwnProperty("MpEndCost")) {
                _local2 = this.curItemXML.MpEndCost;
            }
            this.effects.push(new Effect("EquipmentToolTip.mpCost", {"cost": TooltipHelper.compare(_local1, _local2, false)}));
        } else if (this.objectXML.hasOwnProperty("MpCost")) {
            _local2 = this.objectXML.MpCost;
            _local1 = _local2;
            if (this.curItemXML && this.curItemXML.hasOwnProperty("MpCost")) {
                _local2 = this.curItemXML.MpCost;
            }
            this.effects.push(new Effect("EquipmentToolTip.mpCost", {"cost": TooltipHelper.compare(_local1, _local2, false)}));
        }
    }

    private function addDoseTagsToEffectsList():void {
        if (this.objectXML.hasOwnProperty("Doses")) {
            this.effects.push(new Effect("EquipmentToolTip.doses", {"dose": this.objectXML.Doses}));
        }
        if (this.objectXML.hasOwnProperty("Quantity")) {
            this.effects.push(new Effect("Quantity: {quantity}", {"quantity": this.objectXML.Quantity}));
        }
    }

    private function addNumProjectiles():void {
        var _local1:ComPairTag = new ComPairTag(this.objectXML, this.curItemXML, "NumProjectiles", 1);
        if (_local1.a != 1 || _local1.a != _local1.b) {
            this.effects.push(new Effect("EquipmentToolTip.shots", {"numShots": TooltipHelper.compare(_local1.a, _local1.b)}));
        }
    }

    private function addProjectileTagsToEffectsList():void {
        var _local1:* = null;
        if (this.objectXML.hasOwnProperty("Projectile")) {
            _local1 = this.curItemXML == null ? null : this.curItemXML.Projectile[0];
            this.addProjectile(this.objectXML.Projectile[0], _local1);
        }
    }

    private function addProjectile(_arg_1:XML, _arg_2:XML = null):void {
        var _local15:* = null;
        var _local6:ComPairTag = new ComPairTag(_arg_1, _arg_2, "MinDamage");
        var _local3:ComPairTag = new ComPairTag(_arg_1, _arg_2, "MaxDamage");
        var _local4:ComPairTag = new ComPairTag(_arg_1, _arg_2, "Speed");
        var _local13:ComPairTag = new ComPairTag(_arg_1, _arg_2, "LifetimeMS");
        var _local7:ComPairTagBool = new ComPairTagBool(_arg_1, _arg_2, "Boomerang");
        var _local8:ComPairTagBool = new ComPairTagBool(_arg_1, _arg_2, "Parametric");
        var _local5:ComPairTag = new ComPairTag(_arg_1, _arg_2, "Magnitude", 3);
        var _local11:Number = _local8.a ? _local5.a : Number(MathUtil.round(_local4.a * _local13.a / (_local7.a + 1) / 10000, 2));
        var _local12:Number = _local8.b ? _local5.b : Number(MathUtil.round(_local4.b * _local13.b / (_local7.b + 1) / 10000, 2));
        var _local9:Number = (_local3.a + _local6.a) / 2;
        var _local10:Number = (_local3.b + _local6.b) / 2;
        var _local14:String = (_local6.a == _local3.a ? _local6.a : _local6.a + " - " + _local3.a).toString();
        this.effects.push(new Effect("EquipmentToolTip.damage", {"damage": TooltipHelper.wrapInFontTag(_local14, "#" + TooltipHelper.getTextColor(_local9 - _local10).toString(16))}));
        this.effects.push(new Effect("EquipmentToolTip.range", {"range": TooltipHelper.compare(_local11, _local12)}));
        if (_arg_1.hasOwnProperty("MultiHit")) {
            this.effects.push(new Effect("GeneralProjectileComparison.multiHit", {}).setColor(0xffff8f));
        }
        if (_arg_1.hasOwnProperty("PassesCover")) {
            this.effects.push(new Effect("GeneralProjectileComparison.passesCover", {}).setColor(0xffff8f));
        }
        if (_arg_1.hasOwnProperty("ArmorPiercing")) {
            this.effects.push(new Effect("GeneralProjectileComparison.armorPiercing", {}).setColor(0xffff8f));
        }
        if (_local8.a) {
            this.effects.push(new Effect("Shots are parametric", {}).setColor(0xffff8f));
        } else if (_local7.a) {
            this.effects.push(new Effect("Shots boomerang", {}).setColor(0xffff8f));
        }
        if (_arg_1.hasOwnProperty("ConditionEffect")) {
            this.effects.push(new Effect("EquipmentToolTip.shotEffect", {"effect": ""}));
        }
        var _local17:int = 0;
        var _local16:* = _arg_1.ConditionEffect;
        for each(_local15 in _arg_1.ConditionEffect) {
            this.effects.push(new Effect("EquipmentToolTip.effectForDuration", {
                "effect": _local15,
                "duration": _local15.@duration
            }).setColor(0xffff8f));
        }
    }

    private function addRateOfFire():void {
        var _local2:* = null;
        var _local1:ComPairTag = new ComPairTag(this.objectXML, this.curItemXML, "RateOfFire", 1);
        if (_local1.a != 1 || _local1.a != _local1.b) {
            _local1.a = MathUtil.round(_local1.a * 100, 2);
            _local1.b = MathUtil.round(_local1.b * 100, 2);
            _local2 = TooltipHelper.compare(_local1.a, _local1.b, true, "%");
            this.effects.push(new Effect("EquipmentToolTip.rateOfFire", {"data": _local2}));
        }
    }

    private function addCooldown():void {
        var _local1:ComPairTag = new ComPairTag(this.objectXML, this.curItemXML, "Cooldown", 0.5);
        if (_local1.a != 0.5 || _local1.a != _local1.b) {
            this.effects.push(new Effect("Cooldown: {cd}", {"cd": TooltipHelper.compareAndGetPlural(_local1.a, _local1.b, "second", false)}));
        }
    }

    private function addActivateTagsToEffectsList() : void {
        var _local2:* = null;
        var _local15:* = null;
        var _local16:int = 0;
        var _local4:int = 0;
        var _local18:* = null;
        var _local8:* = null;
        var _local13:* = null;
        var _local19:* = 0;
        var _local9:* = null;
        var _local14:* = null;
        var _local1:* = null;
        var _local17:* = 0;
        var _local10:* = null;
        var _local11:* = null;
        var _local3:* = null;
        var _local20:* = null;
        var _local28:* = null;
        var _local29:Number = NaN;
        var _local5:Number = NaN;
        var _local26:Number = NaN;
        var _local22:Number = NaN;
        var _local23:Number = NaN;
        var _local7:Number = NaN;
        var _local27:Number = NaN;
        var _local25:Number = NaN;
        var _local30:Number = NaN;
        var _local21:Number = NaN;
        var _local6:Number = NaN;
        var _local24:Number = NaN;
        var _local12:* = null;
        for each(_local2 in this.objectXML.Activate) {
            _local18 = this.comparisonResults.processedTags[_local2.toXMLString()];
            if(!_local18) {
                _local8 = _local2.toString();
                switch(_local8) {
                    case "ConditionEffectAura":
                        this.effects.push(new Effect("EquipmentToolTip.partyEffect",{"effect":new AppendingLineBuilder().pushParams("EquipmentToolTip.withinSqrs",{"range":_local2.@range},TooltipHelper.getOpenTag(0xffff8f),TooltipHelper.getCloseTag())}));
                        this.effects.push(new Effect("EquipmentToolTip.effectForDuration",{
                            "effect":_local2.@effect,
                            "duration":_local2.@duration
                        }).setColor(0xffff8f));
                        continue;
                    case "ConditionEffectSelf":
                        this.effects.push(new Effect("EquipmentToolTip.effectOnSelf",{"effect":""}));
                        this.effects.push(new Effect("EquipmentToolTip.effectForDuration",{
                            "effect":_local2.@effect,
                            "duration":_local2.@duration
                        }));
                        continue;
                    case "StatBoostSelf":
                        this.effects.push(new Effect("{amount} {stat} for {duration} ",{
                            "amount":this.prefix(_local2.@amount),
                            "stat":new LineBuilder().setParams(StatData.statToName(int(_local2.@stat))),
                            "duration":TooltipHelper.getPlural(_local2.@duration,"second")
                        }));
                        continue;
                    case "Heal":
                        this.effects.push(new Effect("EquipmentToolTip.incrementStat",{
                            "statAmount":"+" + _local2.@amount + " ",
                            "statName":new LineBuilder().setParams("StatusBar.HealthPoints")
                        }));
                        continue;
                    case "HealNova":
                        if(_local2.hasOwnProperty("@damage") && int(_local2.@damage) > 0) {
                            this.effects.push(new Effect("{damage} damage within {range} sqrs",{
                                "damage":_local2.@damage,
                                "range":_local2.@range
                            }));
                        }
                        this.effects.push(new Effect("EquipmentToolTip.partyHeal",{"effect":new AppendingLineBuilder().pushParams("EquipmentToolTip.partyHealAmount",{
                                "amount":_local2.@amount,
                                "range":_local2.@range
                            },TooltipHelper.getOpenTag(0xffff8f),TooltipHelper.getCloseTag())}));
                        continue;
                    case "Magic":
                        this.effects.push(new Effect("EquipmentToolTip.incrementStat",{
                            "statAmount":"+" + _local2.@amount + " ",
                            "statName":new LineBuilder().setParams("StatusBar.ManaPoints")
                        }));
                        continue;
                    case "MagicNova":
                        this.effects.push(new Effect("EquipmentToolTip.partyFill",{"effect":new AppendingLineBuilder().pushParams("EquipmentToolTip.partyFillAmount",{
                                "amount":_local2.@amount,
                                "range":_local2.@range
                            },TooltipHelper.getOpenTag(0xffff8f),TooltipHelper.getCloseTag())}));
                        continue;
                    case "Teleport":
                        this.effects.push(new Effect("blank",{"data":new LineBuilder().setParams("EquipmentToolTip.teleportToTarget")}));
                        continue;
                    case "BulletNova":
                        this.getSpell(_local2,_local13);
                        continue;
                    case "BulletCreate":
                        this.getBulletCreate(_local2,_local13);
                        continue;
                    case "VampireBlast":
                        this.getSkull(_local2,_local13);
                        continue;
                    case "Trap":
                        this.getTrap(_local2,_local13);
                        continue;
                    case "StasisBlast":
                        this.effects.push(new Effect("EquipmentToolTip.stasisGroup",{"stasis":new AppendingLineBuilder().pushParams("EquipmentToolTip.secsCount",{"duration":_local2.@duration},TooltipHelper.getOpenTag(0xffff8f),TooltipHelper.getCloseTag())}));
                        continue;
                    case "Decoy":
                        this.getDecoy(_local2,_local13);
                        continue;
                    case "Lightning":
                        this.getLightning(_local2,_local13);
                        continue;
                    case "PoisonGrenade":
                        this.getPoison(_local2,_local13);
                        continue;
                    case "RemoveNegativeConditions":
                        this.effects.push(new Effect("EquipmentToolTip.removesNegative",{}).setColor(0xffff8f));
                        continue;
                    case "RemoveNegativeConditionsSelf":
                        this.effects.push(new Effect("EquipmentToolTip.removesNegative",{}).setColor(0xffff8f));
                        continue;
                    case "GenericActivate":
                        if(!("@ignoreOnTooltip" in _local2)) {
                            _local19 = uint(0xffff8f);
                            if(this.curItemXML != null) {
                                _local9 = this.getEffectTag(this.curItemXML,_local2.@effect);
                                if(_local9 != null) {
                                    _local29 = _local2.@range;
                                    _local5 = _local9.@range;
                                    _local26 = _local2.@duration;
                                    _local22 = _local9.@duration;
                                    _local23 = _local29 - _local5 + (_local26 - _local22);
                                    if(_local23 > 0) {
                                        _local19 = uint(0xff00);
                                    } else if(_local23 < 0) {
                                        _local19 = uint(0xff0000);
                                    }
                                }
                            }
                            _local14 = {
                                "range":_local2.@range,
                                "effect":_local2.@effect,
                                "duration":_local2.@duration
                            };
                            _local1 = "Within {range} sqrs {effect} for {duration} seconds";
                            if(_local2.@target != "enemy") {
                                this.effects.push(new Effect("EquipmentToolTip.partyEffect",{"effect":LineBuilder.returnStringReplace(_local1,_local14)}).setReplacementsColor(_local19));
                            } else {
                                this.effects.push(new Effect("EquipmentToolTip.enemyEffect",{"effect":LineBuilder.returnStringReplace(_local1,_local14)}).setReplacementsColor(_local19));
                            }
                        }
                        continue;
                    case "StatBoostAura":
                        _local17 = uint(0xffff8f);
                        if(this.curItemXML != null) {
                            _local10 = this.getStatTag(this.curItemXML,_local2.@stat);
                            if(_local10 != null) {
                                _local7 = _local2.@range;
                                _local27 = _local10.@range;
                                _local25 = _local2.@duration;
                                _local30 = _local10.@duration;
                                _local21 = _local2.@amount;
                                _local6 = _local10.@amount;
                                _local24 = _local7 - _local27 + (_local25 - _local30) + (_local21 - _local6);
                                if(_local24 > 0) {
                                    _local17 = uint(0xff00);
                                } else if(_local24 < 0) {
                                    _local17 = uint(0xff0000);
                                }
                            }
                        }
                        _local16 = _local2.@stat;
                        _local11 = LineBuilder.getLocalizedString2(StatData.statToName(_local16));
                        _local3 = {
                            "range":_local2.@range,
                            "stat":_local11,
                            "amount":_local2.@amount,
                            "duration":_local2.@duration
                        };
                        _local20 = "Within {range} sqrs increase {stat} by {amount} for {duration} seconds";
                        this.effects.push(new Effect("EquipmentToolTip.partyEffect",{"effect":LineBuilder.returnStringReplace(_local20,_local3)}).setReplacementsColor(_local17));
                        continue;
                    case "IncrementStat":
                        _local16 = _local2.@stat;
                        _local4 = _local2.@amount;
                        _local28 = {};
                        if(_local16 != 1 && _local16 != 4) {
                            _local15 = "EquipmentToolTip.permanentlyIncreases";
                            _local28["statName"] = new LineBuilder().setParams(StatData.statToName(_local16));
                            this.effects.push(new Effect(_local15,_local28).setColor(0xffff8f));
                        } else {
                            _local15 = "blank";
                            _local12 = new AppendingLineBuilder().setDelimiter(" ");
                            _local12.pushParams("blank",{"data":new StaticStringBuilder("+" + _local4)});
                            _local12.pushParams(StatData.statToName(_local16));
                            _local28["data"] = _local12;
                            this.effects.push(new Effect(_local15,_local28));
                        }
                        continue;
                    case "BoostRange":
                        continue;
                    default:
                        continue;
                }
            } else {
                continue;
            }
        }
    }

    private function getSpell(_arg_1:XML, _arg_2:XML = null):void {
        var _local3:ComPair = new ComPair(_arg_1, _arg_2, "numShots", 20);
        var _local4:String = this.colorUntiered("Spell: ");
        _local4 = _local4 + "{numShots} Shots";
        this.effects.push(new Effect(_local4, {"numShots": TooltipHelper.compare(_local3.a, _local3.b)}));
    }

    private function getBulletCreate(xml1:XML, xml2:XML = null) : void {
        var shotsPair:ComPair = new ComPair(xml1, xml2, "numShots", 3);
        var anglePair:ComPair = new ComPair(xml1, xml2, "offsetAngle", 90);
        var minDistPair:ComPair = new ComPair(xml1, xml2, "minDistance", 0);
        var maxDistPair:ComPair = new ComPair(xml1, xml2, "maxDistance", 4.4);
        var effText:String = this.colorUntiered("Wakizashi: ")
                + "{numShots} shots at {angle}\n";
        if (minDistPair.a)
            effText += "Min Cast Range: {minDistance}\n";
        effText  += "Max Cast Range: {maxDistance}";
        this.effects.push(new Effect(effText, {
            "numShots": TooltipHelper.compare(shotsPair.a, shotsPair.b),
            "angle": TooltipHelper.getPlural(anglePair.a, "degree"),
            "minDistance": TooltipHelper.compareAndGetPlural(minDistPair.a, minDistPair.b, "square", false),
            "maxDistance": TooltipHelper.compareAndGetPlural(maxDistPair.a, maxDistPair.b, "square")
        }));
    }

    private function getSkull(_arg_1:XML, _arg_2:XML = null):void {
        var _local7:int = this.player != null ? this.player.wisdom : 10;
        var _local8:int = this.GetIntArgument(_arg_1, "wisPerRad", 10);
        var _local5:Number = this.GetFloatArgument(_arg_1, "incrRad", 0.5);
        var _local6:int = this.GetIntArgument(_arg_1, "wisDamageBase", 0);
        var _local11:int = this.GetIntArgument(_arg_1, "wisMin", 50);
        var _local9:int = Math.max(0, _local7 - _local11);
        var _local10:int = _local6 / 10 * _local9;
        var _local14:Number = MathUtil.round(int(_local9 / _local8) * _local5, 2);
        var _local15:ComPair = new ComPair(_arg_1, _arg_2, "totalDamage");
        _local15.add(_local10);
        var _local12:ComPair = new ComPair(_arg_1, _arg_2, "radius");
        var _local13:ComPair = new ComPair(_arg_1, _arg_2, "healRange", 5);
        _local13.add(_local14);
        var _local17:ComPair = new ComPair(_arg_1, _arg_2, "heal");
        var _local18:ComPair = new ComPair(_arg_1, _arg_2, "ignoreDef", 0);
        var _local4:int = this.GetIntArgument(_arg_1, "hitsForSelfPuri", -1);
        var _local16:int = this.GetIntArgument(_arg_1, "hitsForGroupPuri", -1);
        var _local3:String = this.colorUntiered("Skull: ");
        _local3 = _local3 + ("{damage}" + this.colorWisBonus(_local10) + " damage\n");
        _local3 = _local3 + "within {radius} squares\n";
        if (_local17.a) {
            _local3 = _local3 + "Steals {heal} HP";
        }
        if (_local17.a && Number(_local18.a)) {
            _local3 = _local3 + " and ignores {ignoreDef} defense";
        } else if (_local18.a) {
            _local3 = _local3 + "Ignores {ignoreDef} defense";
        }
        if (_local17.a) {
            _local3 = _local3 + ("\nHeals allies within {healRange}" + this.colorWisBonus(_local14) + " squares");
        }
        if (_local4 != -1) {
            _local3 = _local3 + "\n{hitsSelf}: Removes negative conditions on self";
        }
        if (_local4 != -1) {
            _local3 = _local3 + "\n{hitsGroup}: Removes negative conditions on group";
        }
        this.effects.push(new Effect(_local3, {
            "damage": TooltipHelper.compare(_local15.a, _local15.b),
            "radius": TooltipHelper.compare(_local12.a, _local12.b),
            "heal": TooltipHelper.compare(_local17.a, _local17.b),
            "ignoreDef": TooltipHelper.compare(_local18.a, _local18.b),
            "healRange": TooltipHelper.compare(MathUtil.round(_local13.a, 2), MathUtil.round(_local13.b, 2)),
            "hitsSelf": TooltipHelper.getPlural(_local4, "Hit"),
            "hitsGroup": TooltipHelper.getPlural(_local16, "Hit")
        }));
        this.AddConditionToEffects(_arg_1, _arg_2, "Nothing", 2.5);
    }

    private function getTrap(_arg_1:XML, _arg_2:XML = null):void {
        var _local10:ComPair = new ComPair(_arg_1, _arg_2, "totalDamage");
        var _local4:ComPair = new ComPair(_arg_1, _arg_2, "radius");
        var _local5:ComPair = new ComPair(_arg_1, _arg_2, "duration", 20);
        var _local6:ComPair = new ComPair(_arg_1, _arg_2, "throwTime", 1);
        var _local3:ComPair = new ComPair(_arg_1, _arg_2, "sensitivity", 0.5);
        var _local8:Number = MathUtil.round(_local4.a * _local3.a, 2);
        var _local9:Number = MathUtil.round(_local4.b * _local3.b, 2);
        var _local7:String = this.colorUntiered("Trap: ");
        _local7 = _local7 + "{damage} damage within {radius} squares";
        this.effects.push(new Effect(_local7, {
            "damage": TooltipHelper.compare(_local10.a, _local10.b),
            "radius": TooltipHelper.compare(_local4.a, _local4.b)
        }));
        this.AddConditionToEffects(_arg_1, _arg_2, "Slowed", 5);
        this.effects.push(new Effect("{throwTime} to arm for {duration} ", {
            "throwTime": TooltipHelper.compareAndGetPlural(_local6.a, _local6.b, "second", false),
            "duration": TooltipHelper.compareAndGetPlural(_local5.a, _local5.b, "second")
        }));
        this.effects.push(new Effect("Triggers within {triggerRadius} squares", {"triggerRadius": TooltipHelper.compare(_local8, _local9)}));
    }

    private function getLightning(_arg_1:XML, _arg_2:XML = null):void {
        var _local14:Boolean = false;
        var _local15:* = null;
        var _local6:int = this.player != null ? this.player.wisdom : 10;
        var _local3:ComPair = new ComPair(_arg_1, _arg_2, "decrDamage", 0);
        var _local4:int = this.GetIntArgument(_arg_1, "wisPerTarget", 10);
        var _local13:int = this.GetIntArgument(_arg_1, "wisDamageBase", _local3.a);
        var _local7:int = this.GetIntArgument(_arg_1, "wisMin", 50);
        var _local8:int = Math.max(0, _local6 - _local7);
        var _local5:int = _local8 / _local4;
        var _local11:int = _local13 / 10 * _local8;
        var _local12:ComPair = new ComPair(_arg_1, _arg_2, "maxTargets");
        _local12.add(_local5);
        var _local9:ComPair = new ComPair(_arg_1, _arg_2, "totalDamage");
        _local9.add(_local11);
        var _local10:String = this.colorUntiered("Lightning: ");
        _local10 = _local10 + ("{targets}" + this.colorWisBonus(_local5) + " targets\n");
        _local10 = _local10 + ("{damage}" + this.colorWisBonus(_local11) + " damage");
        if (_local3.a) {
            if (_local3.a < 0) {
                _local14 = true;
            }
            _local15 = "reduced";
            if (_local14) {
                _local15 = TooltipHelper.wrapInFontTag("increased", "#" + 0xffff8f.toString(16));
            }
            _local10 = _local10 + (", " + _local15 + " by \n{decrDamage} for each subsequent target");
        }
        this.effects.push(new Effect(_local10, {
            "targets": TooltipHelper.compare(_local12.a, _local12.b),
            "damage": TooltipHelper.compare(_local9.a, _local9.b),
            "decrDamage": TooltipHelper.compare(_local3.a, _local3.b, false, "", _local14)
        }));
        this.AddConditionToEffects(_arg_1, _arg_2, "Nothing", 5);
    }

    private function getDecoy(_arg_1:XML, _arg_2:XML = null):void {
        var _local7:ComPair = new ComPair(_arg_1, _arg_2, "duration");
        var _local4:ComPair = new ComPair(_arg_1, _arg_2, "angleOffset", 0);
        var _local10:ComPair = new ComPair(_arg_1, _arg_2, "speed", 1);
        var _local6:ComPair = new ComPair(_arg_1, _arg_2, "distance", 8);
        var _local5:Number = MathUtil.round(_local6.a / (_local10.a * 5), 2);
        var _local9:Number = MathUtil.round(_local6.b / (_local10.b * 5), 2);
        var _local3:ComPair = new ComPair(_arg_1, _arg_2, "numShots", 0);
        var _local8:* = this.colorUntiered("Decoy: ");
        _local8 = _local8 + "{duration}";
        if (_local4.a) {
            _local8 = _local8 + " at {angleOffset}";
        }
        _local8 = _local8 + "\n";
        if (_local10.a == 0) {
            _local8 = _local8 + "Decoy does not move";
        } else {
            _local8 = _local8 + "{distance} in {travelTime}";
        }
        if (_local3.a) {
            _local8 = _local8 + "\nShots: {numShots}";
        }
        this.effects.push(new Effect(_local8, {
            "duration": TooltipHelper.compareAndGetPlural(_local7.a, _local7.b, "second"),
            "angleOffset": TooltipHelper.compareAndGetPlural(_local4.a, _local4.b, "degree"),
            "distance": TooltipHelper.compareAndGetPlural(_local6.a, _local6.b, "square"),
            "travelTime": TooltipHelper.compareAndGetPlural(_local5, _local9, "second"),
            "numShots": TooltipHelper.compare(_local3.a, _local3.b)
        }));
    }

    private function getPoison(_arg_1:XML, _arg_2:XML = null):void {
        var _local7:ComPair = new ComPair(_arg_1, _arg_2, "totalDamage");
        var _local4:ComPair = new ComPair(_arg_1, _arg_2, "radius");
        var _local10:ComPair = new ComPair(_arg_1, _arg_2, "duration");
        var _local6:ComPair = new ComPair(_arg_1, _arg_2, "throwTime", 1);
        var _local5:ComPair = new ComPair(_arg_1, _arg_2, "impactDamage", 0);
        var _local9:Number = _local7.a - _local5.a;
        var _local3:Number = _local7.b - _local5.b;
        var _local8:* = this.colorUntiered("Poison: ");
        _local8 = _local8 + "{totalDamage} damage";
        if (_local5.a) {
            _local8 = _local8 + " ({impactDamage} on impact)";
        }
        _local8 = _local8 + " within {radius}";
        _local8 = _local8 + " over {duration}";
        this.effects.push(new Effect(_local8, {
            "totalDamage": TooltipHelper.compare(_local7.a, _local7.b, true, "", false, !this.sameActivateEffect),
            "radius": TooltipHelper.compareAndGetPlural(_local4.a, _local4.b, "square", true, !this.sameActivateEffect),
            "impactDamage": TooltipHelper.compare(_local5.a, _local5.b, true, "", false, !this.sameActivateEffect),
            "duration": TooltipHelper.compareAndGetPlural(_local10.a, _local10.b, "second", false, !this.sameActivateEffect)
        }));
        this.AddConditionToEffects(_arg_1, _arg_2, "Nothing", 5);
        this.sameActivateEffect = true;
    }

    private function AddConditionToEffects(_arg_1:XML, _arg_2:XML, _arg_3:String = "Nothing", _arg_4:Number = 5):void {
        var _local6:* = null;
        var _local5:* = null;
        var _local7:String = !!_arg_1.hasOwnProperty("@condEffect") ? _arg_1.@condEffect : _arg_3;
        if (_local7 != "Nothing") {
            _local6 = new ComPair(_arg_1, _arg_2, "condDuration", _arg_4);
            if (_arg_2) {
                _local5 = !!_arg_2.hasOwnProperty("@condEffect") ? _arg_2.@condEffect : _arg_3;
                if (_local5 == "Nothing") {
                    _local6.b = 0;
                }
            }
            this.effects.push(new Effect("Inflicts {condition} for {duration} ", {
                "condition": _local7,
                "duration": TooltipHelper.compareAndGetPlural(_local6.a, _local6.b, "second")
            }));
        }
    }

    private function GetIntArgument(_arg_1:XML, _arg_2:String, _arg_3:int = 0):int {
        return !!_arg_1.hasOwnProperty("@" + _arg_2) ? int(_arg_1[_arg_2]) : int(_arg_3);
    }

    private function GetFloatArgument(_arg_1:XML, _arg_2:String, _arg_3:Number = 0):Number {
        return !!_arg_1.hasOwnProperty("@" + _arg_2) ? Number(_arg_1[_arg_2]) : Number(_arg_3);
    }

    private function GetStringArgument(_arg_1:XML, _arg_2:String, _arg_3:String = ""):String {
        return !!_arg_1.hasOwnProperty("@" + _arg_2) ? _arg_1[_arg_2] : _arg_3;
    }

    private function colorWisBonus(_arg_1:Number):String {
        if (_arg_1) {
            return TooltipHelper.wrapInFontTag(" (+" + _arg_1 + ")", "#" + (4219875).toString(16))
        }

        return "";
    }

    private function colorUntiered(_arg_1:String):String {
        var _local2:Boolean = this.objectXML.hasOwnProperty("Tier");
        var _local3:Boolean = this.objectXML.hasOwnProperty("@setType");
        if (_local3) {
            return TooltipHelper.wrapInFontTag(_arg_1, "#" + 0xff9900.toString(16));
        }
        if (!_local2) {
            return TooltipHelper.wrapInFontTag(_arg_1, "#" + (9055202).toString(16))
        }

        return _arg_1;
    }

    private function getEffectTag(_arg_1:XML, _arg_2:String):XML {
        var _local3:* = null;
        var _local4:* = null;
        var _local5:* = _arg_1.Activate;
        var _local6:int = 0;
        var _local8:* = new XMLList("");
        _local3 = _arg_1.Activate.(text() == "GenericActivate");
        var _local10:int = 0;
        var _local9:* = _local3;
        for each(_local4 in _local3) {
            if (_local4.@effect == _arg_2) {
                return _local4;
            }
        }
        return null;
    }

    private function getStatTag(_arg_1:XML, _arg_2:String):XML {
        var _local3:* = null;
        var _local4:* = null;
        var _local5:* = _arg_1.Activate;
        var _local6:int = 0;
        var _local8:* = new XMLList("");
        _local3 = _arg_1.Activate.(text() == "StatBoostAura");
        var _local10:int = 0;
        var _local9:* = _local3;
        for each(_local4 in _local3) {
            if (_local4.@stat == _arg_2) {
                return _local4;
            }
        }
        return null;
    }

    private function addActivateOnEquipTagsToEffectsList():void {
        var _local1:* = null;
        var _local2:Boolean = true;
        var _local4:int = 0;
        var _local3:* = this.objectXML.ActivateOnEquip;
        for each(_local1 in this.objectXML.ActivateOnEquip) {
            if (_local2) {
                this.effects.push(new Effect("EquipmentToolTip.onEquip", ""));
                _local2 = false;
            }
            if (_local1.toString() == "IncrementStat") {
                this.effects.push(new Effect("EquipmentToolTip.incrementStat", this.getComparedStatText(_local1)).setReplacementsColor(this.getComparedStatColor(_local1)));
            }
        }
    }

    private function getComparedStatText(_arg_1:XML):Object {
        var _local2:int = _arg_1.@stat;
        var _local3:int = _arg_1.@amount;
        return {
            "statAmount": this.prefix(_local3) + " ",
            "statName": new LineBuilder().setParams(StatData.statToName(_local2))
        };
    }

    private function prefix(_arg_1:int):String {
        var _local2:String = _arg_1 > -1 ? "+" : "";
        return _local2 + _arg_1;
    }

    private function getComparedStatColor(param1:XML) : uint {
        var _local6:XML = null;
        var _local2:int = 0;
        var _local5:* = param1;
        var _local3:int = _local5.@stat;
        var _local4:int = _local5.@amount;
        var _local8:uint = !!this.playerCanUse?0xff00:0xffff8f;
        var _local7:* = null;
        if(this.curItemXML != null) {
            var _local9:* = this.curItemXML.ActivateOnEquip;
            var _local10:int = 0;
            var _local12:* = new XMLList("");
            _local7 = this.curItemXML.ActivateOnEquip.(@stat == _local3);
        }
        if(_local7 != null && _local7.length() == 1) {
            _local6 = XML(_local7[0]);
            _local2 = _local6.@amount;
            _local8 = TooltipHelper.getTextColor(_local4 - _local2);
        }
        if(_local4 < 0) {
            _local8 = 0xff0000;
        }
        return _local8;
    }

    private function getComparedStatColorOLD(param1:XML) : uint {
        var _local5:* = null;
        var _local2:int = 0;
        var _local6:* = null;
        var _local3:int = param1.@stat;
        var _local4:int = param1.@amount;
        var _local7:uint = !!this.playerCanUse?0xff00:0xffff8f;
        if(this.curItemXML != null) {
            var _local8:* = this.curItemXML.ActivateOnEquip;
            var _local9:int = 0;
            var _local11:* = new XMLList("");
            _local6 = this.curItemXML.ActivateOnEquip.(@stat == _local3);
        }
        if(_local6 != null && _local6.length() == 1) {
            _local5 = XML(_local6[0]);
            _local2 = _local5.@amount;
            _local7 = TooltipHelper.getTextColor(_local4 - _local2);
        }
        if(_local4 < 0) {
            _local7 = 0xff0000;
        }
        return _local7;
    }

    private function addEquipmentItemRestrictions():void {
        if (this.objectXML.hasOwnProperty("PetFood")) {
            this.restrictions.push(new Restriction("Used to feed your pet in the pet yard", 0xb3b3b3, false));
        } else if (this.objectXML.hasOwnProperty("Treasure") == false) {
            this.restrictions.push(new Restriction("EquipmentToolTip.equippedToUse", 0xb3b3b3, false));
            if (this.isInventoryFull || this.inventoryOwnerType == "CURRENT_PLAYER") {
                this.restrictions.push(new Restriction("EquipmentToolTip.doubleClickEquip", 0xb3b3b3, false));
            } else {
                this.restrictions.push(new Restriction("EquipmentToolTip.doubleClickTake", 0xb3b3b3, false));
            }
        }
    }

    private function addAbilityItemRestrictions():void {
        this.restrictions.push(new Restriction("EquipmentToolTip.keyCodeToUse", 0xffffff, false));
    }

    private function addConsumableItemRestrictions():void {
        this.restrictions.push(new Restriction("EquipmentToolTip.consumedWithUse", 0xb3b3b3, false));
        if (this.isInventoryFull || this.inventoryOwnerType == "CURRENT_PLAYER") {
            this.restrictions.push(new Restriction("EquipmentToolTip.doubleClickOrShiftClickToUse", 0xffffff, false));
        } else {
            this.restrictions.push(new Restriction("EquipmentToolTip.doubleClickTakeShiftClickUse", 0xffffff, false));
        }
    }

    private function addReusableItemRestrictions():void {
        this.restrictions.push(new Restriction("EquipmentToolTip.usedMultipleTimes", 0xb3b3b3, false));
        this.restrictions.push(new Restriction("EquipmentToolTip.doubleClickOrShiftClickToUse", 0xffffff, false));
    }

    private function makeRestrictionList():void {
        var _local3:Boolean = false;
        var _local4:int = 0;
        var _local5:int = 0;
        var _local2:* = null;
        this.restrictions = new Vector.<Restriction>();
        if (this.objectXML.hasOwnProperty("VaultItem") && this.invType != -1 && this.invType != ObjectLibrary.idToType_["Vault Chest"]) {
            this.restrictions.push(new Restriction("EquipmentToolTip.storeVaultItem", 16549442, true));
        }
        if (this.objectXML.hasOwnProperty("Soulbound")) {
            this.restrictions.push(new Restriction("Item.Soulbound", 0xb3b3b3, false));
        }
        if (this.playerCanUse) {
            if (this.objectXML.hasOwnProperty("Usable")) {
                this.addAbilityItemRestrictions();
                this.addEquipmentItemRestrictions();
            } else if (this.objectXML.hasOwnProperty("Consumable")) {
                if (this.objectXML.hasOwnProperty("Potion")) {
                    this.restrictions.push(new Restriction("Potion", 0xb3b3b3, false));
                }
                this.addConsumableItemRestrictions();
            } else if (this.objectXML.hasOwnProperty("InvUse")) {
                this.addReusableItemRestrictions();
            } else {
                this.addEquipmentItemRestrictions();
            }
        } else if (this.player != null) {
            this.restrictions.push(new Restriction("EquipmentToolTip.notUsableBy", 16549442, true));
        }
        var _local1:Vector.<String> = ObjectLibrary.usableBy(this.objectType);
        if (_local1 != null) {
            this.restrictions.push(new Restriction("EquipmentToolTip.usableBy", 0xb3b3b3, false));
        }
        var _local7:int = 0;
        var _local6:* = this.objectXML.EquipRequirement;
        for each(_local2 in this.objectXML.EquipRequirement) {
            _local3 = ObjectLibrary.playerMeetsRequirement(_local2, this.player);
            if (_local2.toString() == "Stat") {
                _local4 = _local2.@stat;
                _local5 = _local2.@value;
                this.restrictions.push(new Restriction("Requires " + StatData.statToName(_local4) + " of " + _local5, !!_local3 ? 0xb3b3b3 : 16549442, !_local3));
            }
        }
    }

    private function makeLineTwo():void {
        this.line2 = new LineBreakDesign(218, 0);
        addChild(this.line2);
    }

    private function makeLineThree():void {
        this.line3 = new LineBreakDesign(218, 0);
        addChild(this.line3);
    }

    private function makeRestrictionText():void {
        if (this.restrictions.length != 0) {
            this.restrictionsText = new TextFieldDisplayConcrete().setSize(14).setColor(0xb3b3b3).setTextWidth(226).setIndent(-10).setLeftMargin(10).setWordWrap(true).setHTML(true);
            this.restrictionsText.setStringBuilder(this.buildRestrictionsLineBuilder());
            this.restrictionsText.filters = FilterUtil.getStandardDropShadowFilter();
            waiter.push(this.restrictionsText.textChanged);
            addChild(this.restrictionsText);
        }
    }

    private function makeSetInfoText():void {
        if (this.setInfo.length != 0) {
            this.setInfoText = new TextFieldDisplayConcrete().setSize(14).setColor(0xb3b3b3).setTextWidth(226).setIndent(-10).setLeftMargin(10).setWordWrap(true).setHTML(true);
            this.setInfoText.setStringBuilder(this.getSetBonusStringBuilder());
            this.setInfoText.filters = FilterUtil.getStandardDropShadowFilter();
            waiter.push(this.setInfoText.textChanged);
            addChild(this.setInfoText);
            this.makeLineThree();
        }
    }

    private function getSetBonusStringBuilder():AppendingLineBuilder {
        var _local1:AppendingLineBuilder = new AppendingLineBuilder();
        this.appendEffects(this.setInfo, _local1);
        return _local1;
    }

    private function buildRestrictionsLineBuilder():StringBuilder {
        var _local2:* = null;
        var _local3:* = null;
        var _local4:* = null;
        var _local5:* = null;
        var _local1:AppendingLineBuilder = new AppendingLineBuilder();
        var _local7:int = 0;
        var _local6:* = this.restrictions;
        for each(_local2 in this.restrictions) {
            _local3 = !!_local2.bold_ ? "<b>" : "";
            _local3 = _local3 + ("<font color=\"#" + _local2.color_.toString(16) + "\">");
            _local4 = "</font>";
            _local4 = _local4.concat(!!_local2.bold_ ? "</b>" : "");
            _local5 = !!this.player ? ObjectLibrary.typeToDisplayId_[this.player.objectType_] : "";
            _local1.pushParams(_local2.text_, {
                "unUsableClass": _local5,
                "usableClasses": this.getUsableClasses(),
                "keyCode": KeyCodes.CharCodeStrings[Parameters.data.useSpecial]
            }, _local3, _local4);
        }
        return _local1;
    }

    private function getUsableClasses():StringBuilder {
        var _local3:* = null;
        var _local1:Vector.<String> = ObjectLibrary.usableBy(this.objectType);
        var _local2:AppendingLineBuilder = new AppendingLineBuilder();
        _local2.setDelimiter(", ");
        var _local5:int = 0;
        var _local4:* = _local1;
        for each(_local3 in _local1) {
            _local2.pushParams(_local3);
        }
        return _local2;
    }

    private function addDescriptionText():void {
        this.descText = new TextFieldDisplayConcrete().setSize(14).setColor(0xb3b3b3).setTextWidth(230).setWordWrap(true);
        if (this.descriptionOverride) {
            this.descText.setStringBuilder(new StaticStringBuilder(this.descriptionOverride));
        } else {
            this.descText.setStringBuilder(new LineBuilder().setParams(this.objectXML.Description));
        }
        this.descText.filters = FilterUtil.getStandardDropShadowFilter();
        waiter.push(this.descText.textChanged);
        addChild(this.descText);
    }

    private function buildCategorySpecificText():void {
        if (this.curItemXML != null) {
            this.comparisonResults = this.slotTypeToTextBuilder.getComparisonResults(this.objectXML, this.curItemXML);
        } else {
            this.comparisonResults = new SlotComparisonResult();
        }
    }

    private function handleWisMod() : void {
        var _local4:* = null;
        var _local3:* = null;
        var _local1:* = null;
        var _local5:String = null;
        if(this.player == null) {
            return;
        }
        var _local2:Number = this.player.wisdom;
        if(_local2 < 30) {
            return;
        }
        var _local6:Vector.<XML> = new Vector.<XML>();
        if(this.curItemXML != null) {
            this.curItemXML = this.curItemXML.copy();
            _local6.push(this.curItemXML);
        }
        if(this.objectXML != null) {
            this.objectXML = this.objectXML.copy();
            _local6.push(this.objectXML);
        }
        for each(_local3 in _local6) {
            for each(_local4 in _local3.Activate) {
                _local1 = _local4.toString();
                if(_local4.@effect != "Stasis") {
                    _local5 = _local4.@useWisMod;
                    if(!(_local5 == "" || _local5 == "false" || _local5 == "0" || _local4.@effect == "Stasis")) {
                        var _local7:* = _local1;
                        switch(_local7) {
                            case "HealNova":
                                _local4.@amount = this.modifyWisModStat(_local4.@amount,0);
                                _local4.@range = this.modifyWisModStat(_local4.@range);
                                _local4.@damage = this.modifyWisModStat(_local4.@damage,0);
                                continue;
                            case "ConditionEffectAura":
                                _local4.@duration = this.modifyWisModStat(_local4.@duration);
                                _local4.@range = this.modifyWisModStat(_local4.@range);
                                continue;
                            case "ConditionEffectSelf":
                                _local4.@duration = this.modifyWisModStat(_local4.@duration);
                                continue;
                            case "StatBoostAura":
                                _local4.@amount = this.modifyWisModStat(_local4.@amount,0);
                                _local4.@duration = this.modifyWisModStat(_local4.@duration);
                                _local4.@range = this.modifyWisModStat(_local4.@range);
                                continue;
                            case "GenericActivate":
                                _local4.@duration = this.modifyWisModStat(_local4.@duration);
                                _local4.@range = this.modifyWisModStat(_local4.@range);
                                continue;
                            default:
                                continue;
                        }
                    } else {
                        continue;
                    }
                } else {
                    continue;
                }
            }
        }
    }

    private function modifyWisModStat(param1:String, param2:Number = 1) : String {
        var _local5:Number = NaN;
        var _local7:int = 0;
        var _local6:Number = NaN;
        var _local3:* = "-1";
        var _local4:Number = this.player.wisdom;
        if(_local4 < 30) {
            _local3 = param1;
        } else {
            _local5 = parseInt(param1);
            _local7 = _local5 < 0?-1:1;
            _local6 = _local5 * _local4 / 150 + _local5 * _local7;
            _local6 = Math.floor(_local6 * Math.pow(10,param2)) / Math.pow(10,param2);
            if(_local6 - int(_local6) * _local7 >= 1 / Math.pow(10,param2) * _local7) {
                _local3 = _local6.toFixed(1);
            } else {
                _local3 = _local6.toFixed(0);
            }
        }
        return _local3;
    }
}
}

import kabam.rotmg.text.view.stringBuilder.AppendingLineBuilder;
import kabam.rotmg.text.view.stringBuilder.LineBuilder;

class ComPair {
    public var a:Number = 0;
    public var b:Number = 0;

    function ComPair(xml1:XML, xml2:XML, tag:String, defaultValue:Number = 0) {
        super();
        this.a = this.b = xml1.hasOwnProperty("@" + tag) ?
                xml1.attribute(tag) : defaultValue;
        if (xml2)
            this.b = xml2.hasOwnProperty("@" + tag) ?
                    xml2.attribute(tag) : defaultValue;
    }

    public function add(num:Number) : void {
        this.a += num;
        this.b += num;
    }
}

class ComPairTag {


    function ComPairTag(_arg_1:XML, _arg_2:XML, _arg_3:String, _arg_4:Number = 0) {
        super();
        var _local5:* = !!_arg_1.hasOwnProperty(_arg_3) ? _arg_1[_arg_3] : _arg_4;
        this.b = _local5;
        this.a = _local5;
        if (_arg_2) {
            this.b = !!_arg_2.hasOwnProperty(_arg_3) ? _arg_2[_arg_3] : _arg_4;
        }
    }
    public var a:Number;
    public var b:Number;

    public function add(_arg_1:Number):void {
        this.a = this.a + _arg_1;
        this.b = this.b + _arg_1;
    }
}

class ComPairTagBool {


    function ComPairTagBool(_arg_1:XML, _arg_2:XML, _arg_3:String, _arg_4:Boolean = false) {
        super();
        if (_arg_1)
            this.a = _arg_1.hasOwnProperty(_arg_3) ? true : _arg_4;
        if (_arg_2)
            this.b = _arg_2.hasOwnProperty(_arg_3) ? true : _arg_4;
    }
    public var a:Boolean;
    public var b:Boolean;
}

class Effect {


    function Effect(_arg_1:String, _arg_2:Object) {
        super();
        this.name_ = _arg_1;
        this.valueReplacements_ = _arg_2;
    }
    public var name_:String;
    public var valueReplacements_:Object;
    public var replacementColor_:uint = 16777103;
    public var color_:uint = 11776947;

    public function setColor(_arg_1:uint):Effect {
        this.color_ = _arg_1;
        return this;
    }

    public function setReplacementsColor(_arg_1:uint):Effect {
        this.replacementColor_ = _arg_1;
        return this;
    }

    public function getValueReplacementsWithColor():Object {
        var _local4:* = null;
        var _local5:* = null;
        var _local1:* = {};
        var _local2:* = "";
        var _local3:* = "";
        if (this.replacementColor_) {
            _local2 = "</font><font color=\"#" + this.replacementColor_.toString(16) + "\">";
            _local3 = "</font><font color=\"#" + this.color_.toString(16) + "\">";
        }
        var _local7:int = 0;
        var _local6:* = this.valueReplacements_;
        for (_local4 in this.valueReplacements_) {
            if (this.valueReplacements_[_local4] is AppendingLineBuilder) {
                _local1[_local4] = this.valueReplacements_[_local4];
            } else if (this.valueReplacements_[_local4] is LineBuilder) {
                _local5 = this.valueReplacements_[_local4] as LineBuilder;
                _local5.setPrefix(_local2).setPostfix(_local3);
                _local1[_local4] = _local5;
            } else {
                _local1[_local4] = _local2 + this.valueReplacements_[_local4] + _local3;
            }
        }
        return _local1;
    }
}

class Restriction {


    function Restriction(_arg_1:String, _arg_2:uint, _arg_3:Boolean) {
        super();
        this.text_ = _arg_1;
        this.color_ = _arg_2;
        this.bold_ = _arg_3;
    }
    public var text_:String;
    public var color_:uint;
    public var bold_:Boolean;
}
