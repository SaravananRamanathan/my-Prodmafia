package com.company.assembleegameclient.map {
import com.company.assembleegameclient.engine3d.Face3D;

import flash.display.BitmapData;
import flash.display.GraphicsBitmapFill;

import kabam.rotmg.stage3D.GraphicsFillExtra;

public class SquareFace {
    public var animate_:int;
    public var face:Face3D;
    public var xOffset:Number = 0;
    public var yOffset:Number = 0;
    public var animateDx:Number = 0;
    public var animateDy:Number = 0;

    public function SquareFace(tex:BitmapData, vin:Vector.<Number>, xOffset:Number, yOffset:Number, animate:int, dx:Number, dy:Number) {
        super();
        this.face = new Face3D(tex, vin, Square.UVT.concat());
        this.xOffset = xOffset;
        this.yOffset = yOffset;
        if (this.xOffset != 0 || this.yOffset != 0) {
            this.face.bitmapFill.repeat = true;
        }
        this.animate_ = animate;
        if (this.animate_ != 0) {
            this.face.bitmapFill.repeat = true;
        }
        this.animateDx = dx;
        this.animateDy = dy;
    }

    public function dispose():void {
        this.face.dispose();
        this.face = null;
    }

    public function draw(gfx:Vector.<GraphicsBitmapFill>, camera:Camera, time:int) : Boolean {
        var xOffset:Number = NaN;
        var yOffset:Number = NaN;
        if (this.animate_ != 0) {
            switch (int(this.animate_) - 1) {
                case 0:
                    xOffset = this.xOffset + Math.sin(this.animateDx * time / 1000);
                    yOffset = this.yOffset + Math.sin(this.animateDy * time / 1000);
                    break;
                case 1:
                    xOffset = this.xOffset + this.animateDx * time / 1000;
                    yOffset = this.yOffset + this.animateDy * time / 1000;
            }
        } else {
            xOffset = this.xOffset;
            yOffset = this.yOffset;
        }

        GraphicsFillExtra.setOffsetUV(this.face.bitmapFill, xOffset, yOffset);

        this.face.uvt.length = 0;
        this.face.uvt.push(0, 0, 0, 1, 0, 0, 1, 1, 0, 0, 1, 0);
        this.face.setUVT(this.face.uvt);
        var draw:Boolean = this.face.draw(gfx, camera);
        return draw;
    }
}
}
