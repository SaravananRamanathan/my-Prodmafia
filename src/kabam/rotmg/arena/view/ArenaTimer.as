package kabam.rotmg.arena.view {
import flash.display.Sprite;
import flash.events.TimerEvent;
import flash.filters.DropShadowFilter;
import flash.utils.Timer;

import kabam.rotmg.text.view.StaticTextDisplay;
import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;

public class ArenaTimer extends Sprite {


    private const timerText:StaticTextDisplay = makeTimerText();

    private const timerStringBuilder:StaticStringBuilder = new StaticStringBuilder();

    private const timer:Timer = new Timer(1000);

    public function ArenaTimer() {
        super();
    }
    private var secs:Number = 0;

    public function start():void {
        this.updateTimer(null);
        this.timer.addEventListener("timer", this.updateTimer);
        this.timer.start();
    }

    public function stop():void {
        this.timer.removeEventListener("timer", this.updateTimer);
        this.timer.stop();
    }

    private function makeTimerText():StaticTextDisplay {
        var _local1:StaticTextDisplay = new StaticTextDisplay();
        _local1.setSize(24).setBold(true).setColor(0xffffff);
        _local1.filters = [new DropShadowFilter(0, 0, 0, 1, 8, 8)];
        addChild(_local1);
        return _local1;
    }

    private function updateTimer(_arg_1:TimerEvent):void {
        var _local2:int = this.secs / 60;
        var _local4:int = this.secs % 60;
        var _local3:String = _local2 < 10 ? "0" : "";
        _local3 = _local3 + (_local2 + ":");
        _local3 = _local3 + (_local4 < 10 ? "0" : "");
        _local3 = _local3 + _local4;
        this.timerText.setStringBuilder(this.timerStringBuilder.setString(_local3));
        this.secs++;
    }
}
}
