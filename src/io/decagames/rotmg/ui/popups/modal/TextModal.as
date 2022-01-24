package io.decagames.rotmg.ui.popups.modal {
    import io.decagames.rotmg.ui.buttons.BaseButton;
    import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
    import io.decagames.rotmg.ui.labels.UILabel;
    
    public class TextModal extends ModalPopup {
        
        
        public function TextModal(_arg_1: int, _arg_2: String, _arg_3: String, _arg_4: Vector.<BaseButton>, _arg_5: Boolean = false) {
            var _local7: int = 0;
            var _local9: int = 0;
            var _local8: * = null;
            super(_arg_1, 0, _arg_2);
            var _local6: UILabel = new UILabel();
            _local6.multiline = true;
            DefaultLabelFormat.defaultTextModalText(_local6);
            _local6.multiline = true;
            _local6.width = _arg_1;
            if (_arg_5) {
                _local6.htmlText = _arg_3;
            } else {
                _local6.text = _arg_3;
            }
            _local6.wordWrap = true;
            addChild(_local6);
            var _local11: int = 0;
            var _local10: * = _arg_4;
            for each(_local8 in _arg_4) {
                _local9 = _local9 + _local8.width;
            }
            _local9 = _local9 + this.buttonsMargin * (_arg_4.length - 1);
            _local7 = (_arg_1 - _local9) / 2;
            var _local13: int = 0;
            var _local12: * = _arg_4;
            for each(_local8 in _arg_4) {
                _local8.x = _local7;
                _local7 = _local7 + (this.buttonsMargin + _local8.width);
                _local8.y = _local6.y + _local6.textHeight + 15;
                addChild(_local8);
                registerButton(_local8);
            }
        }
        
        private var buttonsMargin: int = 30;
    }
}
