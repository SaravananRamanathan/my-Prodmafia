 
package com.company.assembleegameclient.objects.particles {
import com.company.assembleegameclient.objects.GameObject;

import flash.geom.Point;

import kabam.rotmg.messaging.impl.data.WorldPosData;

public class ConeBlastEffect extends ParticleEffect {
       
      
      public var start_:Point;
      
      public var target_:WorldPosData;
      
      public var blastRadius_:Number;
      
      public var color_:int;
      
      public function ConeBlastEffect(param1:GameObject, param2:WorldPosData, param3:Number, param4:int) {
         super();
         this.start_ = new Point(param1.x_,param1.y_);
         this.target_ = param2;
         this.blastRadius_ = param3;
         this.color_ = param4;
      }
      
      override public function runNormalRendering(param1:int, param2:int) : Boolean {
         var _local11:Number = NaN;
         var _local9:Point = null;
         var _local5:Particle = null;
         x_ = this.start_.x;
         y_ = this.start_.y;
         var _local3:int = 200;
         var _local7:int = 100;
         var _local8:* = 1.0471975511966;
         var _local4:int = 7;
         var _local6:Number = Math.atan2(this.target_.y_ - this.start_.y,this.target_.x_ - this.start_.x);
         var _local10:int = 0;
         while(_local10 < _local4) {
            _local11 = _local6 - _local8 / 2 + _local10 * _local8 / _local4;
            _local9 = new Point(this.start_.x + this.blastRadius_ * Math.cos(_local11),this.start_.y + this.blastRadius_ * Math.sin(_local11));
            _local5 = new SparkerParticle(_local3,this.color_,_local7,this.start_,_local9);
            map_.addObj(_local5,x_,y_);
            _local10++;
         }
         return false;
      }
      
      override public function runEasyRendering(param1:int, param2:int) : Boolean {
         var _local11:Number = NaN;
         var _local9:Point = null;
         var _local5:Particle = null;
         x_ = this.start_.x;
         y_ = this.start_.y;
         var _local3:int = 50;
         var _local7:int = 10;
         var _local8:* = 1.0471975511966;
         var _local4:int = 5;
         var _local6:Number = Math.atan2(this.target_.y_ - this.start_.y,this.target_.x_ - this.start_.x);
         var _local10:int = 0;
         while(_local10 < _local4) {
            _local11 = _local6 - _local8 / 2 + _local10 * _local8 / _local4;
            _local9 = new Point(this.start_.x + this.blastRadius_ * Math.cos(_local11),this.start_.y + this.blastRadius_ * Math.sin(_local11));
            _local5 = new SparkerParticle(_local3,this.color_,_local7,this.start_,_local9);
            map_.addObj(_local5,x_,y_);
            _local10++;
         }
         return false;
      }
   }
}
