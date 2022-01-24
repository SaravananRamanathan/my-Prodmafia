package kabam.rotmg.messaging.impl {
import com.company.assembleegameclient.parameters.Parameters;

import flash.display.Sprite;
import flash.events.Event;
import flash.filters.DropShadowFilter;
import flash.utils.getTimer;

import kabam.rotmg.text.view.TextFieldDisplayConcrete;
import kabam.rotmg.text.view.stringBuilder.LineBuilder;

public class JitterWatcher extends Sprite {

    private static const lineBuilder:LineBuilder = new LineBuilder();

    public function JitterWatcher() {
        ticks_ = new Vector.<int>();
        super();
        this.text_ = new TextFieldDisplayConcrete().setSize(14).setColor(0xffffff);
        this.text_.setAutoSize("left");
        this.text_.filters = [new DropShadowFilter(0, 0, 0)];
        addChild(this.text_);
        addEventListener("addedToStage", this.onAddedToStage);
        addEventListener("removedFromStage", this.onRemovedFromStage);
    }
    private var text_:TextFieldDisplayConcrete = null;
    private var lastRecord_:int = -1;
    private var ticks_:Vector.<int>;
    private var sum_:int;

    public function record():void {
        var _local1:int = 0;
        var _local3:int = getTimer();
        if (this.lastRecord_ == -1) {
            this.lastRecord_ = _local3;
            return;
        }
        var _local2:int = _local3 - this.lastRecord_;
        this.ticks_.push(_local2);
        this.sum_ = this.sum_ + _local2;
        if (this.ticks_.length > 50) {
            _local1 = this.ticks_.shift();
            this.sum_ = this.sum_ - _local1;
        }
        this.lastRecord_ = _local3;
    }

    private function jitter():Number {
        var _local3:int = 0;
        var _local4:int = this.ticks_.length;
        if (_local4 == 0) {
            return 0;
        }
        var _local2:Number = this.sum_ / _local4;
        var _local1:* = 0;
        var _local6:int = 0;
        var _local5:* = this.ticks_;
        for each(_local3 in this.ticks_) {
            _local1 = _local1 + (_local3 - _local2) * (_local3 - _local2);
        }
        return int(Math.sqrt(_local1 / _local4));
    }

    private function onAddedToStage(_arg_1:Event):void {
        stage.addEventListener("enterFrame", this.onEnterFrame);
    }

    private function onRemovedFromStage(_arg_1:Event):void {
        stage.removeEventListener("enterFrame", this.onEnterFrame);
    }

    private function onEnterFrame(_arg_1:Event):void {
        this.text_.setStringBuilder(lineBuilder.setParams("JitterWatcher.desc", {"jitter": this.jitter()}));
    }
}
}
