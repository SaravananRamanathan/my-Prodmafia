package com.company.assembleegameclient.objects {
import com.company.assembleegameclient.map.Camera;
import com.company.assembleegameclient.sound.SoundEffectLibrary;

import flash.display.GraphicsBitmapFill;

public class Character extends GameObject {


    public static function green2red(_arg_1:int):int {
        if (_arg_1 > 50) {
            return 0xff00 + 327680 * (100 - _arg_1);
        }
        return 16776960 - 1280 * (50 - _arg_1);
    }

    public static function green2redu(_arg_1:uint):uint {
        if (_arg_1 > 50) {
            return 0xff00 + 327680 * (100 - _arg_1);
        }
        return 16776960 - 1280 * (50 - _arg_1);
    }

    public function Character(_arg_1:XML) {
        super(_arg_1);
        this.hurtSound_ = "HitSound" in _arg_1 ? _arg_1.HitSound : "monster/default_hit";
        SoundEffectLibrary.load(this.hurtSound_);
        this.deathSound_ = "DeathSound" in _arg_1 ? _arg_1.DeathSound : "monster/default_death";
        SoundEffectLibrary.load(this.deathSound_);
    }
    public var hurtSound_:String;
    public var deathSound_:String;

    override public function damage(_arg_1:Boolean, _arg_2:int, _arg_3:Vector.<uint>, _arg_4:Boolean, _arg_5:Projectile, _arg_6:Boolean = false):void {
        super.damage(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6);
        if (dead_) {
            SoundEffectLibrary.play(this.deathSound_);
        } else if (_arg_5 || _arg_2 > 0) {
            SoundEffectLibrary.play(this.hurtSound_);
        }
    }

    override public function draw(_arg_1:Vector.<GraphicsBitmapFill>, _arg_2:Camera, _arg_3:int):void {
        super.draw(_arg_1, _arg_2, _arg_3);
    }

    public function barLength(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:Boolean, _arg_5:Boolean):int {
        var _local6:int = 0;
        if (_arg_4) {
            _local6 = _arg_3 * _arg_1 * 0.01;
            if (_arg_5) {
                return _local6 > _arg_2 ? _local6 : int(_arg_2);
            }
            return _local6;
        }
        return _arg_1;
    }
}
}
