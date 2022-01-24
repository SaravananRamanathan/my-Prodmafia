package com.company.assembleegameclient.ui.panels.mediators {
import com.company.assembleegameclient.account.ui.CreateGuildFrame;
import com.company.assembleegameclient.game.GameSprite;
import com.company.assembleegameclient.objects.Player;
import com.company.assembleegameclient.ui.dialogs.Dialog;
import com.company.assembleegameclient.ui.panels.GuildRegisterPanel;

import flash.events.Event;

import kabam.rotmg.dialogs.control.CloseDialogsSignal;
import kabam.rotmg.dialogs.control.OpenDialogSignal;
import kabam.rotmg.ui.model.HUDModel;

import robotlegs.bender.bundles.mvcs.Mediator;

public class GuildRegisterPanelMediator extends Mediator {


    public function GuildRegisterPanelMediator() {
        super();
    }
    [Inject]
    public var view:GuildRegisterPanel;
    [Inject]
    public var openDialog:OpenDialogSignal;
    [Inject]
    public var closeDialog:CloseDialogsSignal;
    [Inject]
    public var hudModel:HUDModel;

    override public function initialize():void {
        this.view.openCreateGuildFrame.add(this.onDispatchCreateGuildFrame);
        this.view.renounce.add(this.onRenounceClick);
    }

    override public function destroy():void {
        this.view.openCreateGuildFrame.remove(this.onDispatchCreateGuildFrame);
        this.view.renounce.remove(this.onRenounceClick);
    }

    public function onRenounceClick():void {
        var _local3:GameSprite = this.hudModel.gameSprite;
        if (_local3.map == null || _local3.map.player_ == null) {
            return;
        }
        var _local2:Player = _local3.map.player_;
        var _local1:Dialog = new Dialog("RenounceDialog.subTitle", "RenounceDialog.title", "RenounceDialog.cancel", "RenounceDialog.accept", "/renounceGuild");
        _local1.setTextParams("RenounceDialog.title", {"guildName": _local2.guildName_});
        _local1.addEventListener("dialogLeftButton", this.onRenounce);
        _local1.addEventListener("dialogRightButton", this.onCancel);
        this.openDialog.dispatch(_local1);
    }

    private function onDispatchCreateGuildFrame():void {
        this.openDialog.dispatch(new CreateGuildFrame(this.hudModel.gameSprite));
    }

    private function onCancel(_arg_1:Event):void {
        this.closeDialog.dispatch();
    }

    private function onRenounce(_arg_1:Event):void {
        var _local2:GameSprite = this.hudModel.gameSprite;
        if (_local2.map == null || _local2.map.player_ == null) {
            return;
        }
        var _local3:Player = _local2.map.player_;
        _local2.gsc_.guildRemove(_local3.name_);
        this.closeDialog.dispatch();
    }
}
}
