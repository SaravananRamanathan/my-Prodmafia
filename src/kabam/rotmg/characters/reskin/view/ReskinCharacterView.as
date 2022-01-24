package kabam.rotmg.characters.reskin.view {
import com.company.assembleegameclient.ui.DeprecatedTextButton;

import flash.display.DisplayObject;
import flash.display.Sprite;

import kabam.rotmg.classes.view.CharacterSkinListView;
import kabam.rotmg.text.view.TextFieldDisplayConcrete;
import kabam.rotmg.text.view.stringBuilder.LineBuilder;
import kabam.rotmg.ui.view.SignalWaiter;
import kabam.rotmg.util.components.DialogBackground;
import kabam.rotmg.util.graphics.ButtonLayoutHelper;

import org.osflash.signals.Signal;
import org.osflash.signals.natives.NativeMappedSignal;

public class ReskinCharacterView extends Sprite {

    private static const MARGIN:int = 10;

    private static const DIALOG_WIDTH:int = 462;

    private static const BUTTON_WIDTH:int = 120;

    private static const BUTTON_FONT:int = 16;

    private static const BUTTONS_HEIGHT:int = 40;

    private static const TITLE_OFFSET:int = 27;


    private const layoutListener:SignalWaiter = makeLayoutWaiter();

    private const background:DialogBackground = makeBackground();

    private const title:TextFieldDisplayConcrete = makeTitle();

    private const list:CharacterSkinListView = makeListView();

    private const cancel:DeprecatedTextButton = makeCancelButton();

    private const select:DeprecatedTextButton = makeSelectButton();

    public const cancelled:Signal = new NativeMappedSignal(cancel, "click");

    public const selected:Signal = new NativeMappedSignal(select, "click");

    public function ReskinCharacterView() {
        super();
    }
    public var viewHeight:int;

    public function setList(_arg_1:Vector.<DisplayObject>):void {
        this.list.setItems(_arg_1);
        this.getDialogHeight();
        this.resizeBackground();
        this.positionButtons();
    }

    private function makeLayoutWaiter():SignalWaiter {
        var _local1:SignalWaiter = new SignalWaiter();
        _local1.complete.add(this.positionButtons);
        return _local1;
    }

    private function makeBackground():DialogBackground {
        var _local1:DialogBackground = new DialogBackground();
        addChild(_local1);
        return _local1;
    }

    private function makeTitle():TextFieldDisplayConcrete {
        var _local1:TextFieldDisplayConcrete = new TextFieldDisplayConcrete().setSize(18).setColor(0xb6b6b6).setTextWidth(462);
        _local1.setAutoSize("center").setBold(true);
        _local1.setStringBuilder(new LineBuilder().setParams("ReskinCharacterView.title"));
        _local1.y = 5;
        addChild(_local1);
        return _local1;
    }

    private function makeListView():CharacterSkinListView {
        var _local1:* = null;
        _local1 = new CharacterSkinListView();
        _local1.x = 10;
        _local1.y = 37;
        addChild(_local1);
        return _local1;
    }

    private function makeCancelButton():DeprecatedTextButton {
        var _local1:DeprecatedTextButton = new DeprecatedTextButton(16, "ReskinCharacterView.cancel", 2 * 60);
        addChild(_local1);
        this.layoutListener.push(_local1.textChanged);
        return _local1;
    }

    private function makeSelectButton():DeprecatedTextButton {
        var _local1:DeprecatedTextButton = new DeprecatedTextButton(16, "ReskinCharacterView.select", 2 * 60);
        addChild(_local1);
        this.layoutListener.push(_local1.textChanged);
        return _local1;
    }

    private function getDialogHeight():void {
        this.viewHeight = Math.min(410, this.list.getListHeight());
        this.viewHeight = this.viewHeight + 87;
    }

    private function resizeBackground():void {
        this.background.draw(462, this.viewHeight);
        this.background.graphics.lineStyle(2, 0x5b5b5b, 1, false, "none", "none", "bevel");
        this.background.graphics.moveTo(1, 27);
        this.background.graphics.lineTo(461, 27);
    }

    private function positionButtons():void {
        var _local2:ButtonLayoutHelper = new ButtonLayoutHelper();
        _local2.layout(462, this.cancel, this.select);
        var _local1:* = this.viewHeight - 40;
        this.select.y = _local1;
        this.cancel.y = _local1;
    }
}
}
