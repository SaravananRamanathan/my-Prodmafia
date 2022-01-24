package com.company.assembleegameclient.screens.charrects {
import com.company.assembleegameclient.appengine.CharacterStats;
import com.company.assembleegameclient.appengine.SavedCharacter;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.screens.events.DeleteCharacterEvent;
import com.company.assembleegameclient.ui.tooltip.MyPlayerToolTip;
import com.company.assembleegameclient.ui.tooltip.TextToolTip;
import com.company.assembleegameclient.util.FameUtil;
import com.company.rotmg.graphics.DeleteXGraphic;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;

import io.decagames.rotmg.fame.FameContentPopup;
import io.decagames.rotmg.pets.data.vo.PetVO;
import io.decagames.rotmg.ui.popups.signals.ShowPopupSignal;

import kabam.rotmg.assets.services.IconFactory;
import kabam.rotmg.classes.model.CharacterClass;
import kabam.rotmg.core.StaticInjectorContext;
import kabam.rotmg.text.view.TextFieldDisplayConcrete;
import kabam.rotmg.text.view.stringBuilder.LineBuilder;
import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;

import org.osflash.signals.Signal;
import org.swiftsuspenders.Injector;

public class CurrentCharacterRect extends CharacterRect {

    public const selected:Signal = new Signal();
    public const deleteCharacter:Signal = new Signal();
    public const showToolTip:Signal = new Signal(Sprite);
    public const hideTooltip:Signal = new Signal();
    private static var toolTip_:MyPlayerToolTip = null;
    private static var fameToolTip:TextToolTip = null;

    public function CurrentCharacterRect(_arg_1:String, _arg_2:CharacterClass, _arg_3:SavedCharacter, _arg_4:CharacterStats) {
        myPlayerToolTipFactory = new MyPlayerToolTipFactory();
        super();
        this.charName = _arg_1;
        this.charType = _arg_2;
        this.char_ = _arg_3;
        this.charStats = _arg_4;
        var _local8:String = _arg_2.name;
        var _local5:int = _arg_3.charXML_.Level;
        var _local7:int = _arg_3.charXML_.IsChallenger;
        var _local6:Number = _local7 == 1 ? 0xee00ff : 16777215;

        super.className = new LineBuilder().setParams("CurrentCharacter.description", {
            "className": _local8,
            "level": _local5
        });
        this.setCharCon(_local8.toLowerCase(), this.char_.charId());

        super.color = 0x5c5c5c;

        super.overColor = 0x7f7f7f;
        super.init();
        super.classNameText.setColor(_local6);
        this.setSeasonalOverlay(_local7 == 1);
        this.makeTagline();
        this.makeDeleteButton();
        this.makePetIcon();
        this.makeStatsMaxedText();
        this.makeFameUIIcon();
        this.addEventListeners();
    }
    public var charName:String;
    public var charStats:CharacterStats;
    public var char_:SavedCharacter;
    public var myPlayerToolTipFactory:MyPlayerToolTipFactory;
    protected var statsMaxedText:TextFieldDisplayConcrete;
    private var charType:CharacterClass;
    private var deleteButton:Sprite;
    private var icon:DisplayObject;
    private var petIcon:Bitmap;
    private var fameBitmap:Bitmap;
    private var fameBitmapContainer:Sprite;

    public function addEventListeners():void {
        addEventListener("removedFromStage", this.onRemovedFromStage);
        selectContainer.addEventListener("click", this.onSelect);
        this.fameBitmapContainer.addEventListener("click", this.onFameClick);
        this.deleteButton.addEventListener("click", this.onDelete);
    }

    public function setIcon(_arg_1:DisplayObject):void {
        this.icon && selectContainer.removeChild(this.icon);
        this.icon = _arg_1;
        this.icon.x = 8;
        this.icon.y = 4;
        addChild(this.icon);
    }

    private function setCharCon(_arg_1:String, _arg_2:int):void {
        var _local3:int = 0;
        _local3 = 0;
        while (_local3 < Parameters.charNames.length) {
            if (Parameters.charNames[_local3] == _arg_1) {
                if (Parameters.charIds[_local3] < _arg_2) {
                    _arg_1 = _arg_1 + "2";
                    Parameters.charNames.push(_arg_1);
                    Parameters.charIds.push(_arg_2);
                } else {
                    _arg_1 = _arg_1 + "2";
                    Parameters.charNames.push(_arg_1);
                    Parameters.charIds.push(Parameters.charIds[_local3]);
                    Parameters.charIds[_local3] = _arg_2;
                }
                return;
            }
            _local3++;
        }
        Parameters.charNames.push(_arg_1);
        Parameters.charIds.push(_arg_2);
    }

    private function makePetIcon():void {
        var _local1:PetVO = this.char_.getPetVO();
        if (_local1) {
            this.petIcon = _local1.getSkinBitmap();
            if (this.petIcon == null) {
                return;
            }
            this.petIcon.x = 275;
            this.petIcon.y = 1;
            selectContainer.addChild(this.petIcon);
        }
    }

    private function makeTagline():void {
        var _local1:int = this.getNextStarFame();
        if (_local1 > 0) {
            super.makeTaglineIcon();
            super.makeTaglineText(new LineBuilder().setParams("CurrentCharacter.tagline", {
                "fame": this.char_.fame(),
                "nextStarFame": _local1
            }));
            taglineText.x = taglineText.x + taglineIcon.width;
        } else {
            super.makeTaglineIcon();
            super.makeTaglineText(new LineBuilder().setParams("CurrentCharacter.tagline_noquest", {"fame": this.char_.fame()}));
            taglineText.x = taglineText.x + taglineIcon.width;
        }
    }

    private function getNextStarFame():int {
        return FameUtil.nextStarFame(this.charStats == null ? 0 : this.charStats.bestFame(), this.char_.fame());
    }

    private function makeDeleteButton():void {
        this.deleteButton = new DeleteXGraphic();
        this.deleteButton.addEventListener("mouseDown", this.onDeleteDown);
        this.deleteButton.x = 389;
        this.deleteButton.y = 19;
        addChild(this.deleteButton);
    }

    private function makeStatsMaxedText():void {
        var _local1:int = this.getMaxedStats();
        var _local2:int = 0xb3b3b3;
        if (_local1 >= 8) {
            _local2 = 16572160;
        }
        this.statsMaxedText = new TextFieldDisplayConcrete().setSize(18).setColor(0xffffff);
        this.statsMaxedText.setBold(true);
        this.statsMaxedText.setColor(_local2);
        this.statsMaxedText.setStringBuilder(new StaticStringBuilder(_local1 + "/8"));
        this.statsMaxedText.filters = makeDropShadowFilter();
        this.statsMaxedText.x = 353;
        this.statsMaxedText.y = 19;
        selectContainer.addChild(this.statsMaxedText);
    }

    private function makeFameUIIcon():void {
        var _local1:BitmapData = IconFactory.makeFame();
        this.fameBitmap = new Bitmap(_local1);
        this.fameBitmapContainer = new Sprite();
        this.fameBitmapContainer.name = "fame_ui";
        this.fameBitmapContainer.addChild(this.fameBitmap);
        this.fameBitmapContainer.x = 328;
        this.fameBitmapContainer.y = 19;
        addChild(this.fameBitmapContainer);
    }

    private function getMaxedStats():int {
        var _local1:int = 0;
        if (this.char_.hp() == this.charType.hp.max) {
            _local1++;
        }
        if (this.char_.mp() == this.charType.mp.max) {
            _local1++;
        }
        if (this.char_.att() == this.charType.attack.max) {
            _local1++;
        }
        if (this.char_.def() == this.charType.defense.max) {
            _local1++;
        }
        if (this.char_.spd() == this.charType.speed.max) {
            _local1++;
        }
        if (this.char_.dex() == this.charType.dexterity.max) {
            _local1++;
        }
        if (this.char_.vit() == this.charType.hpRegeneration.max) {
            _local1++;
        }
        if (this.char_.wis() == this.charType.mpRegeneration.max) {
            _local1++;
        }
        return _local1;
    }

    private function removeToolTip():void {
        this.hideTooltip.dispatch();
    }

    override protected function onMouseOver(_arg_1:MouseEvent):void {
        super.onMouseOver(_arg_1);
        this.removeToolTip();
        if (_arg_1.target.name == "fame_ui") {
            fameToolTip = new TextToolTip(0x363636, 0x9b9b9b, "Fame", "Click to get an Overview!", 225);
            this.showToolTip.dispatch(fameToolTip);
        } else {
            toolTip_ = this.myPlayerToolTipFactory.create(this.char_.charXML_.Account.Name,this.char_.charXML_,this.charStats);
            toolTip_.createUI();
            this.showToolTip.dispatch(toolTip_);
        }
    }

    override protected function onRollOut(_arg_1:MouseEvent):void {
        super.onRollOut(_arg_1);
        this.removeToolTip();
    }

    private function onSelect(_arg_1:MouseEvent):void {
        this.selected.dispatch(this.char_);
    }

    private function onFameClick(_arg_1:MouseEvent):void {
        var _local2:Injector = StaticInjectorContext.getInjector();
        var _local3:ShowPopupSignal = _local2.getInstance(ShowPopupSignal);
        _local3.dispatch(new FameContentPopup(this.char_.charId()));
    }

    private function onDelete(_arg_1:MouseEvent):void {
        this.deleteCharacter.dispatch(this.char_);
    }

    private function onRemovedFromStage(_arg_1:Event):void {
        this.removeToolTip();
        selectContainer.removeEventListener("click", this.onSelect);
        this.fameBitmapContainer.removeEventListener("click", this.onFameClick);
        this.deleteButton.removeEventListener("click", this.onDelete);
    }

    private function onDeleteDown(_arg_1:MouseEvent):void {
        _arg_1.stopImmediatePropagation();
        dispatchEvent(new DeleteCharacterEvent(this.char_));
    }
}
}
