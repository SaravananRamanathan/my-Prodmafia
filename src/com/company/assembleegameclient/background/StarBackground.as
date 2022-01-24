package com.company.assembleegameclient.background {
import com.company.assembleegameclient.map.Camera;
import com.company.util.AssetLibrary;
import com.company.util.ImageSet;
import com.company.util.PointUtil;

import flash.display.IGraphicsData;

public class StarBackground extends Background {


    public function StarBackground() {
        var _local1:int = 0;
        stars_ = new Vector.<Star>();
        graphicsData_ = new Vector.<IGraphicsData>();
        super();
        visible = true;
        while (_local1 < 100) {
            this.tryAddStar();
            _local1++;
        }
    }
    public var stars_:Vector.<Star>;
    protected var graphicsData_:Vector.<IGraphicsData>;

    override public function draw(_arg_1:Camera, _arg_2:int):void {
        var _local3:* = null;
        this.graphicsData_.length = 0;
        var _local5:int = 0;
        var _local4:* = this.stars_;
        for each(_local3 in this.stars_) {
            _local3.draw(this.graphicsData_, _arg_1, _arg_2);
        }
        graphics.clear();
        graphics.drawGraphicsData(this.graphicsData_);
    }

    private function tryAddStar():void {
        var _local3:* = null;
        var _local2:ImageSet = AssetLibrary.getImageSet("stars");
        var _local1:Star = new Star(Math.random() * 1000 - 500, Math.random() * 1000 - 500, 4 * (0.5 + 0.5 * Math.random()), _local2.images[int(_local2.images.length * Math.random())]);
        var _local5:int = 0;
        var _local4:* = this.stars_;
        for each(_local3 in this.stars_) {
            if (PointUtil.distanceXY(_local1.x_, _local1.y_, _local3.x_, _local3.y_) < 3) {
                return;
            }
        }
        this.stars_.push(_local1);
    }
}
}

import com.company.assembleegameclient.map.Camera;

import flash.display.BitmapData;
import flash.display.GraphicsBitmapFill;
import flash.display.GraphicsEndFill;
import flash.display.GraphicsPath;
import flash.display.IGraphicsData;
import flash.geom.Matrix;

class Star {

    protected static const sqCommands:Vector.<int> = new <int>[1, 2, 2, 2];

    protected static const END_FILL:GraphicsEndFill = new GraphicsEndFill();

    function Star(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:BitmapData) {
        bitmapFill_ = new GraphicsBitmapFill(null, new Matrix(), false, false);
        path_ = new GraphicsPath(Star.sqCommands, new Vector.<Number>());
        super();
        this.x_ = _arg_1;
        this.y_ = _arg_2;
        this.scale_ = _arg_3;
        this.bitmap_ = _arg_4;
        this.w_ = this.bitmap_.width * this.scale_;
        this.h_ = this.bitmap_.height * this.scale_;
    }
    public var x_:Number;
    public var y_:Number;
    public var scale_:Number;
    public var bitmap_:BitmapData;
    protected var bitmapFill_:GraphicsBitmapFill;
    protected var path_:GraphicsPath;
    private var w_:Number;
    private var h_:Number;

    public function draw(_arg_1:Vector.<IGraphicsData>, _arg_2:Camera, _arg_3:int):void {
        var _local6:Number = this.x_ * Math.cos(-_arg_2.angleRad_) - this.y_ * Math.sin(-_arg_2.angleRad_);
        var _local5:Number = this.x_ * Math.sin(-_arg_2.angleRad_) + this.y_ * Math.cos(-_arg_2.angleRad_);
        var _local4:Matrix = this.bitmapFill_.matrix;
        _local4.identity();
        _local4.translate(-this.bitmap_.width / 2, -this.bitmap_.height / 2);
        _local4.scale(this.scale_, this.scale_);
        _local4.translate(_local6, _local5);
        this.bitmapFill_.bitmapData = this.bitmap_;
        this.path_.data.length = 0;
        var _local8:Number = _local6 - this.w_ / 2;
        var _local7:Number = _local5 - this.h_ / 2;
        this.path_.data.push(_local8, _local7, _local8 + this.w_, _local7, _local8 + this.w_, _local7 + this.h_, _local8, _local7 + this.h_);
        _arg_1.push(this.bitmapFill_);
        _arg_1.push(this.path_);
        _arg_1.push(END_FILL);
    }
}
