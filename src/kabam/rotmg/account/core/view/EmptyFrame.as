package kabam.rotmg.account.core.view {
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;

import io.decagames.rotmg.pets.utils.PetsViewAssetFactory;

import kabam.rotmg.pets.view.components.DialogCloseButton;
import kabam.rotmg.pets.view.components.PopupWindowBackground;
import kabam.rotmg.text.view.TextFieldDisplayConcrete;
import kabam.rotmg.text.view.stringBuilder.LineBuilder;
import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;

import org.osflash.signals.Signal;

public class EmptyFrame extends Sprite {

    public static const TEXT_MARGIN:int = 20;

    public function EmptyFrame(_arg_1:int = 288, _arg_2:int = 150, _arg_3:String = "") {
        super();
        this.modalWidth = _arg_1;
        this.modalHeight = _arg_2;
        x = WebMain.STAGE.stageWidth / 2 - this.modalWidth / 2;
        y = WebMain.STAGE.stageHeight / 2 - this.modalHeight / 2;
        if (_arg_3 != "") {
            this.setTitle(_arg_3, true);
        }
        if (this.background == null) {
            this.backgroundContainer = new Sprite();
            this.background = this.makeModalBackground();
            this.backgroundContainer.addChild(this.background);
            addChild(this.backgroundContainer);
        }
        if (_arg_3 != "") {
            this.setTitle(_arg_3, true);
        }
    }
    public var register:Signal;
    public var cancel:Signal;
    protected var modalWidth:Number;
    protected var modalHeight:Number;
    protected var closeButton:DialogCloseButton;
    protected var background:Sprite;
    protected var backgroundContainer:Sprite;
    protected var title:TextFieldDisplayConcrete;
    protected var desc:TextFieldDisplayConcrete;

    public function setWidth(_arg_1:Number):void {
        this.modalWidth = _arg_1;
        x = WebMain.STAGE.stageWidth / 2 - this.modalWidth / 2;
        this.refreshBackground();
    }

    public function setHeight(_arg_1:Number):void {
        this.modalHeight = _arg_1;
        y = WebMain.STAGE.stageHeight / 2 - this.modalHeight / 2;
        this.refreshBackground();
    }

    public function setTitle(_arg_1:String, _arg_2:Boolean):void {
        if (this.title != null && this.title.parent != null) {
            removeChild(this.title);
        }
        if (_arg_1 != null) {
            this.title = this.getText(_arg_1, 20, 5, _arg_2);
            addChild(this.title);
        } else {
            this.title = null;
        }
    }

    public function setDesc(_arg_1:String, _arg_2:Boolean):void {
        if (_arg_1 != null) {
            if (this.desc != null && this.desc.parent != null) {
                removeChild(this.desc);
            }
            this.desc = this.getText(_arg_1, 20, 50, _arg_2);
            addChild(this.desc);
        }
    }

    public function setCloseButton(_arg_1:Boolean):void {
        if (this.closeButton == null && _arg_1) {
            this.closeButton = PetsViewAssetFactory.returnCloseButton(this.modalWidth);
            this.closeButton.addEventListener("click", this.onCloseClick);
            addEventListener("removedFromStage", this.onRemovedFromStage);
            addChild(this.closeButton);
        } else if (this.closeButton != null && !_arg_1) {
            removeChild(this.closeButton);
            this.closeButton = null;
        }
    }

    public function alignAssets():void {
        this.desc.setTextWidth(this.modalWidth - 40);
        this.title.setTextWidth(this.modalWidth - 40);
    }

    protected function getText(_arg_1:String, _arg_2:int, _arg_3:int, _arg_4:Boolean):TextFieldDisplayConcrete {
        var _local5:* = null;
        _local5 = new TextFieldDisplayConcrete().setSize(16).setColor(0xffffff).setTextWidth(this.modalWidth - 40);
        _local5.setBold(true);
        if (_arg_4) {
            _local5.setStringBuilder(new StaticStringBuilder(_arg_1));
        } else {
            _local5.setStringBuilder(new LineBuilder().setParams(_arg_1));
        }
        _local5.setWordWrap(true);
        _local5.setMultiLine(true);
        _local5.setAutoSize("center");
        _local5.setHorizontalAlign("center");
        _local5.filters = [new DropShadowFilter(0, 0, 0)];
        _local5.x = _arg_2;
        _local5.y = _arg_3;
        return _local5;
    }

    protected function makeModalBackground():Sprite {
        x = WebMain.STAGE.stageWidth / 2 - this.modalWidth / 2;
        y = WebMain.STAGE.stageHeight / 2 - this.modalHeight / 2;
        var _local1:PopupWindowBackground = new PopupWindowBackground();
        _local1.draw(this.modalWidth, this.modalHeight, 0);
        if (this.title != null) {
            _local1.divide("HORIZONTAL_DIVISION", 30);
        }
        return _local1;
    }

    protected function refreshBackground():void {
        this.backgroundContainer.removeChild(this.background);
        this.background = this.makeModalBackground();
        this.backgroundContainer.addChild(this.background);
    }

    public function onCloseClick(_arg_1:MouseEvent):void {
    }

    private function onRemovedFromStage(_arg_1:Event):void {
        removeEventListener("removedFromStage", this.onRemovedFromStage);
        if (this.closeButton != null) {
            this.closeButton.removeEventListener("click", this.onCloseClick);
        }
    }
}
}
