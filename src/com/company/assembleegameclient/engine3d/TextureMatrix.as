package com.company.assembleegameclient.engine3d {
import flash.display.BitmapData;
import flash.geom.Matrix;

public class TextureMatrix {


    public function TextureMatrix(_arg_1:BitmapData, _arg_2:Vector.<Number>) {
        tToS_ = new Matrix();
        tempMatrix_ = new Matrix();
        uvMatrix_ = new Matrix();
        super();
        this.texture_ = _arg_1;
        this.calculateUVMatrix(_arg_2);
    }
    public var texture_:BitmapData = null;
    public var tToS_:Matrix;
    public var tempMatrix_:Matrix;
    public var uvMatrix_:Matrix;

    public function setUVT(_arg_1:Vector.<Number>):void {
        this.calculateUVMatrix(_arg_1);
    }

    public function setVOut(_arg_1:Vector.<Number>):void {
        this.calculateTextureMatrix(_arg_1);
    }

    public function calculateTextureMatrix(_arg_1:Vector.<Number>):void {
        this.tToS_.a = this.uvMatrix_.a;
        this.tToS_.b = this.uvMatrix_.b;
        this.tToS_.c = this.uvMatrix_.c;
        this.tToS_.d = this.uvMatrix_.d;
        this.tToS_.tx = this.uvMatrix_.tx;
        this.tToS_.ty = this.uvMatrix_.ty;
        var _local2:int = _arg_1.length - 2;
        this.tempMatrix_.a = _arg_1[2] - _arg_1[0];
        this.tempMatrix_.b = _arg_1[3] - _arg_1[1];
        this.tempMatrix_.c = _arg_1[_local2] - _arg_1[0];
        this.tempMatrix_.d = _arg_1[_local2 + 1] - _arg_1[1];
        this.tempMatrix_.tx = _arg_1[0];
        this.tempMatrix_.ty = _arg_1[1];
        this.tToS_.concat(this.tempMatrix_);
    }

    public function calculateUVMatrix(_arg_1:Vector.<Number>):void {
        if (this.texture_ == null) {
            this.uvMatrix_ = null;
            return;
        }
        // assume same width and height for more performance
        const size:int = this.texture_.height;
        var _local3:Number = _arg_1[0] * size;
        var _local5:Number = _arg_1[1] * size;
        this.uvMatrix_.a = _arg_1[3] * size - _local3;
        this.uvMatrix_.b = _arg_1[4] * size - _local5;
        this.uvMatrix_.c = _arg_1[_arg_1.length - 3] * size - _local3;
        this.uvMatrix_.d = _arg_1[_arg_1.length - 2] * size - _local5;
        this.uvMatrix_.tx = _local3;
        this.uvMatrix_.ty = _local5;
        this.uvMatrix_.invert();
    }
}
}
