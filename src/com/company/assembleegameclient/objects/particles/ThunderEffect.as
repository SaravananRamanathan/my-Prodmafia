 
package com.company.assembleegameclient.objects.particles {
import com.company.assembleegameclient.objects.GameObject;
import com.company.assembleegameclient.util.TextureRedrawer;
import com.company.util.AssetLibrary;
import com.company.util.ImageSet;
import com.company.util.MoreColorUtil;

import flash.display.BitmapData;
import flash.geom.ColorTransform;

public class ThunderEffect extends ParticleEffect {
      
      private static var impactImages:Vector.<BitmapData>;
      
      private static var beamImages:Vector.<BitmapData>;
       
      
      public var go_:GameObject;
      
      public function ThunderEffect(param1:GameObject) {
         super();
         this.go_ = param1;
         x_ = this.go_.x_;
         y_ = this.go_.y_;
      }
      
      public static function initialize() : void {
         beamImages = parseBitmapDataFromImageSet(6,"lofiParticlesBeam",16768115);
         impactImages = prepareThunderImpactImages(parseBitmapDataFromImageSet(13,"lofiParticlesElectric"));
      }
      
      private static function prepareThunderImpactImages(param1:Vector.<BitmapData>) : Vector.<BitmapData> {
         var _local2:int = param1.length;
         var _local3:int = 0;
         while(_local3 < _local2) {
            if(_local3 == 8) {
               param1[_local3] = applyColorTransform(param1[_local3],16768115);
            } else if(_local3 == 7) {
               param1[_local3] = applyColorTransform(param1[_local3],0xffffff);
            } else {
               param1[_local3] = applyColorTransform(param1[_local3],16751104);
            }
            _local3++;
         }
         return param1;
      }
      
      private static function applyColorTransform(param1:BitmapData, param2:uint) : BitmapData {
         var _local3:ColorTransform = MoreColorUtil.veryGreenCT;
         _local3.color = param2;
         var _local4:BitmapData = param1.clone();
         _local4.colorTransform(_local4.rect,_local3);
         return _local4;
      }
      
      private static function parseBitmapDataFromImageSet(param1:uint, param2:String, param3:uint = 0) : Vector.<BitmapData> {
         var _local4:uint = 0;
         var _local8:BitmapData = null;
         var _local6:Vector.<BitmapData> = new Vector.<BitmapData>();
         var _local7:ImageSet = AssetLibrary.getImageSet(param2);
         var _local5:* = param1;
         _local4 = 0;
         while(_local4 < _local5) {
            _local8 = TextureRedrawer.redraw(_local7.images[_local4],2 * 60,true,16768115,true,5,1.4);
            if(param3 != 0) {
               _local8 = applyColorTransform(_local8,param3);
            }
            _local6.push(_local8);
            _local4++;
         }
         return _local6;
      }
      
      override public function update(param1:int, param2:int) : Boolean {
         x_ = this.go_.x_;
         y_ = this.go_.y_;
         this.runEffect();
         return false;
      }
      
      private function runEffect() : void {
         map_.addObj(new AnimatedEffect(beamImages,2,0,4 * 60),x_,y_);
         map_.addObj(new AnimatedEffect(impactImages,0,80,6 * 60),x_,y_);
      }
   }
}
