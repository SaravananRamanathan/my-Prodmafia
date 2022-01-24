package kabam.rotmg.news.services {
import com.company.assembleegameclient.parameters.Parameters;

import flash.utils.getTimer;

import kabam.lib.tasks.BaseTask;
import kabam.rotmg.appengine.api.AppEngineClient;
import kabam.rotmg.language.model.LanguageModel;
import kabam.rotmg.news.model.NewsCellLinkType;
import kabam.rotmg.news.model.NewsCellVO;
import kabam.rotmg.news.model.NewsModel;

public class GetAppEngineNewsTask extends BaseTask implements GetNewsTask {

    private static const TEN_MINUTES:int = 600;

    public function GetAppEngineNewsTask() {
        super();
    }
    [Inject]
    public var client:AppEngineClient;
    [Inject]
    public var model:NewsModel;
    [Inject]
    public var languageModel:LanguageModel;
    private var lastRan:int = -1;
    private var numUpdateAttempts:int = 0;
    private var updateCooldown:int = 600;

    override protected function startTask():void {
        this.numUpdateAttempts++;
        var _local1:Number = getTimer() * 0.001;
        if (this.lastRan == -1 || this.lastRan + this.updateCooldown < _local1) {
            this.lastRan = _local1;
            this.client.complete.addOnce(this.onComplete);
            this.client.sendRequest("/app/globalNews", {"language": this.languageModel.getLanguage()});
        } else {
            completeTask(true);
            reset();
        }
    }

    private function onComplete(_arg_1:Boolean, _arg_2:*):void {
        if (_arg_1) {
            this.onNewsRequestDone(_arg_2);
        }
        completeTask(_arg_1, _arg_2);
        reset();
    }

    private function onNewsRequestDone(_arg_1:String):void {
        var _local2:Vector.<NewsCellVO> = new Vector.<NewsCellVO>();
        var _local3:Object = JSON.parse(_arg_1);
        for each(var _local4:Object in _local3) {
            _local2.push(this.returnNewsCellVO(_local4));
        }
        this.model.updateNews(_local2);
    }

    private function returnNewsCellVO(_arg_1:Object):NewsCellVO {
        var _local2:NewsCellVO = new NewsCellVO();
        _local2.headline = _arg_1.title;
        _local2.imageURL = _arg_1.image;
        _local2.linkDetail = _arg_1.linkDetail;
        _local2.startDate = _arg_1.startTime;
        _local2.endDate = _arg_1.endTime;
        _local2.linkType = NewsCellLinkType.parse(_arg_1.linkType);
        _local2.networks = _arg_1.platform.split(",");
        _local2.priority = _arg_1.priority;
        _local2.slot = _arg_1.slot;
        return _local2;
    }
}
}
