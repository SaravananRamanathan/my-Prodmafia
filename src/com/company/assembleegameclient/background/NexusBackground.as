package com.company.assembleegameclient.background {
import com.company.assembleegameclient.map.Camera;
import com.company.util.GraphicsUtil;

import flash.display.BitmapData;
import flash.display.GraphicsBitmapFill;
import flash.display.GraphicsPath;
import flash.display.IGraphicsData;
import flash.geom.Matrix;
import flash.geom.Point;

public class NexusBackground extends Background {

    public static const MOVEMENT:Point = new Point(0.01, 0.01);

    public function NexusBackground() {
        graphicsData_ = new Vector.<IGraphicsData>();
        islands_ = new Vector.<Island>();
        bitmapFill_ = new GraphicsBitmapFill(null, new Matrix(), true, false);
        path_ = new GraphicsPath(GraphicsUtil.QUAD_COMMANDS, new Vector.<Number>());
        super();
        visible = true;
        this.water_ = new BitmapDataSpy(1024, 1024, false, 0);
        this.water_.perlinNoise(1024, 1024, 8, Math.random(), true, true, 4, false, null);
    }
    protected var graphicsData_:Vector.<IGraphicsData>;
    private var water_:BitmapData;
    private var islands_:Vector.<Island>;
    private var bitmapFill_:GraphicsBitmapFill;
    private var path_:GraphicsPath;

    override public function draw(_arg_1:Camera, _arg_2:int):void {
        this.graphicsData_.length = 0;
        var _local4:Matrix = this.bitmapFill_.matrix;
        _local4.identity();
        _local4.translate(_arg_2 * MOVEMENT.x, _arg_2 * MOVEMENT.y);
        _local4.rotate(-_arg_1.angleRad_);
        this.bitmapFill_.bitmapData = this.water_;
        this.graphicsData_.push(this.bitmapFill_);
        this.drawIslands(_arg_1, _arg_2);
        graphics.clear();
        graphics.drawGraphicsData(this.graphicsData_);
    }

    private function drawIslands(_arg_1:Camera, _arg_2:int):void {
        var _local3:* = null;
        var _local4:int = 0;
        while (_local4 < this.islands_.length) {
            _local3 = this.islands_[_local4];
            _local3.draw(_arg_1, _arg_2, this.graphicsData_);
            _local4++;
        }
    }
}
}

import com.company.assembleegameclient.background.NexusBackground;
import com.company.assembleegameclient.map.Camera;
import com.company.util.AssetLibrary;
import com.company.util.GraphicsUtil;

import flash.display.BitmapData;
import flash.display.GraphicsBitmapFill;
import flash.display.GraphicsPath;
import flash.display.IGraphicsData;
import flash.geom.Matrix;
import flash.geom.Point;

class Island {


    function Island(_arg_1:Number, _arg_2:Number, _arg_3:int) {
        bitmapFill_ = new GraphicsBitmapFill(null, new Matrix(), true, false);
        path_ = new GraphicsPath(GraphicsUtil.QUAD_COMMANDS, new Vector.<Number>());
        super();
        this.center_ = new Point(_arg_1, _arg_2);
        this.startTime_ = _arg_3;
        this.bitmapData_ = AssetLibrary.getImage("stars");
    }
    public var center_:Point;
    public var startTime_:int;
    public var bitmapData_:BitmapData;
    private var bitmapFill_:GraphicsBitmapFill;
    private var path_:GraphicsPath;

    public function draw(_arg_1:Camera, _arg_2:int, _arg_3:Vector.<IGraphicsData>):void {
        var _local6:int = _arg_2 - this.startTime_;
        var _local5:Number = this.center_.x + _local6 * NexusBackground.MOVEMENT.x;
        var _local4:Number = this.center_.y + _local6 * NexusBackground.MOVEMENT.y;
        var _local9:Matrix = this.bitmapFill_.matrix;
        _local9.identity();
        _local9.translate(_local5, _local4);
        _local9.rotate(-_arg_1.angleRad_);
        this.bitmapFill_.bitmapData = this.bitmapData_;
        _arg_3.push(this.bitmapFill_);
    }
}
