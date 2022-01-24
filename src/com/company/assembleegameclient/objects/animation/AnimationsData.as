package com.company.assembleegameclient.objects.animation {

    public class AnimationsData {
        public function AnimationsData(_arg_1:XML) {
            animations = new Vector.<AnimationData>();
            var _local2:* = null;
            super();
            var _local4:int = 0;
            var _local3:* = _arg_1.Animation;
            for each (_local2 in _arg_1.Animation) {
                this.animations.push(new AnimationData(_local2));
            }
        }
        public var animations:Vector.<AnimationData>;
    }
}
