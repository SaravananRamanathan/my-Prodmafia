 
package com.company.assembleegameclient.objects.particles {
import com.company.assembleegameclient.objects.GameObject;

public class HealEffect extends ParticleEffect {
       
      
      public var go_:GameObject;
      
      public var color1_:uint;
      
      public var color2_:uint;
      
      public function HealEffect(param1:GameObject, param2:uint, param3:uint = 16777215) {
         super();
         this.go_ = param1;
         this.color1_ = param2;
         this.color2_ = uint(param3 == 0xffffff?this.color1_:uint(param3));
      }
      
      override public function update(param1:int, param2:int) : Boolean {
         var _local7:Number = NaN;
         var _local4:int = 0;
         var _local5:Number = NaN;
         var _local8:HealParticle = null;
         if(this.go_.map_ == null) {
            return false;
         }
         x_ = this.go_.x_;
         y_ = this.go_.y_;
         var _local3:int = 10;
         var _local6:int = 0;
         while(_local6 < _local3) {
            _local7 = 6.28318530717959 * (_local6 / _local3);
            _local4 = (3 + int(Math.random() * 5)) * 20;
            _local5 = 0.3 + 0.4 * Math.random();
            _local8 = new HealParticle(this.color1_,Math.random() * 0.3,_local4,1000,0.1 + Math.random() * 0.1,this.go_,_local7,_local5,this.color2_);
            map_.addObj(_local8,x_ + _local5 * Math.cos(_local7),y_ + _local5 * Math.sin(_local7));
            _local6++;
         }
         return false;
      }
   }
}
