package com.company.assembleegameclient.objects.particles {
    public class SparkParticle extends Particle {
    
        public var lifetime_: int;
        public var timeLeft_: int;
        public var initialSize_: int;
        public var dx_: Number;
        public var dy_: Number;
        
        public function SparkParticle(size: int, color: int, lifetime: int, param4: Number, posX: Number, posY: Number) {
            super(color, param4, size);
            this.initialSize_ = size;
            var lifetimeMs: * = lifetime;
            this.timeLeft_ = lifetimeMs;
            this.lifetime_ = lifetimeMs;
            this.dx_ = posX;
            this.dy_ = posY;
        }
        
        override public function update(param1: int, param2: int): Boolean {
            this.timeLeft_ = this.timeLeft_ - param2;
            if (this.timeLeft_ <= 0) {
                return false;
            }
            x_ = x_ + this.dx_ * param2 * 0.001;
            y_ = y_ + this.dy_ * param2 * 0.001;
            setSize(this.timeLeft_ / this.lifetime_ * this.initialSize_);
            return true;
        }
    }
}
