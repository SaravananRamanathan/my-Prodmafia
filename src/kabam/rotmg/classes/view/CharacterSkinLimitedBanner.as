package kabam.rotmg.classes.view {
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.filters.DropShadowFilter;

import kabam.rotmg.text.view.TextFieldDisplayConcrete;
import kabam.rotmg.text.view.stringBuilder.LineBuilder;

import org.osflash.signals.Signal;

public class CharacterSkinLimitedBanner extends Sprite {

    private static const CharacterSkinLimitedBanner_LimitedBanner_:Class = CharacterSkinLimitedBanner_LimitedBanner;


    private const limitedText:TextFieldDisplayConcrete = makeText();

    private const limitedBanner:Class = makeLimitedBanner();

    public const readyForPositioning:Signal = new Signal();

    public function CharacterSkinLimitedBanner() {
        super();
    }

    public function layout():void {
        this.limitedText.y = height / 2 - this.limitedText.height / 2 + 1;
        this.limitedBanner.x = this.limitedText.x + this.limitedText.width;
        this.readyForPositioning.dispatch();
    }

    private function makeText():TextFieldDisplayConcrete {
        var _local1:* = null;
        _local1 = new TextFieldDisplayConcrete().setSize(16).setColor(0xb3b3b3).setBold(true);
        _local1.filters = [new DropShadowFilter(0, 0, 0, 1, 8, 8)];
        _local1.setStringBuilder(new LineBuilder().setParams("CharacterSkinListItem.limited"));
        _local1.textChanged.addOnce(this.layout);
        addChild(_local1);
        return _local1;
    }

    private function makeLimitedBanner():Class {
        var _local1:Class = new CharacterSkinLimitedBanner_LimitedBanner_();
        addChild(_local1 as DisplayObject);
        return _local1;
    }
}
}
