 
package com.company.assembleegameclient.objects.particles {
import com.company.assembleegameclient.objects.GameObject;

import flash.geom.Point;

public class RingEffect extends ParticleEffect {
       
      
      public var start_:Point;
      
      public var novaRadius_:Number;
      
      public var color_:int;
      
      public function RingEffect(param1:GameObject, param2:Number, param3:int) {
         super();
         this.start_ = new Point(param1.x_,param1.y_);
         this.novaRadius_ = param2;
         this.color_ = param3;
      }
      
      override public function runNormalRendering(param1:int, param2:int) : Boolean {
         var _local5:Number = NaN;
         var _local8:Point = null;
         var _local10:Point = null;
         var _local9:Particle = null;
         x_ = this.start_.x;
         y_ = this.start_.y;
         var _local3:int = 0;
         var _local6:int = 12;
         var _local7:int = 200;
         var _local4:int = 0;
         while(_local4 < _local6) {
            _local5 = _local4 * 6.28318530717959 / _local6;
            _local8 = new Point(this.start_.x + this.novaRadius_ * Math.cos(_local5),this.start_.y + this.novaRadius_ * Math.sin(_local5));
            _local10 = new Point(this.start_.x + this.novaRadius_ * 0.9 * Math.cos(_local5),this.start_.y + this.novaRadius_ * 0.9 * Math.sin(_local5));
            _local9 = new SparkerParticle(_local3,this.color_,_local7,_local10,_local8);
            map_.addObj(_local9,x_,y_);
            _local4++;
         }
         return false;
      }
      
      override public function runEasyRendering(param1:int, param2:int) : Boolean {
         var _local5:Number = NaN;
         var _local8:Point = null;
         var _local10:Point = null;
         var _local9:Particle = null;
         x_ = this.start_.x;
         y_ = this.start_.y;
         var _local3:int = 0;
         var _local6:int = 10;
         var _local7:int = 50;
         var _local4:int = 0;
         while(_local4 < _local6) {
            _local5 = _local4 * 6.28318530717959 / _local6;
            _local8 = new Point(this.start_.x + this.novaRadius_ * Math.cos(_local5),this.start_.y + this.novaRadius_ * Math.sin(_local5));
            _local10 = new Point(this.start_.x + this.novaRadius_ * 0.9 * Math.cos(_local5),this.start_.y + this.novaRadius_ * 0.9 * Math.sin(_local5));
            _local9 = new SparkerParticle(_local3,this.color_,_local7,_local10,_local8);
            map_.addObj(_local9,x_,y_);
            _local4++;
         }
         return false;
      }
   }
}
