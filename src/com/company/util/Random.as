package com.company.util {
public class Random {


    public static function randomSeed():uint {
        return Math.round(Math.random() * 4294967294 + 1);
    }

    public function Random(_arg_1:uint = 1) {
        super();
        this.seed = _arg_1;
    }
    public var seed:uint;

    public function nextInt():uint {
        return this.gen();
    }

    public function nextDouble():Number {
        return this.gen() / 2147483647;
    }

    public function nextNormal(_arg_1:Number = 0, _arg_2:Number = 1):Number {
        var _local5:Number = this.gen() / 2147483647;
        var _local4:Number = this.gen() / 2147483647;
        var _local3:Number = Math.sqrt(-2 * Math.log(_local5)) * Math.cos(_local4 * 6.28318530717959);
        return _arg_1 + _local3 * _arg_2;
    }

    public function nextIntRange(_arg_1:uint, _arg_2:uint):uint {
        return _arg_1 == _arg_2 ? _arg_1 : _arg_1 + this.gen() % (_arg_2 - _arg_1);
    }

    public function peekIntRange(_arg_1:uint, _arg_2:uint):uint {
        return _arg_1 == _arg_2 ? _arg_1 : _arg_1 + this.genPeek() % (_arg_2 - _arg_1);
    }

    public function nextDoubleRange(_arg_1:Number, _arg_2:Number):Number {
        return _arg_1 + (_arg_2 - _arg_1) * this.nextDouble();
    }

    private function genPeek():uint {
        var _local1:uint = 16807 * (this.seed & 65535);
        var _local2:uint = 16807 * (this.seed >> 16);
        _local1 = _local1 + ((_local2 & 32767) << 16);
        _local1 = _local1 + (_local2 >> 15);
        if (_local1 > 0x7fffffff) {
            _local1 = _local1 - 2147483647;
        }
        return _local1;
    }

    private function gen():uint {
        var _local1:uint = 16807 * (this.seed & 65535);
        var _local2:uint = 16807 * (this.seed >> 16);
        _local1 = _local1 + ((_local2 & 32767) << 16);
        _local1 = _local1 + (_local2 >> 15);
        if (_local1 > 0x7fffffff) {
            _local1 = _local1 - 2147483647;
        }
        var _local3:* = _local1;
        this.seed = _local3;
        return _local3;
    }
}
}
