package kabam.rotmg.pets.view.components {
import flash.display.Sprite;
import flash.events.MouseEvent;

import org.osflash.signals.Signal;

public class DialogCloseButton extends Sprite {

    public const clicked:Signal = new Signal();
    public const closeClicked:Signal = new Signal();
    public static var CloseButtonAsset:Class = DialogCloseButton_CloseButtonAsset;
    public static var CloseButtonLargeAsset:Class = DialogCloseButton_CloseButtonLargeAsset;

    public function DialogCloseButton(_arg_1:Number = -1) {
        var _local2:* = null;
        super();
        if (_arg_1 < 0) {
            addChild(new CloseButtonAsset());
        } else {
            _local2 = new CloseButtonLargeAsset();
            addChild(new CloseButtonLargeAsset());
            scaleX = scaleX * _arg_1;
            scaleY = scaleY * _arg_1;
        }
        buttonMode = true;
        addEventListener("click", this.onClicked);
    }
    public var disabled:Boolean = false;

    public function setDisabled(_arg_1:Boolean):void {
        this.disabled = _arg_1;
        if (_arg_1) {
            removeEventListener("click", this.onClicked);
        } else {
            addEventListener("click", this.onClicked);
        }
    }

    public function disableLegacyCloseBehavior():void {
        this.disabled = true;
        removeEventListener("click", this.onClicked);
    }

    private function onClicked(_arg_1:MouseEvent):void {
        if (!this.disabled) {
            removeEventListener("click", this.onClicked);
            this.closeClicked.dispatch();
            this.clicked.dispatch();
        }
    }
}
}
