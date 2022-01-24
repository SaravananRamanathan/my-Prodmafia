package io.decagames.rotmg.shop.mysteryBox.rollModal.elements {
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.utils.getTimer;
    
    import io.decagames.rotmg.utils.colors.RGB;
    import io.decagames.rotmg.utils.colors.RandomColorGenerator;
    import io.decagames.rotmg.utils.colors.Tint;
    
    import kabam.rotmg.assets.EmbeddedAssets;
    
    public class Spinner extends Sprite {
        
        
        public const graphic: DisplayObject = new EmbeddedAssets.EvolveBackground();
        
        public function Spinner(param1: int, param2: Boolean = false, param3: int = -1, param4: int = -1) {
            super();
            this._degreesPerSecond = param1;
            this.multicolor = param2;
            this.secondsElapsed = 0;
            this.setupStartAndFinalColors(param3, param4);
            this.addGraphic();
            this.applyColor(0);
            addEventListener("enterFrame", this.onEnterFrame);
            addEventListener("removedFromStage", this.onRemoved);
        }
        
        private var secondsElapsed: Number;
        
        private var previousSeconds: Number;
        
        private var startColor: uint;
        
        private var endColor: uint;
        
        private var direction: Boolean;
        
        private var previousProgress: Number = 0;
        
        private var multicolor: Boolean;
        
        private var rStart: Number = -1;
        
        private var gStart: Number = -1;
        
        private var bStart: Number = -1;
        
        private var rFinal: Number = -1;
        
        private var gFinal: Number = -1;
        
        private var bFinal: Number = -1;
        
        private var _degreesPerSecond: int;
        
        public function get degreesPerSecond(): int {
            return this._degreesPerSecond;
        }
        
        public function pause(): void {
            removeEventListener("enterFrame", this.onEnterFrame);
            this.previousSeconds = 0;
        }
        
        public function resume(): void {
            addEventListener("enterFrame", this.onEnterFrame);
        }
        
        private function addGraphic(): void {
            addChild(this.graphic);
            this.graphic.x = -1 * width / 2;
            this.graphic.y = -1 * height / 2;
        }
        
        private function applyColor(param1: Number): void {
            if (!this.multicolor) {
                return;
            }
            if (param1 < this.previousProgress) {
                this.direction = !this.direction;
            }
            this.previousProgress = param1;
            if (this.direction) {
                param1 = 1 - param1;
            }
            var _local2: uint = this.getColorByProgress(param1);
            Tint.add(this.graphic, _local2, 1);
        }
        
        private function getColorByProgress(param1: Number): uint {
            var _local2: Number = this.rStart + (this.rFinal - this.rStart) * param1;
            var _local3: Number = this.gStart + (this.gFinal - this.gStart) * param1;
            var _local4: Number = this.bStart + (this.bFinal - this.bStart) * param1;
            return RGB.fromRGB(_local2, _local3, _local4);
        }
        
        private function setupStartAndFinalColors(param1: int = -1, param2: int = -1): void {
            var _local5: RandomColorGenerator = new RandomColorGenerator();
            var _local3: Array = _local5.randomColor();
            var _local4: Array = _local5.randomColor();
            if (param1 == -1) {
                this.rStart = _local3[0];
                this.gStart = _local3[1];
                this.bStart = _local3[2];
            } else {
                this.rStart = param1 >> 16 & 255;
                this.gStart = param1 >> 8 & 255;
                this.bStart = param1 & 255;
            }
            if (param2 == -1) {
                this.rFinal = _local4[0];
                this.gFinal = _local4[1];
                this.bFinal = _local4[2];
            } else {
                this.rStart = param2 >> 16 & 255;
                this.gStart = param2 >> 8 & 255;
                this.bStart = param2 & 255;
            }
        }
        
        private function updateTimeElapsed(): void {
            var _local1: Number = getTimer() / 1000;
            if (this.previousSeconds) {
                this.secondsElapsed = this.secondsElapsed + (_local1 - this.previousSeconds);
            }
            this.previousSeconds = _local1;
        }
        
        private function onRemoved(param1: Event): void {
            removeEventListener("removedFromStage", this.onRemoved);
            removeEventListener("enterFrame", this.onEnterFrame);
        }
        
        private function onEnterFrame(param1: Event): void {
            this.updateTimeElapsed();
            var _local2: Number = this._degreesPerSecond * this.secondsElapsed % 6 * 60;
            rotation = _local2;
            this.applyColor(_local2 / 6 * 60);
        }
    }
}
