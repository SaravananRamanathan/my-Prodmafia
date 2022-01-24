package com.company.assembleegameclient.objects {
import com.company.assembleegameclient.map.Camera;
import com.company.assembleegameclient.map.Map;
import com.company.assembleegameclient.map.Square;
import com.company.assembleegameclient.util.BloodComposition;

import flash.display.BitmapData;
import flash.display.GraphicsBitmapFill;

public class BasicObject {

    private static var nextFakeObjectId_:int = 0;

    public var map_:Map;
    public var square:Square;
    public var objectId_:int;
    public var x_:Number;
    public var y_:Number;
    public var z_:Number;
    public var hasShadow_:Boolean;
    public var drawn_:Boolean;
    public var posW_:Vector.<Number>;
    public var posS_:Vector.<Number>;
    public var sortVal_:int;

    public function BasicObject() {
        this.posW_ = new Vector.<Number>();
        this.posS_ = new Vector.<Number>();
        super();
        this.clear();
    }

    public static function getNextFakeObjectId():int {
        return ((0x7F000000 | nextFakeObjectId_++));
    }

    public function clear():void {
        this.map_ = null;
        this.square = null;
        this.objectId_ = -1;
        this.x_ = 0;
        this.y_ = 0;
        this.z_ = 0;
        this.hasShadow_ = false;
        this.drawn_ = false;
        this.posW_.length = 0;
        this.posS_.length = 0;
        this.sortVal_ = 0;
    }

    public function dispose():void {
        this.map_ = null;
        this.square = null;
        this.posW_ = null;
        this.posS_ = null;
    }

    public function update(_arg1:int, _arg2:int):Boolean {
        return true;
    }

    public function draw(_arg1:Vector.<GraphicsBitmapFill>, _arg2:Camera, _arg3:int):void {
    }

    public function computeSortVal(_arg1:Camera):void {
        this.posW_.length = 0;
        this.posW_.push(this.x_, this.y_, 0, this.x_, this.y_, this.z_);
        this.posS_.length = 0;
        _arg1.wToS_.transformVectors(this.posW_, this.posS_);
        this.sortVal_ = int(this.posS_[1]);
    }

    public function computeSortValNoCamera(_arg1:Number = 12):void {
        this.posW_.length = 0;
        this.posW_.push(this.x_, this.y_, 0, this.x_, this.y_, this.z_);
        this.posS_.length = 0;
        this.posS_.push((this.x_ * _arg1), (this.y_ * _arg1), 0, (this.x_ * _arg1), (this.y_ * _arg1), 0);
        this.sortVal_ = int(this.posS_[1]);
    }

    public function addTo(_arg1:Map, _arg2:Number, _arg3:Number):Boolean {
        this.map_ = _arg1;
        this.square = this.map_.getSquare(_arg2, _arg3);
        if (this.square == null) {
            this.map_ = null;
            return (false);
        }
        this.x_ = _arg2;
        this.y_ = _arg3;
        return (true);
    }

    public function removeFromMap():void {
        this.map_ = null;
        this.square = null;
    }

    public function getBloodComposition(_arg_1:int, _arg_2:BitmapData, _arg_3:Number, _arg_4:uint):Vector.<uint> {
        var _local7:Number = NaN;
        var _local9:int = 0;
        var _local6:Vector.<uint> = BloodComposition.idDict_[_arg_1];
        if (_local6) {
            return _local6;
        }
        _local6 = new Vector.<uint>();
        var _local8:Vector.<uint> = this.getColors(_arg_2);
        var _local5:uint = _local8.length;
        _local9 = 0;
        while (_local9 < _local5) {
            _local7 = Math.random();
            if (_local7 < _arg_3) {
                _local6.push(_arg_4);
            } else {
                _local6.push(_local8[int(_local5 * _local7)]);
            }
            _local9++;
        }
        return _local6;
    }

    public function getColors(_arg_1:BitmapData):Vector.<uint> {
        var _local2:Vector.<uint> = BloodComposition.imageDict_[_arg_1];
        if (_local2 == null) {
            _local2 = this.buildColors(_arg_1);
            BloodComposition.imageDict_[_arg_1] = _local2;
        }
        return _local2;
    }

    private function buildColors(_arg_1:BitmapData):Vector.<uint> {
        var _local4:int = 0;
        var _local3:int = 0;
        var _local2:* = 0;
        var _local6:int = _arg_1.width;
        var _local5:int = _arg_1.height;
        var _local7:Vector.<uint> = new Vector.<uint>();
        _local4 = 0;
        while (_local4 < _local6) {
            _local3 = 0;
            while (_local3 < _local5) {
                _local2 = uint(_arg_1.getPixel32(_local4, _local3));
                if ((_local2 & 4278190080) != 0) {
                    _local7.push(_local2);
                }
                _local3++;
            }
            _local4++;
        }
        return _local7;
    }
}
}
