package com.company.assembleegameclient.objects {
import com.company.assembleegameclient.engine3d.Face3D;
import com.company.assembleegameclient.map.Camera;
import com.company.assembleegameclient.map.Square;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.util.BitmapUtil;

import flash.display.BitmapData;
import flash.display.GraphicsBitmapFill;

public class Wall extends GameObject {

    private static const UVT:Vector.<Number> = new <Number>[0, 0, 0, 1, 0, 0, 1, 1, 0, 0, 1, 0];

    private static const sqX:Vector.<int> = new <int>[0, 1, 0, -1];

    private static const sqY:Vector.<int> = new <int>[-1, 0, 1, 0];

    private static var nums:Vector.<Number> = new <Number>[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

    public function Wall(_arg_1:XML) {
        faces_ = new Vector.<Face3D>();
        super(_arg_1);
        hasShadow_ = false;
        var _local2:TextureData = ObjectLibrary.typeToTopTextureData_[objectType_];
        this.topTexture_ = _local2.getTexture(0);
    }
    public var faces_:Vector.<Face3D>;
    private var topFace_:Face3D = null;
    private var topTexture_:BitmapData = null;

    override public function setObjectId(_arg_1:int):void {
        super.setObjectId(_arg_1);
        var _local2:TextureData = ObjectLibrary.typeToTopTextureData_[objectType_];
        this.topTexture_ = _local2.getTexture(_arg_1);
    }

    override public function getColor():uint {
        return BitmapUtil.mostCommonColor(this.topTexture_);
    }

    override public function draw(_arg_1:Vector.<GraphicsBitmapFill>, _arg_2:Camera, _arg_3:int):void {
        var _local8:int = 0;
        var _local4:BitmapData = null;
        var _local5:Face3D = null;
        var _local6:Square = null;
        if (Parameters.lowCPUMode) {
            return;
        }
        if (texture == null) {
            return;
        }
        if (this.faces_.length == 0) {
            this.rebuild3D_clean();
        }
        var _local7:* = texture;
        if (this.animations_) {
            _local4 = this.animations_.getTexture(_arg_3);
            if (_local4) {
                _local7 = _local4;
            }
        }
        var _local9:uint = this.faces_.length;
        _local8 = 0;
        while (_local8 < _local9) {
            _local5 = this.faces_[_local8];
            _local6 = this.map_.lookupSquare(x_ + sqX[_local8], y_ + sqY[_local8]);
            if (_local6 == null || _local6.texture_ == null || _local6 && _local6.obj_ is Wall && !_local6.obj_.dead_) {
                _local5.blackOut_ = true;
            } else {
                _local5.blackOut_ = false;
                if (this.animations_) {
                    _local5.setTexture(_local7);
                }
            }
            _local5.draw(_arg_1, _arg_2);
            _local8++;
        }
        this.topFace_.draw(_arg_1, _arg_2);
    }

    public function rebuild3D_clean():void {
        this.faces_.length = 0;
        var _local3:int = x_;
        var _local2:int = y_;
        var _local1:Vector.<Number> = new <Number>[_local3, _local2, 1, _local3 + 1, _local2, 1, _local3 + 1, _local2 + 1, 1, _local3, _local2 + 1, 1];
        this.topFace_ = new Face3D(this.topTexture_, _local1, UVT, false, true);
        this.topFace_.bitmapFill.repeat = true;
        this.addWall(_local3, _local2, 1, _local3 + 1, _local2, 1);
        this.addWall(_local3 + 1, _local2, 1, _local3 + 1, _local2 + 1, 1);
        this.addWall(_local3 + 1, _local2 + 1, 1, _local3, _local2 + 1, 1);
        this.addWall(_local3, _local2 + 1, 1, _local3, _local2, 1);
    }

    public function rebuild3D_2():void {
        this.faces_.length = 0;
        var _local1:int = x_ + 1;
        var _local2:int = y_ + 1;
        nums[0] = x_;
        nums[1] = y_;
        nums[2] = 1;
        nums[3] = _local1;
        nums[4] = y_;
        nums[5] = 1;
        nums[6] = _local1;
        nums[7] = _local2;
        nums[8] = 1;
        nums[9] = x_;
        nums[10] = _local2;
        nums[11] = 1;
        this.topFace_ = new Face3D(this.topTexture_, nums, UVT, false, true);
        this.topFace_.bitmapFill.repeat = true;
        this.addWall(x_, y_, 1, _local1, y_, 1);
        this.addWall(_local1, y_, 1, _local1, _local2, 1);
        this.addWall(_local1, _local2, 1, x_, _local2, 1);
        this.addWall(x_, _local2, 1, x_, y_, 1);
    }

    private function addWall(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Number, _arg_6:Number):void {
        var _local8:Vector.<Number> = new <Number>[_arg_1, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_4, _arg_5, _arg_6 - 1, _arg_1, _arg_2, _arg_3 - 1];
        var _local7:Face3D = new Face3D(texture, _local8, UVT, true, true);
        _local7.bitmapFill.repeat = true;
        this.faces_.push(_local7);
    }
}
}
