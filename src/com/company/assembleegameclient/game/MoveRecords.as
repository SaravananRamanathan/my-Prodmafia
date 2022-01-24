package com.company.assembleegameclient.game {
import kabam.rotmg.messaging.impl.data.MoveRecord;

public class MoveRecords {


    public function MoveRecords() {
        records_ = new Vector.<MoveRecord>();
        super();
    }
    public var lastClearTime_:int = -1;
    public var records_:Vector.<MoveRecord>;

    public function addRecord(_arg_1:int, _arg_2:Number, _arg_3:Number):void {
        if (this.lastClearTime_ < 0) {
            return;
        }
        var _local4:int = this.getId(_arg_1);
        if (_local4 < 1 || _local4 > 10) {
            return;
        }
        if (this.records_.length == 0) {
            this.records_.push(new MoveRecord(_arg_1, _arg_2, _arg_3));
            return;
        }
        var _local8:MoveRecord = this.records_[this.records_.length - 1];
        var _local6:int = this.getId(_local8.time_);
        if (_local4 != _local6) {
            this.records_.push(new MoveRecord(_arg_1, _arg_2, _arg_3));
            return;
        }
        var _local5:int = this.getScore(_local4, _arg_1);
        var _local7:int = this.getScore(_local4, _local8.time_);
        if (_local5 < _local7) {
            _local8.time_ = _arg_1;
            _local8.x_ = _arg_2;
            _local8.y_ = _arg_3;
        }
    }

    public function clear(_arg_1:int):void {
        this.records_.length = 0;
        this.lastClearTime_ = _arg_1;
    }

    private function getId(_arg_1:int):int {
        return (_arg_1 - this.lastClearTime_ + 50) / 100;
    }

    private function getScore(_arg_1:int, _arg_2:int):int {
        return Math.abs(_arg_2 - this.lastClearTime_ - _arg_1 * 100);
    }
}
}
