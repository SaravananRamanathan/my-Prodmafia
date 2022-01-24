package kabam.rotmg.game.view {
import com.company.assembleegameclient.game.GameSprite;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.ui.DeprecatedTextButton;
import com.company.assembleegameclient.ui.RankText;
import com.company.assembleegameclient.ui.panels.Panel;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;

import kabam.rotmg.text.view.TextFieldDisplayConcrete;
import kabam.rotmg.text.view.stringBuilder.LineBuilder;
import kabam.rotmg.text.view.stringBuilder.StringBuilder;
import kabam.rotmg.util.components.LegacyBuyButton;

import org.osflash.signals.Signal;

public class NameChangerPanel extends Panel {


    public function NameChangerPanel(_arg_1:GameSprite, _arg_2:int) {
        var _local4:* = null;
        var _local3:* = null;
        chooseName = new Signal();
        super(_arg_1);
        if (this.hasMapAndPlayer()) {
            _local4 = gs_.map.player_;
            this.buy_ = _local4.nameChosen_;
            _local3 = this.createNameText();
            if (this.buy_) {
                this.handleAlreadyHasName(_local3);
            } else if (_local4.numStars_ < _arg_2) {
                this.handleInsufficientRank(_arg_2);
            } else {
                this.handleNoName();
            }
        }
        addEventListener("addedToStage", this.onAddedToStage);
    }
    public var chooseName:Signal;
    public var buy_:Boolean;
    private var title_:TextFieldDisplayConcrete;
    private var button_:Sprite;

    public function updateName(_arg_1:String):void {
        this.title_.setStringBuilder(this.makeNameText(_arg_1));
        this.title_.y = 0;
    }

    private function hasMapAndPlayer():Boolean {
        return gs_.map && gs_.map.player_;
    }

    private function createNameText():String {
        var _local1:* = null;
        _local1 = gs_.model.getName();
        this.title_ = new TextFieldDisplayConcrete().setSize(18).setColor(0xffffff).setTextWidth(188);
        this.title_.setBold(true).setWordWrap(true).setMultiLine(true).setHorizontalAlign("center");
        this.title_.filters = [new DropShadowFilter(0, 0, 0)];
        return _local1;
    }

    private function handleAlreadyHasName(_arg_1:String):void {
        this.title_.setStringBuilder(this.makeNameText(_arg_1));
        this.title_.y = 0;
        addChild(this.title_);
        var _local2:LegacyBuyButton = new LegacyBuyButton("NameChangerPanel.change", 16, 1000, 0);
        _local2.readyForPlacement.addOnce(this.positionButton);
        this.button_ = _local2;
        var _local3:* = 1000 <= gs_.map.player_.credits_;
        if (!_local3) {
            (this.button_ as LegacyBuyButton).setEnabled(_local3);
        } else {
            this.addListeners();
        }
        addChild(this.button_);
    }

    private function positionButton():void {
        this.button_.x = 94 - this.button_.width / 2;
        this.button_.y = 84 - this.button_.height / 2 - 17;
    }

    private function handleNoName():void {
        this.title_.setStringBuilder(new LineBuilder().setParams("NameChangerPanel.text"));
        this.title_.y = 6;
        addChild(this.title_);
        var _local1:DeprecatedTextButton = new DeprecatedTextButton(16, "NameChangerPanel.choose");
        _local1.textChanged.addOnce(this.positionTextButton);
        this.button_ = _local1;
        addChild(this.button_);
        this.addListeners();
    }

    private function positionTextButton():void {
        this.button_.x = 94 - this.button_.width / 2;
        this.button_.y = 84 - this.button_.height - 4;
    }

    private function addListeners():void {
        this.button_.addEventListener("click", this.onButtonClick);
    }

    private function handleInsufficientRank(_arg_1:int):void {
        var _local2:* = null;
        var _local4:* = null;
        var _local3:* = null;
        this.title_.setStringBuilder(new LineBuilder().setParams("NameChangerPanel.text"));
        addChild(this.title_);
        _local2 = new Sprite();
        _local4 = new TextFieldDisplayConcrete().setSize(16).setColor(0xffffff);
        _local4.setBold(true);
        _local4.setStringBuilder(new LineBuilder().setParams("NameChangerPanel.requireRank"));
        _local4.filters = [new DropShadowFilter(0, 0, 0)];
        _local2.addChild(_local4);
        _local3 = new RankText(_arg_1, false, false);
        _local3.x = _local4.width + 4;
        _local3.y = _local4.height / 2 - _local3.height / 2;
        _local2.addChild(_local3);
        _local2.x = 94 - _local2.width / 2;
        _local2.y = 84 - _local2.height / 2 - 20;
        addChild(_local2);
    }

    private function makeNameText(_arg_1:String):StringBuilder {
        return new LineBuilder().setParams("NameChangerPanel.yourName", {"name": _arg_1});
    }

    private function performAction():void {
        this.chooseName.dispatch();
    }

    private function onAddedToStage(_arg_1:Event):void {
        if (this.button_) {
            stage.addEventListener("keyDown", this.onKeyDown);
        }
        addEventListener("removedFromStage", this.onRemovedFromStage);
    }

    private function onRemovedFromStage(_arg_1:Event):void {
        stage.removeEventListener("keyDown", this.onKeyDown);
    }

    private function onKeyDown(_arg_1:KeyboardEvent):void {
        if (_arg_1.keyCode == Parameters.data.interact && stage.focus == null) {
            this.performAction();
        }
    }

    private function onButtonClick(_arg_1:MouseEvent):void {
        this.performAction();
    }
}
}
