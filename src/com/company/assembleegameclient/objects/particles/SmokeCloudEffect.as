 
package com.company.assembleegameclient.objects.particles {
import com.company.assembleegameclient.objects.GameObject;
import com.company.assembleegameclient.util.TextureRedrawer;
import com.company.util.AssetLibrary;
import com.company.util.ImageSet;

import flash.display.BitmapData;
import flash.events.TimerEvent;
import flash.geom.Point;
import flash.utils.Timer;

public class SmokeCloudEffect extends ParticleEffect {
      
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
      
      public var start_:Point;
      
      public var end_:Point;
      
      private var innerRadius:Number;
      
      private var outerRadius:Number;
      
      private var radians:Number;
      
      private var partSize_:int;
      
      private var zMax_:Number;
      
      public function SmokeCloudEffect(param1:GameObject, param2:int, param3:Number, param4:int = 100, param5:Number = 0.5) {
         super();
         this.go_ = param1;
         this.partSize_ = param4;
         this.duration_ = param2;
         this.rad_ = param3;
         this.zMax_ = param5;
         x_ = this.go_.x_;
         y_ = this.go_.y_;
         if(param1.texture.height == 8) {
            this.outerRadius = this.rad_;
            this.innerRadius = this.outerRadius * 0.2;
         } else {
            this.outerRadius = this.rad_ * 1.5;
            this.innerRadius = this.outerRadius * 0.2;
         }
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
         this.timer = new Timer(0,1);
         this.timer.addEventListener("timer",this.onTimer);
         this.timer.addEventListener("timerComplete",this.onTimerComplete);
         this.timer.start();
         this.parseBitmapDataFromImageSet();
      }
      
      private function onTimer(param1:TimerEvent) : void {
         var _local2:int = 0;
         var _local3:int = 0;
         if(map_) {
            _local2 = 0;
            _local3 = 0;
            while(_local3 < 20) {
               _local2 = int(Math.random() * (this.duration_ / 2)) + int(this.duration_ * 0.5);
               this.radians = int(Math.random() * 360) * 0.0174532925199433;
               this.start_ = new Point(this.go_.x_ + Math.sin(this.radians) * this.innerRadius * (0.5 + Math.random() / 2),this.go_.y_ + Math.cos(this.radians) * this.innerRadius * (0.5 + Math.random() / 2));
               this.end_ = new Point(this.go_.x_ + Math.sin(this.radians) * this.outerRadius * (0.5 + Math.random() / 2),this.go_.y_ + Math.cos(this.radians) * this.outerRadius * (0.5 + Math.random() / 2));
               map_.addObj(new SmokeCloudParticle(this.go_,images,this.zMax_,_local2,this.start_,this.end_),x_,y_);
               _local3++;
            }
         }
      }
      
      private function onTimerComplete(param1:TimerEvent) : void {
         if(map_) {
         }
      }
      
      private function parseBitmapDataFromImageSet() : void {
         var _local1:int = 0;
         images = new Vector.<BitmapData>();
         var _local3:ImageSet = AssetLibrary.getImageSet("lofiParts");
         _local1 = 0;
         while(_local1 < 14) {
            images.push(TextureRedrawer.redraw(_local3.images[_local1],this.partSize_,true,0,true,5,0));
            _local1++;
         }
      }
      
      public function destroy() : void {
         if(this.timer) {
            this.timer.removeEventListener("timer",this.onTimer);
            this.timer.removeEventListener("timer",this.onTimerComplete);
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
