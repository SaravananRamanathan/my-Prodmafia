package io.decagames.rotmg.seasonalEvent.SeasonalLeaderBoard {
import flash.events.TimerEvent;
import flash.utils.Timer;

import io.decagames.rotmg.seasonalEvent.data.SeasonalEventModel;
import io.decagames.rotmg.seasonalEvent.signals.RequestChallengerListSignal;
import io.decagames.rotmg.seasonalEvent.signals.SeasonalLeaderBoardErrorSignal;
import io.decagames.rotmg.ui.buttons.BaseButton;
import io.decagames.rotmg.ui.buttons.SliceScalingButton;
import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
import io.decagames.rotmg.ui.popups.signals.ClosePopupSignal;
import io.decagames.rotmg.ui.texture.TextureParser;

import kabam.rotmg.core.signals.HideTooltipsSignal;
import kabam.rotmg.core.signals.ShowTooltipSignal;
import kabam.rotmg.legends.control.FameListUpdateSignal;
import kabam.rotmg.legends.model.LegendsModel;

import robotlegs.bender.bundles.mvcs.Mediator;

public class SeasonalLeaderBoardMediator extends Mediator {

    public static const REFRESH_TIME:String = " The list will be refreshed in: ";

    public static const REFRESH_INTERVAL_IN_MILLISECONDS:Number = 300000;

    public function SeasonalLeaderBoardMediator() {
        super();
    }
    [Inject]
    public var view:SeasonalLeaderBoard;
    [Inject]
    public var closePopupSignal:ClosePopupSignal;
    [Inject]
    public var showTooltipSignal:ShowTooltipSignal;
    [Inject]
    public var hideTooltipSignal:HideTooltipsSignal;
    [Inject]
    public var seasonalEventModel:SeasonalEventModel;
    [Inject]
    public var legendsModel:LegendsModel;
    [Inject]
    public var requestChallengerListSignal:RequestChallengerListSignal;
    [Inject]
    public var updateBoardSignal:FameListUpdateSignal;
    [Inject]
    public var seasonalLeaderBoardErrorSignal:SeasonalLeaderBoardErrorSignal;
    private var closeButton:SliceScalingButton;
    private var _refreshTimer:Timer;

    override public function initialize():void {
        this._refreshTimer = new Timer(1000);
        this._refreshTimer.addEventListener("timer", this.onTime);
        this.updateBoardSignal.add(this.updateLeaderBoard);
        this.seasonalLeaderBoardErrorSignal.add(this.onLeaderBoardError);
        this.view.header.setTitle("RIFTS Leaderboard", 8 * 60, DefaultLabelFormat.defaultMediumPopupTitle);
        this.closeButton = new SliceScalingButton(TextureParser.instance.getSliceScalingBitmap("UI", "close_button"));
        this.closeButton.clickSignal.addOnce(this.onClose);
        this.view.header.addButton(this.closeButton, "right_button");
        this.view.tabs.tabSelectedSignal.add(this.onTabSelected);
    }

    override public function destroy():void {
        this.view.dispose();
        this.closeButton.dispose();
        this._refreshTimer.stop();
        this._refreshTimer.removeEventListener("timer", this.onTime);
        this._refreshTimer = null;
        this.seasonalLeaderBoardErrorSignal.remove(this.onLeaderBoardError);
        this.updateBoardSignal.remove(this.updateLeaderBoard);
    }

    private function setGeneratedTime():void {
        var _local1:Date = this.view.tabs.currentTabLabel == "Top 20" ? this.seasonalEventModel.leaderboardTop20CreateTime : this.seasonalEventModel.leaderboardPlayerCreateTime;
        this.view.lastUpdatedTime.text = "Last updated at: " + this.getTimeFormat(_local1.time);
    }

    private function onLeaderBoardError(_arg_1:String):void {
        this.view.clearLeaderBoard();
        this.view.spinner.visible = false;
        this.view.spinner.pause();
        this.view.setErrorMessage(_arg_1);
    }

    private function updateRefreshTime():void {
        var _local1:String = this.getTimeFormat(this.timeToRefresh());
        this.view.refreshTime.text = " The list will be refreshed in: " + _local1;
    }

    private function getTimeFormat(_arg_1:Number):String {
        var _local2:Date = new Date(_arg_1);
        var _local5:String = _local2.getUTCHours() > 9 ? _local2.getUTCHours().toString() : "0" + _local2.getUTCHours();
        var _local4:String = _local2.getUTCMinutes() > 9 ? _local2.getUTCMinutes().toString() : "0" + _local2.getUTCMinutes();
        var _local3:String = _local2.getUTCSeconds() > 9 ? _local2.getUTCSeconds().toString() : "0" + _local2.getUTCSeconds();
        return _local5 + ":" + _local4 + ":" + _local3;
    }

    private function onTabSelected(_arg_1:String):void {
        this.view.refreshTime.visible = false;
        this.view.lastUpdatedTime.visible = false;
        this._refreshTimer.stop();
        this.showSpinner();
        if (this.timeToRefresh() <= 0) {
            this.requestChallengerListSignal.dispatch(this.legendsModel.getTimespan(), _arg_1);
        } else if (_arg_1 == "Top 20") {
            this.upDateTop20();
        } else if (_arg_1 == "Your Position") {
            this.upDatePlayerPosition();
        }
    }

    private function timeToRefresh():Number {
        var _local2:* = null;
        var _local1:Date = this.view.tabs.currentTabLabel == "Top 20" ? this.seasonalEventModel.leaderboardTop20RefreshTime : this.seasonalEventModel.leaderboardPlayerRefreshTime;
        if (_local1) {
            _local2 = new Date();
            return _local1.time - _local2.time;
        }
        return 0;
    }

    private function showSpinner():void {
        this.view.spinner.resume();
        this.view.spinner.visible = true;
    }

    private function updateLeaderBoard():void {
        if (this.view.tabs.currentTabLabel == "Top 20") {
            if (this.seasonalEventModel.leaderboardTop20ItemDatas) {
                this.upDateTop20();
            }
        } else if (this.view.tabs.currentTabLabel == "Your Position") {
            if (this.seasonalEventModel.leaderboardPlayerItemDatas) {
                this.upDatePlayerPosition();
            }
        } else {
            this.onTabSelected(this.view.tabs.currentTabLabel);
        }
    }

    private function upDateTop20():void {
        var _local2:* = null;
        this.view.clearLeaderBoard();
        this.view.spinner.visible = false;
        this.view.spinner.pause();
        var _local1:Vector.<SeasonalLeaderBoardItemData> = this.seasonalEventModel.leaderboardTop20ItemDatas;
        var _local4:int = 0;
        var _local3:* = _local1;
        for each(_local2 in _local1) {
            this.view.addTop20Item(_local2);
        }
        this.view.refreshTime.visible = true;
        this.setGeneratedTime();
        this.view.lastUpdatedTime.visible = true;
        this._refreshTimer.start();
    }

    private function upDatePlayerPosition():void {
        var _local2:* = null;
        this.view.clearLeaderBoard();
        this.view.spinner.visible = false;
        this.view.spinner.pause();
        var _local1:Vector.<SeasonalLeaderBoardItemData> = this.seasonalEventModel.leaderboardPlayerItemDatas;
        var _local4:int = 0;
        var _local3:* = _local1;
        for each(_local2 in _local1) {
            this.view.addPlayerListItem(_local2);
        }
        this.view.refreshTime.visible = true;
        this.setGeneratedTime();
        this.view.lastUpdatedTime.visible = true;
        this._refreshTimer.start();
    }

    private function onClose(_arg_1:BaseButton):void {
        this.closePopupSignal.dispatch(this.view);
    }

    private function onTime(_arg_1:TimerEvent):void {
        if (this.timeToRefresh() <= 0) {
            this.onTabSelected(this.view.tabs.currentTabLabel);
        } else {
            this.updateRefreshTime();
        }
    }
}
}
