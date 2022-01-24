package kabam.rotmg.dailyLogin.tasks {
import com.company.assembleegameclient.parameters.Parameters;
import com.company.util.MoreObjectUtil;

import kabam.lib.tasks.BaseTask;
import kabam.rotmg.account.core.Account;
import kabam.rotmg.appengine.api.AppEngineClient;
import kabam.rotmg.build.api.BuildData;
import kabam.rotmg.build.api.BuildEnvironment;
import kabam.rotmg.core.signals.SetLoadingMessageSignal;
import kabam.rotmg.dailyLogin.model.CalendarDayModel;
import kabam.rotmg.dailyLogin.model.DailyLoginModel;

import robotlegs.bender.framework.api.ILogger;

public class FetchPlayerCalendarTask extends BaseTask {


    public function FetchPlayerCalendarTask() {
        super();
    }
    [Inject]
    public var account:Account;
    [Inject]
    public var logger:ILogger;
    [Inject]
    public var client:AppEngineClient;
    [Inject]
    public var setLoadingMessage:SetLoadingMessageSignal;
    [Inject]
    public var dailyLoginModel:DailyLoginModel;
    [Inject]
    public var buildData:BuildData;
    private var requestData:Object;

    override protected function startTask():void {
        this.logger.info("FetchPlayerCalendarTask start");
        this.requestData = this.makeRequestData();
        this.sendRequest();
    }

    public function makeRequestData():Object {
        var _local1:* = {};
        _local1.game_net_user_id = this.account.gameNetworkUserId();
        _local1.game_net = this.account.gameNetwork();
        _local1.play_platform = this.account.playPlatform();
        _local1.do_login = Parameters.sendLogin_;
        MoreObjectUtil.addToObject(_local1, this.account.getCredentials());
        return _local1;
    }

    private function sendRequest():void {
        this.client.complete.addOnce(this.onComplete);
        this.client.sendRequest("/dailyLogin/fetchCalendar", this.requestData);
    }

    private function onComplete(_arg_1:Boolean, _arg_2:*):void {
        if (_arg_1) {
            this.onCalendarUpdate(_arg_2);
        } else {
            this.onTextError(_arg_2);
        }
    }

    private function onCalendarUpdate(_arg_1:String):void {
        var _local3:* = null;
        var _local2:* = _arg_1;
        try {
            _local3 = new XML(_local2);
        } catch (e:Error) {
            completeTask(true);
            return;
        }
        this.dailyLoginModel.clear();
        var _local4:Number = parseFloat(_local3.attribute("serverTime")) * 1000;
        this.dailyLoginModel.setServerTime(_local4);
        if (!Parameters.data.calendarShowOnDay || Parameters.data.calendarShowOnDay < this.dailyLoginModel.getTimestampDay()) {
            this.dailyLoginModel.shouldDisplayCalendarAtStartup = true;
        }
        if (this.buildData.getEnvironment() == BuildEnvironment.LOCALHOST) {
        }
        if (_local3.hasOwnProperty("NonConsecutive") && _local3.NonConsecutive..Login.length() > 0) {
            this.parseCalendar(_local3.NonConsecutive, "nonconsecutive", _local3.attribute("nonconCurDay"));
        }
        if (_local3.hasOwnProperty("Consecutive") && _local3.Consecutive..Login.length() > 0) {
            this.parseCalendar(_local3.Consecutive, "consecutive", _local3.attribute("conCurDay"));
        }
        completeTask(true);
    }

    private function parseCalendar(_arg_1:XMLList, _arg_2:String, _arg_3:String):void {
        var _local5:* = null;
        var _local4:* = null;
        var _local7:int = 0;
        var _local6:* = _arg_1..Login;
        for each(_local5 in _arg_1..Login) {
            _local4 = this.getDayFromXML(_local5, _arg_2);
            if (_local5.hasOwnProperty("key")) {
                _local4.claimKey = _local5.key;
            }
            this.dailyLoginModel.addDay(_local4, _arg_2);
        }
        if (_arg_3) {
            this.dailyLoginModel.setCurrentDay(_arg_2, int(_arg_3));
        }
        this.dailyLoginModel.setUserDay(_arg_1.attribute("days"), _arg_2);
        this.dailyLoginModel.calculateCalendar(_arg_2);
    }

    private function getDayFromXML(_arg_1:XML, _arg_2:String):CalendarDayModel {
        return new CalendarDayModel(_arg_1.Days, _arg_1.ItemId, _arg_1.Gold, _arg_1.ItemId.attribute("quantity"), _arg_1.hasOwnProperty("Claimed"), _arg_2);
    }

    private function onTextError(_arg_1:String):void {
        completeTask(true);
    }
}
}
