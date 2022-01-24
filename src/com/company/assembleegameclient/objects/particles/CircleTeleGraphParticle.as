 
package com.company.assembleegameclient.objects.particles {
import com.company.assembleegameclient.objects.GameObject;
import com.company.assembleegameclient.objects.thrown.BitmapParticle;

import flash.display.BitmapData;

import kabam.lib.math.easing.Quad;

public class CircleTeleGraphParticle extends BitmapParticle {
       
      
      private var percentDone:Number;
      
      private var rad_:Number;
      
      private var lifeTimeMS:int;
      
      private var currentTime:int;
      
      private var go:GameObject;
      
      private var images:Vector.<BitmapData>;
      
      public function CircleTeleGraphParticle(param1:GameObject, param2:Vector.<BitmapData>, param3:int, param4:Number) {
         this.go = param1;
         this.images = param2;
         this.percentDone = 0;
         this.currentTime = 0;
         this.lifeTimeMS = param3;
         this.rad_ = param4;
         super(param2[0],0);
         z_ = 0.2;
         _rotation = 0;
         this.percentDone = 0;
         _bitmapData = param2[0];
      }
      
      override public function update(param1:int, param2:int) : Boolean {
         this.percentDone = this.currentTime / this.lifeTimeMS;
         var _local3:int = Math.min(Math.max(0,Math.floor(this.images.length * (1 - Quad.easeIn(this.percentDone)))),this.images.length - 1);
         _bitmapData = this.images[_local3];
         y_ = this.go.y_;
         x_ = this.go.x_;
         this.currentTime = this.currentTime + param2;
         return this.percentDone < 1;
      }
      
      private function normalizedRange(param1:Number, param2:Number, param3:Number) : Number {
         var _local4:* = Number((param1 - param2) * (1 / (param3 - param2)));
         if(_local4 < 0) {
            _local4 = 0;
         } else if(_local4 > 1) {
            _local4 = 1;
         }
         return _local4;
      }
      
      private function GetAnimationIndex(param1:Number, param2:Number, param3:Number, param4:int, param5:int) : int {
         var _local6:int = Math.floor((param1 - param2) / (param3 - param2) * (param5 - param4) + param5);
         return _local6 <= 15?int(_local6):15;
      }
   }
}
