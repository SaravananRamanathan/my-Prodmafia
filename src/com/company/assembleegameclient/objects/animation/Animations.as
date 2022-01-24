package com.company.assembleegameclient.objects.animation {
    import flash.display.BitmapData;

    public class Animations {


        public function Animations(_arg_1:AnimationsData) {
            super();
            this.animationsData_ = _arg_1;
        }
        public var animationsData_:AnimationsData;
        public var nextRun_:Vector.<int> = null;
        public var running_:RunningAnimation = null;

        public function getTexture(_arg_1:int):BitmapData {
            var _local2:int = 0;
            var _local4:int = 0;
            var _local7:* = null;
            var _local6:* = null;
            var _local3:* = 0;
            if (this.nextRun_ == null) {
                this.nextRun_ = new Vector.<int>();
                var _local9:int = 0;
                var _local8:* = this.animationsData_.animations;
                for each (_local7 in this.animationsData_.animations) {
                    this.nextRun_.push(_local7.getLastRun(_arg_1));
                }
            }
            if (this.running_) {
                _local6 = this.running_.getTexture(_arg_1);
                if (_local6) {
                    return _local6;
                }
                this.running_ = null;
            }
            var _local5:uint = this.nextRun_.length;
            _local4 = 0;
            while (_local4 < _local5) {
                _local2 = this.nextRun_[_local4];
                if (_arg_1 > _local2) {
                    _local3 = _local2;
                    _local7 = this.animationsData_.animations[_local4];
                    this.nextRun_[_local4] = _local7.getNextRun(_arg_1);
                    if (!(_local7.prob_ != 1 && Math.random() > _local7.prob_)) {
                        this.running_ = new RunningAnimation(_local7, _local3);
                        return this.running_.getTexture(_arg_1);
                    }
                }
                _local4++;
            }
            return null;
        }
    }
}

import com.company.assembleegameclient.objects.animation.AnimationData;
import com.company.assembleegameclient.objects.animation.FrameData;
import flash.display.BitmapData;

class RunningAnimation {


    function RunningAnimation(_arg_1:AnimationData, _arg_2:int) {
        super();
        this.animationData_ = _arg_1;
        this.length_ = this.animationData_.frames.length;
        this.start_ = _arg_2;
        this.frameId_ = 0;
        this.frameStart_ = _arg_2;
        this.texture_ = null;
    }
    public var animationData_:AnimationData;
    public var length_:uint;
    public var start_:int;
    public var frameId_:int;
    public var frameStart_:int;
    public var texture_:BitmapData;

    public function getTexture(_arg_1:int):BitmapData {
        var _local2:FrameData = this.animationData_.frames[this.frameId_];
        while (_arg_1 - this.frameStart_ > _local2.time_) {
            if (this.frameId_ >= this.length_ - 1) {
                return null;
            }
            this.frameStart_ = this.frameStart_ + _local2.time_;
            this.frameId_++;
            _local2 = this.animationData_.frames[this.frameId_];
            this.texture_ = null;
        }
        if (this.texture_ == null) {
            this.texture_ = _local2.textureData_.getTexture(Math.random() * 100);
        }
        return this.texture_;
    }
}
