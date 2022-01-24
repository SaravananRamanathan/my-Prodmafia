 
package com.company.assembleegameclient.objects.particles {
   public class HitEffect extends ParticleEffect {
       
      
      public var colors_:Vector.<uint>;
      
      public var numParts_:int;
      
      public var angle_:Number;
      
      public var speed_:Number;
      
      public function HitEffect(param1:Vector.<uint>, param2:int, param3:int, param4:Number, param5:Number) {
         super();
         this.colors_ = param1;
         size_ = param2;
         this.numParts_ = param3;
         this.angle_ = param4;
         this.speed_ = param5;
      }
      
      override public function runNormalRendering(param1:int, param2:int) : Boolean {
         var _local4:uint = 0;
         var _local5:Particle = null;
         if(this.colors_.length == 0) {
            return false;
         }
         var _local3:Number = this.speed_ / 10 * 60 * Math.cos(this.angle_ + 3.14159265358979);
         var _local6:Number = this.speed_ / 10 * 60 * Math.sin(this.angle_ + 3.14159265358979);
         var _local7:int = 0;
         while(_local7 < this.numParts_) {
            _local4 = this.colors_[int(this.colors_.length * Math.random())];
            _local5 = new HitParticle(_local4,0.5,size_,200 + Math.random() * 100,_local3 + (Math.random() - 0.5) * 0.4,_local6 + (Math.random() - 0.5) * 0.4,0);
            map_.addObj(_local5,x_,y_);
            _local7++;
         }
         return false;
      }
      
      override public function runEasyRendering(param1:int, param2:int) : Boolean {
         var _local4:uint = 0;
         var _local5:Particle = null;
         if(this.colors_.length == 0) {
            return false;
         }
         var _local3:Number = this.speed_ / 10 * 60 * Math.cos(this.angle_ + 3.14159265358979);
         var _local6:Number = this.speed_ / 10 * 60 * Math.sin(this.angle_ + 3.14159265358979);
         this.numParts_ = this.numParts_ * 0.2;
         var _local7:int = 0;
         while(_local7 < this.numParts_) {
            _local4 = this.colors_[int(this.colors_.length * Math.random())];
            _local5 = new HitParticle(_local4,0.5,10,5 + Math.random() * 100,_local3 + (Math.random() - 0.5) * 0.4,_local6 + (Math.random() - 0.5) * 0.4,0);
            map_.addObj(_local5,x_,y_);
            _local7++;
         }
         return false;
      }
   }
}

import com.company.assembleegameclient.objects.particles.Particle;

import flash.geom.Vector3D;

class HitParticle extends Particle {
    
   
   public var lifetime_:int;
   
   public var timeLeft_:int;
   
   protected var moveVec_:Vector3D;
   
   function HitParticle(param1:uint, param2:Number, param3:int, param4:int, param5:Number, param6:Number, param7:Number) {
      this.moveVec_ = new Vector3D();
      super(param1,param2,param3);
      var _local8:* = param4;
      this.lifetime_ = _local8;
      this.timeLeft_ = _local8;
      this.moveVec_.x = param5;
      this.moveVec_.y = param6;
      this.moveVec_.z = param7;
   }
   
   override public function update(param1:int, param2:int) : Boolean {
      this.timeLeft_ = this.timeLeft_ - param2;
      if(this.timeLeft_ <= 0) {
         return false;
      }
      x_ = x_ + this.moveVec_.x * param2 * 0.008;
      y_ = y_ + this.moveVec_.y * param2 * 0.008;
      z_ = z_ + this.moveVec_.z * param2 * 0.008;
      return true;
   }
}
