 
package com.company.assembleegameclient.objects.particles {
   public class ParticleLibrary {
      
      public static const propsLibrary_:Object = {};
       
      
      public function ParticleLibrary() {
         super();
      }
      
      public static function parseFromXML(param1:XML) : void {
         var _local2:* = null;
         var _local4:int = 0;
         var _local3:* = param1.Particle;
         for each(_local2 in param1.Particle) {
            propsLibrary_[_local2.@id] = new ParticleProperties(_local2);
         }
      }
   }
}
