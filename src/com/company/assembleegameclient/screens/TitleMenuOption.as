package com.company.assembleegameclient.screens {
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.sound.SoundEffectLibrary;
import com.company.util.MoreColorUtil;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;
import flash.geom.ColorTransform;
import flash.utils.getTimer;

import kabam.rotmg.text.view.TextFieldDisplayConcrete;
import kabam.rotmg.text.view.stringBuilder.LineBuilder;

import org.osflash.signals.Signal;

public class TitleMenuOption extends Sprite {

    protected static const OVER_COLOR_TRANSFORM:ColorTransform = new ColorTransform(1, 0.862745098039216, 0.52156862745098);

    private static const DROP_SHADOW_FILTER:DropShadowFilter = new DropShadowFilter(0, 0, 0, 0.5, 12, 12);


    public const clicked:Signal = new Signal();

    public function TitleMenuOption(_arg_1:String, _arg_2:int, _arg_3:Boolean, _arg_4:uint = 16777215) {
        this.textField = this.makeTextFieldDisplayConcrete();
        this.changed = this.textField.textChanged;
        super();
        this.color = _arg_4;
        this.setColor(_arg_4);
        this.size = _arg_2;
        this.isPulse = _arg_3;
        this.textField.setSize(_arg_2).setColor(0xffffff).setBold(true);
        this.setTextKey(_arg_1);
        this.originalWidth = width;
        this.originalHeight = height;
        this.activate();
    }
    public var textField:TextFieldDisplayConcrete;
    public var changed:Signal;
    private var colorTransform:ColorTransform;
    private var size:int;
    private var isPulse:Boolean;
    private var originalWidth:Number;
    private var originalHeight:Number;
    private var active:Boolean;
    private var color:uint = 16777215;
    private var hoverColor:uint;

    override public function toString():String {
        return "[TitleMenuOption " + this.textField.getText() + "]";
    }

    public function enable():void {
        this.setColorTransform(null);
        addEventListener("mouseOver", this.onMouseOver);
        addEventListener("mouseOut", this.onMouseOut);
        addEventListener("click", this.onMouseClick);
        addEventListener("addedToStage", this.onAddedToStage);
        addEventListener("removedFromStage", this.onRemovedFromStage);
        this.active = true;
    }

    public function disable():void {
        var _local1:ColorTransform = new ColorTransform();
        _local1.color = 0x767676;
        this.setColorTransform(_local1);
        removeEventListener("mouseOver", this.onMouseOver);
        removeEventListener("mouseOut", this.onMouseOut);
        removeEventListener("click", this.onMouseClick);
        removeEventListener("addedToStage", this.onAddedToStage);
        removeEventListener("removedFromStage", this.onRemovedFromStage);
        this.active = false;
    }

    public function activate():void {
        addEventListener("mouseOver", this.onMouseOver);
        addEventListener("mouseOut", this.onMouseOut);
        addEventListener("click", this.onMouseClick);
        addEventListener("addedToStage", this.onAddedToStage);
        addEventListener("removedFromStage", this.onRemovedFromStage);
        this.active = true;
    }

    public function deactivate():void {
        var _local1:ColorTransform = new ColorTransform();
        _local1.color = 0x363636;
        this.setColorTransform(_local1);
        removeEventListener("mouseOver", this.onMouseOver);
        removeEventListener("mouseOut", this.onMouseOut);
        removeEventListener("click", this.onMouseClick);
        removeEventListener("addedToStage", this.onAddedToStage);
        removeEventListener("removedFromStage", this.onRemovedFromStage);
        this.active = false;
    }

    public function setColor(_arg_1:uint):void {
        this.color = _arg_1;
        var _local2:uint = (_arg_1 & 16711680) >> 16;
        var _local5:uint = (_arg_1 & 65280) >> 8;
        var _local4:uint = _arg_1 & 255;
        var _local3:ColorTransform = new ColorTransform(_local2 / 255, _local5 / 255, _local4 / 255);
        this.setColorTransform(_local3);
    }

    public function isActive():Boolean {
        return this.active;
    }

    public function setTextKey(_arg_1:String):void {
        name = _arg_1;
        this.textField.setStringBuilder(new LineBuilder().setParams(_arg_1));
    }

    public function setAutoSize(_arg_1:String):void {
        this.textField.setAutoSize(_arg_1);
    }

    public function setVerticalAlign(_arg_1:String):void {
        this.textField.setVerticalAlign(_arg_1);
    }

    public function setColorTransform(_arg_1:ColorTransform):void {
        if (_arg_1 == this.colorTransform) {
            return;
        }
        this.colorTransform = _arg_1;
        if (this.colorTransform == null) {
            this.textField.transform.colorTransform = MoreColorUtil.identity;
        } else {
            this.textField.transform.colorTransform = this.colorTransform;
        }
    }

    public function createNoticeTag(_arg_1:String, _arg_2:int, _arg_3:uint, _arg_4:Boolean):void {
        var _local5:TextFieldDisplayConcrete = new TextFieldDisplayConcrete();
        _local5.setSize(_arg_2).setColor(_arg_3).setBold(_arg_4);
        _local5.setStringBuilder(new LineBuilder().setParams(_arg_1));
        _local5.x = this.textField.x - 4;
        _local5.y = this.textField.y - 20;
        addChild(_local5);
    }

    private function makeTextFieldDisplayConcrete():TextFieldDisplayConcrete {
        var _local1:* = null;
        _local1 = new TextFieldDisplayConcrete();
        _local1.filters = [DROP_SHADOW_FILTER];
        addChild(_local1);
        return _local1;
    }

    protected function onMouseOver(_arg_1:MouseEvent):void {
        this.setColorTransform(OVER_COLOR_TRANSFORM);
    }

    protected function onMouseOut(_arg_1:MouseEvent):void {
        if (this.color != 0xffffff) {
            this.setColor(this.color);
        } else {
            this.setColorTransform(null);
        }
    }

    protected function onMouseClick(_arg_1:MouseEvent):void {
        SoundEffectLibrary.play("button_click");
        this.clicked.dispatch();
    }

    private function onAddedToStage(_arg_1:Event):void {
        if (this.isPulse) {
            addEventListener("enterFrame", this.onEnterFrame);
        }
    }

    private function onRemovedFromStage(_arg_1:Event):void {
        if (this.isPulse) {
            removeEventListener("enterFrame", this.onEnterFrame);
        }
    }

    private function onEnterFrame(_arg_1:Event):void {
        var _local2:Number = 1.05 + 0.05 * Math.sin(getTimer() / 200);
        this.textField.scaleX = _local2;
        this.textField.scaleY = _local2;
    }
}
}
