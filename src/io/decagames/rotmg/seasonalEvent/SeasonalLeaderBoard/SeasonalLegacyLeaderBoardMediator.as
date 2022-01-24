package io.decagames.rotmg.seasonalEvent.SeasonalLeaderBoard {
import flash.events.Event;

import io.decagames.rotmg.seasonalEvent.data.LegacySeasonData;
import io.decagames.rotmg.seasonalEvent.data.SeasonalEventModel;
import io.decagames.rotmg.seasonalEvent.signals.RequestLegacySeasonSignal;
import io.decagames.rotmg.seasonalEvent.signals.SeasonalLeaderBoardErrorSignal;
import io.decagames.rotmg.ui.buttons.BaseButton;
import io.decagames.rotmg.ui.buttons.SliceScalingButton;
import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
import io.decagames.rotmg.ui.popups.signals.ClosePopupSignal;
import io.decagames.rotmg.ui.texture.TextureParser;

import kabam.rotmg.core.signals.HideTooltipsSignal;
import kabam.rotmg.core.signals.ShowTooltipSignal;
import kabam.rotmg.legends.control.FameListUpdateSignal;

import robotlegs.bender.bundles.mvcs.Mediator;

public class SeasonalLegacyLeaderBoardMediator extends Mediator {


    public function SeasonalLegacyLeaderBoardMediator() {
        _legacyLeaderBoardSeasons = new Vector.<LegacySeasonData>(0);
        super();
    }
    [Inject]
    public var view:SeasonalLegacyLeaderBoard;
    [Inject]
    public var closePopupSignal:ClosePopupSignal;
    [Inject]
    public var showTooltipSignal:ShowTooltipSignal;
    [Inject]
    public var hideTooltipSignal:HideTooltipsSignal;
    [Inject]
    public var seasonalEventModel:SeasonalEventModel;
    [Inject]
    public var seasonalLeaderBoardErrorSignal:SeasonalLeaderBoardErrorSignal;
    [Inject]
    public var requestLegacySeasonSignal:RequestLegacySeasonSignal;
    [Inject]
    public var updateBoardSignal:FameListUpdateSignal;
    private var closeButton:SliceScalingButton;
    private var _currentSeasonId:String = "";
    private var _isActiveSeason:Boolean;
    private var _legacyLeaderBoardSeasons:Vector.<LegacySeasonData>;

    override public function initialize():void {
        this.seasonalLeaderBoardErrorSignal.add(this.onLeaderBoardError);
        this.view.header.setTitle("Seasons Leaderboard", 8 * 60, DefaultLabelFormat.defaultMediumPopupTitle);
        this.closeButton = new SliceScalingButton(TextureParser.instance.getSliceScalingBitmap("UI", "close_button"));
        this.closeButton.clickSignal.addOnce(this.onClose);
        this.view.header.addButton(this.closeButton, "right_button");
        this.view.tabs.tabSelectedSignal.add(this.onTabSelected);
        this.setSeasonData();
        this.updateBoardSignal.add(this.updateLeaderBoard);
    }

    override public function destroy():void {
        this.view.dispose();
        this.closeButton.dispose();
        this.seasonalLeaderBoardErrorSignal.remove(this.onLeaderBoardError);
        this.updateBoardSignal.remove(this.updateLeaderBoard);
        if (this.view.dropDown) {
            this.view.dropDown.removeEventListener("change", this.onDropDownChanged);
        }
    }

    private function setSeasonData():void {
        var _local3:* = null;
        var _local4:int = 0;
        var _local5:Vector.<String> = new Vector.<String>(0);
        var _local2:Vector.<LegacySeasonData> = this.seasonalEventModel.legacySeasons;
        var _local1:int = _local2.length;
        while (_local4 < _local1) {
            _local3 = _local2[_local4];
            if (_local3.hasLeaderBoard) {
                this._legacyLeaderBoardSeasons.push(_local3);
                _local5.push(_local3.title);
            }
            _local4++;
        }
        if (_local5.length > 0) {
            this._currentSeasonId = "";
            _local5.unshift("Click to choose a season!");
            this.view.setDropDownData(_local5);
            this.view.dropDown.addEventListener("change", this.onDropDownChanged);
        }
    }

    private function isSeasonActive(_arg_1:String):Boolean {
        var _local2:Boolean = false;
        var _local3:* = null;
        var _local4:int = 0;
        var _local5:int = this._legacyLeaderBoardSeasons.length;
        while (_local4 < _local5) {
            _local3 = this._legacyLeaderBoardSeasons[_local4];
            if (_arg_1 == _local3.seasonId && _local3.active) {
                _local2 = true;
                break;
            }
            _local4++;
        }
        return _local2;
    }

    private function resetLeaderBoard():void {
        this.view.clearLeaderBoard();
        this.view.spinner.visible = false;
        this.view.spinner.pause();
        this.seasonalEventModel.leaderboardLegacyTop20ItemDatas = null;
        this.seasonalEventModel.leaderboardLegacyPlayerItemDatas = null;
        this._currentSeasonId = "";
        if (this.view.tabs.currentTabLabel == "Your Position") {
            this.view.tabs.tabSelectedSignal.dispatch("Top 20");
        }
    }

    private function getSeasonId():String {
        var _local1:String = this.view.dropDown.getValue();
        return this.seasonalEventModel.getSeasonIdByTitle(_local1);
    }

    private function onLeaderBoardError(_arg_1:String):void {
        this.view.clearLeaderBoard();
        this.view.spinner.visible = false;
        this.view.spinner.pause();
        this.view.setErrorMessage(_arg_1);
    }

    private function getTimeFormat(_arg_1:Number):String {
        var _local2:Date = new Date(_arg_1);
        var _local5:String = _local2.getHours() > 9 ? _local2.getHours().toString() : "0" + _local2.getHours();
        var _local4:String = _local2.getMinutes() > 9 ? _local2.getMinutes().toString() : "0" + _local2.getMinutes();
        var _local3:String = _local2.getSeconds() > 9 ? _local2.getSeconds().toString() : "0" + _local2.getSeconds();
        return _local5 + ":" + _local4 + ":" + _local3;
    }

    private function onTabSelected(_arg_1:String):void {
        if (this._currentSeasonId != "") {
            this.showSpinner();
            this.updateLeaderBoard();
        }
    }

    private function showSpinner():void {
        this.view.spinner.resume();
        this.view.spinner.visible = true;
    }

    private function updateLeaderBoard():void {
        if (this.view.tabs.currentTabLabel == "Top 20") {
            if (this.seasonalEventModel.leaderboardLegacyTop20ItemDatas) {
                this.upDateTop20();
            }
        } else if (this.view.tabs.currentTabLabel == "Your Position") {
            if (this.seasonalEventModel.leaderboardLegacyPlayerItemDatas) {
                this.upDatePlayerPosition();
            } else {
                this.requestLegacySeasonSignal.dispatch(this._currentSeasonId != "" ? this._currentSeasonId : this.getSeasonId(), false);
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
        var _local1:Vector.<SeasonalLeaderBoardItemData> = this.seasonalEventModel.leaderboardLegacyTop20ItemDatas;
        var _local4:int = 0;
        var _local3:* = _local1;
        for each(_local2 in _local1) {
            this.view.addTop20Item(_local2);
        }
    }

    private function upDatePlayerPosition():void {
        var _local2:* = null;
        this.view.clearLeaderBoard();
        this.view.spinner.visible = false;
        this.view.spinner.pause();
        var _local1:Vector.<SeasonalLeaderBoardItemData> = this.seasonalEventModel.leaderboardLegacyPlayerItemDatas;
        var _local4:int = 0;
        var _local3:* = _local1;
        for each(_local2 in _local1) {
            this.view.addPlayerListItem(_local2);
        }
    }

    private function onClose(_arg_1:BaseButton):void {
        this.closePopupSignal.dispatch(this.view);
    }

    private function onDropDownChanged(_arg_1:Event):void {
        this.resetLeaderBoard();
        this.showSpinner();
        this._currentSeasonId = this.getSeasonId();
        if (this.isSeasonActive(this._currentSeasonId)) {
            this.view.tabs.getTabButtonByLabel("Your Position").visible = true;
        } else {
            this.view.tabs.getTabButtonByLabel("Your Position").visible = false;
        }
        this.requestLegacySeasonSignal.dispatch(this._currentSeasonId, true);
    }
}
}
