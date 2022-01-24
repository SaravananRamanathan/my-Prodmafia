 
package com.company.assembleegameclient.objects.particles {
import com.company.assembleegameclient.objects.GameObject;
import com.company.util.MoreColorUtil;

import kabam.lib.math.easing.Quad;

public class GildedParticle extends Particle {
       
      
      private var mSize:Number;
      
      private var fSize:Number = 0;
      
      private var go:GameObject;
      
      private var currentLife:int;
      
      private var lifetimeMS:int = 2500;
      
      private var radius:Number;
      
      private var armOffset:Number = 0;
      
      public var color1_:uint;
      
      public var color2_:uint;
      
      public var color3_:uint;
      
      public function GildedParticle(param1:GameObject, param2:Number, param3:Number, param4:Number, param5:Number, param6:int, param7:uint = 2556008, param8:uint = 2556008, param9:uint = 2556008) {
         this.mSize = 3.5 + 2 * Math.random();
         super(param7,1,0);
         this.lifetimeMS = param6;
         this.radius = param5;
         this.color1_ = param7;
         this.color2_ = param8;
         this.color3_ = param9;
         z_ = 0;
         this.fSize = 0;
         size_ = this.fSize;
         this.currentLife = 0;
         this.armOffset = param4;
         this.go = param1;
      }
      
      override public function update(param1:int, param2:int) : Boolean {
         var _local3:Number = this.currentLife / this.lifetimeMS;
         if(this.mSize > size_) {
            this.fSize = this.fSize + param2 * 0.01;
         }
         size_ = this.fSize;
         var _local6:Number = Quad.easeOut(_local3);
         var _local7:Number = 2 * 3.14159265358979 * (_local6 + this.armOffset);
         var _local4:Number = this.radius * (1 - _local6);
         var _local5:Number = _local4 * Math.cos(_local7);
         var _local8:Number = _local4 * Math.sin(_local7);
         moveTo(this.go.x_ + _local5,this.go.y_ + _local8);
         if(_local3 < 0.33) {
            setColor(MoreColorUtil.lerpColor(this.color3_,this.color2_,this.normalizedRange(_local3,0,0.33)));
         } else if(_local3 > 0.5) {
            setColor(MoreColorUtil.lerpColor(this.color2_,this.color1_,this.normalizedRange(_local3,0.5,1)));
         }
         this.currentLife = this.currentLife + param2;
         return _local3 < 1;
      }
      
      public function normalizedRange(param1:Number, param2:Number, param3:Number) : Number {
         var _local4:* = Number((param1 - param2) / (param3 - param2));
         if(_local4 < 0) {
            _local4 = 0;
         } else if(_local4 > 1) {
            _local4 = 1;
         }
         return _local4;
      }
   }
}
