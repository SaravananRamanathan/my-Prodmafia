package kabam.rotmg.external.service {
import com.company.util.MoreObjectUtil;

import flash.events.TimerEvent;
import flash.utils.Timer;

import kabam.lib.tasks.BaseTask;
import kabam.rotmg.account.core.Account;
import kabam.rotmg.appengine.api.AppEngineClient;
import kabam.rotmg.core.model.PlayerModel;
import kabam.rotmg.game.model.GameModel;

public class RequestPlayerCreditsTask extends BaseTask {

    private static const REQUEST:String = "account/getCredits";

    public function RequestPlayerCreditsTask() {
        retryTimes = [2, 5, 15];
        timer = new Timer(1000);
        super();
    }
    [Inject]
    public var account:Account;
    [Inject]
    public var client:AppEngineClient;
    [Inject]
    public var gameModel:GameModel;
    [Inject]
    public var playerModel:PlayerModel;
    private var retryTimes:Array;
    private var timer:Timer;
    private var retryCount:int = 0;

    override protected function startTask():void {
        this.timer.addEventListener("timer", this.handleTimer);
        this.timer.start();
    }

    private function makeRequest():void {
        this.client.complete.addOnce(this.onComplete);
        this.client.sendRequest("account/getCredits", this.makeRequestObject());
    }

    private function onComplete(_arg_1:Boolean, _arg_2:*):void {
        var _local3:* = null;
        var _local4:Boolean = false;
        if (_arg_1) {
            _local3 = XML(_arg_2).toString();
            if (_local3 != "" && _local3.search("Error") != -1) {
                this.setCredits(parseInt(_local3));
            }
        } else if (this.retryCount < this.retryTimes.length) {
            this.timer.addEventListener("timer", this.handleTimer);
            this.timer.start();
            _local4 = true;
        }
    }

    private function setCredits(_arg_1:int):void {
        if (_arg_1 >= 0) {
            if (this.gameModel != null && this.gameModel.player != null && _arg_1 != this.gameModel.player.credits_) {
                this.gameModel.player.setCredits(_arg_1);
            } else if (this.playerModel != null && this.playerModel.getCredits() != _arg_1) {
                this.playerModel.setCredits(_arg_1);
            }
        }
    }

    private function makeRequestObject():Object {
        var _local1:* = {};
        MoreObjectUtil.addToObject(_local1, this.account.getCredentials());
        return _local1;
    }

    private function handleTimer(_arg_1:TimerEvent):void {
        var _local2:* = this.retryTimes;
        var _local3:* = this.retryCount;
        var _local4:* = Number(_local2[_local3]) - 1;
        _local2[_local3] = _local4;
        if (this.retryTimes[this.retryCount] <= 0) {
            this.timer.removeEventListener("timer", this.handleTimer);
            this.makeRequest();
            this.retryCount++;
            this.timer.stop();
        }
    }
}
}
