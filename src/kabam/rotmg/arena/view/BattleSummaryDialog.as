package kabam.rotmg.arena.view {
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;

import kabam.rotmg.arena.component.BattleSummaryText;
import kabam.rotmg.editor.view.StaticTextButton;
import kabam.rotmg.text.view.StaticTextDisplay;
import kabam.rotmg.text.view.stringBuilder.LineBuilder;
import kabam.rotmg.util.components.DialogBackground;

import org.osflash.signals.Signal;

public class BattleSummaryDialog extends Sprite {


    private const WIDTH:int = 264;

    private const HEIGHT:int = 302;

    public const close:Signal = new Signal();

    private const background:DialogBackground = makeBackground();

    private const splashArt:Class = makeSplashArt();

    public function BattleSummaryDialog() {
        BattleSummarySplash = BattleSummaryDialog_BattleSummarySplash;
        this.titleText = this.makeTitle();
        this.closeButton = this.makeButton();
        super();
        this.drawHorizontalDivide(25);
        this.drawHorizontalDivide(132);
        this.drawHorizontalDivide(252);
        this.makeVerticalDivide();
    }
    private var leftSummary:BattleSummaryText;
    private var rightSummary:BattleSummaryText;
    private var titleText:StaticTextDisplay;
    private var closeButton:StaticTextButton;
    private var BattleSummarySplash:Class;

    public function positionThis():void {
        x = (stage.stageWidth - 264) * 0.5;
        y = (stage.stageHeight - 302) * 0.5;
    }

    public function setCurrentRun(_arg_1:int, _arg_2:int):void {
        if (this.leftSummary) {
            removeChild(this.leftSummary);
        }
        this.leftSummary = new BattleSummaryText("BattleSummaryDialog.currentSubtitle", _arg_1, _arg_2);
        this.leftSummary.y = 60 - this.leftSummary.height / 2 + 132;
        this.leftSummary.x = 66 - this.leftSummary.width / 2;
        addChild(this.leftSummary);
    }

    public function setBestRun(_arg_1:int, _arg_2:int):void {
        if (this.rightSummary) {
            removeChild(this.rightSummary);
        }
        this.rightSummary = new BattleSummaryText("BattleSummaryDialog.bestSubtitle", _arg_1, _arg_2);
        this.rightSummary.y = 60 - this.rightSummary.height / 2 + 132;
        this.rightSummary.x = 66 - this.rightSummary.width / 2 + 132;
        addChild(this.rightSummary);
    }

    private function makeBackground():DialogBackground {
        var _local1:DialogBackground = new DialogBackground();
        _local1.draw(264, 302);
        addChild(_local1);
        return _local1;
    }

    private function makeVerticalDivide():void {
        this.background.graphics.lineStyle();
        this.background.graphics.beginFill(0x666666, 1);
        this.background.graphics.drawRect(132, 132, 2, 2 * 60);
        this.background.graphics.endFill();
    }

    private function drawHorizontalDivide(_arg_1:int):void {
        this.background.graphics.lineStyle();
        this.background.graphics.beginFill(0x666666, 1);
        this.background.graphics.drawRect(1, _arg_1, this.background.width - 2, 2);
        this.background.graphics.endFill();
    }

    private function makeSplashArt():Class {
        var _local1:Class = new this.BattleSummarySplash();
        _local1.y = 27;
        _local1.x = 2;
        addChild(_local1 as Sprite);
        return _local1;
    }

    private function makeTitle():StaticTextDisplay {
        var _local1:* = null;
        _local1 = new StaticTextDisplay();
        _local1.setSize(18).setBold(true).setColor(0xb3b3b3);
        _local1.setStringBuilder(new LineBuilder().setParams("BattleSummaryDialog.title"));
        _local1.filters = [new DropShadowFilter(0, 0, 0, 1, 8, 8)];
        _local1.x = (264 - _local1.width) * 0.5;
        _local1.y = 3;
        addChild(_local1);
        return _local1;
    }

    private function makeButton():StaticTextButton {
        var _local1:* = null;
        _local1 = new StaticTextButton(16, "BattleSummaryDialog.close", 100);
        _local1.addEventListener("click", this.closeClicked);
        _local1.y = 302 - _local1.height - 10;
        _local1.x = 132 - _local1.width / 2;
        addChild(_local1);
        return _local1;
    }

    private function closeClicked(_arg_1:MouseEvent):void {
        this.closeButton.removeEventListener("click", this.closeClicked);
        this.close.dispatch();
    }
}
}
