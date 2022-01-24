 
package com.company.assembleegameclient.objects.particles {
import com.company.assembleegameclient.objects.GameObject;
import com.company.assembleegameclient.util.FreeList;

public class SkyBeamEffect extends ParticleEffect {
      
      private static const BUBBLE_PERIOD:int = 30;
       
      
      public var go_:GameObject;
      
      public var color_:uint;
      
      public var rise_:Number;
      
      public var radius:Number;
      
      public var height_:Number;
      
      public var maxRadius:Number;
      
      public var speed_:Number;
      
      public var lastUpdate_:int = -1;
      
      public function SkyBeamEffect(param1:GameObject, param2:EffectProperties) {
         super();
         this.go_ = param1;
         this.color_ = param2.color;
         this.rise_ = param2.rise;
         this.radius = param2.minRadius;
         this.maxRadius = param2.maxRadius;
         this.height_ = param2.zOffset;
         this.speed_ = param2.speed;
      }
      
      override public function update(param1:int, param2:int) : Boolean {
         var _local6:int = 0;
         var _local7:SkyBeamParticle = null;
         var _local4:Number = NaN;
         var _local5:Number = NaN;
         var _local8:Number = NaN;
         var _local9:Number = NaN;
         if(this.go_.map_ == null) {
            return false;
         }
         if(this.lastUpdate_ < 0) {
            this.lastUpdate_ = Math.max(0,param1 - 400);
         }
         x_ = this.go_.x_;
         y_ = this.go_.y_;
         var _local3:int = this.lastUpdate_ / 30;
         while(_local3 < int(param1 / 30)) {
            _local6 = _local3 * 30;
            _local7 = FreeList.newObject(SkyBeamParticle) as SkyBeamParticle;
            _local7.setColor(this.color_);
            _local7.height_ = this.height_;
            _local7.restart(_local6,param1);
            _local4 = Math.random() * 6.28318530717959;
            _local5 = Math.random() * this.radius;
            _local7.setSpeed(this.speed_ + (this.maxRadius - _local5));
            _local8 = this.go_.x_ + _local5 * Math.cos(_local4);
            _local9 = this.go_.y_ + _local5 * Math.sin(_local4);
            map_.addObj(_local7,_local8,_local9);
            _local3++;
         }
         this.radius = Math.min(this.radius + this.rise_ * (param2 / 1000),this.maxRadius);
         this.lastUpdate_ = param1;
         return true;
      }
   }
}

import com.company.assembleegameclient.objects.particles.Particle;
import com.company.assembleegameclient.util.FreeList;

class SkyBeamParticle extends Particle {
    
   
   public var startTime_:int;
   
   public var speed_:Number;
   
   public var height_:Number;
   
   function SkyBeamParticle() {
      var _local1:Number = Math.random();
      super(2542335,this.height_,80 + _local1 * 40);
   }
   
   public function setSpeed(param1:Number) : void {
      this.speed_ = param1;
   }
   
   public function restart(param1:int, param2:int) : void {
      this.startTime_ = param1;
      var _local3:Number = (param2 - this.startTime_) / 1000;
      z_ = this.height_ - this.speed_ * _local3;
   }
   
   override public function removeFromMap() : void {
      super.removeFromMap();
      FreeList.deleteObject(this);
   }
   
   override public function update(param1:int, param2:int) : Boolean {
      var _local3:Number = (param1 - this.startTime_) / 1000;
      z_ = this.height_ - this.speed_ * _local3;
      return z_ > 0;
   }
}
