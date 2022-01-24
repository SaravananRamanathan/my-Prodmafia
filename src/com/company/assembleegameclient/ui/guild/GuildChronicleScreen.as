package com.company.assembleegameclient.ui.guild {
import com.company.assembleegameclient.game.AGameSprite;
import com.company.assembleegameclient.game.events.GuildResultEvent;
import com.company.assembleegameclient.objects.Player;
import com.company.assembleegameclient.screens.TitleMenuOption;
import com.company.assembleegameclient.ui.dialogs.Dialog;
import com.company.rotmg.graphics.ScreenGraphic;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;

public class GuildChronicleScreen extends Sprite {


    public function GuildChronicleScreen(_arg_1:AGameSprite) {
        super();
        this.gs_ = _arg_1;
        graphics.clear();
        graphics.beginFill(0x2b2b2b, 0.8);
        graphics.drawRect(0, 0, 800, 10 * 60);
        graphics.endFill();
        var _local2:* = new Sprite();
        this.container = _local2;
        addChild(_local2);
        this.addList();
        addChild(new ScreenGraphic());
        this.continueButton_ = new TitleMenuOption("Options.continueButton", 36, false);
        this.continueButton_.setAutoSize("center");
        this.continueButton_.setVerticalAlign("middle");
        this.continueButton_.addEventListener("click", this.onContinueClick, false, 0, true);
        addChild(this.continueButton_);
        addEventListener("addedToStage", this.onAddedToStage, false, 0, true);
        addEventListener("removedFromStage", this.onRemovedFromStage, false, 0, true);
    }
    private var gs_:AGameSprite;
    private var container:Sprite;
    private var guildPlayerList_:GuildPlayerList;
    private var continueButton_:TitleMenuOption;

    private function addList():void {
        if (this.guildPlayerList_ && this.guildPlayerList_.parent) {
            this.container.removeChild(this.guildPlayerList_);
        }
        var _local1:Player = this.gs_.map.player_;
        this.guildPlayerList_ = new GuildPlayerList(500, 0, _local1 == null ? "" : _local1.name_, _local1.guildRank_);
        this.guildPlayerList_.addEventListener("SET_RANK", this.onSetRank, false, 0, true);
        this.guildPlayerList_.addEventListener("REMOVE_MEMBER", this.onRemoveMember, false, 0, true);
        this.container.addChild(this.guildPlayerList_);
    }

    private function removeList():void {
        this.guildPlayerList_.removeEventListener("SET_RANK", this.onSetRank);
        this.guildPlayerList_.removeEventListener("REMOVE_MEMBER", this.onRemoveMember);
        this.container.removeChild(this.guildPlayerList_);
        this.guildPlayerList_ = null;
    }

    private function showError(_arg_1:String):void {
        var _local2:Dialog = new Dialog("GuildChronicle.left", _arg_1, "GuildChronicle.right", null, "/guildError");
        _local2.addEventListener("dialogLeftButton", this.onErrorTextDone, false, 0, true);
        stage.addChild(_local2);
    }

    private function close():void {
        stage.focus = null;
        parent.removeChild(this);
    }

    private function onSetRank(_arg_1:GuildPlayerListEvent):void {
        this.removeList();
        this.gs_.addEventListener("GUILDRESULTEVENT", this.onSetRankResult, false, 0, true);
        this.gs_.gsc_.changeGuildRank(_arg_1.name_, _arg_1.rank_);
    }

    private function onSetRankResult(_arg_1:GuildResultEvent):void {
        this.gs_.removeEventListener("GUILDRESULTEVENT", this.onSetRankResult);
        if (!_arg_1.success_) {
            this.showError(_arg_1.errorKey);
        } else {
            this.addList();
        }
    }

    private function onRemoveMember(_arg_1:GuildPlayerListEvent):void {
        this.removeList();
        this.gs_.addEventListener("GUILDRESULTEVENT", this.onRemoveResult, false, 0, true);
        this.gs_.gsc_.guildRemove(_arg_1.name_);
    }

    private function onRemoveResult(_arg_1:GuildResultEvent):void {
        this.gs_.removeEventListener("GUILDRESULTEVENT", this.onRemoveResult);
        if (!_arg_1.success_) {
            this.showError(_arg_1.errorKey);
        } else {
            this.addList();
        }
    }

    private function onErrorTextDone(_arg_1:Event):void {
        var _local2:Dialog = _arg_1.currentTarget as Dialog;
        stage.removeChild(_local2);
        this.addList();
    }

    private function onContinueClick(_arg_1:MouseEvent):void {
        this.close();
    }

    private function onAddedToStage(_arg_1:Event):void {
        this.continueButton_.x = 400 - this.continueButton_.width;
        this.continueButton_.y = 550;
        stage.addEventListener("keyDown", this.onKeyDown, false, 1);
        stage.addEventListener("keyUp", this.onKeyUp, false, 1);
    }

    private function onRemovedFromStage(_arg_1:Event):void {
        stage.removeEventListener("keyDown", this.onKeyDown, false);
        stage.removeEventListener("keyUp", this.onKeyUp, false);
    }

    private function onKeyDown(_arg_1:KeyboardEvent):void {
        _arg_1.stopImmediatePropagation();
    }

    private function onKeyUp(_arg_1:KeyboardEvent):void {
        _arg_1.stopImmediatePropagation();
    }
}
}
