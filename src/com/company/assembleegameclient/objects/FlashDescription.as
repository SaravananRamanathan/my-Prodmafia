package com.company.assembleegameclient.objects {
import flash.display.BitmapData;
import flash.geom.ColorTransform;

import kabam.rotmg.stage3D.GraphicsFillExtra;

public class FlashDescription {


    public function FlashDescription(_arg1:int, _arg2:uint, _arg3:Number, _arg4:int) {
        super();
        this.startTime_ = _arg1;
        this.color_ = _arg2;
        this.periodMS_ = _arg3 * 1000;
        this.repeats_ = _arg4;
        this.targetR = _arg2 >> 16 & 255;
        this.targetG = _arg2 >> 8 & 255;
        this.targetB = _arg2 & 255;
    }
    public var startTime_:int;
    public var color_:uint;
    public var periodMS_:int;
    public var repeats_:int;
    public var targetR:int;
    public var targetG:int;
    public var targetB:int;

    public function applyCPU(_arg1:BitmapData, _arg2:int):BitmapData {
        var _local3:int = (_arg2 - this.startTime_) % this.periodMS_;
        var _local6:Number = Math.sin(_local3 / this.periodMS_ * 3.14159265358979);
        var _local7:Number = _local6 * 0.5;
        var _local4:ColorTransform = new ColorTransform(1 - _local7, 1 - _local7, 1 - _local7, 1, _local7 * this.targetR, _local7 * this.targetG, _local7 * this.targetB, 0);
        var _local5:BitmapData = _arg1.clone();
        _local5.colorTransform(_local5.rect, _local4);
        return _local5;
    }

    public function applyGPU(_arg1:BitmapData, _arg2:int):void {
        var _local3:int = (_arg2 - this.startTime_) % this.periodMS_;
        var _local5:Number = Math.sin(_local3 / this.periodMS_ * 3.14159265358979);
        var _local6:Number = _local5 * 0.5;
        var _local4:ColorTransform = new ColorTransform(1 - _local6, 1 - _local6, 1 - _local6, 1, _local6 * this.targetR, _local6 * this.targetG, _local6 * this.targetB, 0);
        GraphicsFillExtra.setColorTransform(_arg1, _local4);
    }

    public function doneAt(_arg1:int):Boolean {
        return _arg1 > this.startTime_ + this.periodMS_ * this.repeats_;
    }
}
}
