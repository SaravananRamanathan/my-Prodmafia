package com.company.assembleegameclient.screens {
import com.company.assembleegameclient.ui.GuildText;
import com.company.assembleegameclient.ui.RankText;
import com.company.assembleegameclient.ui.tooltip.RankToolTip;

import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.MouseEvent;

import kabam.rotmg.account.core.view.AccountInfoView;

import org.osflash.signals.Signal;

public class AccountScreen extends Sprite {


    public function AccountScreen() {
        super();
        this.tooltip = new Signal();
        this.makeLayers();
    }
    public var tooltip:Signal;
    private var rankLayer:Sprite;
    private var guildLayer:Sprite;
    private var accountInfoLayer:Sprite;
    private var guildName:String;
    private var guildRank:int;
    private var stars:int;
    private var starBg:int;
    private var rankText:RankText;
    private var guildText:GuildText;
    private var accountInfo:AccountInfoView;

    public function setGuild(_arg_1:String, _arg_2:int):void {
        this.guildName = _arg_1;
        this.guildRank = _arg_2;
        this.makeGuildText();
    }

    public function setRank(_arg_1:int, _arg_2:int = 0):void {
        this.stars = _arg_1;
        this.starBg = _arg_2;
        this.makeRankText();
    }

    public function setAccountInfo(_arg_1:AccountInfoView):void {
        this.accountInfo = _arg_1;
        var _local2:DisplayObject = _arg_1 as DisplayObject;
        _local2.x = stage.stageWidth - 10;
        _local2.y = 2;
        while (this.accountInfoLayer.numChildren > 0) {
            this.accountInfoLayer.removeChildAt(0);
        }
        this.accountInfoLayer.addChild(_local2);
    }

    private function makeLayers():void {
        var _local1:* = new Sprite();
        this.rankLayer = _local1;
        addChild(_local1);
        _local1 = new Sprite();
        this.guildLayer = _local1;
        addChild(_local1);
        _local1 = new Sprite();
        this.accountInfoLayer = _local1;
        addChild(_local1);
    }

    private function makeGuildText():void {
        this.guildText = new GuildText(this.guildName, this.guildRank);
        this.guildText.x = 92;
        this.guildText.y = 6;
        while (this.guildLayer.numChildren > 0) {
            this.guildLayer.removeChildAt(0);
        }
        this.guildLayer.addChild(this.guildText);
    }

    private function makeRankText():void {
        this.rankText = new RankText(this.stars, true, false, this.starBg);
        this.rankText.x = 36;
        this.rankText.y = 4;
        this.rankText.mouseEnabled = true;
        this.rankText.addEventListener("mouseOver", this.onMouseOver);
        this.rankText.addEventListener("rollOut", this.onRollOut);
        while (this.rankLayer.numChildren > 0) {
            this.rankLayer.removeChildAt(0);
        }
        this.rankLayer.addChild(this.rankText);
    }

    protected function onMouseOver(_arg_1:MouseEvent):void {
        this.tooltip.dispatch(new RankToolTip(this.stars));
    }

    protected function onRollOut(_arg_1:MouseEvent):void {
        this.tooltip.dispatch(null);
    }
}
}
