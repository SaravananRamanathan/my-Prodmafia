 
package com.company.assembleegameclient.objects.particles {
import com.company.assembleegameclient.objects.GameObject;

public class HealingEffect extends ParticleEffect {
       
      
      public var go_:GameObject;
      
      public var lastPart_:int;
      
      public function HealingEffect(param1:GameObject) {
         super();
         this.go_ = param1;
         this.lastPart_ = 0;
      }
      
      override public function update(param1:int, param2:int) : Boolean {
         var _local6:Number = NaN;
         var _local7:int = 0;
         var _local4:Number = NaN;
         var _local5:HealParticle = null;
         if(this.go_.map_ == null) {
            return false;
         }
         x_ = this.go_.x_;
         y_ = this.go_.y_;
         var _local3:int = param1 - this.lastPart_;
         if(_local3 > 500) {
            _local6 = 6.28318530717959 * Math.random();
            _local7 = (3 + int(Math.random() * 5)) * 20;
            _local4 = 0.3 + 0.4 * Math.random();
            _local5 = new HealParticle(0xffffff,Math.random() * 0.3,_local7,1000,0.1 + Math.random() * 0.1,this.go_,_local6,_local4,0xffffff);
            map_.addObj(_local5,x_ + _local4 * Math.cos(_local6),y_ + _local4 * Math.sin(_local6));
            this.lastPart_ = param1;
         }
         return true;
      }
   }
}
