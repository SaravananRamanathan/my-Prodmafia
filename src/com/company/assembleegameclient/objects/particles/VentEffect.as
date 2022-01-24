 
package com.company.assembleegameclient.objects.particles {
import com.company.assembleegameclient.objects.GameObject;
import com.company.assembleegameclient.util.FreeList;

public class VentEffect extends ParticleEffect {
      
      private static const BUBBLE_PERIOD:int = 50;
       
      
      public var go_:GameObject;
      
      public var lastUpdate_:int = -1;
      
      public function VentEffect(param1:GameObject) {
         super();
         this.go_ = param1;
      }
      
      override public function update(param1:int, param2:int) : Boolean {
         var _local6:int = 0;
         var _local7:VentParticle = null;
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
         var _local3:int = this.lastUpdate_ / 50;
         while(_local3 < int(param1 / 50)) {
            _local6 = _local3 * 50;
            _local7 = FreeList.newObject(VentParticle) as VentParticle;
            _local7.restart(_local6,param1);
            _local4 = Math.random() * 3.14159265358979;
            _local5 = Math.random() * 0.4;
            _local8 = this.go_.x_ + _local5 * Math.cos(_local4);
            _local9 = this.go_.y_ + _local5 * Math.sin(_local4);
            map_.addObj(_local7,_local8,_local9);
            _local3++;
         }
         this.lastUpdate_ = param1;
         return true;
      }
   }
}

import com.company.assembleegameclient.objects.particles.Particle;
import com.company.assembleegameclient.util.FreeList;

class VentParticle extends Particle {
    
   
   public var startTime_:int;
   
   public var speed_:int;
   
   function VentParticle() {
      var _local1:Number = Math.random();
      super(2542335,0,75 + _local1 * 50);
      this.speed_ = 2.5 - _local1 * 1.5;
   }
   
   public function restart(param1:int, param2:int) : void {
      this.startTime_ = param1;
      var _local3:Number = (param2 - this.startTime_) / 1000;
      z_ = this.speed_ * _local3;
   }
   
   override public function removeFromMap() : void {
      super.removeFromMap();
      FreeList.deleteObject(this);
   }
   
   override public function update(param1:int, param2:int) : Boolean {
      var _local3:Number = (param1 - this.startTime_) / 1000;
      z_ = this.speed_ * _local3;
      return z_ < 1;
   }
}
