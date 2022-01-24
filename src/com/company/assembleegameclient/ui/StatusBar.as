package com.company.assembleegameclient.ui {
import com.company.assembleegameclient.objects.GameObject;
import com.company.assembleegameclient.parameters.Parameters;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;

import kabam.rotmg.text.view.TextFieldDisplayConcrete;
import kabam.rotmg.text.view.stringBuilder.LineBuilder;
import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;

import org.osflash.signals.Signal;

public class StatusBar extends Sprite {

    public const DEFAULT_FILTER:DropShadowFilter = new DropShadowFilter(0, 0, 0);
    public static var barTextSignal:Signal = new Signal(int);

    public function StatusBar(_arg_1:int, _arg_2:int, _arg_3:uint, _arg_4:uint, _arg_5:String = null, _arg_6:Boolean = false, _arg_7:GameObject = null, _arg_8:Boolean = false, _arg_9:Boolean = false) {
        colorSprite = new Sprite();
        super();
        this.isProgressBar_ = _arg_9;
        addChild(this.colorSprite);
        this.w_ = _arg_1;
        this.h_ = _arg_2;
        this.forceNumText_ = _arg_6;
        var _local10:* = _arg_3;
        this.color_ = _local10;
        this.defaultForegroundColor = _local10;
        _local10 = _arg_4;
        this.backColor_ = _local10;
        this.defaultBackgroundColor = _local10;
        this.textColor_ = 0xffffff;
        if (_arg_5 && _arg_5.length != 0) {
            this.labelText_ = new TextFieldDisplayConcrete().setSize(14).setColor(this.textColor_);
            this.labelText_.setBold(true);
            this.labelTextStringBuilder_ = new LineBuilder().setParams(_arg_5);
            this.labelText_.setStringBuilder(this.labelTextStringBuilder_);
            this.centerVertically(this.labelText_);
            this.labelText_.filters = [DEFAULT_FILTER];
            addChild(this.labelText_);
        }
        if (_arg_8) {
            this.rightLabelText_ = new TextFieldDisplayConcrete().setSize(14).setColor(this.textColor_);
            this.rightLabelText_.setBold(true);
            this.rightLabelTextStringBuilder_ = new LineBuilder().setParams("0%");
            this.rightLabelText_.setStringBuilder(this.labelTextStringBuilder_);
            this.centerVertically(this.rightLabelText_);
            this.rightLabelText_.filters = [DEFAULT_FILTER];
            addChild(this.rightLabelText_);
        }
        this.valueText_ = new TextFieldDisplayConcrete().setSize(14).setColor(0xffffff);
        this.valueText_.setBold(true);
        this.valueText_.filters = [DEFAULT_FILTER];
        this.centerVertically(this.valueText_);
        this.valueTextStringBuilder_ = new StaticStringBuilder();
        this.boostText_ = new TextFieldDisplayConcrete().setSize(14).setColor(this.textColor_);
        this.boostText_.setBold(true);
        this.boostText_.alpha = 0.6;
        this.centerVertically(this.boostText_);
        this.boostText_.filters = [DEFAULT_FILTER];
        this.multiplierIcon = new Sprite();
        this.multiplierIcon.x = this.w_ - 25;
        this.multiplierIcon.y = -3;
        this.multiplierIcon.graphics.beginFill(0xff00ff, 0);
        this.multiplierIcon.graphics.drawRect(0, 0, 20, 20);
        this.multiplierIcon.addEventListener("mouseOver", this.onMultiplierOver, false, 0, true);
        this.multiplierIcon.addEventListener("mouseOut", this.onMultiplierOut, false, 0, true);
        this.multiplierText = new TextFieldDisplayConcrete().setSize(14).setColor(9493531);
        this.multiplierText.setBold(true);
        this.multiplierText.setStringBuilder(new StaticStringBuilder("x2"));
        this.multiplierText.filters = [DEFAULT_FILTER];
        this.multiplierIcon.addChild(this.multiplierText);
        if (!this.bTextEnabled(Parameters.data.toggleBarText)) {
            addEventListener("rollOver", this.onMouseOver, false, 0, true);
            addEventListener("rollOut", this.onMouseOut, false, 0, true);
        }
        quest = _arg_7;
        barTextSignal.add(this.setBarText);
    }
    public var w_:int;
    public var h_:int;
    public var color_:uint;
    public var backColor_:uint;
    public var pulseBackColor:uint;
    public var textColor_:uint;
    public var val_:int = -1;
    public var max_:int = -1;
    public var boost_:int = -1;
    public var maxMax_:int = -1;
    public var level_:int = 0;
    public var multiplierIcon:Sprite;
    public var mouseOver_:Boolean = false;
    public var quest:GameObject = null;
    private var labelText_:TextFieldDisplayConcrete;
    private var labelTextStringBuilder_:LineBuilder;
    private var rightLabelText_:TextFieldDisplayConcrete;
    private var rightLabelTextStringBuilder_:LineBuilder;
    private var valueText_:TextFieldDisplayConcrete;
    private var valueTextStringBuilder_:StaticStringBuilder;
    private var boostText_:TextFieldDisplayConcrete;
    private var multiplierText:TextFieldDisplayConcrete;
    private var colorSprite:Sprite;
    private var defaultForegroundColor:Number;
    private var defaultBackgroundColor:Number;
    private var isPulsing:Boolean = false;
    private var forceNumText_:Boolean = false;
    private var isProgressBar_:Boolean = false;
    private var repetitions:int;
    private var direction:int = -1;
    private var speed:Number = 0.1;

    public function centerVertically(_arg_1:TextFieldDisplayConcrete):void {
        _arg_1.setVerticalAlign("middle");
        _arg_1.y = int(this.h_ / 2);
    }

    public function draw(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:int = -1, _arg_5:int = 0):void {
        if (_arg_2 > 0) {
            _arg_1 = Math.min(_arg_2, Math.max(0, _arg_1));
        }
        if (_arg_1 == this.val_ && _arg_2 == this.max_ && _arg_3 == this.boost_ && _arg_4 == this.maxMax_) {
            return;
        }
        this.val_ = _arg_1;
        this.max_ = _arg_2;
        this.boost_ = _arg_3;
        this.maxMax_ = _arg_4;
        this.level_ = _arg_5;
        this.internalDraw();
    }

    public function setLabelText(_arg_1:String, _arg_2:Object = null):void {
        this.labelTextStringBuilder_.setParams(_arg_1, _arg_2);
        this.labelText_.setStringBuilder(this.labelTextStringBuilder_);
    }

    public function setBarText(_arg_1:int):void {
        this.mouseOver_ = false;
        if (this.bTextEnabled(_arg_1)) {
            removeEventListener("rollOver", this.onMouseOver);
            removeEventListener("rollOut", this.onMouseOut);
        } else {
            addEventListener("rollOver", this.onMouseOver);
            addEventListener("rollOut", this.onMouseOut);
        }
        this.internalDraw();
    }

    public function drawWithMouseOver():void {
        var _local2:int = 0;
        var _local1:String = "";
        if (Parameters.data.toggleToMaxText) {
            _local2 = this.maxMax_ - (this.max_ - this.boost_);
            if (this.level_ >= 20 && _local2 > 0) {
                _local1 = _local1 + ("|" + Math.ceil(_local2 * 0.2));
            }
        }
        if (this.max_ > 0) {
            this.valueText_.setStringBuilder(this.valueTextStringBuilder_.setString(this.val_ + "/" + this.max_ + _local1));
        } else {
            this.valueText_.setStringBuilder(this.valueTextStringBuilder_.setString("" + this.val_));
        }
        if (!contains(this.valueText_)) {
            this.valueText_.mouseEnabled = false;
            this.valueText_.mouseChildren = false;
            addChild(this.valueText_);
        }
        if (this.boost_ != 0) {
            this.boostText_.setStringBuilder(this.valueTextStringBuilder_.setString(" (" + (this.boost_ > 0 ? "+" : "") + this.boost_.toString() + ")"));
            if (!contains(this.boostText_)) {
                this.boostText_.mouseEnabled = false;
                this.boostText_.mouseChildren = false;
                addChild(this.boostText_);
            }
            this.valueText_.x = this.w_ * 0.5 - (this.valueText_.width + this.boostText_.width) * 0.5;
            this.boostText_.x = this.valueText_.x + this.valueText_.width;
        } else {
            this.valueText_.x = this.w_ * 0.5 - this.valueText_.width * 0.5;
            if (contains(this.boostText_)) {
                removeChild(this.boostText_);
            }
        }
    }

    public function showMultiplierText():void {
        this.multiplierIcon.mouseEnabled = false;
        this.multiplierIcon.mouseChildren = false;
        addChild(this.multiplierIcon);
        this.startPulse(3, 9493531, 0xffffff);
    }

    public function hideMultiplierText():void {
        if (this.multiplierIcon.parent) {
            removeChild(this.multiplierIcon);
        }
    }

    public function startPulse(_arg_1:Number, _arg_2:Number, _arg_3:Number):void {
        this.isPulsing = true;
        this.color_ = _arg_2;
        this.pulseBackColor = _arg_3;
        this.repetitions = _arg_1;
        this.internalDraw();
        addEventListener("enterFrame", this.onPulse, false, 0, true);
    }

    private function setTextColor(_arg_1:uint):void {
        this.textColor_ = _arg_1;
        if (this.boostText_ != null) {
            this.boostText_.setColor(this.textColor_);
        }
        this.valueText_.setColor(this.textColor_);
    }

    private function bTextEnabled(_arg_1:int):Boolean {
        return _arg_1 && (_arg_1 == 1 || _arg_1 == 2 && this.isProgressBar_ || _arg_1 == 3 && !this.isProgressBar_);
    }

    private function internalDraw():void {
        graphics.clear();
        this.colorSprite.graphics.clear();
        var _local1:int = 0xffffff;
        if (this.maxMax_ > 0 && this.max_ - this.boost_ == this.maxMax_) {
            _local1 = 16572160;
        } else if (this.boost_ > 0) {
            _local1 = 6206769;
        }
        if (this.textColor_ != _local1) {
            this.setTextColor(_local1);
        }
        graphics.beginFill(this.backColor_);
        graphics.drawRect(0, 0, this.w_, this.h_);
        graphics.endFill();
        if (this.isPulsing) {
            this.colorSprite.graphics.beginFill(this.pulseBackColor);
            this.colorSprite.graphics.drawRect(0, 0, this.w_, this.h_);
        }
        this.colorSprite.graphics.beginFill(this.color_);
        if (this.max_ > 0) {
            this.colorSprite.graphics.drawRect(0, 0, this.w_ * (this.val_ / this.max_), this.h_);
        } else {
            this.colorSprite.graphics.drawRect(0, 0, this.w_, this.h_);
        }
        this.colorSprite.graphics.endFill();
        if (this.bTextEnabled(Parameters.data.toggleBarText) || this.mouseOver_ && this.h_ > 4 || this.forceNumText_) {
            this.drawWithMouseOver();
        } else {
            if (contains(this.valueText_)) {
                removeChild(this.valueText_);
            }
            if (contains(this.boostText_)) {
                removeChild(this.boostText_);
            }
        }
    }

    private function onMultiplierOver(_arg_1:MouseEvent):void {
        dispatchEvent(new Event("MULTIPLIER_OVER"));
    }

    private function onMultiplierOut(_arg_1:MouseEvent):void {
        dispatchEvent(new Event("MULTIPLIER_OUT"));
    }

    private function onPulse(_arg_1:Event):void {
        if (this.colorSprite.alpha > 1 || this.colorSprite.alpha < 0) {
            this.direction = this.direction * -1;
            if (this.colorSprite.alpha > 1) {
                this.repetitions--;
                if (!this.repetitions) {
                    this.isPulsing = false;
                    this.color_ = this.defaultForegroundColor;
                    this.backColor_ = this.defaultBackgroundColor;
                    this.colorSprite.alpha = 1;
                    this.internalDraw();
                    removeEventListener("enterFrame", this.onPulse);
                }
            }
        }
        this.colorSprite.alpha = this.colorSprite.alpha + this.speed * this.direction;
    }

    private function onMouseOver(_arg_1:MouseEvent):void {
        this.mouseOver_ = true;
        this.internalDraw();
    }

    private function onMouseOut(_arg_1:MouseEvent):void {
        this.mouseOver_ = false;
        this.internalDraw();
    }
}
}
