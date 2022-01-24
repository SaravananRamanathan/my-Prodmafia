package com.company.assembleegameclient.ui {
import com.company.assembleegameclient.ui.components.TimerDisplay;

import flash.display.Sprite;
import flash.filters.DropShadowFilter;

import kabam.rotmg.text.view.TextFieldDisplayConcrete;
import kabam.rotmg.text.view.stringBuilder.StringBuilder;

import org.osflash.signals.Signal;

public class BoostTimer extends Sprite {


    public function BoostTimer() {
        super();
        this.createLabelTextField();
        this.textChanged = this.labelTextField.textChanged;
        this.labelTextField.x = 0;
        this.labelTextField.y = 0;
        var _local1:TextFieldDisplayConcrete = this.returnTimerTextField();
        this.timerDisplay = new TimerDisplay(_local1);
        this.timerDisplay.x = 0;
        this.timerDisplay.y = 20;
        addChild(this.timerDisplay);
        addChild(this.labelTextField);
    }
    public var textChanged:Signal;
    private var labelTextField:TextFieldDisplayConcrete;
    private var timerDisplay:TimerDisplay;

    public function setLabelBuilder(_arg_1:StringBuilder):void {
        this.labelTextField.setStringBuilder(_arg_1);
    }

    public function setTime(_arg_1:Number):void {
        this.timerDisplay.update(_arg_1);
    }

    private function returnTimerTextField():TextFieldDisplayConcrete {
        var _local1:* = null;
        _local1 = new TextFieldDisplayConcrete().setSize(16).setColor(0xffff8f);
        _local1.setBold(true);
        _local1.setMultiLine(true);
        _local1.mouseEnabled = true;
        _local1.filters = [new DropShadowFilter(0, 0, 0)];
        return _local1;
    }

    private function createLabelTextField():void {
        this.labelTextField = new TextFieldDisplayConcrete().setSize(16).setColor(0xffffff);
        this.labelTextField.setMultiLine(true);
        this.labelTextField.mouseEnabled = true;
        this.labelTextField.filters = [new DropShadowFilter(0, 0, 0)];
    }
}
}
