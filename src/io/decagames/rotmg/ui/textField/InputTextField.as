package io.decagames.rotmg.ui.textField {
    import flash.events.Event;
    import flash.events.FocusEvent;
    
    import io.decagames.rotmg.ui.labels.UILabel;
    
    public class InputTextField extends UILabel {
        
        
        public function InputTextField(_arg_1: String = "") {
            super();
            this.placeholder = _arg_1;
            this.text = _arg_1;
            this.type = "input";
            this.autoSize = "left";
            this.selectable = true;
            this.wordWrap = true;
            this.multiline = false;
            this.addEventListener("focusIn", this.onFocusHandler);
            this.addEventListener("removedFromStage", this.onRemoveEvent);
        }
        
        private var placeholder: String;
        
        private var _wasModified: Boolean;
        
        public function get wasModified(): Boolean {
            return this._wasModified;
        }
        
        public function reset(): void {
            this.text = this.placeholder;
            this._wasModified = false;
        }
        
        private function onRemoveEvent(_arg_1: Event): void {
            this.removeEventListener("focusIn", this.onFocusHandler);
            this.removeEventListener("removedFromStage", this.onRemoveEvent);
        }
        
        private function onFocusHandler(_arg_1: FocusEvent): void {
            if (!this._wasModified) {
                this._wasModified = true;
                this.text = "";
            }
        }
    }
}
