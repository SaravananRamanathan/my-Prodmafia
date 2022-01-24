package com.company.util {
import flash.geom.Point;
import flash.geom.Rectangle;

public class Triangle {


    public static function containsXY(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Number, _arg_6:Number, _arg_7:Number, _arg_8:Number):Boolean {
        var _local14:Number = _arg_3 - _arg_1;
        var _local13:Number = _arg_4 - _arg_2;
        var _local9:Number = _arg_5 - _arg_1;
        var _local10:Number = _arg_6 - _arg_2;
        var _local15:Number = _local14 * _local10 - _local13 * _local9;
        var _local11:Number = (_arg_7 * _local10 - _arg_8 * _local9 - (_arg_1 * _local10 - _arg_2 * _local9)) / _local15;
        var _local12:Number = -(_arg_7 * _local13 - _arg_8 * _local14 - (_arg_1 * _local13 - _arg_2 * _local14)) / _local15;
        return _local11 >= 0 && _local12 >= 0 && _local11 + _local12 <= 1;
    }

    public static function intersectTriAABB(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Number, _arg_6:Number, _arg_7:Number, _arg_8:Number, _arg_9:Number, _arg_10:Number):Boolean {
        if (_arg_7 > _arg_1 && _arg_7 > _arg_3 && _arg_7 > _arg_5 || _arg_9 < _arg_1 && _arg_9 < _arg_3 && _arg_9 < _arg_5 || _arg_8 > _arg_2 && _arg_8 > _arg_4 && _arg_8 > _arg_6 || _arg_10 < _arg_2 && _arg_10 < _arg_4 && _arg_10 < _arg_6) {
            return false;
        }
        if (_arg_7 < _arg_1 && _arg_1 < _arg_9 && _arg_8 < _arg_2 && _arg_2 < _arg_10 || _arg_7 < _arg_3 && _arg_3 < _arg_9 && _arg_8 < _arg_4 && _arg_4 < _arg_10 || _arg_7 < _arg_5 && _arg_5 < _arg_9 && _arg_8 < _arg_6 && _arg_6 < _arg_10) {
            return true;
        }
        return lineRectIntersect(_arg_1, _arg_2, _arg_3, _arg_4, _arg_7, _arg_8, _arg_9, _arg_10) || lineRectIntersect(_arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8, _arg_9, _arg_10) || lineRectIntersect(_arg_5, _arg_6, _arg_1, _arg_2, _arg_7, _arg_8, _arg_9, _arg_10);
    }

    private static function lineRectIntersect(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Number, _arg_6:Number, _arg_7:Number, _arg_8:Number):Boolean {
        var _local12:Number = NaN;
        var _local9:Number = NaN;
        var _local14:* = NaN;
        var _local11:* = NaN;
        var _local13:Number = (_arg_4 - _arg_2) / (_arg_3 - _arg_1);
        var _local15:Number = _arg_2 - _local13 * _arg_1;
        if (_local13 > 0) {
            _local12 = _local13 * _arg_5 + _local15;
            _local9 = _local13 * _arg_7 + _local15;
        } else {
            _local12 = _local13 * _arg_7 + _local15;
            _local9 = _local13 * _arg_5 + _local15;
        }
        if (_arg_2 < _arg_4) {
            _local14 = _arg_2;
            _local11 = _arg_4;
        } else {
            _local14 = _arg_4;
            _local11 = _arg_2;
        }
        var _local10:Number = _local12 > _local14 ? _local12 : Number(_local14);
        var _local16:Number = _local9 < _local11 ? _local9 : Number(_local11);
        return _local10 < _local16 && !(_local16 < _arg_6 || _local10 > _arg_8);
    }

    public function Triangle(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Number, _arg_6:Number) {
        super();
        this.x0_ = _arg_1;
        this.y0_ = _arg_2;
        this.x1_ = _arg_3;
        this.y1_ = _arg_4;
        this.x2_ = _arg_5;
        this.y2_ = _arg_6;
        this.vx1_ = this.x1_ - this.x0_;
        this.vy1_ = this.y1_ - this.y0_;
        this.vx2_ = this.x2_ - this.x0_;
        this.vy2_ = this.y2_ - this.y0_;
    }
    public var x0_:Number;
    public var y0_:Number;
    public var x1_:Number;
    public var y1_:Number;
    public var x2_:Number;
    public var y2_:Number;
    public var vx1_:Number;
    public var vy1_:Number;
    public var vx2_:Number;
    public var vy2_:Number;

    public function aabb():Rectangle {
        var _local4:Number = Math.min(this.x0_, this.x1_, this.x2_);
        var _local2:Number = Math.max(this.x0_, this.x1_, this.x2_);
        var _local1:Number = Math.min(this.y0_, this.y1_, this.y2_);
        var _local3:Number = Math.max(this.y0_, this.y1_, this.y2_);
        return new Rectangle(_local4, _local1, _local2 - _local4, _local3 - _local1);
    }

    public function area():Number {
        return Math.abs((this.x0_ * (this.y1_ - this.y2_) + this.x1_ * (this.y2_ - this.y0_) + this.x2_ * (this.y0_ - this.y1_)) * 0.5);
    }

    public function incenter(_arg_1:Point):void {
        var _local2:Number = PointUtil.distanceXY(this.x1_, this.y1_, this.x2_, this.y2_);
        var _local4:Number = PointUtil.distanceXY(this.x0_, this.y0_, this.x2_, this.y2_);
        var _local3:Number = PointUtil.distanceXY(this.x0_, this.y0_, this.x1_, this.y1_);
        _arg_1.x = (_local2 * this.x0_ + _local4 * this.x1_ + _local3 * this.x2_) / (_local2 + _local4 + _local3);
        _arg_1.y = (_local2 * this.y0_ + _local4 * this.y1_ + _local3 * this.y2_) / (_local2 + _local4 + _local3);
    }

    public function contains(_arg_1:Number, _arg_2:Number):Boolean {
        var _local4:Number = (_arg_1 * this.vy2_ - _arg_2 * this.vx2_ - (this.x0_ * this.vy2_ - this.y0_ * this.vx2_)) / (this.vx1_ * this.vy2_ - this.vy1_ * this.vx2_);
        var _local3:Number = -(_arg_1 * this.vy1_ - _arg_2 * this.vx1_ - (this.x0_ * this.vy1_ - this.y0_ * this.vx1_)) / (this.vx1_ * this.vy2_ - this.vy1_ * this.vx2_);
        return _local4 >= 0 && _local3 >= 0 && _local4 + _local3 <= 1;
    }

    public function distance(_arg_1:Number, _arg_2:Number):Number {
        if (this.contains(_arg_1, _arg_2)) {
            return 0;
        }
        return Math.min(LineSegmentUtil.pointDistance(_arg_1, _arg_2, this.x0_, this.y0_, this.x1_, this.y1_), LineSegmentUtil.pointDistance(_arg_1, _arg_2, this.x1_, this.y1_, this.x2_, this.y2_), LineSegmentUtil.pointDistance(_arg_1, _arg_2, this.x0_, this.y0_, this.x2_, this.y2_));
    }

    public function intersectAABB(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number):Boolean {
        return intersectTriAABB(this.x0_, this.y0_, this.x1_, this.y1_, this.x2_, this.y2_, _arg_1, _arg_2, _arg_3, _arg_4);
    }
}
}
