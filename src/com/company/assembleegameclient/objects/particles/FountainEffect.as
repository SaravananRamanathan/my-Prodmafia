 
package com.company.assembleegameclient.objects.particles {
import com.company.assembleegameclient.objects.GameObject;
import com.company.assembleegameclient.util.FreeList;

public class FountainEffect extends ParticleEffect {
       
      
      public var go_:GameObject;
      
      public var color_:uint;
      
      public var lastUpdate_:int = -1;
      
      public function FountainEffect(param1:GameObject, param2:EffectProperties) {
         super();
         this.go_ = param1;
         this.color_ = param2.color;
      }
      
      override public function update(param1:int, param2:int) : Boolean {
         var _local4:int = 0;
         var _local5:FountainParticle = null;
         if(this.go_.map_ == null) {
            return false;
         }
         if(this.lastUpdate_ < 0) {
            this.lastUpdate_ = Math.max(0,param1 - 400);
         }
         x_ = this.go_.x_;
         y_ = this.go_.y_;
         var _local3:int = this.lastUpdate_ / 50;
         while(_local3 < param1 / 50) {
            _local4 = _local3 * 50;
            _local5 = FreeList.newObject(FountainParticle) as FountainParticle;
            _local5.setColor(this.color_);
            _local5.restart(_local4,param1);
            map_.addObj(_local5,x_,y_);
            _local3++;
         }
         this.lastUpdate_ = param1;
         return true;
      }
   }
}

import com.company.assembleegameclient.objects.particles.Particle;
import com.company.assembleegameclient.util.FreeList;

import flash.geom.Vector3D;

class FountainParticle extends Particle {
   
   private static const G:Number = -4.9;
   
   private static const VI:Number = 6.5;
   
   private static const ZI:Number = 0.75;
    
   
   public var startTime_:int;
   
   protected var moveVec_:Vector3D;
   
   function FountainParticle(param1:uint = 4285909) {
      this.moveVec_ = new Vector3D();
      super(param1,0.75,100);
   }
   
   public function restart(param1:int, param2:int) : void {
      var _local3:Number = 6.28318530717959 * Math.random();
      this.moveVec_.x = Math.cos(_local3);
      this.moveVec_.y = Math.sin(_local3);
      this.startTime_ = param1;
      var _local4:int = param2 - this.startTime_;
      x_ = x_ + this.moveVec_.x * _local4 * 0.0008;
      y_ = y_ + this.moveVec_.y * _local4 * 0.0008;
      var _local5:Number = (param2 - this.startTime_) / 1000;
      z_ = 0.75 + 6.5 * _local5 + -4.9 * (_local5 * _local5);
   }
   
   override public function removeFromMap() : void {
      super.removeFromMap();
      FreeList.deleteObject(this);
   }
   
   override public function update(param1:int, param2:int) : Boolean {
      var _local3:Number = (param1 - this.startTime_) / 1000;
      moveTo(x_ + this.moveVec_.x * param2 * 0.0008,y_ + this.moveVec_.y * param2 * 0.0008);
      z_ = 0.75 + 6.5 * _local3 + -4.9 * (_local3 * _local3);
      return z_ > 0;
   }
}
