 
package com.company.assembleegameclient.objects.particles {
import com.company.assembleegameclient.objects.GameObject;
import com.company.assembleegameclient.util.FreeList;

public class VortexEffect extends ParticleEffect {
       
      
      public var go_:GameObject;
      
      public var color_:uint;
      
      public var rad_:Number;
      
      public var lastUpdate_:int = -1;
      
      public function VortexEffect(param1:GameObject, param2:EffectProperties) {
         super();
         this.go_ = param1;
         this.color_ = param2.color;
         this.rad_ = param2.minRadius;
      }
      
      override public function update(param1:int, param2:int) : Boolean {
         var _local3:int = 0;
         var _local6:int = 0;
         var _local7:VortexParticle = null;
         var _local4:Number = NaN;
         var _local5:Number = NaN;
         var _local8:Number = NaN;
         if(this.go_.map_ == null) {
            return false;
         }
         if(this.lastUpdate_ < 0) {
            this.lastUpdate_ = Math.max(0,param1 - 400);
         }
         x_ = this.go_.x_;
         y_ = this.go_.y_;
         _local3 = this.lastUpdate_ * 0.02;
         while(_local3 < param1 * 0.02) {
            _local6 = _local3 * 50;
            _local7 = FreeList.newObject(VortexParticle) as VortexParticle;
            _local7.setColor(this.color_);
            _local4 = 6.28318530717959 * Math.random();
            _local5 = Math.cos(_local4) * 6;
            _local8 = Math.sin(_local4) * 6;
            map_.addObj(_local7,x_ + _local5,y_ + _local8);
            _local7.restart(_local6,param1,x_,y_);
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

class VortexParticle extends Particle {
   
   private static const G:Number = 4;
    
   
   public var startTime_:int;
   
   protected var moveVec_:Vector3D;
   
   private var A:Number;
   
   private var mSize:Number;
   
   private var centerX_:Number;
   
   private var centerY_:Number;
   
   private var initAccelX:Number;
   
   private var initAccelY:Number;
   
   private var fSize:Number = 0;
   
   function VortexParticle(param1:uint = 2556008) {
      this.moveVec_ = new Vector3D();
      this.A = 2.5 + 0.5 * Math.random();
      this.mSize = 3.5 + 2 * Math.random();
      super(param1,1,0);
   }
   
   public function restart(param1:int, param2:int, param3:Number, param4:Number) : void {
      this.centerX_ = param3;
      this.centerY_ = param4;
      var _local5:Number = Math.atan2(this.centerX_ - this.x_,this.centerY_ - this.y_) + 1.5707963267949 - 0.523598775598299;
      this.initAccelX = Math.sin(_local5) * this.A;
      this.initAccelY = Math.cos(_local5) * this.A;
      this.z_ = 1;
      this.fSize = 0;
      this.size_ = this.fSize;
   }
   
   override public function removeFromMap() : void {
      super.removeFromMap();
      FreeList.deleteObject(this);
   }
   
   override public function update(param1:int, param2:int) : Boolean {
      var _local3:Number = Math.atan2(this.centerX_ - this.x_,this.centerY_ - this.y_);
      var _local5:Number = Math.sin(_local3) * 4;
      var _local4:Number = Math.cos(_local3) * 4;
      if(this.mSize > this.size_) {
         this.fSize = this.fSize + param2 * 0.01;
      }
      this.size_ = this.fSize;
      moveTo(this.x_ + (_local5 + this.initAccelX) * param2 * 0.0006,this.y_ + (_local4 + this.initAccelY) * param2 * 0.0006);
      this.z_ = this.z_ + -0.5 * param2 * 0.0006;
      return this.z_ > 0;
   }
}
