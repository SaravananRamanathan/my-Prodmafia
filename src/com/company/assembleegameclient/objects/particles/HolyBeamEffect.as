 
package com.company.assembleegameclient.objects.particles {
import com.company.assembleegameclient.objects.GameObject;
import com.company.assembleegameclient.util.TextureRedrawer;
import com.company.util.AssetLibrary;
import com.company.util.ImageSet;

import flash.display.BitmapData;
import flash.events.TimerEvent;
import flash.utils.Timer;

public class HolyBeamEffect extends ParticleEffect {
      
      public static var images:Vector.<BitmapData>;
       
      
      public var go_:GameObject;
      
      public var color1_:uint;
      
      public var color2_:uint;
      
      public var color3_:uint;
      
      public var duration_:int;
      
      public var rad_:Number;
      
      public var spriteSheetOffsetIndex:int;
      
      private var timer:Timer;
      
      private var isDestroyed:Boolean = false;
      
      public function HolyBeamEffect(param1:GameObject, param2:int, param3:int = 0) {
         super();
         this.go_ = param1;
         this.duration_ = param2;
         this.spriteSheetOffsetIndex = param3;
         x_ = this.go_.x_;
         y_ = this.go_.y_;
      }
      
      override public function update(param1:int, param2:int) : Boolean {
         if(this.isDestroyed) {
            return false;
         }
         if(!this.timer) {
            this.initialize();
         }
         x_ = this.go_.x_;
         y_ = this.go_.y_;
         return true;
      }
      
      private function initialize() : void {
         this.timer = new Timer(0, 1);
         this.timer.addEventListener(TimerEvent.TIMER, this.onTimer);
         this.timer.start();
         this.parseBitmapDataFromImageSet();
      }
      
      private function onTimer(param1:TimerEvent) : void {
         if (map_)
            map_.addObj(new HolyBeamParticle(this.go_, images, 2, this.duration_), x_, y_);
      }
      
      public function parseBitmapDataFromImageSet() : void {
         var _local3:int;
         images = new Vector.<BitmapData>();
         var _local1:ImageSet = AssetLibrary.getImageSet("lofiParticlesHolyBeam");
         var _local2:uint = 16 + 16 * this.spriteSheetOffsetIndex;
         _local3 = uint(0 + this.spriteSheetOffsetIndex * 16);
         while(_local3 < _local2) {
            images.push(TextureRedrawer.redraw(_local1.images[_local3],2 * 60,true,0,true,5,0, 0));
            _local3++;
         }
      }
      
      public function destroy() : void {
         if (this.timer) {
            this.timer.removeEventListener("timer",this.onTimer);
            this.timer.stop();
            this.timer = null;
         }

         this.go_ = null;
         this.isDestroyed = true;
      }
      
      override public function removeFromMap() : void {
         this.destroy();
         super.removeFromMap();
      }
   }
}