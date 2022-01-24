 
package com.company.assembleegameclient.objects.particles {
import flash.geom.Point;

public class ThrowEffect extends ParticleEffect {
       
      
      public var start_:Point;
      
      public var end_:Point;
      
      public var color_:int;
      
      public var duration_:int;
      
      public function ThrowEffect(param1:Point, param2:Point, param3:int, param4:int = 1500) {
         super();
         this.start_ = param1;
         this.end_ = param2;
         this.color_ = param3;
         this.duration_ = param4;
      }
      
      override public function runNormalRendering(param1:int, param2:int) : Boolean {
         x_ = this.start_.x;
         y_ = this.start_.y;
         var _local3:int = 200;
         var _local4:ThrowParticle = new ThrowParticle(_local3,this.color_,this.duration_,this.start_,this.end_);
         map_.addObj(_local4,x_,y_);
         return false;
      }
      
      override public function runEasyRendering(param1:int, param2:int) : Boolean {
         x_ = this.start_.x;
         y_ = this.start_.y;
         var _local3:int = 10;
         var _local4:ThrowParticle = new ThrowParticle(_local3,this.color_,this.duration_,this.start_,this.end_);
         map_.addObj(_local4,x_,y_);
         return false;
      }
   }
}

import com.company.assembleegameclient.objects.particles.Particle;
import com.company.assembleegameclient.objects.particles.SparkParticle;
import com.company.assembleegameclient.util.RandomUtil;

import flash.geom.Point;

class ThrowParticle extends Particle {
    
   
   public var lifetime_:int;
   
   public var timeLeft_:int;
   
   public var initialSize_:int;
   
   public var start_:Point;
   
   public var end_:Point;
   
   public var dx_:Number;
   
   public var dy_:Number;
   
   public var pathX_:Number;
   
   public var pathY_:Number;
   
   function ThrowParticle(param1:int, param2:int, param3:int, param4:Point, param5:Point) {
      super(param2,0,param1);
      var _local7:* = param3;
      this.timeLeft_ = _local7;
      this.lifetime_ = _local7;
      this.initialSize_ = param1;
      this.start_ = param4;
      this.end_ = param5;
      this.dx_ = (this.end_.x - this.start_.x) / this.timeLeft_;
      this.dy_ = (this.end_.y - this.start_.y) / this.timeLeft_;
      var _local6:Number = Point.distance(param4,param5) / this.timeLeft_;
      x_ = this.start_.x;
      this.pathX_ = this.start_.x;
      y_ = this.start_.y;
      this.pathY_ = this.start_.y;
   }
   
   override public function update(param1:int, param2:int) : Boolean {
      this.timeLeft_ = this.timeLeft_ - param2;
      if(this.timeLeft_ <= 0) {
         return false;
      }
      z_ = Math.sin(this.timeLeft_ / this.lifetime_ * 3.14159265358979) * 2;
      setSize(0);
      this.pathX_ = this.pathX_ + this.dx_ * param2;
      this.pathY_ = this.pathY_ + this.dy_ * param2;
      moveTo(this.pathX_,this.pathY_);
      map_.addObj(new SparkParticle(100 * (z_ + 1),color_,400,z_,RandomUtil.plusMinus(1),RandomUtil.plusMinus(1)),this.pathX_,this.pathY_);
      return true;
   }
}
