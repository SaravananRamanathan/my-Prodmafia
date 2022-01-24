package com.company.assembleegameclient.map {
import com.company.assembleegameclient.engine3d.TextureMatrix;
import com.company.assembleegameclient.objects.GameObject;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.util.TileRedrawer;

import flash.display.BitmapData;
import flash.display.GraphicsBitmapFill;

public class Square {

    public static const UVT:Vector.<Number> = new <Number>[0, 0, 0, 1, 0, 0, 1, 1, 0, 0, 1, 0];


    private static const LOOKUP:Vector.<int> = new <int>[26171, 44789, 20333, 70429, 98257, 59393, 33961];

    public function Square(_arg_1:Map, _arg_2:int, _arg_3:int) {
        props_ = GroundLibrary.defaultProps_;
        faces_ = new Vector.<SquareFace>();
        super();
        this.map = _arg_1;
        this.x_ = _arg_2;
        this.y_ = _arg_3;
        this.centerX_ = this.x_ + 0.5;
        this.centerY_ = this.y_ + 0.5;
        this.vin_ = new <Number>[this.x_, this.y_, 0, this.x_ + 1, this.y_, 0, this.x_ + 1, this.y_ + 1, 0, this.x_, this.y_ + 1, 0];
    }
    public var map:Map;
    public var x_:int;
    public var y_:int;
    public var tileType:uint = 255;
    public var centerX_:Number;
    public var centerY_:Number;
    public var vin_:Vector.<Number>;
    public var obj_:GameObject = null;
    public var props_:GroundProperties;
    public var texture_:BitmapData = null;
    public var textureW_:int;
    public var textureH_:int;
    public var sink:int = 0;
    public var lastDamage_:int = 0;
    public var faces_:Vector.<SquareFace>;
    public var topFace_:SquareFace = null;
    public var baseTexMatrix_:TextureMatrix = null;
    public var lastVisible_:int;
    public var bmpRect_:BitmapData;

    public function dispose():void {
        var _local1:* = null;
        this.map = null;
        this.vin_.length = 0;
        this.vin_ = null;
        this.obj_ = null;
        this.texture_ = null;
        var _local3:int = 0;
        var _local2:* = this.faces_;
        for each(_local1 in this.faces_) {
            _local1.dispose();
            _local1 = null;
        }
        this.faces_.length = 0;
        if (this.topFace_) {
            this.topFace_.dispose();
            this.topFace_ = null;
        }
        this.faces_ = null;
        this.baseTexMatrix_ = null;
    }

    public function setTileType(_arg_1:uint):void {
        this.tileType = _arg_1;
        this.props_ = GroundLibrary.propsLibrary_[this.tileType];
        this.texture_ = GroundLibrary.getBitmapData(this.tileType, hash(this.x_, this.y_));
        this.bmpRect_ = GroundLibrary.getBitmapData(this.tileType);
        this.textureW_ = this.texture_.width;
        this.textureH_ = this.texture_.height;
        this.baseTexMatrix_ = new TextureMatrix(this.texture_, UVT);
        this.faces_.length = 0;
    }

    public function isWalkable():Boolean {
        return !this.props_.noWalk_ && (this.obj_ == null || !this.obj_.props_.occupySquare_);
    }

    public function draw(_arg_1:Vector.<GraphicsBitmapFill>, _arg_2:Camera, _arg_3:int):void {
        var _local5:SquareFace = null;
        if (Parameters.lowCPUMode && this.map && this.map.player_
                && this != this.map.player_.square && this.props_.maxDamage_ == 0)
                return;

        if (Parameters.data.noClip && !this.isWalkable())
                return;

        if (this.texture_ == null) {
            return;
        }
        if (this.faces_.length == 0) {
            this.rebuild3D();
        }
        var _local4:Number = _arg_2.clipRect_.bottom;
        for each(_local5 in this.faces_) {
            if (!_local5.draw(_arg_1, _arg_2, _arg_3)) {
                if (_local5.face.vout_[1] < _local4) {
                    this.lastVisible_ = 0;
                }
                return;
            }
        }
    }

    public function drawTop(_arg_1:Vector.<GraphicsBitmapFill>, _arg_2:Camera, _arg_3:int):void {
        this.topFace_.draw(_arg_1, _arg_2, _arg_3);
    }

    public static function hash(_arg_1:int, _arg_2:int):int {
        return ((_arg_1 << 16 | _arg_2) ^ 81397550) * LOOKUP[(_arg_1 + _arg_2) % 7] % 65535;
    }

    private function rebuild3D():void {
        var _local2:* = NaN;
        var _local1:* = NaN;
        var _local3:* = 0;
        var _local4:* = undefined;
        var _local7:* = 0;
        var _local6:* = null;
        var _local5:* = null;
        this.faces_.length = 0;
        this.topFace_ = null;
        if (this.props_.animate_.type_ != 0) {
            this.faces_.push(new SquareFace(this.texture_, this.vin_, this.props_.xOffset_, this.props_.yOffset_, this.props_.animate_.type_, this.props_.animate_.dx_, this.props_.animate_.dy_));
            _local6 = TileRedrawer.redraw(this, false);
            if (_local6) {
                this.faces_.push(new SquareFace(_local6, this.vin_, 0, 0, 0, 0, 0));
            }
        } else {
            _local6 = TileRedrawer.redraw(this, true);
            _local2 = 0;
            _local1 = 0;
            if (_local6 == null) {
                if (this.props_.randomOffset_) {
                    _local2 = (int((this.texture_.width * Math.random())) / this.texture_.width);
                    _local3 = (int((this.texture_.height * Math.random())) / this.texture_.height);
                } else {
                    _local2 = Number(this.props_.xOffset_);
                    _local1 = Number(this.props_.yOffset_);
                }
                this.faces_.push(new SquareFace(this.texture_, this.vin_, _local2, _local1, 0, 0, 0));
            } else {
                this.faces_.push(new SquareFace(_local6, this.vin_, _local2, _local1, 0, 0, 0));
            }
        }
        if (this.props_.sink_) {
            this.sink = _local6 == null ? 12 : 6;
        } else {
            this.sink = 0;
        }
        if (this.props_.topTD_) {
            _local5 = this.props_.topTD_.getTexture();
            _local4 = this.vin_.concat();
            _local3 = uint(_local4.length);
            _local7 = 2;
            while (_local7 < _local3) {
                _local4[_local7] = 1;
                _local7 = uint(_local7 + 3);
            }
            this.topFace_ = new SquareFace(_local5, _local4, 0, 0, this.props_.topAnimate_.type_, this.props_.topAnimate_.dx_, this.props_.topAnimate_.dy_);
        }
    }
}
}
