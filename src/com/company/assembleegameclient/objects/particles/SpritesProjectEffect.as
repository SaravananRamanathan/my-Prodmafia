package com.company.assembleegameclient.objects.particles {
    import com.company.assembleegameclient.objects.GameObject;
    import com.company.assembleegameclient.util.TextureRedrawer;
    import com.company.util.AssetLibrary;
    import com.company.util.ImageSet;
    
    import flash.display.BitmapData;
    import flash.events.TimerEvent;
    import flash.geom.Point;
    import flash.utils.Timer;
    
    public class SpritesProjectEffect extends ParticleEffect {
        
        public static var images: Vector.<BitmapData>;
        
        public function SpritesProjectEffect(param1: GameObject, param2: Number) {
            super();
            this.go = param1;
            if (param1.texture.height == 8) {
                this.innerRadius = 0;
                this.outerRadius = param2;
                this.particleScale = 50;
            } else {
                this.innerRadius = 0;
                this.outerRadius = param2;
                this.particleScale = 80;
            }
        }
        public var start_: Point;
        public var end_: Point;
        public var objectId: uint;
        public var go: GameObject;
        private var innerRadius: Number;
        private var outerRadius: Number;
        private var radians: Number;
        private var particleScale: uint;
        private var timer: Timer;
        private var isDestroyed: Boolean = false;
        
        override public function update(param1: int, param2: int): Boolean {
            if (this.isDestroyed) {
                return false;
            }
            if (!this.timer) {
                this.initialize();
            }
            x_ = this.go.x_;
            y_ = this.go.y_;
            return true;
        }
    
        private function initialize(): void {
            this.timer = new Timer(50, 1);
            this.timer.addEventListener("timer", this.onTimer);
            this.timer.addEventListener("timerComplete", this.onTimerComplete);
            this.timer.start();
            this.parseBitmapDataFromImageSet();
        }
        
        public function destroy(): void {
            if (this.timer) {
                this.timer.removeEventListener("timer", this.onTimer);
                this.timer.removeEventListener("timer", this.onTimerComplete);
                this.timer.stop();
                this.timer = null;
            }
            this.go = null;
            this.isDestroyed = true;
        }
    
        override public function removeFromMap(): void {
            this.destroy();
            super.removeFromMap();
        }
        
        private function parseBitmapDataFromImageSet(): void {
            images = new Vector.<BitmapData>();
            var imageSet: ImageSet = AssetLibrary.getImageSet("lofiparticlesMusicNotes");
            var imageSize: uint = 9;
            var counter: uint = 0;
            while (counter < imageSize) {
                images.push(TextureRedrawer.redraw(imageSet.images[counter], this.particleScale, true, 16764736, true));
                counter++;
            }
        }
        
        private function onTimer(event: TimerEvent): void {
            var offset: int = 0;
            var counter: int = 0;
            if (map_) {
                offset = 8 + this.outerRadius * 2;
                counter = 0;
                while (counter < offset) {
                    this.radians = counter * 2 * 3.14159265358979 / offset;
                    this.start_ = new Point(this.go.x_ + Math.sin(this.radians) * this.innerRadius, this.go.y_ + Math.cos(this.radians) * this.innerRadius);
                    this.end_ = new Point(this.go.x_ + Math.sin(this.radians) * this.outerRadius, this.go.y_ + Math.cos(this.radians) * this.outerRadius);
                    map_.addObj(new NoteParticle(this.objectId, 20, this.particleScale, this.start_, this.end_, this.radians, this.go, images), this.start_.x, this.start_.y);
                    counter++;
                }
            }
        }
        
        private function onTimerComplete(event: TimerEvent): void {
            this.destroy();
        }
    }
}
