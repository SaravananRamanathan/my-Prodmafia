 
package com.company.assembleegameclient.objects.particles {
import com.company.assembleegameclient.objects.GameObject;
import com.company.assembleegameclient.util.ColorUtil;

import flash.geom.Point;

public class SnowflakeEffect extends ParticleEffect {
       
      
      public var start_:Point;
      
      public var color1_:int;
      
      public var color2_:int;
      
      public var minRad_:Number;
      
      public var maxRad_:Number;
      
      public var maxLife_:int;
      
      public function SnowflakeEffect(param1:GameObject, param2:EffectProperties) {
         super();
         this.color1_ = param2.color;
         this.color2_ = param2.color2;
         this.minRad_ = param2.minRadius;
         this.maxRad_ = param2.maxRadius;
         this.maxLife_ = param2.life * 1000;
         size_ = param2.size;
      }
      
      private function run(param1:int, param2:int, param3:int) : Boolean {
         var _local4:int = 0;
         var _local5:Number = NaN;
         var _local8:Particle = null;
         var _local6:Number = this.minRad_ + Math.random() * (this.maxRad_ - this.minRad_);
         var _local7:int = 0;
         while(_local7 < param3) {
            _local4 = ColorUtil.rangeRandomSmart(this.color1_,this.color2_);
            _local5 = _local7 * 2 * 3.14159265358979 / param3;
            _local8 = new SnowflakeParticle(size_,_local4,this.maxLife_,_local5,_local6,true);
            map_.addObj(_local8,x_,y_);
            _local7++;
         }
         return false;
      }
      
      override public function runNormalRendering(param1:int, param2:int) : Boolean {
         return this.run(param1,param2,6);
      }
      
      override public function runEasyRendering(param1:int, param2:int) : Boolean {
         return this.run(param1,param2,6);
      }
   }
}

import com.company.assembleegameclient.objects.particles.Particle;
import com.company.assembleegameclient.objects.particles.SparkParticle;
import com.company.assembleegameclient.util.RandomUtil;

class SnowflakeParticle extends Particle {
    
   
   private var timeLeft_:int;
   
   private var angle_:Number;
   
   private var radius_:Number;
   
   private var dx_:Number;
   
   private var dy_:Number;
   
   private var split_:Boolean;
   
   private var timeSplit_:int;
   
   function SnowflakeParticle(param1:int, param2:int, param3:int, param4:Number, param5:Number, param6:Boolean = false) {
      super(param2,0,param1);
      this.timeLeft_ = param3;
      this.timeSplit_ = this.timeLeft_ * 0.5;
      this.angle_ = param4;
      this.radius_ = param5;
      this.dx_ = param5 * Math.cos(param4) / this.timeLeft_;
      this.dy_ = param5 * Math.sin(param4) / this.timeLeft_;
      this.split_ = param6;
   }
   
   override public function update(param1:int, param2:int) : Boolean {
      this.timeLeft_ = this.timeLeft_ - param2;
      if(this.timeLeft_ <= 0) {
         return false;
      }
      moveTo(x_ + this.dx_ * param2,y_ + this.dy_ * param2);
      if(this.split_ && this.timeLeft_ < this.timeSplit_) {
         map_.addObj(new SnowflakeParticle(size_,color_,this.timeLeft_,this.angle_ + 60 * 0.0174532925199433,this.radius_ * 0.5),x_,y_);
         map_.addObj(new SnowflakeParticle(size_,color_,this.timeLeft_,this.angle_ - 60 * 0.0174532925199433,this.radius_ * 0.5),x_,y_);
         this.split_ = false;
      }
      map_.addObj(new SparkParticle(100 * (z_ + 1),color_,10 * 60,z_,RandomUtil.plusMinus(1),RandomUtil.plusMinus(1)),x_,y_);
      return true;
   }
}
