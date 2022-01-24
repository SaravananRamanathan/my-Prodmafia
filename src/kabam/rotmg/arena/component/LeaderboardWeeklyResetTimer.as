package kabam.rotmg.arena.component {
import flash.display.Sprite;
import flash.events.TimerEvent;
import flash.filters.DropShadowFilter;
import flash.utils.Timer;

import kabam.rotmg.text.view.StaticTextDisplay;
import kabam.rotmg.text.view.stringBuilder.LineBuilder;

public class LeaderboardWeeklyResetTimer extends Sprite {


    private const MONDAY:Number = 1;

    private const UTC_COUNTOFF_HOUR:Number = 7;

    public function LeaderboardWeeklyResetTimer() {
        this.differenceMilliseconds = this.makeDifferenceMilliseconds();
        this.resetClock = this.makeResetClockDisplay();
        this.resetClockStringBuilder = new LineBuilder();
        super();
        addChild(this.resetClock);
        this.resetClock.setStringBuilder(this.resetClockStringBuilder.setParams("LeaderboardWeeklyResetTime.label", {"time": this.getDateString()}));
        this.updateTimer = new Timer(1000);
        this.updateTimer.addEventListener("timer", this.onUpdateTime);
        this.updateTimer.start();
    }
    private var differenceMilliseconds:Number;
    private var updateTimer:Timer;
    private var resetClock:StaticTextDisplay;
    private var resetClockStringBuilder:LineBuilder;

    private function getDateString():String {
        var _local6:int = this.differenceMilliseconds;
        var _local2:int = Math.floor(_local6 / 86400000);
        _local6 = _local6 % 86400000;
        var _local1:int = Math.floor(_local6 / 3600000);
        _local6 = _local6 % 3600000;
        var _local4:int = Math.floor(_local6 / 60000);
        _local6 = _local6 % 60000;
        var _local3:int = Math.floor(_local6 / 1000);
        var _local5:* = "";
        if (_local2 > 0) {
            _local5 = _local2 + " days, " + _local1 + " hours, " + _local4 + " minutes";
        } else {
            _local5 = _local1 + " hours, " + _local4 + " minutes, " + _local3 + " seconds";
        }
        return _local5;
    }

    private function makeDifferenceMilliseconds():Number {
        var _local1:Date = new Date();
        var _local2:Date = this.makeResetDate();
        return _local2.getTime() - _local1.getTime();
    }

    private function makeResetDate():Date {
        var _local1:Date = new Date();
        if (_local1.dayUTC == 1 && _local1.hoursUTC < 7) {
            _local1.setUTCHours(7 - _local1.hoursUTC);
            return _local1;
        }
        _local1.setUTCHours(7);
        _local1.setUTCMinutes(0);
        _local1.setUTCSeconds(0);
        _local1.setUTCMilliseconds(0);
        _local1.setUTCDate(_local1.dateUTC + 1);
        while (_local1.dayUTC != 1) {
            _local1.setUTCDate(_local1.dateUTC + 1);
        }
        return _local1;
    }

    private function makeResetClockDisplay():StaticTextDisplay {
        var _local1:StaticTextDisplay = new StaticTextDisplay();
        _local1.setSize(14).setColor(16567065).setBold(true);
        _local1.filters = [new DropShadowFilter(0, 0, 0, 1, 8, 8)];
        return _local1;
    }

    private function onUpdateTime(_arg_1:TimerEvent):void {
        this.differenceMilliseconds = this.differenceMilliseconds - 1000;
        this.resetClock.setStringBuilder(this.resetClockStringBuilder.setParams("LeaderboardWeeklyResetTime.label", {"time": this.getDateString()}));
    }
}
}
