package kabam.rotmg.arena.view {
import flash.display.Sprite;
import flash.filters.DropShadowFilter;

import kabam.rotmg.text.view.StaticTextDisplay;
import kabam.rotmg.text.view.stringBuilder.LineBuilder;

public class ArenaWaveCounter extends Sprite {


    private const waveText:StaticTextDisplay = makeWaveText();

    private const waveStringBuilder:LineBuilder = new LineBuilder();

    public function ArenaWaveCounter() {
        super();
    }

    public function setWaveNumber(_arg_1:int):void {
        this.waveText.setStringBuilder(this.waveStringBuilder.setParams("ArenaLeaderboardListItem.waveNumber", {"waveNumber": _arg_1}));
    }

    private function makeWaveText():StaticTextDisplay {
        var _local1:StaticTextDisplay = new StaticTextDisplay();
        _local1.setSize(24).setBold(true).setColor(0xffffff);
        _local1.filters = [new DropShadowFilter(0, 0, 0, 1, 8, 8)];
        addChild(_local1);
        return _local1;
    }
}
}
