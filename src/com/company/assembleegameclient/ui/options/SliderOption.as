package com.company.assembleegameclient.ui.options {
import com.company.assembleegameclient.parameters.Parameters;

import flash.events.Event;

public class SliderOption extends BaseOption {


    public function SliderOption(_arg_1:String, _arg_2:Function = null, _arg_3:Boolean = false, _arg_4:Number = 0, _arg_5:Number = 1) {
        super(_arg_1, "", "");
        this.sliderBar = new VolumeSliderBar(Parameters.data[paramName_], 0xffffff, _arg_4, _arg_5);
        this.sliderBar.addEventListener("change", this.onChange);
        this.callbackFunc = _arg_2;
        addChild(this.sliderBar);
        this.setDisabled(_arg_3);
    }
    private var sliderBar:VolumeSliderBar;
    private var disabled_:Boolean;
    private var callbackFunc:Function;

    override public function refresh():void {
        this.sliderBar.currentVolume = Parameters.data[paramName_];
    }

    public function setDisabled(_arg_1:Boolean):void {
        this.disabled_ = _arg_1;
        mouseEnabled = !this.disabled_;
        mouseChildren = !this.disabled_;
    }

    private function onChange(_arg_1:Event):void {
        Parameters.data[paramName_] = this.sliderBar.currentVolume;
        if (this.callbackFunc) {
            this.callbackFunc(this.sliderBar.currentVolume);
        }
        Parameters.save();
    }
}
}
