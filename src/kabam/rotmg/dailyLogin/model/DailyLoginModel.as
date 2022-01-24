package kabam.rotmg.dailyLogin.model {
import io.decagames.rotmg.utils.date.TimeSpan;

public class DailyLoginModel {

    public static const DAY_IN_MILLISECONDS:Number = 86400000;

    public function DailyLoginModel() {
        daysConfig = {};
        userDayConfig = {};
        currentDayConfig = {};
        maxDayConfig = {};
        sortAsc = function (param1:CalendarDayModel, param2:CalendarDayModel):Number {
            if (param1.dayNumber < param2.dayNumber) {
                return -1;
            }
            if (param1.dayNumber > param2.dayNumber) {
                return 1;
            }
            return 0;
        };
        super();
        this.clear();
    }
    public var shouldDisplayCalendarAtStartup:Boolean;
    public var currentDisplayedCaledar:String;
    private var serverTimestamp:Number;
    private var serverMeasureTime:Number;
    private var daysConfig:Object;
    private var userDayConfig:Object;
    private var currentDayConfig:Object;
    private var maxDayConfig:Object;
    private var _currentDay:int = -1;
    private var sortAsc:Function;
    private var _currentDate:Date;
    private var _nextDay:Date;

    private var _initialized:Boolean;

    public function get initialized():Boolean {
        return this._initialized;
    }

    public function get daysLeftToCalendarEnd():int {
        var _local3:Date = this.getServerTime();
        var _local2:int = _local3.getDate();
        var _local1:int = this.getDayCount(_local3.fullYear, _local3.month + 1);
        return _local1 - _local2;
    }

    public function get overallMaxDays():int {
        var _local2:int = 0;
        var _local1:* = 0;
        var _local4:int = 0;
        var _local3:* = this.maxDayConfig;
        for each(_local2 in this.maxDayConfig) {
            if (_local2 > _local1) {
                _local1 = _local2;
            }
        }
        return _local1;
    }

    public function setServerTime(_arg_1:Number):void {
        this.serverTimestamp = _arg_1;
        this.serverMeasureTime = new Date().getTime();
    }

    public function hasCalendar(_arg_1:String):Boolean {
        return this.daysConfig[_arg_1].length > 0;
    }

    public function getServerUTCTime():Date {
        var _local1:Date = new Date();
        _local1.setUTCMilliseconds(this.serverTimestamp);
        return _local1;
    }

    public function getServerTime():Date {
        var _local1:Date = new Date();
        _local1.setTime(this.serverTimestamp + (_local1.getTime() - this.serverMeasureTime));
        return _local1;
    }

    public function getTimestampDay():int {
        return Math.floor(this.getServerTime().getTime() / 86400000);
    }

    public function addDay(_arg_1:CalendarDayModel, _arg_2:String):void {
        this._initialized = true;
        this.daysConfig[_arg_2].push(_arg_1);
    }

    public function setUserDay(_arg_1:int, _arg_2:String):void {
        this.userDayConfig[_arg_2] = _arg_1;
    }

    public function calculateCalendar(_arg_1:String):void {
        var _local5:* = null;
        var _local2:Vector.<CalendarDayModel> = this.sortCalendar(this.daysConfig[_arg_1]);
        var _local6:int = _local2.length;
        this.daysConfig[_arg_1] = _local2;
        this.maxDayConfig[_arg_1] = _local2[_local6 - 1].dayNumber;
        var _local4:Vector.<CalendarDayModel> = new Vector.<CalendarDayModel>();
        var _local3:int = 1;
        while (_local3 <= this.maxDayConfig[_arg_1]) {
            _local5 = this.getDayByNumber(_arg_1, _local3);
            if (_local3 == this.userDayConfig[_arg_1]) {
                _local5.isCurrent = true;
            }
            _local4.push(_local5);
            _local3++;
        }
        this.daysConfig[_arg_1] = _local4;
    }

    public function getDaysConfig(_arg_1:String):Vector.<CalendarDayModel> {
        return this.daysConfig[_arg_1];
    }

    public function getMaxDays(_arg_1:String):int {
        return this.maxDayConfig[_arg_1];
    }

    public function markAsClaimed(_arg_1:int, _arg_2:String):void {
        this.daysConfig[_arg_2][_arg_1 - 1].isClaimed = true;
    }

    public function clear():void {
        this.daysConfig["consecutive"] = new Vector.<CalendarDayModel>();
        this.daysConfig["nonconsecutive"] = new Vector.<CalendarDayModel>();
        this.daysConfig["unlock"] = new Vector.<CalendarDayModel>();
        this.shouldDisplayCalendarAtStartup = false;
    }

    public function getCurrentDay(_arg_1:String):int {
        return this.currentDayConfig[_arg_1];
    }

    public function setCurrentDay(_arg_1:String, _arg_2:int):void {
        this.currentDayConfig[_arg_1] = _arg_2;
    }

    public function getFormatedQuestRefreshTime():String {
        this._currentDate = this.getServerTime();
        this._nextDay = new Date();
        this._nextDay.setTime(this._currentDate.valueOf() + 24 * 60 * 60 * 1000);
        this._nextDay.setUTCHours(0);
        this._nextDay.setUTCMinutes(0);
        this._nextDay.setUTCSeconds(0);
        this._nextDay.setUTCMilliseconds(0);
        var _local1:TimeSpan = new TimeSpan(this._nextDay.valueOf() - this._currentDate.valueOf());
        return (_local1.hours > 9 ? _local1.hours.toString() : "0" + _local1.hours.toString()) + "h " + (_local1.minutes > 9 ? _local1.minutes.toString() : "0" + _local1.minutes.toString()) + "m";
    }

    private function getDayCount(_arg_1:int, _arg_2:int):int {
        var _local3:Date = new Date(_arg_1, _arg_2, 0);
        return _local3.getDate();
    }

    private function getDayByNumber(_arg_1:String, _arg_2:int):CalendarDayModel {
        var _local3:* = null;
        var _local5:int = 0;
        var _local4:* = this.daysConfig[_arg_1];
        for each(_local3 in this.daysConfig[_arg_1]) {
            if (_local3.dayNumber == _arg_2) {
                return _local3;
            }
        }
        return new CalendarDayModel(_arg_2, -1, 0, 0, false, _arg_1);
    }

    private function sortCalendar(_arg_1:Vector.<CalendarDayModel>):Vector.<CalendarDayModel> {
        return _arg_1.sort(this.sortAsc);
    }
}
}
