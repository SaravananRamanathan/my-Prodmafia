package com.company.assembleegameclient.ui.panels.mediators {
import com.company.assembleegameclient.ui.dialogs.Dialog;
import com.company.assembleegameclient.ui.panels.ArenaPortalPanel;
import com.company.assembleegameclient.util.Currency;

import flash.events.Event;

import io.decagames.rotmg.ui.popups.signals.ShowPopupSignal;

import kabam.lib.net.api.MessageProvider;
import kabam.lib.net.impl.SocketServer;
import kabam.rotmg.account.core.Account;
import kabam.rotmg.account.core.view.RegisterPromptDialog;
import kabam.rotmg.arena.model.CurrentArenaRunModel;
import kabam.rotmg.arena.service.GetBestArenaRunTask;
import kabam.rotmg.dialogs.control.CloseDialogsSignal;
import kabam.rotmg.dialogs.control.OpenDialogSignal;
import kabam.rotmg.game.model.GameModel;
import kabam.rotmg.game.signals.ExitGameSignal;
import kabam.rotmg.messaging.impl.outgoing.arena.EnterArena;
import kabam.rotmg.ui.view.NotEnoughGoldDialog;

import org.swiftsuspenders.Injector;

import robotlegs.bender.bundles.mvcs.Mediator;

public class ArenaPortalPanelMediator extends Mediator {

    public static const TEXT:String = "SellableObjectPanelMediator.text";

    public function ArenaPortalPanelMediator() {
        super();
    }
    [Inject]
    public var view:ArenaPortalPanel;
    [Inject]
    public var socketServer:SocketServer;
    [Inject]
    public var messages:MessageProvider;
    [Inject]
    public var openDialog:OpenDialogSignal;
    [Inject]
    public var closeDialog:CloseDialogsSignal;
    [Inject]
    public var gameModel:GameModel;
    [Inject]
    public var currentRunModel:CurrentArenaRunModel;
    [Inject]
    public var injector:Injector;
    [Inject]
    public var exitSignal:ExitGameSignal;
    [Inject]
    public var account:Account;
    [Inject]
    public var showPopupSignal:ShowPopupSignal;
    private var dialog:Dialog;

    override public function initialize():void {
        this.view.purchase.add(this.onPurchase);
    }

    private function onPurchase(_arg_1:int):void {
        if (_arg_1 == 0) {
            this.purchaseWithGold();
        } else {
            this.purchaseWithFame();
        }
    }

    private function purchaseWithFame():void {
        var _local1:* = null;
        var _local2:* = null;
        if (this.gameModel.player.nameChosen_) {
            this.currentRunModel.saveCurrentUserInfo();
            _local1 = this.injector.getInstance(GetBestArenaRunTask);
            _local1.start();
            _local2 = this.messages.require(17) as EnterArena;
            _local2.currency = 1;
            this.socketServer.sendMessage(_local2);
            this.exitSignal.dispatch();
        } else {
            this.dialog = new Dialog("MustBeNamed.title", "MustBeNamed.desc", "ErrorDialog.ok", null, null);
            this.dialog.addEventListener("dialogLeftButton", this.onNoNameDialogClose);
            this.openDialog.dispatch(this.dialog);
        }
    }

    private function purchaseWithGold():void {
        var _local1:* = null;
        var _local2:* = null;
        if (!this.account.isRegistered()) {
            this.openDialog.dispatch(new RegisterPromptDialog("SellableObjectPanelMediator.text", {"type": Currency.typeToName(0)}));
        } else if (!this.gameModel.player.nameChosen_) {
            this.dialog = new Dialog("MustBeNamed.title", "MustBeNamed.desc", "ErrorDialog.ok", null, null);
            this.dialog.addEventListener("dialogLeftButton", this.onNoNameDialogClose);
            this.openDialog.dispatch(this.dialog);
        } else if (this.gameModel.player.credits_ < 50) {
            this.showPopupSignal.dispatch(new NotEnoughGoldDialog());
        } else {
            this.currentRunModel.saveCurrentUserInfo();
            _local1 = this.injector.getInstance(GetBestArenaRunTask);
            _local1.start();
            _local2 = this.messages.require(17) as EnterArena;
            _local2.currency = 0;
            this.socketServer.sendMessage(_local2);
            this.exitSignal.dispatch();
        }
    }

    private function onNoNameDialogClose(_arg_1:Event):void {
        if (this.dialog && this.dialog.hasEventListener("dialogLeftButton")) {
            this.dialog.removeEventListener("dialogLeftButton", this.onNoNameDialogClose);
        }
        this.dialog = null;
        this.closeDialog.dispatch();
    }
}
}
