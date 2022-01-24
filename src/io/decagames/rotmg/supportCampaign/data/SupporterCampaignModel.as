package io.decagames.rotmg.supportCampaign.data {
import flash.display.DisplayObject;
import flash.utils.Dictionary;

import io.decagames.rotmg.supportCampaign.data.vo.RankVO;
import io.decagames.rotmg.supportCampaign.signals.MaxRankReachedSignal;
import io.decagames.rotmg.supportCampaign.signals.UpdateCampaignProgress;
import io.decagames.rotmg.utils.date.TimeLeft;

import kabam.rotmg.core.StaticInjectorContext;

public class SupporterCampaignModel {

    public static const DEFAULT_DONATE_AMOUNT:int = 100;

    public static const DEFAULT_DONATE_SPINNER_STEP:int = 100;

    public static const DONATE_MAX_INPUT_CHARS:int = 5;

    public static const SUPPORT_COLOR:Number = 13395711;

    public static const RANKS_NAMES:Array = ["Basic", "Greater", "Superior", "Paramount", "Exalted", "Unbound"];

    public function SupporterCampaignModel() {
        _campaignImages = new Dictionary(true);
        super();
    }
    private var _activeUntil:Date;
    private var _picUrls:Vector.<String>;
    private var _campaignImages:Dictionary;
    private var _maxRank:int;

    private var _unlockPrice:int;

    public function get unlockPrice():int {
        return this._unlockPrice;
    }

    private var _points:int;

    public function get points():int {
        return this._points;
    }

    private var _rank:int;

    public function get rank():int {
        return this._rank;
    }

    private var _tempRank:int;

    public function get tempRank():int {
        return this._tempRank;
    }

    public function set tempRank(_arg_1:int):void {
        this._tempRank = _arg_1;
    }

    private var _donatePointsRatio:int;

    public function get donatePointsRatio():int {
        return this._donatePointsRatio;
    }

    private var _shopPurchasePointsRatio:int;

    public function get shopPurchasePointsRatio():int {
        return this._shopPurchasePointsRatio;
    }

    private var _endDate:Date;

    public function get endDate():Date {
        return this._endDate;
    }

    private var _startDate:Date;

    public function get startDate():Date {
        return this._startDate;
    }

    private var _ranks:Array;

    public function get ranks():Array {
        return this._ranks;
    }

    private var _isUnlocked:Boolean;

    public function get isUnlocked():Boolean {
        return this._isUnlocked;
    }

    private var _hasValidData:Boolean;

    public function get hasValidData():Boolean {
        return this._hasValidData;
    }

    private var _claimed:int;

    public function get claimed():int {
        return this._claimed;
    }

    private var _rankConfig:Vector.<RankVO>;

    public function get rankConfig():Vector.<RankVO> {
        return this._rankConfig;
    }

    private var _campaignTitle:String;

    public function get campaignTitle():String {
        return this._campaignTitle;
    }

    private var _campaignDescription:String;

    public function get campaignDescription():String {
        return this._campaignDescription;
    }

    private var _campaignBannerUrl:String;

    public function get campaignBannerUrl():String {
        return this._campaignBannerUrl;
    }

    public function get isStarted():Boolean {
        return new Date().time >= this._startDate.time;
    }

    public function get isEnded():Boolean {
        return new Date().time >= this._endDate.time;
    }

    public function get isActive():Boolean {
        return this.isStarted && new Date().time < this._activeUntil.time;
    }

    public function get nextClaimableTier():int {
        var _local1:* = null;
        if (this._ranks.length == 0) {
            return 1;
        }
        var _local2:int = 1;
        var _local4:int = 0;
        var _local3:* = this._ranks;
        for each(_local1 in this._ranks) {
            if (this._rank >= _local2 && this._claimed < _local2) {
                return _local2;
            }
            _local2++;
        }
        return this._rank;
    }

    public function parseConfigData(_arg_1:XML):void {
        this._hasValidData = _arg_1.hasOwnProperty("CampaignConfig");
        if (this._hasValidData) {
            this.parseConfig(_arg_1);
        }
        if (_arg_1.hasOwnProperty("CampaignProgress")) {
            this.parseUpdateData(_arg_1.CampaignProgress, false);
        }
    }

    public function updatePoints(_arg_1:int):void {
        this._points = _arg_1;
        this._rank = this.getRankByPoints(this._points);
        StaticInjectorContext.getInjector().getInstance(UpdateCampaignProgress).dispatch();
    }

    public function getRankByPoints(_arg_1:int):int {
        var _local3:int = 0;
        var _local2:int = 0;
        if (!this.hasValidData) {
            return 0;
        }
        if (this._ranks != null && this._ranks.length > 0) {
            _local3 = 0;
            while (_local3 < this._ranks.length) {
                if (_arg_1 >= this._ranks[_local3]) {
                    _local2 = _local3 + 1;
                }
                _local3++;
            }
        }
        return _local2;
    }

    public function parseUpdateData(_arg_1:Object, _arg_2:Boolean = true):void {
        this._isUnlocked = int(this.getXMLData(_arg_1, "Unlocked", false)) === 1;
        this._points = int(this.getXMLData(_arg_1, "Points", false));
        this._rank = int(this.getXMLData(_arg_1, "Rank", false));
        if (this._tempRank == 0) {
            this._tempRank = this._rank;
        }
        this._claimed = int(this.getXMLData(_arg_1, "Claimed", false));
        if (_arg_2) {
            StaticInjectorContext.getInjector().getInstance(UpdateCampaignProgress).dispatch();
        }
        if (this.hasMaxRank()) {
            StaticInjectorContext.getInjector().getInstance(MaxRankReachedSignal).dispatch();
        }
    }

    public function getCampaignImageByUrl(_arg_1:String):DisplayObject {
        return this._campaignImages[_arg_1] as DisplayObject;
    }

    public function addCampaignImageByUrl(_arg_1:String, _arg_2:DisplayObject):void {
        if (!this._campaignImages[_arg_1]) {
            this._campaignImages[_arg_1] = _arg_2;
        }
    }

    public function getCampaignPictureUrlByRank(_arg_1:int):String {
        var _local2:* = "";
        if (this._picUrls && this._picUrls.length > 0 && _arg_1 <= this._picUrls.length) {
            _arg_1 = _arg_1 == 0 ? 1 : _arg_1;
            _local2 = this._picUrls[_arg_1 - 1];
        }
        return _local2;
    }

    public function getStartTimeString():String {
        var _local2:* = "";
        var _local1:Number = this.getSecondsToStart();
        if (_local1 <= 0) {
            return "";
        }
        if (_local1 > 24 * 60 * 60) {
            _local2 = _local2 + TimeLeft.parse(_local1, "%dd %hh");
        } else if (_local1 > 60 * 60) {
            _local2 = _local2 + TimeLeft.parse(_local1, "%hh %mm");
        } else if (_local1 > 60) {
            _local2 = _local2 + TimeLeft.parse(_local1, "%mm %ss");
        } else {
            _local2 = _local2 + TimeLeft.parse(_local1, "%ss");
        }
        return _local2;
    }

    public function hasMaxRank():Boolean {
        return this._rank == this._maxRank;
    }

    private function parseConfig(_arg_1:XML):void {
        var _local3:* = null;
        var _local2:int = 0;
        this._campaignTitle = this.getXMLData(_arg_1.CampaignConfig, "Title", true);
        this._campaignDescription = this.getXMLData(_arg_1.CampaignConfig, "Description", true);
        this._campaignBannerUrl = this.getXMLData(_arg_1.CampaignConfig, "BannerUrl", true);
        this._unlockPrice = int(this.getXMLData(_arg_1.CampaignConfig, "UnlockPrice", true));
        this._donatePointsRatio = int(this.getXMLData(_arg_1.CampaignConfig, "DonatePointsRatio", true));
        this._endDate = new Date(int(this.getXMLData(_arg_1.CampaignConfig, "CampaignEndDate", true)) * 1000);
        this._activeUntil = new Date(int(this.getXMLData(_arg_1.CampaignConfig, "CampaignActiveUntil", true)) * 1000);
        this._startDate = new Date(int(this.getXMLData(_arg_1.CampaignConfig, "CampaignStartDate", true)) * 1000);
        this._ranks = this.getXMLData(_arg_1.CampaignConfig, "RanksList", true).split(",");
        if (this._ranks) {
            this._maxRank = this._ranks.length;
        }
        this._shopPurchasePointsRatio = int(this.getXMLData(_arg_1.CampaignConfig, "ShopPurchasePointsRatio", true));
        this._rankConfig = new Vector.<RankVO>();
        while (_local2 < this._ranks.length) {
            this._rankConfig.push(new RankVO(this._ranks[_local2], SupporterCampaignModel.RANKS_NAMES[_local2]));
            _local2++;
        }
        this._picUrls = new Vector.<String>(0);
        var _local4:XMLList = XML(_arg_1.CampaignConfig.PicUrls).children();
        var _local6:int = 0;
        var _local5:* = _local4;
        for each(_local3 in _local4) {
            this._picUrls.push(_local3);
        }
    }

    private function parseConfigStatus(_arg_1:XML):void {
        this._isUnlocked = int(this.getXMLData(_arg_1.CampaignProgress, "Unlocked", false)) === 1;
        this._points = int(this.getXMLData(_arg_1.CampaignProgress, "Points", false));
        this._rank = int(this.getXMLData(_arg_1.CampaignProgress, "Rank", false));
        this._claimed = int(this.getXMLData(_arg_1, "Claimed", false));
    }

    private function getXMLData(_arg_1:Object, _arg_2:String, _arg_3:Boolean):String {
        if (_arg_1.hasOwnProperty(_arg_2)) {
            return String(_arg_1[_arg_2]);
        }
        if (_arg_3) {
            this._hasValidData = false;
        }
        return "";
    }

    private function getSecondsToStart():Number {
        var _local1:Date = new Date();
        return (this._startDate.time - _local1.time) / 1000;
    }
}
}
