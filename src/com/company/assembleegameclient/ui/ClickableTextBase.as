package com.company.assembleegameclient.ui {
import com.company.assembleegameclient.sound.SoundEffectLibrary;

import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;

import kabam.rotmg.text.view.TextFieldDisplayConcrete;
import kabam.rotmg.text.view.stringBuilder.LineBuilder;

public class ClickableTextBase extends Sprite {


    public function ClickableTextBase(_arg_1:int, _arg_2:Boolean, _arg_3:String) {
        super();
        var _local5:* = 0xffffff;
        var _local4:* = _arg_3;
        if (_local4.indexOf("#") == 0 && _local4.length >= 8) {
            _local5 = parseInt(_local4.substring(1, 7), 16);
            _local4 = _local4.substring(8);
            this.defaultColor_ = _local5;
        }
        this.text_ = this.makeText().setSize(_arg_1).setColor(_local5);
        this.text_.setBold(_arg_2);
        this.text_.setStringBuilder(new LineBuilder().setParams(_local4));
        addChild(this.text_);
        this.text_.filters = [new DropShadowFilter(0, 0, 0)];
        addEventListener("mouseOver", this.onMouseOver, false, 0, true);
        addEventListener("mouseOut", this.onMouseOut, false, 0, true);
        addEventListener("click", this.onMouseClick, false, 0, true);
    }
    public var text_:TextFieldDisplayConcrete;
    public var defaultColor_:uint = 16777215;

    public function removeOnHoverEvents():void {
        removeEventListener("mouseOver", this.onMouseOver);
        removeEventListener("mouseOut", this.onMouseOut);
    }

    public function setAutoSize(_arg_1:String):void {
        this.text_.setAutoSize(_arg_1);
    }

    public function makeStatic(_arg_1:String):void {
        this.text_.setStringBuilder(new LineBuilder().setParams(_arg_1));
        this.setDefaultColor(0xb3b3b3);
        mouseEnabled = false;
        mouseChildren = false;
    }

    public function setColor(_arg_1:uint):void {
        this.text_.setColor(_arg_1);
    }

    public function setDefaultColor(_arg_1:uint):void {
        this.defaultColor_ = _arg_1;
        this.setColor(this.defaultColor_);
    }

    protected function makeText():TextFieldDisplayConcrete {
        return new TextFieldDisplayConcrete();
    }

    private function onMouseOver(_arg_1:MouseEvent):void {
        this.setColor(16768133);
    }

    private function onMouseOut(_arg_1:MouseEvent):void {
        this.setColor(this.defaultColor_);
    }

    private function onMouseClick(_arg_1:MouseEvent):void {
        SoundEffectLibrary.play("button_click");
    }
}
}
