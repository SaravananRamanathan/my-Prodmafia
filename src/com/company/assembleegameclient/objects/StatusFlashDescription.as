 
package com.company.assembleegameclient.objects {
import flash.display.BitmapData;
import flash.geom.ColorTransform;

import kabam.rotmg.stage3D.GraphicsFillExtra;

public class StatusFlashDescription {
       
      
      public var startTime_:int;
      
      public var color_:uint;
      
      public var periodMS_:int;
      
      public var repeats_:int;
      
      public var duration_:int;
      
      public var percentDone:Number;
      
      public var curTime:Number;
      
      public var targetR:int;
      
      public var targetG:int;
      
      public var targetB:int;
      
      public function StatusFlashDescription(param1:int, param2:uint, param3:int) {
         super();
         this.startTime_ = param1;
         this.color_ = param2;
         this.duration_ = param3 * 1000;
         this.targetR = param2 >> 16 & 255;
         this.targetG = param2 >> 8 & 255;
         this.targetB = param2 & 255;
         this.curTime = 0;
      }
      
      public function apply(param1:BitmapData, param2:int) : BitmapData {
         var _local3:BitmapData = param1.clone();
         var _local6:int = (param2 - this.startTime_) % this.duration_;
         var _local7:Number = Math.abs(Math.sin(_local6 / this.duration_ * 3.14159265358979 * (this.percentDone * 10)));
         var _local4:Number = _local7 * 0.5;
         var _local5:ColorTransform = new ColorTransform(1 - _local4,1 - _local4,1 - _local4,1,_local4 * this.targetR,_local4 * this.targetG,_local4 * this.targetB,0);
         _local3.colorTransform(_local3.rect,_local5);
         return _local3;
      }
      
      public function applyGPUTextureColorTransform(param1:BitmapData, param2:int) : void {
         var _local3:int = (param2 - this.startTime_) % this.duration_;
         var _local5:Number = Math.abs(Math.sin(_local3 / this.duration_ * 3.14159265358979 * (this.percentDone * 10)));
         var _local6:Number = _local5 * 0.5;
         var _local4:ColorTransform = new ColorTransform(1 - _local6,1 - _local6,1 - _local6,1,_local6 * this.targetR,_local6 * this.targetG,_local6 * this.targetB,0);
         GraphicsFillExtra.setColorTransform(param1,_local4);
      }
      
      public function doneAt(param1:int) : Boolean {
         this.percentDone = this.curTime / this.duration_;
         this.curTime = param1 - this.startTime_;
         return this.percentDone > 1;
      }
   }
}
