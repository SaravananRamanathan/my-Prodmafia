package kabam.rotmg.characters.reskin.view {
import com.company.assembleegameclient.game.GameSprite;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.ui.DeprecatedTextButton;
import com.company.assembleegameclient.ui.panels.Panel;

import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.filters.DropShadowFilter;

import kabam.rotmg.text.view.TextFieldDisplayConcrete;
import kabam.rotmg.text.view.stringBuilder.LineBuilder;

import org.osflash.signals.Signal;
import org.osflash.signals.natives.NativeMappedSignal;

public class ReskinPanel extends Panel {


    private const title:TextFieldDisplayConcrete = makeTitle();

    private const button:DeprecatedTextButton = makeButton();

    private const click:Signal = new NativeMappedSignal(button, "click");

    public const reskin:Signal = new Signal();

    public function ReskinPanel(_arg_1:GameSprite = null) {
        super(_arg_1);
        this.click.add(this.onClick);
        addEventListener("addedToStage", this.onAddedToStage);
        addEventListener("removedFromStage", this.onRemovedFromStage);
    }

    private function onClick():void {
        this.reskin.dispatch();
    }

    private function makeTitle():TextFieldDisplayConcrete {
        var _local1:* = null;
        _local1 = new TextFieldDisplayConcrete().setSize(18).setColor(0xffffff).setAutoSize("center");
        _local1.x = 94;
        _local1.y = 6;
        _local1.setBold(true);
        _local1.filters = [new DropShadowFilter(0, 0, 0)];
        _local1.setStringBuilder(new LineBuilder().setParams("ReskinPanel.changeSkin"));
        addChild(_local1);
        return _local1;
    }

    private function makeButton():DeprecatedTextButton {
        var _local1:DeprecatedTextButton = new DeprecatedTextButton(16, "ReskinPanel.choose");
        _local1.textChanged.addOnce(this.onTextSet);
        addChild(_local1);
        return _local1;
    }

    private function onTextSet():void {
        this.button.x = 94 - this.button.width * 0.5;
        this.button.y = 84 - this.button.height - 4;
    }

    private function onAddedToStage(_arg_1:Event):void {
        removeEventListener("addedToStage", this.onAddedToStage);
        stage.addEventListener("keyDown", this.onKeyDown);
    }

    private function onRemovedFromStage(_arg_1:Event):void {
        removeEventListener("removedFromStage", this.onRemovedFromStage);
        stage.removeEventListener("keyDown", this.onKeyDown);
    }

    private function onKeyDown(_arg_1:KeyboardEvent):void {
        if (_arg_1.keyCode == Parameters.data.interact && stage.focus == null) {
            this.reskin.dispatch();
        }
    }
}
}
