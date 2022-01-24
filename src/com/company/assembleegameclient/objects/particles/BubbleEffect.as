
package com.company.assembleegameclient.objects.particles {
    import com.company.assembleegameclient.objects.GameObject;
    import com.company.assembleegameclient.util.FreeList;

    public class BubbleEffect extends ParticleEffect {

        private static const PERIOD_MAX:Number = 400;

        private var poolID:String;
        public var go_:GameObject;
        public var lastUpdate_:int = -1;
        public var rate_:Number;
        private var fxProps:EffectProperties;

        public function BubbleEffect(param1:GameObject, param2:EffectProperties) {
            super();
            this.go_ = param1;
            this.fxProps = param2;
            this.rate_ = (1 - param2.rate) * 400 + 1;
            this.poolID = "BubbleEffect_" + Math.random();
        }

        override public function update(param1:int, param2:int):Boolean {
            var _local3:int = 0;
            var _local11:Number = NaN;
            var _local12:Number = NaN;
            var _local9:int = 0;
            var _local4:Number = NaN;
            var _local6:Number = NaN;
            var _local7:BubbleParticle = null;
            var _local5:Number = NaN;
            var _local10:Number = NaN;
            if (this.go_.map_ == null) {
                return false;
            }
            if (!this.lastUpdate_) {
                this.lastUpdate_ = param1;
                return true;
            }
            _local3 = this.lastUpdate_ / this.rate_;
            var _local8:int = param1 / this.rate_;
            _local11 = this.go_.x_;
            _local12 = this.go_.y_;
            if (this.lastUpdate_ < 0) {
                this.lastUpdate_ = Math.max(0, param1 - 400);
            }
            x_ = _local11;
            y_ = _local12;
            var _local13:* = _local3;
            while (_local13 < _local8) {
                _local9 = _local13 * this.rate_;
                _local7 = BubbleParticle.create(this.poolID, this.fxProps.color, this.fxProps.speed, this.fxProps.life, this.fxProps.lifeVariance, this.fxProps.speedVariance, this.fxProps.spread);
                _local7.restart(_local9, param1);
                _local4 = Math.random() * 3.14159265358979;
                _local6 = Math.random() * 0.4;
                _local5 = _local11 + _local6 * Math.cos(_local4);
                _local10 = _local12 + _local6 * Math.sin(_local4);
                map_.addObj(_local7, _local5, _local10);
                _local13++;
            }
            this.lastUpdate_ = param1;
            return true;
        }

        override public function removeFromMap():void {
            super.removeFromMap();
            FreeList.dump(this.poolID);
        }
    }
}
