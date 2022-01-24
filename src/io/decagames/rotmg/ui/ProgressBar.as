package io.decagames.rotmg.ui {
    import com.greensock.TweenLite;
    
    import flash.display.Shape;
    import flash.text.TextFormat;
    
    import io.decagames.rotmg.ui.gird.UIGridElement;
    import io.decagames.rotmg.ui.labels.UILabel;
    
    public class ProgressBar extends UIGridElement {
        
        public static const DYNAMIC_LABEL_TOKEN: String = "{X}";
        
        public static const MAX_VALUE_TOKEN: String = "{M}";
        
        public function ProgressBar(_arg_1: int, _arg_2: int, _arg_3: String, _arg_4: String, _arg_5: int, _arg_6: int, _arg_7: int, _arg_8: uint, _arg_9: uint, _arg_10: uint = 0) {
            super();
            this.componentWidth = _arg_1;
            this.componentHeight = _arg_2;
            this._staticLabel = new UILabel();
            this._staticLabel.text = _arg_3;
            this._dynamicLabel = new UILabel();
            this._maxLabel = new UILabel();
            this._dynamicLabelString = _arg_4;
            this._maxValue = _arg_6;
            this._minValue = _arg_5;
            this.backgroundColor = _arg_8;
            this.progressBarColor = _arg_9;
            this.simulationColor = _arg_10;
            addChild(this._dynamicLabel);
            addChild(this._staticLabel);
            this.backgroundShape = new Shape();
            addChild(this.backgroundShape);
            this.progressShape = new Shape();
            addChild(this.progressShape);
            this.value = _arg_7;
            this._shouldAnimate = true;
        }
        
        private var componentWidth: int;
        private var componentHeight: int;
        private var backgroundColor: uint;
        private var progressBarColor: uint;
        private var backgroundShape: Shape;
        private var progressShape: Shape;
        private var simulationColor: uint;
        private var useMaxColor: Boolean;
        
        private var _staticLabel: UILabel;
        
        public function get staticLabel(): UILabel {
            return this._staticLabel;
        }
        
        private var _dynamicLabel: UILabel;
        
        public function get dynamicLabel(): UILabel {
            return this._dynamicLabel;
        }
        
        private var _maxLabel: UILabel;
        
        public function get maxLabel(): UILabel {
            return this._maxLabel;
        }
        
        private var _dynamicLabelString: String;
        
        public function get dynamicLabelString(): String {
            return this._dynamicLabelString;
        }
        
        public function set dynamicLabelString(_arg_1: String): void {
            this._dynamicLabelString = _arg_1;
        }
        
        private var _maxValue: int;
        
        public function get maxValue(): int {
            return this._maxValue;
        }
        
        public function set maxValue(_arg_1: int): void {
            this._maxValue = _arg_1;
        }
        
        private var _minValue: int;
        
        public function get minValue(): int {
            return this._minValue;
        }
        
        private var _value: int;
        
        public function get value(): int {
            return this._value;
        }
        
        public function set value(_arg_1: int): void {
            this.render(this._value, this._value, false);
            this._value = _arg_1;
            this._simulatedValue = _arg_1;
            this.render(this._value, this._simulatedValue, this._shouldAnimate);
        }
        
        private var _simulatedValue: int;
        
        public function set simulatedValue(_arg_1: int): void {
            this._simulatedValue = _arg_1;
            this.render(this._value, this._simulatedValue, false);
        }
        
        private var _shouldAnimate: Boolean;
        
        public function get shouldAnimate(): Boolean {
            return this._shouldAnimate;
        }
        
        public function set shouldAnimate(_arg_1: Boolean): void {
            this._shouldAnimate = _arg_1;
        }
        
        private var _showMaxLabel: Boolean;
        
        public function get showMaxLabel(): Boolean {
            return this._showMaxLabel;
        }
        
        public function set showMaxLabel(_arg_1: Boolean): void {
            if (_arg_1 && !this._maxLabel.parent) {
                addChild(this._maxLabel);
            }
            if (!_arg_1 && this._maxLabel.parent) {
                removeChild(this._maxLabel);
            }
            this._showMaxLabel = _arg_1;
        }
        
        private var _simulatedValueTextFormat: TextFormat;
        
        public function set simulatedValueTextFormat(_arg_1: TextFormat): void {
            this._simulatedValueTextFormat = _arg_1;
        }
        
        private var _maxColor: uint;
        
        public function get maxColor(): uint {
            return this._maxColor;
        }
        
        public function set maxColor(_arg_1: uint): void {
            this.useMaxColor = true;
            this._maxColor = _arg_1;
            this.render(this._value, this._simulatedValue, false);
        }
        
        override public function resize(_arg_1: int, _arg_2: int = -1): void {
            this.componentWidth = _arg_1;
            this.render(this._value, this._simulatedValue, false);
        }
        
        private function render(_arg_1: int, _arg_2: int, _arg_3: Boolean): void {
            var _local5: int = 0;
            var _local4: * = _arg_2 != _arg_1;
            this.backgroundShape.graphics.clear();
            this.backgroundShape.graphics.beginFill(this.backgroundColor, 1);
            this.backgroundShape.graphics.drawRect(0, 0, this.componentWidth, this.componentHeight);
            var _local7: * = Number(this.componentWidth * _arg_1 / (this._maxValue - this._minValue));
            if (isNaN(_local7)) {
                _local7 = 0;
            }
            if (_arg_3) {
                TweenLite.to(this.progressShape, 1, {
                    "width": _local7,
                    "onComplete": this.onAnimationComplete
                });
            } else {
                this.progressShape.graphics.clear();
                this.progressShape.graphics.beginFill(this.useMaxColor && _arg_1 >= this._maxValue - this._minValue ? this._maxColor : this.progressBarColor, 1);
                this.progressShape.graphics.drawRect(0, 0, _local7, this.componentHeight);
                this.progressShape.width = _local7;
            }
            if (_local4) {
                this.progressShape.graphics.beginFill(this.useMaxColor && this._maxValue - this._minValue == _arg_2 ? this._maxColor : this.simulationColor, 1);
                this.progressShape.graphics.drawRect(_local7, 0, this.componentWidth * _arg_2 / (this._maxValue - this._minValue) - _local7, this.componentHeight);
            }
            var _local6: String = this._dynamicLabelString.replace("{X}", !_local4 ? _arg_1 : int(_arg_2));
            this._dynamicLabel.text = _local6.replace("{M}", this._maxValue);
            this._maxLabel.text = "";
            if (_local4 && this._simulatedValueTextFormat) {
                _local5 = this._dynamicLabel.text.indexOf(_arg_2.toString());
                this._dynamicLabel.setTextFormat(this._simulatedValueTextFormat, _local5, _local5 + _arg_2.toString().length);
                if (this._showMaxLabel && this._maxValue == _arg_2) {
                    this._maxLabel.text = "MAX";
                }
            }
            this._dynamicLabel.x = this.componentWidth - this._dynamicLabel.width + 2;
            this._maxLabel.x = this._dynamicLabel.x + this._dynamicLabel.width;
            this._staticLabel.x = -2;
            this.backgroundShape.y = this._staticLabel.height;
            this.progressShape.y = this._staticLabel.height;
        }
        
        private function onAnimationComplete(): void {
            this.render(this._value, this._value, false);
        }
    }
}
