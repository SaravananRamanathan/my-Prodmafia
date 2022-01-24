package com.company.assembleegameclient.screens {
import com.company.assembleegameclient.objects.ObjectLibrary;
import com.company.rotmg.graphics.ScreenGraphic;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;

import kabam.rotmg.core.model.PlayerModel;
import kabam.rotmg.game.view.CreditDisplay;
import kabam.rotmg.ui.view.components.ScreenBase;

import org.osflash.signals.Signal;

public class NewCharacterScreen extends Sprite {


    public function NewCharacterScreen() {
        boxes_ = {};
        super();
        this.tooltip = new Signal(Sprite);
        this.selected = new Signal(int);
        this.close = new Signal();
        addChild(new ScreenBase());
        addChild(new AccountScreen());
        addChild(new ScreenGraphic());
    }
    public var tooltip:Signal;
    public var close:Signal;
    public var selected:Signal;
    private var backButton_:TitleMenuOption;
    private var creditDisplay_:CreditDisplay;
    private var boxes_:Object;
    private var isInitialized:Boolean = false;

    public function initialize(param1:PlayerModel) : void {
        var _local4:int = 0;
        var _local2:XML = null;
        var _local7:int = 0;
        var _local5:String = null;
        var _local6:Boolean = false;
        var _local3:CharacterBox = null;
        if(this.isInitialized) {
            return;
        }
        this.isInitialized = true;
        this.backButton_ = new TitleMenuOption("Screens.back",36,false);
        this.backButton_.addEventListener("click",this.onBackClick);
        this.backButton_.setVerticalAlign("middle");
        addChild(this.backButton_);
        this.creditDisplay_ = new CreditDisplay();
        this.creditDisplay_.draw(param1.getCredits(),param1.getFame());
        addChild(this.creditDisplay_);
        _local4 = 0;
        while(_local4 < ObjectLibrary.playerChars_.length) {
            _local2 = ObjectLibrary.playerChars_[_local4];
            _local7 = _local2.@type;
            _local5 = _local2.@id;
            if(!param1.isClassAvailability(_local5,"unavailable")) {
                if(_local5 != "Bard") {
                    _local6 = param1.isClassAvailability(_local5,"unrestricted");
                    _local3 = new CharacterBox(_local2,param1.getCharStats()[_local7],param1,_local6);
                    _local3.x = 50 + 140 * (int(_local4 % 5)) + 70 - _local3.width / 2;
                    _local3.y = 88 + 140 * (int(_local4 / 5));
                    this.boxes_[_local7] = _local3;
                    _local3.addEventListener("rollOver",this.onCharBoxOver);
                    _local3.addEventListener("rollOut",this.onCharBoxOut);
                    _local3.characterSelectClicked_.add(this.onCharBoxClick);
                    addChild(_local3);
                }
            }
            _local4++;
        }
        this.backButton_.x = stage.stageWidth / 2 - this.backButton_.width / 2;
        this.backButton_.y = 550;
        this.creditDisplay_.x = stage.stageWidth;
        this.creditDisplay_.y = 20;
    }

    public function updateCreditsAndFame(_arg_1:int, _arg_2:int):void {
        this.creditDisplay_.draw(_arg_1, _arg_2);
    }

    public function update(_arg_1:PlayerModel):void {
        var _local6:* = null;
        var _local3:int = 0;
        var _local7:* = null;
        var _local5:Boolean = false;
        var _local4:* = null;
        var _local2:int = 0;
        while (_local2 < ObjectLibrary.playerChars_.length) {
            _local6 = ObjectLibrary.playerChars_[_local2];
            _local3 = _local6.@type;
            _local7 = String(_local6.@id);
            if (!_arg_1.isClassAvailability(_local7, "unavailable")) {
                _local5 = _arg_1.isClassAvailability(_local7, "unrestricted");
                _local4 = this.boxes_[_local3];
                if (_local4) {
                    if (_local5 || _arg_1.isLevelRequirementsMet(_local3)) {
                        _local4.unlock();
                    }
                }
            }
            _local2++;
        }
    }

    private function onBackClick(_arg_1:Event):void {
        this.close.dispatch();
    }

    private function onCharBoxOver(_arg_1:MouseEvent):void {
        var _local2:CharacterBox = _arg_1.currentTarget as CharacterBox;
        _local2.setOver(true);
        this.tooltip.dispatch(_local2.getTooltip());
    }

    private function onCharBoxOut(_arg_1:MouseEvent):void {
        var _local2:CharacterBox = _arg_1.currentTarget as CharacterBox;
        _local2.setOver(false);
        this.tooltip.dispatch(null);
    }

    private function onCharBoxClick(_arg_1:MouseEvent):void {
        this.tooltip.dispatch(null);
        var _local2:CharacterBox = _arg_1.currentTarget.parent as CharacterBox;
        if (!_local2.available_) {
            return;
        }
        var _local4:int = _local2.objectType();
        var _local3:String = ObjectLibrary.typeToDisplayId_[_local4];
        this.selected.dispatch(_local4);
    }
}
}
