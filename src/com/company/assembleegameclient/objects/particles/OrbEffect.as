 
package com.company.assembleegameclient.objects.particles {
import com.company.assembleegameclient.objects.GameObject;
import com.company.assembleegameclient.util.TextureRedrawer;
import com.company.util.AssetLibrary;
import com.company.util.ImageSet;
import com.company.util.MoreColorUtil;

import flash.display.BitmapData;
import flash.geom.ColorTransform;
import flash.geom.Point;

public class OrbEffect extends ParticleEffect {
      
      public static var images:Vector.<BitmapData>;
       
      
      public var go_:GameObject;
      
      public var color1_:uint;
      
      public var color2_:uint;
      
      public var color3_:uint;
      
      public var duration_:int;
      
      public var rad_:Number;
      
      public var target_:Point;
      
      public function OrbEffect(param1:GameObject, param2:uint, param3:uint, param4:uint, param5:Number, param6:int, param7:Point) {
         super();
         this.go_ = param1;
         this.color1_ = param2;
         this.color2_ = param3;
         this.color3_ = param4;
         this.rad_ = param5;
         this.duration_ = param6;
         this.target_ = param7;
      }
      
      public static function initialize() : void {
         images = parseBitmapDataFromImageSet("lofiParticlesSkull");
      }
      
      private static function apply(param1:BitmapData, param2:uint) : BitmapData {
         var _local3:ColorTransform = MoreColorUtil.veryGreenCT;
         _local3.color = param2;
         var _local4:BitmapData = param1.clone();
         _local4.colorTransform(_local4.rect,_local3);
         return _local4;
      }
      
      private static function parseBitmapDataFromImageSet(param1:String) : Vector.<BitmapData> {
         var _local5:uint = 0;
         var _local4:BitmapData = null;
         var _local2:Vector.<BitmapData> = new Vector.<BitmapData>();
         var _local3:ImageSet = AssetLibrary.getImageSet(param1);
         var _local6:uint = _local3.images.length;
         _local5 = 0;
         while(_local5 < _local6) {
            _local4 = TextureRedrawer.redraw(_local3.images[_local5],2 * 60,true,11673446,true,5,1.4);
            if(_local5 == 8) {
               _local4 = apply(_local4,11673446);
            } else {
               _local4 = apply(_local4,3675232);
            }
            _local2.push(_local4);
            _local5++;
         }
         return _local2;
      }
      
      override public function update(param1:int, param2:int) : Boolean {
         x_ = this.target_.x;
         y_ = this.target_.y;
         map_.addObj(new SkullEffect(this.target_,images),this.target_.x,this.target_.y);
         return false;
      }
   }
}
