package io.decagames.rotmg.ui.spinner {
    import flash.display.Sprite;
    
    import io.decagames.rotmg.ui.buttons.SliceScalingButton;
    import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
    import io.decagames.rotmg.ui.labels.UILabel;
    import io.decagames.rotmg.ui.sliceScaling.SliceScalingBitmap;
    
    import org.osflash.signals.Signal;
    
    public class NumberSpinner extends Sprite {
        
        
        public function NumberSpinner(_arg_1: SliceScalingBitmap, _arg_2: int, _arg_3: int, _arg_4: int, _arg_5: int, _arg_6: String = "") {
            super();
            this._upArrow = new SliceScalingButton(_arg_1);
            this.startValue = _arg_2;
            this.minValue = _arg_3;
            this.maxValue = _arg_4;
            this.suffix = _arg_6;
            this._step = _arg_5;
            this.valueWasChanged = new Signal();
            this.label = new UILabel();
            DefaultLabelFormat.numberSpinnerLabel(this.label);
            this.label.autoSize = "left";
            this.label.text = _arg_2.toString() + _arg_6;
            this.label.x = -this.label.width / 2;
            this._upArrow.x = -this._upArrow.width / 2;
            this._upArrow.y = 6;
            this.label.y = this._upArrow.height + 4;
            addChild(this.label);
            addChild(this._upArrow);
            this._downArrow = new SliceScalingButton(_arg_1.clone());
            this._downArrow.rotation = 3 * 60;
            this._downArrow.x = this._downArrow.width / 2;
            this._downArrow.y = this.label.y + this.label.height + 6;
            addChild(this._downArrow);
            this._value = _arg_2;
        }
        
        public var valueWasChanged: Signal;
        protected var suffix: String;
        protected var label: UILabel;
        private var startValue: int;
        private var minValue: int;
        private var maxValue: int;
        
        private var _upArrow: SliceScalingButton;
        
        public function get upArrow(): SliceScalingButton {
            return this._upArrow;
        }
        
        private var _downArrow: SliceScalingButton;
        
        public function get downArrow(): SliceScalingButton {
            return this._downArrow;
        }
        
        protected var _value: int;
        
        public function get value(): int {
            return this._value;
        }
        
        public function set value(_arg_1: int): void {
            this._value = _arg_1;
        }
        
        private var _step: int;
        
        public function get step(): int {
            return this._step;
        }
        
        public function addToValue(_arg_1: int): void {
            var _local2: int = this._value;
            this._value = this._value + _arg_1;
            if (this._value > this.maxValue) {
                this._value = this.maxValue;
            }
            if (this._value < this.minValue) {
                this._value = this.minValue;
            }
            if (this._value != _local2) {
                this.valueWasChanged.dispatch(this.value);
            }
            this.updateLabel();
        }
        
        public function setValue(_arg_1: int): void {
            var _local2: int = this._value;
            this._value = _arg_1;
            if (this._value != _local2) {
                this.valueWasChanged.dispatch(this.value);
            }
            this.updateLabel();
        }
        
        public function dispose(): void {
            this._upArrow.dispose();
            this._downArrow.dispose();
            this.valueWasChanged.removeAll();
        }
        
        protected function updateLabel(): void {
            this.label.text = this._value.toString() + this.suffix;
            this.label.x = -this.label.width / 2;
        }
    }
}
