 
package com.company.assembleegameclient.objects.particles {
import com.company.assembleegameclient.objects.GameObject;
import com.company.assembleegameclient.util.TextureRedrawer;
import com.company.util.AssetLibrary;
import com.company.util.ImageSet;

import flash.display.BitmapData;
import flash.events.TimerEvent;
import flash.geom.Point;
import flash.utils.Timer;

public class ShockerEffect extends ParticleEffect {
      
      public static var images:Vector.<BitmapData>;
       
      
      public var start_:Point;
      
      public var end_:Point;
      
      public var objectId:uint;
      
      public var go:GameObject;
      
      private var innerRadius:Number;
      
      private var outerRadius:Number;
      
      private var radians:Number;
      
      private var particleScale:uint;
      
      private var timer:Timer;
      
      private var isDestroyed:Boolean = false;
      
      public function ShockerEffect(param1:GameObject) {
         super();
         this.go = param1;
         if(param1.texture.height == 8) {
            this.innerRadius = 0.4;
            this.outerRadius = 1.3;
            this.particleScale = 30;
         } else {
            this.innerRadius = 0.7;
            this.outerRadius = 2;
            this.particleScale = 40;
         }
      }
      
      private function parseBitmapDataFromImageSet() : void {
         var _local1:* = 0;
         images = new Vector.<BitmapData>();
         var _local3:ImageSet = AssetLibrary.getImageSet("lofiParticlesShocker");
         var _local2:uint = 9;
         _local1 = uint(0);
         while(_local1 < _local2) {
            images.push(TextureRedrawer.redraw(_local3.images[_local1],this.particleScale,true,0,true));
            _local1++;
         }
      }
      
      override public function update(param1:int, param2:int) : Boolean {
         if(this.isDestroyed) {
            return false;
         }
         if(!this.timer) {
            this.initialize();
         }
         x_ = this.go.x_;
         y_ = this.go.y_;
         return true;
      }
      
      private function initialize() : void {
         this.timer = new Timer(200,10);
         this.timer.addEventListener("timer",this.onTimer);
         this.timer.addEventListener("timerComplete",this.onTimerComplete);
         this.timer.start();
         this.parseBitmapDataFromImageSet();
      }
      
      private function onTimer(param1:TimerEvent) : void {
         if(map_) {
            this.radians = int(Math.random() * 6 * 60) * 0.0174532925199433;
            this.start_ = new Point(this.go.x_ + Math.sin(this.radians) * this.innerRadius,this.go.y_ + Math.cos(this.radians) * this.innerRadius);
            this.end_ = new Point(this.go.x_ + Math.sin(this.radians) * this.outerRadius,this.go.y_ + Math.cos(this.radians) * this.outerRadius);
            map_.addObj(new ShockParticle(this.objectId,25,this.particleScale,this.start_,this.end_,this.radians,this.go,images),this.start_.x,this.start_.y);
         }
      }
      
      private function onTimerComplete(param1:TimerEvent) : void {
         this.destroy();
      }
      
      public function destroy() : void {
         if(this.timer) {
            this.timer.removeEventListener("timer",this.onTimer);
            this.timer.removeEventListener("timer",this.onTimerComplete);
            this.timer.stop();
            this.timer = null;
         }
         this.go = null;
         this.isDestroyed = true;
      }
      
      override public function removeFromMap() : void {
         this.destroy();
         super.removeFromMap();
      }
   }
}
