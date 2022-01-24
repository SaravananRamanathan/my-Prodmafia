package kabam.rotmg.arena.view {
import com.company.assembleegameclient.ui.DeprecatedTextButton;

import flash.display.BitmapData;
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;

import kabam.rotmg.arena.component.ArenaQueryDialogHost;
import kabam.rotmg.arena.util.ArenaViewAssetFactory;
import kabam.rotmg.pets.view.components.PopupWindowBackground;
import kabam.rotmg.text.view.TextFieldDisplayConcrete;
import kabam.rotmg.text.view.stringBuilder.LineBuilder;
import kabam.rotmg.ui.view.SignalWaiter;
import kabam.rotmg.util.graphics.ButtonLayoutHelper;

import org.osflash.signals.natives.NativeSignal;

public class HostQueryDialog extends Sprite {

    public static const WIDTH:int = 274;

    public static const HEIGHT:int = 338;

    public static const TITLE:String = "ArenaQueryPanel.title";

    public static const CLOSE:String = "Close.text";

    public static const QUERY:String = "ArenaQueryDialog.info";

    public static const BACK:String = "Screens.back";


    private const layoutWaiter:SignalWaiter = makeDeferredLayout();

    private const container:DisplayObjectContainer = makeContainer();

    private const background:PopupWindowBackground = makeBackground();

    private const host:ArenaQueryDialogHost = makeHost();

    private const title:TextFieldDisplayConcrete = makeTitle();

    private const backButton:DeprecatedTextButton = makeBackButton();

    public const backClick:NativeSignal = new NativeSignal(backButton, "click");

    public function HostQueryDialog() {
        super();
    }

    public function setHostIcon(_arg_1:BitmapData):void {
        this.host.setHostIcon(_arg_1);
    }

    private function makeDeferredLayout():SignalWaiter {
        var _local1:SignalWaiter = new SignalWaiter();
        _local1.complete.addOnce(this.onLayout);
        return _local1;
    }

    private function onLayout():void {
        var _local1:ButtonLayoutHelper = new ButtonLayoutHelper();
        _local1.layout(274, this.backButton);
    }

    private function makeContainer():DisplayObjectContainer {
        var _local1:* = null;
        _local1 = new Sprite();
        _local1.x = 263;
        _local1.y = 131;
        addChild(_local1);
        return _local1;
    }

    private function makeBackground():PopupWindowBackground {
        var _local1:PopupWindowBackground = new PopupWindowBackground();
        _local1.draw(274, 338);
        _local1.divide("HORIZONTAL_DIVISION", 34);
        this.container.addChild(_local1);
        return _local1;
    }

    private function makeHost():ArenaQueryDialogHost {
        var _local1:* = null;
        _local1 = new ArenaQueryDialogHost();
        _local1.x = 20;
        _local1.y = 50;
        this.container.addChild(_local1);
        return _local1;
    }

    private function makeTitle():TextFieldDisplayConcrete {
        var _local1:* = null;
        _local1 = ArenaViewAssetFactory.returnTextfield(0xffffff, 18, true);
        _local1.setStringBuilder(new LineBuilder().setParams("ArenaQueryPanel.title"));
        _local1.setAutoSize("center");
        _local1.x = 137;
        _local1.y = 24;
        this.container.addChild(_local1);
        return _local1;
    }

    private function makeBackButton():DeprecatedTextButton {
        var _local1:* = null;
        _local1 = new DeprecatedTextButton(16, "Screens.back", 80);
        this.container.addChild(_local1);
        this.layoutWaiter.push(_local1.textChanged);
        _local1.y = 292;
        return _local1;
    }

    private function makeCloseButton():DeprecatedTextButton {
        var _local1:* = null;
        _local1 = new DeprecatedTextButton(16, "Close.text", 110);
        _local1.y = 292;
        this.container.addChild(_local1);
        this.layoutWaiter.push(_local1.textChanged);
        return _local1;
    }
}
}
