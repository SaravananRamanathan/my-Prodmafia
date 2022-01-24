package com.company.assembleegameclient.engine3d {
import flash.geom.Vector3D;

public class Plane3D {

    public static const NONE:int = 0;

    public static const POSITIVE:int = 1;

    public static const NEGATIVE:int = 2;

    public static const EQUAL:int = 3;

    public static function computeNormal(_arg_1:Vector3D, _arg_2:Vector3D, _arg_3:Vector3D, _arg_4:Vector3D):void {
        var _local10:Number = _arg_2.x - _arg_1.x;
        var _local7:Number = _arg_2.y - _arg_1.y;
        var _local6:Number = _arg_2.z - _arg_1.z;
        var _local9:Number = _arg_3.x - _arg_1.x;
        var _local5:Number = _arg_3.y - _arg_1.y;
        var _local8:Number = _arg_3.z - _arg_1.z;
        _arg_4.x = _local7 * _local8 - _local6 * _local5;
        _arg_4.y = _local6 * _local9 - _local10 * _local8;
        _arg_4.z = _local10 * _local5 - _local7 * _local9;
        _arg_4.normalize();
    }

    public static function computeNormalVec(_arg_1:Vector.<Number>, _arg_2:Vector3D):void {
        var _local6:Number = _arg_1[3] - _arg_1[0];
        var _local3:Number = _arg_1[4] - _arg_1[1];
        var _local8:Number = _arg_1[5] - _arg_1[2];
        var _local5:Number = _arg_1[6] - _arg_1[0];
        var _local4:Number = _arg_1[7] - _arg_1[1];
        var _local7:Number = _arg_1[8] - _arg_1[2];
        _arg_2.x = _local3 * _local7 - _local8 * _local4;
        _arg_2.y = _local8 * _local5 - _local6 * _local7;
        _arg_2.z = _local6 * _local4 - _local3 * _local5;
        _arg_2.normalize();
    }

    public function Plane3D(_arg_1:Vector3D = null, _arg_2:Vector3D = null, _arg_3:Vector3D = null) {
        super();
        if (_arg_1 != null && _arg_2 != null && _arg_3 != null) {
            this.normal_ = new Vector3D();
            computeNormal(_arg_1, _arg_2, _arg_3, this.normal_);
            this.d_ = -this.normal_.dotProduct(_arg_1);
        }
    }
    public var normal_:Vector3D;
    public var d_:Number;

    public function testPoint(_arg_1:Vector3D):int {
        var _local2:Number = this.normal_.dotProduct(_arg_1) + this.d_;
        if (_local2 > 0.001) {
            return 1;
        }
        if (_local2 < -0.001) {
            return 2;
        }
        return 3;
    }

    public function lineIntersect(_arg_1:Line3D):Number {
        var _local2:Number = -this.d_ - this.normal_.x * _arg_1.v0_.x - this.normal_.y * _arg_1.v0_.y - this.normal_.z * _arg_1.v0_.z;
        var _local3:Number = this.normal_.x * (_arg_1.v1_.x - _arg_1.v0_.x) + this.normal_.y * (_arg_1.v1_.y - _arg_1.v0_.y) + this.normal_.z * (_arg_1.v1_.z - _arg_1.v0_.z);
        if (_local3 == 0) {
            return NaN;
        }
        return _local2 / _local3;
    }

    public function zAtXY(_arg_1:Number, _arg_2:Number):Number {
        return -(this.d_ + this.normal_.x * _arg_1 + this.normal_.y * _arg_2) / this.normal_.z;
    }

    public function toString():String {
        return "Plane(n = " + this.normal_ + ", d = " + this.d_ + ")";
    }
}
}
