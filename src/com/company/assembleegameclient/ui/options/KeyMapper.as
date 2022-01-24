package com.company.assembleegameclient.ui.options {
import com.company.assembleegameclient.parameters.Parameters;
import com.company.util.MoreColorUtil;

import flash.events.Event;

public class KeyMapper extends BaseOption {


    public function KeyMapper(_arg_1:String, _arg_2:String, _arg_3:String, _arg_4:Boolean = false, _arg_5:uint = 16777215) {
        super(_arg_1, _arg_2, _arg_3);
        desc_.setColor(_arg_5);
        tooltip_.tipText_.setColor(_arg_5);
        this.keyCodeBox_ = new KeyCodeBox(Parameters.data[paramName_], _arg_5);
        this.keyCodeBox_.addEventListener("change", this.onChange);
        addChild(this.keyCodeBox_);
        this.setDisabled(_arg_4);
    }
    private var keyCodeBox_:KeyCodeBox;
    private var disabled_:Boolean;

    override public function refresh():void {
        this.keyCodeBox_.setKeyCode(Parameters.data[paramName_]);
    }

    public function setDisabled(_arg_1:Boolean):void {
        this.disabled_ = _arg_1;
        transform.colorTransform = !!this.disabled_ ? MoreColorUtil.darkCT : MoreColorUtil.identity;
        mouseEnabled = !this.disabled_;
        mouseChildren = !this.disabled_;
    }

    private function onChange(_arg_1:Event):void {
        Parameters.setKey(paramName_, this.keyCodeBox_.value());
        Parameters.save();
    }
}
}
