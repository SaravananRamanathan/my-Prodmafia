package com.company.assembleegameclient.screens {
import com.company.assembleegameclient.util.FilterUtil;

import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;
import flash.geom.Rectangle;

import io.decagames.rotmg.ui.buttons.InfoButton;

import kabam.rotmg.core.signals.LeagueItemSignal;
import kabam.rotmg.text.view.TextFieldDisplayConcrete;
import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;
import kabam.rotmg.ui.view.ButtonFactory;
import kabam.rotmg.ui.view.components.MenuOptionsBar;
import kabam.rotmg.ui.view.components.ScreenBase;

import org.osflash.signals.Signal;

public class CharacterTypeSelectionScreen extends Sprite {


    private const DROP_SHADOW:DropShadowFilter = new DropShadowFilter(0, 0, 0, 1, 8, 8);

    public function CharacterTypeSelectionScreen() {
        leagueItemSignal = new LeagueItemSignal();
        super();
        this.init();
    }
    public var close:Signal;
    public var leagueItemSignal:LeagueItemSignal;
    private var nameText:TextFieldDisplayConcrete;
    private var backButton:TitleMenuOption;
    private var _leagueItems:Vector.<LeagueItem>;
    private var _leagueContainer:Sprite;
    private var _buttonFactory:ButtonFactory;

    private var _leagueDatas:Vector.<LeagueData>;

    public function set leagueDatas(_arg_1:Vector.<LeagueData>):void {
        this._leagueDatas = _arg_1;
        this.createLeagues();
        this.createInfoButton();
    }

    private var _infoButton:InfoButton;

    public function get infoButton():InfoButton {
        return this._infoButton;
    }

    public function setName(_arg_1:String):void {
        this.nameText.setStringBuilder(new StaticStringBuilder(_arg_1));
        this.nameText.x = (this.getReferenceRectangle().width - this.nameText.width) * 0.5;
    }

    internal function getReferenceRectangle():Rectangle {
        var _local1:Rectangle = new Rectangle();
        if (stage) {
            _local1 = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
        }
        return _local1;
    }

    private function init():void {
        this._buttonFactory = new ButtonFactory();
        addChild(new ScreenBase());
        addChild(new AccountScreen());
        this.createDisplayAssets();
    }

    private function createDisplayAssets():void {
        this.createNameText();
        this.makeMenuOptionsBar();
        this._leagueContainer = new Sprite();
        addChild(this._leagueContainer);
    }

    private function makeMenuOptionsBar():void {
        this.backButton = this._buttonFactory.getBackButton();
        this.close = this.backButton.clicked;
        var _local1:MenuOptionsBar = new MenuOptionsBar();
        _local1.addButton(this.backButton, "CENTER");
        addChild(_local1);
    }

    private function createNameText():void {
        this.nameText = new TextFieldDisplayConcrete().setSize(22).setColor(0xb3b3b3);
        this.nameText.setBold(true).setAutoSize("center");
        this.nameText.filters = [this.DROP_SHADOW];
        this.nameText.y = 24;
        this.nameText.x = (this.getReferenceRectangle().width - this.nameText.width) / 2;
        addChild(this.nameText);
    }

    private function createInfoButton():void {
        this._infoButton = new InfoButton(10);
        this._infoButton.x = this._leagueContainer.width - this._infoButton.width - 18;
        this._infoButton.y = this._infoButton.height + 16;
        this._leagueContainer.addChild(this._infoButton);
    }

    private function createLeagues():void {
        var _local1:* = null;
        var _local2:int = 0;
        if (!this._leagueItems) {
            this._leagueItems = new Vector.<LeagueItem>(0);
        } else {
            this._leagueItems.length = 0;
        }
        var _local3:int = this._leagueDatas.length;
        while (_local2 < _local3) {
            _local1 = new LeagueItem(this._leagueDatas[_local2]);
            _local1.x = _local2 * (_local1.width + 20);
            _local1.buttonMode = true;
            _local1.addEventListener("click", this.onLeagueItemClick);
            _local1.addEventListener("rollOver", this.onOver);
            _local1.addEventListener("rollOut", this.onOut);
            this._leagueItems.push(_local1);
            this._leagueContainer.addChild(_local1);
            _local2++;
        }
        this._leagueContainer.x = (this.width - this._leagueContainer.width) / 2;
        this._leagueContainer.y = (this.height - this._leagueContainer.height) / 2;
    }

    private function removeLeagueItemListeners():void {
        var _local2:int = 0;
        var _local1:int = this._leagueItems.length;
        while (_local2 < _local1) {
            this._leagueItems[_local2].removeEventListener("click", this.onLeagueItemClick);
            this._leagueItems[_local2].removeEventListener("rollOut", this.onOut);
            this._leagueItems[_local2].removeEventListener("rollOver", this.onOver);
            _local2++;
        }
    }

    private function onOut(_arg_1:MouseEvent):void {
        var _local2:* = null;
        _local2 = _arg_1.currentTarget as LeagueItem;
        if (_local2) {
            _local2.filters = [];
            _local2.characterDance(false);
        } else {
            _arg_1.currentTarget.filters = [];
        }
    }

    private function onOver(_arg_1:MouseEvent):void {
        var _local2:LeagueItem = _arg_1.currentTarget as LeagueItem;
        if (_local2) {
            _local2.characterDance(true);
        } else {
            _arg_1.currentTarget.filters = FilterUtil.getLargeGlowFilter();
        }
    }

    private function onLeagueItemClick(_arg_1:MouseEvent):void {
        this.removeLeagueItemListeners();
        this.leagueItemSignal.dispatch((_arg_1.currentTarget as LeagueItem).leagueType);
    }
}
}
