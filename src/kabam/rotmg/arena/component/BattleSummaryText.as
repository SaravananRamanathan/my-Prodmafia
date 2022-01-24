package kabam.rotmg.arena.component {
import flash.display.Sprite;
import flash.filters.DropShadowFilter;

import kabam.rotmg.text.view.StaticTextDisplay;
import kabam.rotmg.text.view.stringBuilder.LineBuilder;
import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;

public class BattleSummaryText extends Sprite {


    public function BattleSummaryText(_arg_1:String, _arg_2:int, _arg_3:int) {
        this.titleText = this.makeTitleText();
        this.waveText = this.makeSubtitleText();
        this.timeText = this.makeSubtitleText();
        super();
        this.titleText.setStringBuilder(new LineBuilder().setParams(_arg_1));
        this.waveText.setStringBuilder(new LineBuilder().setParams("BattleSummaryText.waveNumber", {"waveNumber": _arg_2 - 1}));
        this.timeText.setStringBuilder(new StaticStringBuilder(this.createTimerString(_arg_3)));
        this.align();
    }
    private var titleText:StaticTextDisplay;
    private var waveText:StaticTextDisplay;
    private var timeText:StaticTextDisplay;

    private function align():void {
        this.titleText.x = width / 2 - this.titleText.width / 2;
        this.waveText.y = this.titleText.height + 10;
        this.waveText.x = width / 2 - this.waveText.width / 2;
        this.timeText.y = this.waveText.y + this.waveText.height + 5;
        this.timeText.x = width / 2 - this.timeText.width / 2;
    }

    private function createTimerString(_arg_1:int):String {
        var _local2:int = _arg_1 / 60;
        var _local4:int = _arg_1 % 60;
        var _local3:String = _local2 < 10 ? "0" : "";
        _local3 = _local3 + (_local2 + ":");
        _local3 = _local3 + (_local4 < 10 ? "0" : "");
        _local3 = _local3 + _local4;
        return _local3;
    }

    private function makeTitleText():StaticTextDisplay {
        var _local1:* = null;
        _local1 = new StaticTextDisplay();
        _local1.setSize(16).setBold(true).setColor(0xffffff);
        _local1.filters = [new DropShadowFilter(0, 0, 0, 1, 8, 8)];
        addChild(_local1);
        return _local1;
    }

    private function makeSubtitleText():StaticTextDisplay {
        var _local1:StaticTextDisplay = new StaticTextDisplay();
        _local1.setSize(14).setBold(true).setColor(0xb3b3b3);
        _local1.filters = [new DropShadowFilter(0, 0, 0, 1, 8, 8)];
        addChild(_local1);
        return _local1;
    }
}
}
