 
package com.company.assembleegameclient.objects.particles {
import com.company.assembleegameclient.objects.GameObject;

import kabam.lib.math.easing.Back;

public class InspireEffect extends ParticleEffect {
      
      private static const LIFETIME:int = 1000;
       
      
      public var go_:GameObject;
      
      public var parts1_:Vector.<InspireParticle>;
      
      public var parts2_:Vector.<InspireParticle>;
      
      public var startTime_:int = -1;
      
      private var percentageDone:Number = 0;
      
      public function InspireEffect(param1:GameObject, param2:uint, param3:int) {
         var _local4:InspireParticle = null;
         this.parts1_ = new Vector.<InspireParticle>();
         this.parts2_ = new Vector.<InspireParticle>();
         super();
         this.go_ = param1;
         var _local5:int = 0;
         while(_local5 < param3) {
            _local4 = new InspireParticle(param2,100);
            this.parts1_.push(_local4);
            _local4 = new InspireParticle(param2,100);
            this.parts2_.push(_local4);
            _local5++;
         }
      }
      
      override public function update(param1:int, param2:int) : Boolean {
         if(this.go_.map_ == null) {
            this.endEffect();
            return false;
         }
         x_ = this.go_.x_;
         y_ = this.go_.y_;
         if(this.startTime_ < 0) {
            this.startTime_ = param1;
         }
         var _local3:Number = (param1 - this.startTime_) / 1000;
         if(_local3 >= 1) {
            this.endEffect();
            return false;
         }
         this.updateSwirl(this.parts1_,1,0,_local3);
         this.updateSwirl(this.parts2_,1,3.14159265358979,_local3);
         return true;
      }
      
      private function endEffect() : void {
         var _local1:InspireParticle = null;
         var _local3:int = 0;
         var _local2:* = this.parts1_;
         for each(_local1 in this.parts1_) {
            _local1.alive_ = false;
         }
         var _local5:int = 0;
         var _local4:* = this.parts2_;
         for each(_local1 in this.parts2_) {
            _local1.alive_ = false;
         }
      }
      
      public function updateSwirl(param1:Vector.<InspireParticle>, param2:Number, param3:Number, param4:Number) : void {
         var _local7:int = 0;
         var _local5:InspireParticle = null;
         var _local6:Number = NaN;
         var _local8:Number = NaN;
         var _local9:Number = NaN;
         _local7 = 0;
         while(_local7 < param1.length) {
            _local5 = param1[_local7];
            _local5.z_ = Back.easeOut(param4) * 2 - 1 + _local7 / param1.length;
            if(_local5.z_ >= 0) {
               if(_local5.z_ > 1) {
                  _local5.alive_ = false;
               } else {
                  _local6 = param2 * (2 * 3.14159265358979 * (_local7 / param1.length) + 2 * 3.14159265358979 * Back.easeOut(param4) + param3);
                  _local8 = this.go_.x_ + 0.5 * Math.cos(_local6);
                  _local9 = this.go_.y_ + 0.5 * Math.sin(_local6);
                  if(_local5.map_ == null) {
                     map_.addObj(_local5,_local8,_local9);
                  } else {
                     _local5.moveTo(_local8,_local9);
                  }
               }
            }
            _local7++;
         }
      }
   }
}

import com.company.assembleegameclient.objects.particles.Particle;

class InspireParticle extends Particle {
    
   
   public var alive_:Boolean = true;
   
   function InspireParticle(param1:uint, param2:int) {
      super(param1,0,param2);
   }
   
   override public function update(param1:int, param2:int) : Boolean {
      return this.alive_;
   }
}
