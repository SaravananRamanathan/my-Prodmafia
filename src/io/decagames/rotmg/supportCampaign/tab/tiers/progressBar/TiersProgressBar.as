package io.decagames.rotmg.supportCampaign.tab.tiers.progressBar {
import flash.display.Sprite;

import io.decagames.rotmg.supportCampaign.data.vo.RankVO;
import io.decagames.rotmg.supportCampaign.tab.tiers.button.TierButton;
import io.decagames.rotmg.ui.ProgressBar;
import io.decagames.rotmg.ui.sliceScaling.SliceScalingBitmap;
import io.decagames.rotmg.ui.texture.TextureParser;

public class TiersProgressBar extends Sprite {


    public function TiersProgressBar(_arg_1:Vector.<RankVO>, _arg_2:int) {
        super();
        this._ranks = _arg_1;
        this._componentWidth = _arg_2;
        this._buttons = new Vector.<TierButton>();
        this.supportIcon = TextureParser.instance.getSliceScalingBitmap("UI", "campaign_Points");
    }
    private var _ranks:Vector.<RankVO>;
    private var _componentWidth:int;
    private var _currentRank:int;
    private var _claimed:int;
    private var buttonAreReady:Boolean;
    private var _buttons:Vector.<TierButton>;
    private var _progressBar:ProgressBar;
    private var _points:int;
    private var supportIcon:SliceScalingBitmap;

    public function show(_arg_1:int, _arg_2:int, _arg_3:int):void {
        this._currentRank = _arg_2;
        this._claimed = _arg_3;
        this._points = _arg_1;
        if (!this.buttonAreReady) {
            this.renderProgressBar();
            this.renderButtons();
        }
        this.updateProgressBar();
        this.updateButtons();
    }

    private function getStatusByTier(_arg_1:int):int {
        if (this._claimed >= _arg_1) {
            return 2;
        }
        if (this._currentRank >= _arg_1) {
            return 1;
        }
        return 0;
    }

    private function updateButtons():void {
        var _local2:* = null;
        var _local1:Boolean = false;
        var _local4:int = 0;
        var _local3:* = this._buttons;
        for each(_local2 in this._buttons) {
            _local2.updateStatus(this.getStatusByTier(_local2.tier));
            if (!_local1 && this.getStatusByTier(_local2.tier) == 1) {
                _local1 = true;
                _local2.selected = true;
            } else {
                _local2.selected = false;
            }
        }
        if (!_local1) {
            if (this._currentRank != 0) {
                var _local6:int = 0;
                var _local5:* = this._buttons;
                for each(_local2 in this._buttons) {
                    if (this._currentRank == _local2.tier) {
                        _local1 = true;
                        _local2.selected = true;
                    }
                }
            }
        }
        if (!_local1) {
            this._buttons[0].selected = true;
        }
    }

    private function updateProgressBar():void {
        var _local1:int = this._points;
        if (this._progressBar.value != _local1) {
            if (_local1 > this._progressBar.maxValue - this._progressBar.minValue) {
                this._progressBar.value = this._progressBar.maxValue - this._progressBar.minValue;
            } else {
                this._progressBar.value = _local1;
            }
        }
    }

    private function renderProgressBar():void {
        this._progressBar = new ProgressBar(this._componentWidth, 4, "", "", 0, this._ranks[this._ranks.length - 1].points, 0, 0x545454, 1029573);
        this._progressBar.y = 7;
        this._progressBar.shouldAnimate = false;
        addChild(this._progressBar);
        this.supportIcon.x = -4;
        this.supportIcon.y = 5;
        addChild(this.supportIcon);
    }

    private function renderButtons():void {
        var _local2:* = null;
        var _local1:int = 0;
        var _local3:int = 0;
        var _local8:int = 0;
        var _local5:int = 0;
        var _local4:* = null;
        var _local7:* = null;
        var _local6:int = 1;
        var _local10:int = 0;
        var _local9:* = this._ranks;
        for each(_local2 in this._ranks) {
            _local4 = new TierButton(_local6, this.getStatusByTier(_local6));
            this._buttons.push(_local4);
            _local6++;
        }
        _local1 = this._buttons.length;
        _local3 = this._componentWidth / _local1;
        _local8 = 1;
        _local5 = _local1 - 1;
        while (_local5 >= 0) {
            _local7 = this._buttons[_local5];
            _local7.x = this._componentWidth - _local8 * _local3;
            addChild(_local7);
            _local8++;
            _local5--;
        }
        this.buttonAreReady = true;
    }
}
}
