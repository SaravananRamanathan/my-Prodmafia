package kabam.rotmg.dailyLogin.controller {
import com.company.assembleegameclient.parameters.Parameters;

import flash.events.MouseEvent;
import flash.globalization.DateTimeFormatter;

import kabam.rotmg.dailyLogin.model.DailyLoginModel;
import kabam.rotmg.dailyLogin.view.DailyLoginModal;
import kabam.rotmg.dialogs.control.CloseDialogsSignal;
import kabam.rotmg.dialogs.control.FlushPopupStartupQueueSignal;
import kabam.rotmg.game.signals.ExitGameSignal;
import kabam.rotmg.pets.view.components.DialogCloseButton;
import kabam.rotmg.ui.model.HUDModel;

import robotlegs.bender.bundles.mvcs.Mediator;

public class DailyLoginModalMediator extends Mediator {


    public function DailyLoginModalMediator() {
        super();
    }
    [Inject]
    public var view:DailyLoginModal;
    [Inject]
    public var closeDialogs:CloseDialogsSignal;
    [Inject]
    public var dailyLoginModel:DailyLoginModel;
    [Inject]
    public var hudModel:HUDModel;
    [Inject]
    public var exitGameSignal:ExitGameSignal;
    [Inject]
    public var closeDialog:CloseDialogsSignal;
    [Inject]
    public var flushStartupQueue:FlushPopupStartupQueueSignal;

    override public function initialize():void {
        this.view.init(this.dailyLoginModel);
        this.view.addTitle("Login Rewards");
        var _local3:DateTimeFormatter = new DateTimeFormatter("en-US");
        _local3.setDateTimePattern("yyyy-MM-dd hh:mm:ssa");
        var _local2:Date = new Date();
        var _local1:Date = new Date(_local2.fullYear, _local2.month + 1, 1, 0, 0, 0);
        _local1.time = _local1.time - 1;
        this.view.showLegend(this.hudModel.gameSprite.map.name_ == "Daily Quest Room");
        this.view.showServerTime(_local3.formatUTC(this.dailyLoginModel.getServerTime()), _local3.format(_local1));
        if (this.hudModel.gameSprite.map.name_ != "Daily Quest Room") {
            this.view.claimButton.addEventListener("click", this.onClaimClickHandler);
            this.view.addEventListener("click", this.onPopupClickHandler);
        }
        Parameters.data.calendarShowOnDay = this.dailyLoginModel.getTimestampDay();
        Parameters.save();
        this.dailyLoginModel.shouldDisplayCalendarAtStartup = false;
        this.view.addCloseButton();
        this.view.closeButton.clicked.add(this.onCloseButtonClicked);
    }

    override public function destroy():void {
        if (this.hudModel.gameSprite.map.name_ != "Daily Quest Room") {
            this.view.claimButton.removeEventListener("click", this.onClaimClickHandler);
            this.view.removeEventListener("click", this.onPopupClickHandler);
        }
        super.destroy();
    }

    public function onCloseButtonClicked():void {
        this.view.closeButton.clicked.remove(this.onCloseButtonClicked);
        this.flushStartupQueue.dispatch();
    }

    private function enterPortal():void {
        this.closeDialogs.dispatch();
        this.hudModel.gameSprite.gsc_.gotoQuestRoom();
    }

    private function onClaimClickHandler(_arg_1:MouseEvent):void {
        this.enterPortal();
    }

    private function onPopupClickHandler(_arg_1:MouseEvent):void {
        if (_arg_1.target != DialogCloseButton) {
            this.enterPortal();
        }
    }
}
}
