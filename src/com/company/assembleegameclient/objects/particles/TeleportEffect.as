 
package com.company.assembleegameclient.objects.particles {
   public class TeleportEffect extends ParticleEffect {
       
      
      public function TeleportEffect() {
         super();
      }
      
      override public function runNormalRendering(param1:int, param2:int) : Boolean {
         var _local7:Number = NaN;
         var _local4:Number = NaN;
         var _local5:int = 0;
         var _local8:TeleportParticle = null;
         var _local3:int = 20;
         var _local6:int = 0;
         while(_local6 < _local3) {
            _local7 = 6.28318530717959 * Math.random();
            _local4 = 0.7 * Math.random();
            _local5 = 500 + 1000 * Math.random();
            _local8 = new TeleportParticle(255,50,0.1,_local5);
            map_.addObj(_local8,x_ + _local4 * Math.cos(_local7),y_ + _local4 * Math.sin(_local7));
            _local6++;
         }
         return false;
      }
      
      override public function runEasyRendering(param1:int, param2:int) : Boolean {
         var _local7:Number = NaN;
         var _local4:Number = NaN;
         var _local5:int = 0;
         var _local8:TeleportParticle = null;
         var _local3:int = 10;
         var _local6:int = 0;
         while(_local6 < _local3) {
            _local7 = 6.28318530717959 * Math.random();
            _local4 = 0.7 * Math.random();
            _local5 = 5 + 500 * Math.random();
            _local8 = new TeleportParticle(255,50,0.1,_local5);
            map_.addObj(_local8,x_ + _local4 * Math.cos(_local7),y_ + _local4 * Math.sin(_local7));
            _local6++;
         }
         return false;
      }
   }
}

import com.company.assembleegameclient.objects.particles.Particle;

import flash.geom.Vector3D;

class TeleportParticle extends Particle {
    
   
   public var timeLeft_:int;
   
   protected var moveVec_:Vector3D;
   
   function TeleportParticle(param1:uint, param2:int, param3:Number, param4:int) {
      this.moveVec_ = new Vector3D();
      super(param1,0,param2);
      this.moveVec_.z = param3;
      this.timeLeft_ = param4;
   }
   
   override public function update(param1:int, param2:int) : Boolean {
      this.timeLeft_ = this.timeLeft_ - param2;
      if(this.timeLeft_ <= 0) {
         return false;
      }
      z_ = z_ + this.moveVec_.z * param2 * 0.008;
      return true;
   }
}
