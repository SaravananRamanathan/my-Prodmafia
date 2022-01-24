package com.company.assembleegameclient.engine3d {
import flash.geom.Vector3D;

public class Line3D {


    public static function unitTest():Boolean {
        return UnitTest_5202.run();
    }

    public function Line3D(_arg_1:Vector3D, _arg_2:Vector3D) {
        super();
        this.v0_ = _arg_1;
        this.v1_ = _arg_2;
    }
    public var v0_:Vector3D;
    public var v1_:Vector3D;

    public function crossZ(_arg_1:Line3D):int {
        var _local2:Number = (_arg_1.v1_.y - _arg_1.v0_.y) * (this.v1_.x - this.v0_.x) - (_arg_1.v1_.x - _arg_1.v0_.x) * (this.v1_.y - this.v0_.y);
        if (_local2 < 0.001 && _local2 > -0.001) {
            return 0;
        }
        var _local6:Number = (_arg_1.v1_.x - _arg_1.v0_.x) * (this.v0_.y - _arg_1.v0_.y) - (_arg_1.v1_.y - _arg_1.v0_.y) * (this.v0_.x - _arg_1.v0_.x);
        var _local3:Number = (this.v1_.x - this.v0_.x) * (this.v0_.y - _arg_1.v0_.y) - (this.v1_.y - this.v0_.y) * (this.v0_.x - _arg_1.v0_.x);
        if (_local6 < 0.001 && _local6 > -0.001 && _local3 < 0.001 && _local3 > -0.001) {
            return 0;
        }
        var _local7:Number = _local6 / _local2;
        var _local5:Number = _local3 / _local2;
        if (_local7 > 1 || _local7 < 0 || _local5 > 1 || _local5 < 0) {
            return 0;
        }
        var _local4:Number = this.v0_.z + _local7 * (this.v1_.z - this.v0_.z) - (_arg_1.v0_.z + _local5 * (_arg_1.v1_.z - _arg_1.v0_.z));
        if (_local4 < 0.001 && _local4 > -0.001) {
            return 0;
        }
        if (_local4 > 0) {
            return 1;
        }
        return 2;
    }

    public function lerp(_arg_1:Number):Vector3D {
        return new Vector3D(this.v0_.x + (this.v1_.x - this.v0_.x) * _arg_1, this.v0_.y + (this.v1_.y - this.v0_.y) * _arg_1, this.v0_.z + (this.v1_.z - this.v0_.z) * _arg_1);
    }

    public function toString():String {
        return "(" + this.v0_ + ", " + this.v1_ + ")";
    }
}
}

import com.company.assembleegameclient.engine3d.Line3D;

import flash.geom.Vector3D;

class UnitTest_5202 {


    public static function run():Boolean {
        return testCrossZ();
    }

    private static function testCrossZ():Boolean {
        var _local1:Line3D = new Line3D(new Vector3D(0, 0, 0), new Vector3D(0, 100, 0));
        var _local2:Line3D = new Line3D(new Vector3D(10, 0, 10), new Vector3D(-10, 100, -100));
        if (_local1.crossZ(_local2) != 1) {
            return false;
        }
        if (_local2.crossZ(_local1) != 2) {
            return false;
        }
        _local1 = new Line3D(new Vector3D(1, 1, 200), new Vector3D(6, 6, 200));
        _local2 = new Line3D(new Vector3D(3, 1, -100), new Vector3D(1, 3, -100));
        if (_local1.crossZ(_local2) != 1) {
            return false;
        }
        if (_local2.crossZ(_local1) != 2) {
            return false;
        }
        return true;
    }

    function UnitTest_5202() {
        super();
    }
}
