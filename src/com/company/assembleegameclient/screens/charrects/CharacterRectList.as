package com.company.assembleegameclient.screens.charrects {
import com.company.assembleegameclient.appengine.SavedCharacter;
import com.company.assembleegameclient.parameters.Parameters;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.Event;

import io.decagames.rotmg.seasonalEvent.data.SeasonalEventModel;
import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
import io.decagames.rotmg.ui.labels.UILabel;

import kabam.rotmg.assets.services.CharacterFactory;
import kabam.rotmg.classes.model.CharacterClass;
import kabam.rotmg.classes.model.CharacterSkin;
import kabam.rotmg.classes.model.ClassesModel;
import kabam.rotmg.core.StaticInjectorContext;
import kabam.rotmg.core.model.PlayerModel;

import org.osflash.signals.Signal;
import org.swiftsuspenders.Injector;

public class CharacterRectList extends Sprite {


    public function CharacterRectList() {
        super();
        this.init();
    }
    public var newCharacter:Signal;
    public var buyCharacterSlot:Signal;
    private var classes:ClassesModel;
    private var model:PlayerModel;
    private var seasonalEventModel:SeasonalEventModel;
    private var assetFactory:CharacterFactory;
    private var yOffset:int;
    private var accountName:String;
    private var numberOfSavedCharacters:int;
    private var numberOfAvailableCharSlots:int;
    private var charactersAvailable:UILabel;
    private var isSeasonalEvent:Boolean;

    private function init():void {
        var _local1:* = null;
        this.createInjections();
        this.createSignals();
        this.accountName = this.model.getName();
        this.yOffset = 4;
        this.createSavedCharacters();
        this.createAvailableCharSlots();
        if (this.canBuyCharSlot()) {
            this.createBuyRect();
        }
        if (this.isSeasonalEvent) {
            this.charactersAvailable = new UILabel();
            DefaultLabelFormat.createLabelFormat(this.charactersAvailable, 18, 0xffff00, "center", true);
            this.charactersAvailable.width = this.width;
            this.charactersAvailable.multiline = true;
            this.charactersAvailable.wordWrap = true;
            if (!this.canBuyCharSlot() && this.numberOfAvailableCharSlots == 0 && this.numberOfSavedCharacters == 0) {
                _local1 = "You have no more Characters left to play\n ...maybe one day you can buy some :-)";
            } else {
                _local1 = "You can create " + this.seasonalEventModel.remainingCharacters + " more characters";
            }
            this.charactersAvailable.text = _local1;
            this.charactersAvailable.y = this.yOffset + 2 * 60;
            addChild(this.charactersAvailable);
        }
    }

    private function canBuyCharSlot():Boolean {
        var _local1:* = false;
        if (this.seasonalEventModel.isChallenger == 1) {
            _local1 = this.seasonalEventModel.remainingCharacters - this.numberOfAvailableCharSlots > 0;
        } else {
            _local1 = true;
        }
        return _local1;
    }

    private function createAvailableCharSlots():void {
        var _local2:int = 0;
        var _local1:* = null;
        var _local3:Boolean = this.seasonalEventModel.isChallenger;
        if (this.model.hasAvailableCharSlot()) {
            this.numberOfAvailableCharSlots = this.model.getAvailableCharSlots();
            _local2 = 0;
            while (_local2 < this.numberOfAvailableCharSlots) {
                _local1 = new CreateNewCharacterRect(this.model);
                if (_local3) {
                    _local1.setSeasonalOverlay(true);
                }
                _local1.addEventListener("mouseDown", this.onNewChar);
                _local1.y = this.yOffset;
                addChild(_local1);
                this.yOffset = this.yOffset + 63;
                _local2++;
            }
        }
    }

    private function createSavedCharacters():void {
        var _local2:* = null;
        var _local1:* = null;
        var _local4:* = null;
        var _local3:CurrentCharacterRect = null;
        var _local5:Vector.<SavedCharacter> = this.model.getSavedCharacters();
        this.numberOfSavedCharacters = _local5.length;
        var _local7:int = 0;
        var _local6:* = _local5;
        for each(_local2 in _local5) {
            _local1 = this.classes.getCharacterClass(_local2.objectType());
            _local4 = this.model.getCharStats()[_local2.objectType()];
            _local3 = new CurrentCharacterRect(this.accountName, _local1, _local2, _local4);
            if (Parameters.skinTypes16.indexOf(_local2.skinType()) != -1) {
                _local3.setIcon(this.getIcon(_local2, 50));
            } else {
                _local3.setIcon(this.getIcon(_local2, 100));
            }
            _local3.y = this.yOffset;
            addChild(_local3);
            this.yOffset = this.yOffset + 63;
        }
    }

    private function createSignals():void {
        this.newCharacter = new Signal();
        this.buyCharacterSlot = new Signal();
    }

    private function createInjections():void {
        var _local1:Injector = StaticInjectorContext.getInjector();
        this.classes = _local1.getInstance(ClassesModel);
        this.model = _local1.getInstance(PlayerModel);
        this.assetFactory = _local1.getInstance(CharacterFactory);
        this.seasonalEventModel = _local1.getInstance(SeasonalEventModel);
        this.isSeasonalEvent = this.seasonalEventModel.isChallenger;
    }

    private function createBuyRect():void {
        var _local1:BuyCharacterRect = new BuyCharacterRect(this.model);
        _local1.addEventListener("mouseDown", this.onBuyCharSlot);
        _local1.y = this.yOffset;
        addChild(_local1);
    }

    private function getIcon(_arg_1:SavedCharacter, _arg_2:int = 100):DisplayObject {
        var _local5:CharacterClass = this.classes.getCharacterClass(_arg_1.objectType());
        var _local4:CharacterSkin = _local5.skins.getSkin(_arg_1.skinType()) || _local5.skins.getDefaultSkin();
        var _local3:BitmapData = this.assetFactory.makeIcon(_local4.template, _arg_2, _arg_1.tex1(), _arg_1.tex2());
        return new Bitmap(_local3);
    }

    private function onNewChar(_arg_1:Event):void {
        this.newCharacter.dispatch();
    }

    private function onBuyCharSlot(_arg_1:Event):void {
        this.buyCharacterSlot.dispatch(this.model.getNextCharSlotPrice());
    }
}
}
