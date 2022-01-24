package com.company.assembleegameclient.objects.particles {

    public class LaserParticle extends ParticleEffect {

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

        public function LaserParticle() {

        }
    }
}
