package kabam.rotmg.arena.view {
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;

import kabam.rotmg.editor.view.StaticTextButton;
import kabam.rotmg.text.view.StaticTextDisplay;
import kabam.rotmg.text.view.stringBuilder.LineBuilder;
import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;
import kabam.rotmg.util.components.DialogBackground;
import kabam.rotmg.util.components.LegacyBuyButton;

import org.osflash.signals.Signal;

public class ContinueOrQuitDialog extends Sprite {


    public const quit:Signal = new Signal();

    public const buyContinue:Signal = new Signal(int, int);

    private const WIDTH:int = 350;

    private const HEIGHT:int = 150;

    private const background:DialogBackground = makeBackground();

    private const title:StaticTextDisplay = makeTitle();

    private const quitSubtitle:StaticTextDisplay = makeSubtitle();

    private const quitButton:StaticTextButton = makeQuitButton();

    private const continueButton:LegacyBuyButton = makeContinueButton();

    private const restartSubtitle:StaticTextDisplay = makeSubtitle();

    private const processingText:StaticTextDisplay = makeSubtitle();

    public function ContinueOrQuitDialog(_arg_1:int, _arg_2:Boolean) {
        super();
        this.cost = _arg_1;
        this.continueButton.setPrice(_arg_1, 0);
        this.setProcessing(_arg_2);
    }
    private var cost:int;

    public function init(_arg_1:int, _arg_2:int):void {
        this.positionThis();
        this.quitButton.addEventListener("click", this.onQuit);
        this.continueButton.addEventListener("click", this.onBuyContinue);
        this.quitSubtitle.setStringBuilder(new LineBuilder().setParams("ContinueOrQuitDialog.quitSubtitle"));
        this.restartSubtitle.setStringBuilder(new LineBuilder().setParams("ContinueOrQuitDialog.continueSubtitle", {"waveNumber": _arg_1.toString()}));
        this.processingText.setStringBuilder(new StaticStringBuilder("Processing"));
        this.processingText.visible = false;
        this.align();
        this.makeHorizontalLine();
        this.makeVerticalLine();
    }

    public function setProcessing(_arg_1:Boolean):void {
        this.processingText.visible = _arg_1;
        this.continueButton.visible = !_arg_1;
    }

    public function destroy():void {
        this.quitButton.removeEventListener("click", this.onQuit);
        this.continueButton.removeEventListener("click", this.onBuyContinue);
    }

    private function align():void {
        this.quitSubtitle.x = 70 - this.quitSubtitle.width / 2;
        this.quitSubtitle.y = 85;
        this.quitButton.x = 70 - this.quitButton.width / 2;
        this.quitButton.y = 110;
        this.restartSubtitle.x = 105 - this.restartSubtitle.width / 2 + 140;
        this.restartSubtitle.y = 85;
        this.continueButton.x = 105 - this.continueButton.width / 2 + 140;
        this.continueButton.y = 110;
        this.processingText.x = 105 - this.processingText.width / 2 + 140;
        this.processingText.y = 110;
    }

    private function positionThis():void {
        x = (stage.stageWidth - 350) * 0.5;
        y = (stage.stageHeight - 150) * 0.5;
    }

    private function makeBackground():DialogBackground {
        var _local1:DialogBackground = new DialogBackground();
        _local1.draw(350, 150);
        addChild(_local1);
        return _local1;
    }

    private function makeTitle():StaticTextDisplay {
        var _local1:StaticTextDisplay = new StaticTextDisplay();
        _local1.setSize(20).setBold(true).setColor(0xb3b3b3);
        _local1.setStringBuilder(new LineBuilder().setParams("ContinueOrQuitDialog.title"));
        _local1.filters = [new DropShadowFilter(0, 0, 0, 1, 8, 8)];
        _local1.x = (350 - _local1.width) * 0.5;
        _local1.y = 25;
        addChild(_local1);
        return _local1;
    }

    private function makeHorizontalLine():void {
        this.background.graphics.lineStyle();
        this.background.graphics.beginFill(0x666666, 1);
        this.background.graphics.drawRect(1, 70, this.background.width - 2, 2);
        this.background.graphics.endFill();
    }

    private function makeVerticalLine():void {
        this.background.graphics.lineStyle();
        this.background.graphics.beginFill(0x666666, 1);
        this.background.graphics.drawRect(140, 70, 2, 84);
        this.background.graphics.endFill();
    }

    private function makeQuitButton():StaticTextButton {
        var _local1:StaticTextButton = new StaticTextButton(15, "ContinueOrQuitDialog.exit");
        addChild(_local1);
        return _local1;
    }

    private function makeContinueButton():LegacyBuyButton {
        var _local1:LegacyBuyButton = new LegacyBuyButton("", 15, this.cost, 0);
        _local1.readyForPlacement.addOnce(this.align);
        addChild(_local1);
        return _local1;
    }

    private function makeSubtitle():StaticTextDisplay {
        var _local1:StaticTextDisplay = new StaticTextDisplay();
        _local1.setSize(15).setColor(0xffffff).setBold(true);
        _local1.filters = [new DropShadowFilter(0, 0, 0, 1, 8, 8)];
        addChild(_local1);
        return _local1;
    }

    private function onQuit(_arg_1:MouseEvent):void {
        this.quit.dispatch();
    }

    private function onBuyContinue(_arg_1:MouseEvent):void {
        this.buyContinue.dispatch(0, this.cost);
    }
}
}
