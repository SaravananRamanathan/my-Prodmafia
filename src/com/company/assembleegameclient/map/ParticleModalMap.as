package com.company.assembleegameclient.map {
import com.company.assembleegameclient.objects.BasicObject;
import com.company.assembleegameclient.objects.GameObject;
import com.company.assembleegameclient.objects.particles.ConfettiEffect;
import com.company.assembleegameclient.objects.particles.LightningEffect;
import com.company.assembleegameclient.objects.particles.NovaEffect;
import com.company.assembleegameclient.parameters.Parameters;

import flash.display.GraphicsBitmapFill;
import flash.events.Event;
import flash.utils.Dictionary;
import flash.utils.getTimer;

import kabam.rotmg.messaging.impl.data.WorldPosData;

public class ParticleModalMap extends Map {

    public static const MODE_SNOW:int = 1;

    public static const MODE_AUTO_UPDATE:int = 2;

    public static const PSCALE:Number = 16;

    public static function getLocalPos(_arg_1:Number):Number {
        return _arg_1 / 16;
    }

    public function ParticleModalMap(_arg_1:int = -1) {
        objsToAdd_ = new Vector.<BasicObject>();
        idsToRemove_ = new Vector.<int>();
        graphicsData_ = new Vector.<GraphicsBitmapFill>();
        super(null);
        if (_arg_1 == 1) {
            addEventListener("enterFrame", this.activateModeSnow);
        }
        if (_arg_1 == 2) {
            addEventListener("enterFrame", this.updater);
        }
    }
    private var inUpdate_:Boolean = false;
    private var objsToAdd_:Vector.<BasicObject>;
    private var idsToRemove_:Vector.<int>;
    private var dt:uint = 0;
    private var dtBuildup:uint = 0;
    private var time:uint = 0;
    private var graphicsData_:Vector.<GraphicsBitmapFill>;

    override public function addObj(_arg1:BasicObject, _arg2:Number, _arg3:Number):void {
        _arg1.x_ = _arg2;
        _arg1.y_ = _arg3;
        if (this.inUpdate_) {
            this.objsToAdd_.push(_arg1);
        }
        else {
            this.internalAddObj(_arg1);
        }
    }

    override public function internalAddObj(_arg1:BasicObject):void {
        var _local2:Dictionary = boDict_;
        if (_local2[_arg1.objectId_] != null) {
            return;
        }
        _arg1.map_ = this;
        _local2[_arg1.objectId_] = _arg1;
    }

    override public function internalRemoveObj(_arg1:int):void {
        var _local2:Dictionary = boDict_;
        var _local3:BasicObject = _local2[_arg1];
        if (_local3 == null) {
            return;
        }
        _local3.removeFromMap();
        delete _local2[_arg1];
    }

    override public function update(_arg1:int, _arg2:int):void {
        var _local3:BasicObject;
        var _local4:int;
        this.inUpdate_ = true;
        for each (_local3 in boDict_) {
            if (!_local3.update(_arg1, _arg2)) {
                this.idsToRemove_.push(_local3.objectId_);
            }
        }
        this.inUpdate_ = false;
        for each (_local3 in this.objsToAdd_) {
            this.internalAddObj(_local3);
        }
        this.objsToAdd_.length = 0;
        for each (_local4 in this.idsToRemove_) {
            this.internalRemoveObj(_local4);
        }
        this.idsToRemove_.length = 0;
    }

    override public function draw(_arg1:Camera, _arg2:int):void {
        var _local3:BasicObject;
        this.graphicsData_.length = 0;
        var _local4:int;
        for each (_local3 in boDict_) {
            _local4++;
            _local3.computeSortValNoCamera(PSCALE);
            _local3.draw(this.graphicsData_, _arg1, _arg2);
        }
    }

    public function doNova(_arg_1:Number, _arg_2:Number, _arg_3:int = 20, _arg_4:int = 12447231):void {
        var _local5:GameObject = new GameObject(null);
        _local5.x_ = getLocalPos(_arg_1);
        _local5.y_ = getLocalPos(_arg_2);
        var _local6:NovaEffect = new NovaEffect(_local5, _arg_3, _arg_4);
        this.addObj(_local6, _local5.x_, _local5.y_);
    }

    public function doLightning(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:int = 200, _arg_6:int = 12447231, _arg_7:Number = 1):void {
        var _local10:GameObject = new GameObject(null);
        _local10.x_ = getLocalPos(_arg_1);
        _local10.y_ = getLocalPos(_arg_2);
        var _local8:WorldPosData = new WorldPosData();
        _local8.x_ = getLocalPos(_arg_3);
        _local8.y_ = getLocalPos(_arg_4);
        var _local9:LightningEffect = new LightningEffect(_local10, _local8, _arg_6, _arg_5, _arg_7);
        this.addObj(_local9, _local10.x_, _local10.y_);
    }

    private function doSnow(_arg_1:Number, _arg_2:Number, _arg_3:int = 20, _arg_4:int = 12447231):void {
        var _local7:WorldPosData = new WorldPosData();
        var _local6:WorldPosData = new WorldPosData();
        _local7.x_ = getLocalPos(_arg_1);
        _local7.y_ = getLocalPos(_arg_2);
        _local6.x_ = getLocalPos(_arg_1);
        _local6.y_ = getLocalPos(10 * 60);
        var _local5:ConfettiEffect = new ConfettiEffect(_local7, _local6, _arg_4, _arg_3, true);
        this.addObj(_local5, _local7.x_, _local7.y_);
    }

    private function activateModeSnow(_arg_1:Event):void {
        if (this.time != 0) {
            this.dt = getTimer() - this.time;
        }
        this.dtBuildup = this.dtBuildup + this.dt;
        this.time = getTimer();
        if (this.dtBuildup > 500) {
            this.dtBuildup = 0;
            this.doSnow(Math.random() * 600, -100);
        }
        this.update(this.time, this.dt);
        this.draw(null, this.time);
    }

    private function updater(_arg_1:Event):void {
        if (this.time != 0) {
            this.dt = getTimer() - this.time;
        }
        this.time = getTimer();
        this.update(this.time, this.dt);
        this.draw(null, this.time);
    }
}
}
