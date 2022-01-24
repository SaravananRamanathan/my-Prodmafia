package com.company.assembleegameclient.ui {
import flash.events.MouseEvent;

import kabam.rotmg.text.view.stringBuilder.LineBuilder;

public class TextButtonBase extends BackgroundFilledText {


    public function TextButtonBase(_arg_1:int) {
        super(_arg_1);
    }

    public function setText(_arg_1:String):void {
        text_.setStringBuilder(new LineBuilder().setParams(_arg_1));
    }

    public function setEnabled(_arg_1:Boolean):void {
        if (_arg_1 == mouseEnabled) {
            return;
        }
        mouseEnabled = _arg_1;
        graphicsData_[0] = !!_arg_1 ? enabledFill_ : disabledFill_;
        this.draw();
    }

    protected function initText():void {
        centerTextAndDrawButton();
        this.draw();
        addEventListener("mouseOver", this.onMouseOver, false, 0, true);
        addEventListener("rollOut", this.onRollOut, false, 0, true);
    }

    private function draw():void {
        graphics.clear();
        graphics.drawGraphicsData(graphicsData_);
    }

    private function onMouseOver(_arg_1:MouseEvent):void {
        enabledFill_.color = 16768133;
        this.draw();
    }

    private function onRollOut(_arg_1:MouseEvent):void {
        enabledFill_.color = 0xffffff;
        this.draw();
    }
}
}
