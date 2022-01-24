package kabam.rotmg.news.model {
import com.company.assembleegameclient.parameters.Parameters;

import io.decagames.rotmg.seasonalEvent.data.SeasonalEventModel;

import kabam.rotmg.account.core.Account;
import kabam.rotmg.news.controller.NewsButtonRefreshSignal;
import kabam.rotmg.news.controller.NewsDataUpdatedSignal;
import kabam.rotmg.news.view.NewsModalPage;

public class NewsModel {


    private const COUNT:int = 3;

    public function NewsModel() {
        inGameNews = new Vector.<InGameNews>();
        super();
    }
    [Inject]
    public var update:NewsDataUpdatedSignal;
    [Inject]
    public var updateNoParams:NewsButtonRefreshSignal;
    [Inject]
    public var account:Account;
    [Inject]
    public var seasonalEventModel:SeasonalEventModel;
    public var news:Vector.<NewsCellVO>;
    public var modalPageData:Vector.<NewsCellVO>;
    private var inGameNews:Vector.<InGameNews>;

    public function get numberOfNews():int {
        return this.inGameNews.length;
    }

    public function addInGameNews(_arg_1:InGameNews):void {
        if (this.isInModeToBeShown(_arg_1.showInModes) && this.isValidForPlatform(_arg_1)) {
            this.inGameNews.push(_arg_1);
        }
        this.sortNews();
    }

    public function clearNews():void {
        if (this.inGameNews) {
            this.inGameNews.length = 0;
        }
    }

    public function isInModeToBeShown(_arg_1:int):Boolean {
        var _local2:* = false;
        var _local3:Boolean = this.seasonalEventModel.isChallenger;
        switch (int(_arg_1)) {
            case 0:
                _local2 = true;
                break;
            case 1:
                _local2 = !_local3;
                break;
            case 2:
                _local2 = _local3;
        }
        return _local2;
    }

    public function markAsRead():void {
        var _local1:InGameNews = this.getFirstNews();
        if (_local1 != null) {
            Parameters.data["lastNewsKey"] = _local1.newsKey;
            Parameters.save();
        }
    }

    public function hasUpdates():Boolean {
        var _local1:InGameNews = this.getFirstNews();
        return !(_local1 == null || Parameters.data["lastNewsKey"] == _local1.newsKey);
    }

    public function getFirstNews():InGameNews {
        if (this.inGameNews && this.inGameNews.length > 0) {
            return this.inGameNews[0];
        }
        return null;
    }

    public function initNews():void {
        var _local1:int = 0;
        this.news = new Vector.<NewsCellVO>(3, true);
        while (_local1 < 3) {
            this.news[_local1] = new DefaultNewsCellVO(_local1);
            _local1++;
        }
    }

    public function updateNews(_arg_1:Vector.<NewsCellVO>):void {
        var _local4:int = 0;
        var _local3:int = 0;
        this.initNews();
        var _local2:Vector.<NewsCellVO> = new Vector.<NewsCellVO>();
        this.modalPageData = new Vector.<NewsCellVO>(4, true);
        for each(var _local5:NewsCellVO in _arg_1) {
            if (_local5.slot <= 3) {
                _local2.push(_local5);
            } else {
                _local4 = _local5.slot - 4;
                _local3 = _local4 + 1;
                this.modalPageData[_local4] = _local5;
                if (Parameters.data["newsTimestamp" + _local3] != _local5.endDate) {
                    Parameters.data["newsTimestamp" + _local3] = _local5.endDate;
                    Parameters.data["hasNewsUpdate" + _local3] = true;
                }
            }
        }
        this.sortByPriority(_local2);
        this.update.dispatch(this.news);
        this.updateNoParams.dispatch();
    }

    public function hasValidNews():Boolean {
        return this.news[0] != null && this.news[1] != null && this.news[2] != null;
    }

    public function hasValidModalNews():Boolean {
        return this.inGameNews.length > 0;
    }

    public function getModalPage(_arg_1:int):NewsModalPage {
        var _local2:* = null;
        if (this.hasValidModalNews()) {
            _local2 = this.inGameNews[_arg_1 - 1];
            return new NewsModalPage(_local2.title, _local2.text);
        }
        return new NewsModalPage("No new information", "Please check back later.");
    }

    private function sortNews():void {
        this.inGameNews.sort(function (param1:InGameNews, param2:InGameNews):int {
            if (param1.weight > param2.weight) {
                return -1;
            }
            if (param1.weight == param2.weight) {
                return 0;
            }
            return 1;
        });
    }

    private function sortByPriority(_arg_1:Vector.<NewsCellVO>):void {
        var _local2:* = null;
        var _local4:int = 0;
        var _local3:* = _arg_1;
        for each(_local2 in _arg_1) {
            if (this.isNewsTimely(_local2) && this.isValidForPlatformGlobal(_local2)) {
                this.prioritize(_local2);
            }
        }
    }

    private function prioritize(_arg_1:NewsCellVO):void {
        var _local2:uint = _arg_1.slot - 1;
        if (this.news[_local2]) {
            _arg_1 = this.comparePriority(this.news[_local2], _arg_1);
        }
        this.news[_local2] = _arg_1;
    }

    private function comparePriority(_arg_1:NewsCellVO, _arg_2:NewsCellVO):NewsCellVO {
        return _arg_1.priority < _arg_2.priority ? _arg_1 : _arg_2;
    }

    private function isNewsTimely(_arg_1:NewsCellVO):Boolean {
        var _local2:Number = new Date().getTime();
        return _arg_1.startDate < _local2 && _local2 < _arg_1.endDate;
    }

    private function isValidForPlatformGlobal(_arg_1:NewsCellVO):Boolean {
        var _local2:String = "rotmg";
        return _arg_1.networks.indexOf(_local2) != -1;
    }

    private function isValidForPlatform(_arg_1:InGameNews):Boolean {
        var _local2:String = "rotmg";
        return _arg_1.platform.indexOf(_local2) != -1;
    }
}
}
