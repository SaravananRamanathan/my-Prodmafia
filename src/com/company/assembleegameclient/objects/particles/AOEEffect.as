
package com.company.assembleegameclient.objects.particles {
    import flash.geom.Point;

    public class AOEEffect extends ParticleEffect {

        public var start_:Point;
        public var novaRadius_:Number;
        public var color_:int;

        public function AOEEffect(param1:Point, param2:Number, param3:int) {
            super();
            this.start_ = param1;
            this.novaRadius_ = param2;
            this.color_ = param3;
        }

        override public function runNormalRendering(param1:int, param2:int):Boolean {
            var _local5:int = 0;
            _local5 = 40;
            var _local7:int = 0;
            _local7 = 200;
            var _local8:Number = NaN;
            var _local3:Point = null;
            var _local6:Particle = null;
            if (this.color_ == -1) {
                return false;
            }
            x_ = this.start_.x;
            y_ = this.start_.y;
            var _local4:int = 4 + this.novaRadius_ * 2;
            var _local9:int = 0;
            while (_local9 < _local4) {
                _local8 = _local9 * 6.28318530717959 / _local4;
                _local3 = new Point(this.start_.x + this.novaRadius_ * Math.cos(_local8), this.start_.y + this.novaRadius_ * Math.sin(_local8));
                _local6 = new SparkerParticle(40, this.color_, 200, this.start_, _local3);
                map_.addObj(_local6, x_, y_);
                _local9++;
            }
            return false;
        }

        override public function runEasyRendering(param1:int, param2:int):Boolean {
            var _local5:int = 0;
            _local5 = 200;
            var _local7:int = 0;
            _local7 = 200;
            var _local8:Number = NaN;
            var _local3:Point = null;
            var _local6:Particle = null;
            if (this.color_ == -1) {
                return false;
            }
            x_ = this.start_.x;
            y_ = this.start_.y;
            var _local4:int = 4 + this.novaRadius_ * 2;
            var _local9:int = 0;
            while (_local9 < _local4) {
                _local8 = _local9 * 6.28318530717959 / _local4;
                _local3 = new Point(this.start_.x + this.novaRadius_ * Math.cos(_local8), this.start_.y + this.novaRadius_ * Math.sin(_local8));
                _local6 = new SparkerParticle(200, this.color_, 200, this.start_, _local3);
                map_.addObj(_local6, x_, y_);
                _local9++;
            }
            return false;
        }
    }
}
