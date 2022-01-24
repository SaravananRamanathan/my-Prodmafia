package com.company.assembleegameclient.ui.options {
import com.company.assembleegameclient.ui.tooltip.TextToolTip;

import flash.events.Event;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;

import kabam.rotmg.text.view.TextFieldDisplayConcrete;
import kabam.rotmg.text.view.stringBuilder.LineBuilder;
import kabam.rotmg.text.view.stringBuilder.StringBuilder;

public class BaseOption extends Option {

    public static const DROPSHADOW_FILTER:DropShadowFilter = new DropShadowFilter(0, 0, 0, 1, 4, 4, 2);

    public function BaseOption(_arg_1:String, _arg_2:String, _arg_3:String) {
        super();
        this.paramName_ = _arg_1;
        this.tooltipText_ = _arg_3;
        this.desc_ = new TextFieldDisplayConcrete().setSize(18).setColor(0xb3b3b3);
        this.desc_.setStringBuilder(new LineBuilder().setParams(_arg_2));
        this.desc_.filters = [DROPSHADOW_FILTER];
        this.desc_.x = 104;
        this.desc_.mouseEnabled = true;
        this.desc_.addEventListener("mouseOver", this.onMouseOver);
        this.desc_.addEventListener("rollOut", this.onRollOut);
        addChild(this.desc_);
        this.tooltip_ = new TextToolTip(0x272727, 0x828282, null, this.tooltipText_, 150);
        addEventListener("removedFromStage", this.onRemovedFromStage);
        textChanged = this.desc_.textChanged;
    }
    public var paramName_:String;
    protected var tooltip_:TextToolTip;
    protected var desc_:TextFieldDisplayConcrete;
    private var tooltipText_:String;

    public function setDescription(_arg_1:StringBuilder):void {
        this.desc_.setStringBuilder(_arg_1);
    }

    public function setTooltipText(_arg_1:StringBuilder):void {
        this.tooltip_.setText(_arg_1);
    }

    public function refresh():void {
    }

    private function removeToolTip():void {
        if (this.tooltip_ != null && parent.parent.contains(this.tooltip_)) {
            parent.parent.removeChild(this.tooltip_);
        }
    }

    private function onMouseOver(_arg_1:MouseEvent):void {
        parent.parent.addChild(this.tooltip_);
    }

    private function onRollOut(_arg_1:MouseEvent):void {
        this.removeToolTip();
    }

    private function onRemovedFromStage(_arg_1:Event):void {
        this.removeToolTip();
        this.desc_.removeEventListener("mouseOver", this.onMouseOver);
        this.desc_.removeEventListener("rollOut", this.onRollOut);
    }
}
}
