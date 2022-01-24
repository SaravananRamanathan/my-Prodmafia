package com.company.assembleegameclient.objects {
import com.company.assembleegameclient.engine3d.Face3D;
import com.company.assembleegameclient.map.Camera;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.util.BitmapUtil;

import flash.display.BitmapData;
import flash.display.GraphicsBitmapFill;

public class DoubleWall extends GameObject {

    private static const UVT:Vector.<Number> = new <Number>[0, 0, 0, 1, 0, 0, 1, 1, 0, 0, 1, 0];

    private static const UVTHEIGHT:Vector.<Number> = new <Number>[0, 0, 0, 1, 0, 0, 1, 2, 0, 0, 2, 0];

    private static const sqX:Vector.<int> = new <int>[0, 1, 0, -1];

    private static const sqY:Vector.<int> = new <int>[-1, 0, 1, 0];

    public function DoubleWall(_arg_1:XML) {
        faces = new Vector.<Face3D>();
        super(_arg_1);
        hasShadow_ = false;
        var _local2:TextureData = ObjectLibrary.typeToTopTextureData_[objectType_];
        this.topTexture = _local2.getTexture(0);
    }
    public var faces:Vector.<Face3D>;
    private var topFace:Face3D = null;
    private var topTexture:BitmapData = null;

    override public function setObjectId(_arg_1:int):void {
        super.setObjectId(_arg_1);
        var _local2:TextureData = ObjectLibrary.typeToTopTextureData_[objectType_];
        this.topTexture = _local2.getTexture(_arg_1);
    }

    override public function getColor():uint {
        return BitmapUtil.mostCommonColor(this.topTexture);
    }

    override public function draw(_arg_1:Vector.<GraphicsBitmapFill>, _arg_2:Camera, _arg_3:int):void {
        var _local8:int = 0;
        var _local7:* = null;
        var _local5:* = null;
        var _local6:* = null;
        if (Parameters.lowCPUMode) {
            return;
        }
        if (texture == null) {
            return;
        }
        if (this.faces.length == 0) {
            this.rebuild3D();
        }
        var _local4:* = texture;
        if (animations_) {
            _local7 = animations_.getTexture(_arg_3);
            if (_local7) {
                _local4 = _local7;
            }
        }
        var _local9:uint = this.faces.length;
        _local8 = 0;
        while (_local8 < _local9) {
            _local5 = this.faces[_local8];
            _local6 = map_.lookupSquare(x_ + sqX[_local8], y_ + sqY[_local8]);
            if (_local6 == null || _local6.texture_ == null || _local6 && _local6.obj_ is DoubleWall && !_local6.obj_.dead_) {
                _local5.blackOut_ = true;
            } else {
                _local5.blackOut_ = false;
                if (animations_) {
                    _local5.setTexture(_local4);
                }
            }
            _local5.draw(_arg_1, _arg_2);
            _local8++;
        }
        this.topFace.draw(_arg_1, _arg_2);
    }

    public function rebuild3D() : void {
        this.faces.length = 0;
        var x:int = x_;
        var y:int = y_;
        var vin:Vector.<Number> = new <Number>[x, y, 2, x + 1, y, 2, x + 1, y + 1, 2, x, y + 1, 2];
        this.topFace = new Face3D(this.topTexture, vin, UVT, false, true);
        this.topFace.bitmapFill.repeat = true;
        this.addFace(x, y, 2, x + 1, y, 2);
        this.addFace(x + 1, y, 2, x + 1, y + 1, 2);
        this.addFace(x + 1, y + 1, 2, x, y + 1, 2);
        this.addFace(x, y + 1, 2, x, y, 2);
    }

    private function addFace(x0:Number, y0:Number, z0:Number, x1:Number, y1:Number, z1:Number):void {
        var _local8:Vector.<Number> = new <Number>[x0, y0, z0, x1, y1, z1, x1, y1, z1 - 1, x0, y0, z0 - 1];
        var _local7:Face3D = new Face3D(texture, _local8, UVTHEIGHT, true, true);
        _local7.bitmapFill.repeat = true;
        this.faces.push(_local7);
    }
}
}
