 
package com.company.assembleegameclient.objects.particles {
import com.company.assembleegameclient.objects.GameObject;
import com.company.assembleegameclient.util.RandomUtil;

public class GasEffect extends ParticleEffect {
       
      
      public var go_:GameObject;
      
      public var props:EffectProperties;
      
      public var color_:int;
      
      public var rate:Number;
      
      public var type:String;
      
      public function GasEffect(param1:GameObject, param2:EffectProperties) {
         super();
         this.go_ = param1;
         this.color_ = param2.color;
         this.rate = param2.rate;
         this.props = param2;
      }
      
      override public function update(param1:int, param2:int) : Boolean {
         var _local7:Number = NaN;
         var _local4:Number = NaN;
         var _local5:Number = NaN;
         var _local8:Number = NaN;
         var _local10:Number = NaN;
         var _local9:* = null;
         if(this.go_.map_ == null) {
            return false;
         }
         x_ = this.go_.x_;
         y_ = this.go_.y_;
         var _local3:int = 20;
         var _local6:int = 0;
         while(_local6 < this.rate) {
            _local7 = (Math.random() + 0.3) * 200;
            _local4 = Math.random();
            _local5 = RandomUtil.plusMinus(this.props.speed - this.props.speed * (_local4 * (1 - this.props.speedVariance)));
            _local8 = RandomUtil.plusMinus(this.props.speed - this.props.speed * (_local4 * (1 - this.props.speedVariance)));
            _local10 = this.props.life * 1000 - this.props.life * 1000 * (_local4 * this.props.lifeVariance);
            _local9 = new GasParticle(_local7,this.color_,_local10,this.props.spread,0.75,_local5,_local8);
            map_.addObj(_local9,x_,y_);
            _local6++;
         }
         return true;
      }
   }
}
