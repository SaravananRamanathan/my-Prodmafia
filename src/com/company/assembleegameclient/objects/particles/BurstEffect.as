 
package com.company.assembleegameclient.objects.particles {
import com.company.assembleegameclient.objects.GameObject;

import flash.geom.Point;

import kabam.rotmg.messaging.impl.data.WorldPosData;

public class BurstEffect extends ParticleEffect {
       
      
      public var center_:Point;
      
      public var edgePoint_:Point;
      
      public var color_:int;
      
      public function BurstEffect(param1:GameObject, param2:WorldPosData, param3:WorldPosData, param4:int) {
         super();
         this.center_ = new Point(param2.x_,param2.y_);
         this.edgePoint_ = new Point(param3.x_,param3.y_);
         this.color_ = param4;
      }
      
      override public function runNormalRendering(param1:int, param2:int) : Boolean {
         var _local5:Number = NaN;
         var _local8:Point = null;
         var _local9:Particle = null;
         x_ = this.center_.x;
         y_ = this.center_.y;
         var _local3:Number = Point.distance(this.center_,this.edgePoint_);
         var _local6:int = 100;
         var _local7:int = 24;
         var _local4:int = 0;
         while(_local4 < _local7) {
            _local5 = _local4 * 6.28318530717959 / _local7;
            _local8 = new Point(this.center_.x + _local3 * Math.cos(_local5),this.center_.y + _local3 * Math.sin(_local5));
            _local9 = new SparkerParticle(_local6,this.color_,100 + Math.random() * 200,this.center_,_local8);
            map_.addObj(_local9,x_,y_);
            _local4++;
         }
         return false;
      }
      
      override public function runEasyRendering(param1:int, param2:int) : Boolean {
         var _local5:Number = NaN;
         var _local8:Point = null;
         var _local9:Particle = null;
         x_ = this.center_.x;
         y_ = this.center_.y;
         var _local3:Number = Point.distance(this.center_,this.edgePoint_);
         var _local6:int = 10;
         var _local7:int = 10;
         var _local4:int = 0;
         while(_local4 < _local7) {
            _local5 = _local4 * 6.28318530717959 / _local7;
            _local8 = new Point(this.center_.x + _local3 * Math.cos(_local5),this.center_.y + _local3 * Math.sin(_local5));
            _local9 = new SparkerParticle(_local6,this.color_,50 + Math.random() * 20,this.center_,_local8);
            map_.addObj(_local9,x_,y_);
            _local4++;
         }
         return false;
      }
   }
}
