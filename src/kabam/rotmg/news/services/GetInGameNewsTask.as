package kabam.rotmg.news.services {
import kabam.lib.tasks.BaseTask;
import kabam.rotmg.appengine.api.AppEngineClient;
import kabam.rotmg.dialogs.control.AddPopupToStartupQueueSignal;
import kabam.rotmg.dialogs.control.OpenDialogSignal;
import kabam.rotmg.news.model.InGameNews;
import kabam.rotmg.news.model.NewsModel;
import kabam.rotmg.news.view.NewsModal;

import robotlegs.bender.framework.api.ILogger;

public class GetInGameNewsTask extends BaseTask {


    public function GetInGameNewsTask() {
        super();
    }
    [Inject]
    public var logger:ILogger;
    [Inject]
    public var client:AppEngineClient;
    [Inject]
    public var model:NewsModel;
    [Inject]
    public var addToQueueSignal:AddPopupToStartupQueueSignal;
    [Inject]
    public var openDialogSignal:OpenDialogSignal;
    private var requestData:Object;

    override protected function startTask():void {
        this.requestData = this.makeRequestData();
        this.sendRequest();
    }

    public function makeRequestData():Object {
        return {};
    }

    private function sendRequest():void {
        this.client.complete.addOnce(this.onComplete);
        this.client.sendRequest("/inGameNews/getNews", this.requestData);
    }

    private function onComplete(_arg_1:Boolean, _arg_2:*):void {
        if (_arg_1) {
            this.parseNews(_arg_2);
        } else {
            completeTask(true);
        }
    }

    private function parseNews(_arg_1:String):void {
        var _local5:* = null;
        var _local4:* = null;
        var _local3:* = null;
        try {
            _local5 = JSON.parse(_arg_1);
            var _local8:int = 0;
            var _local7:* = _local5;
            for each(_local4 in _local5) {
                _local3 = new InGameNews();
                _local3.newsKey = _local4.newsKey;
                _local3.showAtStartup = _local4.showAtStartup;
                _local3.showInModes = _local4.showInModes;
                _local3.startTime = _local4.startTime;
                _local3.text = _local4.text;
                _local3.title = _local4.title;
                _local3.platform = _local4.platform;
                _local3.weight = _local4.weight;
                this.model.addInGameNews(_local3);
            }
        } catch (e:Error) {
        }
        var _local2:InGameNews = this.model.getFirstNews();
        if (_local2 && _local2.showAtStartup && this.model.hasUpdates()) {
            this.addToQueueSignal.dispatch("news_popup", this.openDialogSignal, -1, new NewsModal(true));
        }
        completeTask(true);
    }
}
}
