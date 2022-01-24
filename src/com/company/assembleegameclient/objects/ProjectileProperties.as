package com.company.assembleegameclient.objects {
import com.company.assembleegameclient.util.ConditionEffect;

import flash.utils.Dictionary;

public class ProjectileProperties {


    public function ProjectileProperties(_arg_1:XML) {
        var _local3:* = undefined;
        super();
        this.bulletType_ = int(_arg_1.@id);
        this.objectId_ = _arg_1.ObjectId;
        this.lifetime_ = _arg_1.LifetimeMS;
        this.speed_ = int(_arg_1.Speed) / 10000;
        this.maxProjTravel_ = this.speed_ * this.lifetime_;
        this.size_ = "Size" in _arg_1 ? _arg_1.Size : -1;
        if ("Damage" in _arg_1) {
            _local3 = _arg_1.Damage;
            this.maxDamage_ = _local3;
            this.minDamage_ = _local3;
        } else {
            this.minDamage_ = _arg_1.MinDamage;
            this.maxDamage_ = _arg_1.MaxDamage;
        }
        for each(var _local2:XML in _arg_1.ConditionEffect) {
            if (this.effects_ == null) {
                this.effects_ = new Vector.<uint>();
            }
            this.effects_.push(ConditionEffect.getConditionEffectFromName(_local2));
            if (_local2.attribute("target") == "1") {
                if (this.isPetEffect_ == null) {
                    this.isPetEffect_ = new Dictionary();
                }
                this.isPetEffect_[ConditionEffect.getConditionEffectFromName(_local2)] = true;
            }
        }
        this.multiHit_ = "MultiHit" in _arg_1;
        this.passesCover_ = "PassesCover" in _arg_1;
        this.armorPiercing_ = "ArmorPiercing" in _arg_1;
        this.particleTrail_ = "ParticleTrail" in _arg_1;
        this.particleTrailColor_ = !!this.particleTrail_ ? _arg_1.ParticleTrail : 0xff00ff;
        if (this.particleTrailColor_ == 0) {
            this.particleTrailColor_ = 0xff00ff;
        }
        this.wavy_ = "Wavy" in _arg_1;
        this.parametric_ = "Parametric" in _arg_1;
        this.boomerang_ = "Boomerang" in _arg_1;
        this.amplitude_ = "Amplitude" in _arg_1 ? _arg_1.Amplitude : 0;
        this.frequency_ = "Frequency" in _arg_1 ? _arg_1.Frequency : 1;
        this.magnitude_ = "Magnitude" in _arg_1 ? _arg_1.Magnitude : 3;
        this.faceDir_ = "FaceDir" in _arg_1;
        this.noRotation_ = "NoRotation" in _arg_1;
    }
    public var bulletType_:int;
    public var objectId_:String;
    public var lifetime_:int;
    public var speed_:Number;
    public var maxProjTravel_:Number;
    public var size_:int;
    public var minDamage_:int;
    public var maxDamage_:int;
    public var effects_:Vector.<uint> = null;
    public var multiHit_:Boolean;
    public var passesCover_:Boolean;
    public var armorPiercing_:Boolean;
    public var particleTrail_:Boolean;
    public var particleTrailIntensity_:int = -1;
    public var particleTrailLifetimeMS:int = -1;
    public var particleTrailColor_:int = 16711935;
    public var wavy_:Boolean;
    public var parametric_:Boolean;
    public var boomerang_:Boolean;
    public var amplitude_:Number;
    public var frequency_:Number;
    public var magnitude_:Number;
    public var isPetEffect_:Dictionary;
    public var faceDir_:Boolean;
    public var noRotation_:Boolean;
}
}
