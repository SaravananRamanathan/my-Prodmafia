package com.company.assembleegameclient.engine3d {
import com.company.assembleegameclient.map.Camera;
import com.company.assembleegameclient.util.TextureRedrawer;
import com.company.util.Triangle;

import flash.display.BitmapData;
import flash.display.GraphicsBitmapFill;
import flash.geom.Utils3D;
import flash.geom.Vector3D;

public class Face3D {
    private var blackOutFill:GraphicsBitmapFill;

    public function Face3D(_arg_1:BitmapData, _arg_2:Vector.<Number>, _arg_3:Vector.<Number>, _arg_4:Boolean = false, _arg_5:Boolean = false) {
        var _local6:* = null;
        vout_ = new Vector.<Number>();
        bitmapFill = new GraphicsBitmapFill(null, null, false, false);
        blackOutFill = new GraphicsBitmapFill(null, null, false, false);
        super();
        this.origTexture_ = _arg_1;
        this.vin_ = _arg_2;
        this.uvt = _arg_3;
        this.backfaceCull_ = _arg_4;
        if (_arg_5) {
            _local6 = new Vector3D();
            Plane3D.computeNormalVec(_arg_2, _local6);
            this.shade_ = Lighting3D.shadeValue(_local6, 0.75);
        }
    }
    public var origTexture_:BitmapData;
    public var vin_:Vector.<Number>;
    public var uvt:Vector.<Number>;
    public var vout_:Vector.<Number>;
    public var backfaceCull_:Boolean;
    public var shade_:Number = 1;
    public var blackOut_:Boolean = false;
    public var bitmapFill:GraphicsBitmapFill;
    private var needGen_:Boolean = true;
    private var textureMatrix_:TextureMatrix = null;

    public function dispose():void {
        this.origTexture_ = null;
        this.vin_.length = 0;
        this.vin_ = null;
        this.uvt.length = 0;
        this.uvt = null;
        this.vout_.length = 0;
        this.vout_ = null;
        this.textureMatrix_.uvMatrix_ = null;
        this.textureMatrix_.tToS_ = null;
        this.textureMatrix_.tempMatrix_ = null;
        this.textureMatrix_ = null;
        this.bitmapFill = null;
    }

    public function setTexture(_arg_1:BitmapData):void {
        if (this.origTexture_ == _arg_1) {
            return;
        }
        this.origTexture_ = _arg_1;
        this.needGen_ = true;
    }

    public function setUVT(_arg_1:Vector.<Number>):void {
        this.uvt = _arg_1;
        this.needGen_ = true;
    }

    public function draw(gfx:Vector.<GraphicsBitmapFill>, camera:Camera) : Boolean {
        Utils3D.projectVectors(camera.wToS_, this.vin_, this.vout_, this.uvt);
        if (this.backfaceCull_ &&
                (this.vout_[2] - this.vout_[0]) * (this.vout_[5] - this.vout_[1])
                - (this.vout_[3] - this.vout_[1]) * (this.vout_[4] - this.vout_[0]) > 0)
                return false;

        var voutLen:uint = this.vout_.length;
        var clip:Boolean = false;

        for (var i:int = 0; i < voutLen; i += 2)
            if (this.vout_[i] >= camera.clipRect_.x - 10
                    && this.vout_[i] <= camera.clipRect_.right + 10
                    && this.vout_[i + 1] >= camera.clipRect_.y - 10
                    && this.vout_[i + 1] <= camera.clipRect_.bottom + 10) {
                clip = false;
                break;
            }

        if (clip)
            return false;

        if (this.needGen_)
            this.generateTextureMatrix();

        this.textureMatrix_.calculateTextureMatrix(this.vout_);

        if (this.blackOut_) {
            if (this.needGen_ || !this.blackOutFill.bitmapData) {
                var tex:BitmapData = this.textureMatrix_.texture_;
                this.blackOutFill.bitmapData = new BitmapData(tex.width, tex.height, false, 0);
            }
            this.blackOutFill.matrix = this.textureMatrix_.tToS_;
            gfx.push(blackOutFill);
            return true;
        }

        this.bitmapFill.bitmapData = this.textureMatrix_.texture_;
        this.bitmapFill.matrix = this.textureMatrix_.tToS_;
        gfx.push(this.bitmapFill);
        return true;
    }

    public function contains(_arg_1:Number, _arg_2:Number):Boolean {
        if (Triangle.containsXY(this.vout_[0], this.vout_[1], this.vout_[2], this.vout_[3], this.vout_[4], this.vout_[5], _arg_1, _arg_2)) {
            return true;
        }
        return this.vout_.length == 8 && Triangle.containsXY(this.vout_[0], this.vout_[1], this.vout_[4], this.vout_[5], this.vout_[6], this.vout_[7], _arg_1, _arg_2);
    }

    private function generateTextureMatrix() : void {
        var _local2:BitmapData = TextureRedrawer.redrawFace(this.origTexture_, this.shade_);
        if (this.textureMatrix_ == null) {
            this.textureMatrix_ = new TextureMatrix(_local2, this.uvt);
        } else {
            this.textureMatrix_.texture_ = _local2;
            this.textureMatrix_.calculateUVMatrix(this.uvt);
        }
        this.needGen_ = false;
    }
}
}
