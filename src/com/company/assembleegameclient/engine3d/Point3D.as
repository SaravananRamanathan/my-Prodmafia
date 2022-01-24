package com.company.assembleegameclient.engine3d {
import com.company.assembleegameclient.map.Camera;

import flash.display.BitmapData;
import flash.display.GraphicsBitmapFill;
import flash.display.GraphicsEndFill;
import flash.display.GraphicsPath;
import flash.display.GraphicsSolidFill;
import flash.geom.Matrix;
import flash.geom.Matrix3D;
import flash.geom.Utils3D;
import flash.geom.Vector3D;

public class Point3D {

    private static const commands_:Vector.<int> = new <int>[1, 2, 2, 2];

    private static const END_FILL:GraphicsEndFill = new GraphicsEndFill();


    private const data_:Vector.<Number> = new Vector.<Number>();

    private const path_:GraphicsPath = new GraphicsPath(commands_, data_);

    private const bitmapFill_:GraphicsBitmapFill = new GraphicsBitmapFill(null, new Matrix(), false, false);

    private const solidFill_:GraphicsSolidFill = new GraphicsSolidFill(0, 1);

    public function Point3D(_arg_1:Number) {
        super();
        this.size_ = _arg_1;
    }
    public var size_:Number;
    public var posS_:Vector3D;

    public function setSize(_arg_1:Number):void {
        this.size_ = _arg_1;
    }

    public function draw(_arg_1:Vector.<GraphicsBitmapFill>, _arg_2:Vector3D, _arg_3:Number, _arg_4:Matrix3D, _arg_5:Camera, _arg_6:BitmapData, _arg_7:uint = 0):void {
        var _local9:Number = NaN;
        var _local11:Number = NaN;
        var _local12:* = null;
        this.posS_ = Utils3D.projectVector(_arg_4, _arg_2);
        if (this.posS_.w < 0) {
            return;
        }
        var _local8:Number = this.posS_.w * Math.sin(_arg_5.pp_.fieldOfView / 2 * 0.0174532925199433);
        var _local10:Number = this.size_ / _local8;
        this.data_.length = 0;
        if (_arg_3 == 0) {
            this.data_.push(this.posS_.x - _local10, this.posS_.y - _local10, this.posS_.x + _local10, this.posS_.y - _local10, this.posS_.x + _local10, this.posS_.y + _local10, this.posS_.x - _local10, this.posS_.y + _local10);
        } else {
            _local9 = Math.cos(_arg_3);
            _local11 = Math.sin(_arg_3);
            this.data_.push(this.posS_.x + (_local9 * -_local10 + _local11 * -_local10), this.posS_.y + (_local11 * -_local10 - _local9 * -_local10), this.posS_.x + (_local9 * _local10 + _local11 * -_local10), this.posS_.y + (_local11 * _local10 - _local9 * -_local10), this.posS_.x + (_local9 * _local10 + _local11 * _local10), this.posS_.y + (_local11 * _local10 - _local9 * _local10), this.posS_.x + (_local9 * -_local10 + _local11 * _local10), this.posS_.y + (_local11 * -_local10 - _local9 * _local10));
        }
        if (_arg_6 != null) {
            this.bitmapFill_.bitmapData = _arg_6;
            _local12 = this.bitmapFill_.matrix;
            _local12.identity();
            _local12.scale(2 * _local10 / _arg_6.width, 2 * _local10 / _arg_6.height);
            _local12.translate(-_local10, -_local10);
            _local12.rotate(_arg_3);
            _local12.translate(this.posS_.x, this.posS_.y);
            _arg_1.push(this.bitmapFill_);
        } else {
            this.solidFill_.color = _arg_7;
            _arg_1.push(this.solidFill_);
        }
    }
}
}
