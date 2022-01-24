package com.company.assembleegameclient.ui.options {
import com.company.assembleegameclient.parameters.Parameters;
import com.company.util.KeyCodes;

import flash.display.Graphics;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;
import flash.utils.getTimer;

import kabam.rotmg.text.view.TextFieldDisplayConcrete;
import kabam.rotmg.text.view.stringBuilder.LineBuilder;
import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;
import kabam.rotmg.text.view.stringBuilder.StringBuilder;

public class KeyCodeBox extends Sprite {

    public static const WIDTH:int = 80;

    public static const HEIGHT:int = 32;

    public function KeyCodeBox(_arg_1:uint, _arg_2:uint = 16777215) {
        super();
        this.keyCode_ = _arg_1;
        this.selected_ = false;
        this.inputMode_ = false;
        this.char_ = new TextFieldDisplayConcrete().setSize(16).setColor(_arg_2);
        this.char_.setBold(true);
        this.char_.filters = [new DropShadowFilter(0, 0, 0, 1, 4, 4, 2)];
        this.char_.setAutoSize("center").setVerticalAlign("middle");
        addChild(this.char_);
        this.drawBackground();
        this.setNormalMode();
        addEventListener("mouseOver", this.onMouseOver);
        addEventListener("rollOut", this.onRollOut);
    }
    public var keyCode_:uint;
    public var selected_:Boolean;
    public var inputMode_:Boolean;
    private var char_:TextFieldDisplayConcrete = null;

    public function value():uint {
        return this.keyCode_;
    }

    public function setKeyCode(_arg_1:uint):void {
        if (_arg_1 == this.keyCode_) {
            return;
        }
        this.keyCode_ = _arg_1;
        this.setTextToKey();
        dispatchEvent(new Event("change", true));
    }

    public function setTextToKey():void {
        this.setText(new StaticStringBuilder(KeyCodes.CharCodeStrings[this.keyCode_]));
    }

    private function drawBackground():void {
        var _local1:Graphics = graphics;
        _local1.clear();
        _local1.lineStyle(2, this.selected_ || this.inputMode_ ? 0xb3b3b3 : 4473924);
        _local1.beginFill(0x333333);
        _local1.drawRect(0, 0, 80, 32);
        _local1.endFill();
        _local1.lineStyle();
    }

    private function setText(_arg_1:StringBuilder):void {
        this.char_.setStringBuilder(_arg_1);
        this.char_.x = 40;
        this.char_.y = 16;
        this.drawBackground();
    }

    private function setNormalMode():void {
        this.inputMode_ = false;
        removeEventListener("enterFrame", this.onInputEnterFrame);
        if (stage != null) {
            removeEventListener("keyDown", this.onInputKeyDown);
            stage.removeEventListener("mouseDown", this.onInputMouseDown, true);
        }
        this.setTextToKey();
        addEventListener("click", this.onNormalClick);
    }

    private function setInputMode():void {
        if (stage == null) {
            return;
        }
        stage.stageFocusRect = false;
        stage.focus = this;
        this.inputMode_ = true;
        removeEventListener("click", this.onNormalClick);
        addEventListener("enterFrame", this.onInputEnterFrame);
        addEventListener("keyDown", this.onInputKeyDown);
        stage.addEventListener("mouseDown", this.onInputMouseDown, true);
    }

    private function onMouseOver(_arg_1:MouseEvent):void {
        this.selected_ = true;
        this.drawBackground();
    }

    private function onRollOut(_arg_1:MouseEvent):void {
        this.selected_ = false;
        this.drawBackground();
    }

    private function onNormalClick(_arg_1:MouseEvent):void {
        this.setInputMode();
    }

    private function onInputEnterFrame(_arg_1:Event):void {
        var _local2:* = getTimer() / 400 % 2 == 0;
        if (_local2) {
            this.setText(new StaticStringBuilder(""));
        } else {
            this.setText(new LineBuilder().setParams("KeyCodeBox.hitKey"));
        }
    }

    private function onInputKeyDown(_arg_1:KeyboardEvent):void {
        _arg_1.stopImmediatePropagation();
        this.keyCode_ = _arg_1.keyCode;
        this.setNormalMode();
        dispatchEvent(new Event("change", true));
    }

    private function onInputMouseDown(_arg_1:MouseEvent):void {
        this.setNormalMode();
    }
}
}
