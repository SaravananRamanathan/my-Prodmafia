package io.decagames.rotmg.ui.popups.modal {
    import io.decagames.rotmg.ui.buttons.BaseButton;
    import io.decagames.rotmg.ui.buttons.SliceScalingButton;
    import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
    import io.decagames.rotmg.ui.popups.modal.buttons.ClosePopupButton;
    import io.decagames.rotmg.ui.texture.TextureParser;
    
    public class ConfirmationModal extends TextModal {
        
        
        public function ConfirmationModal(_arg_1: int, _arg_2: String, _arg_3: String, _arg_4: String, _arg_5: String, _arg_6: int = 100) {
            var _local8: * = undefined;
            _local8 = new Vector.<BaseButton>();
            var _local7: ClosePopupButton = new ClosePopupButton(_arg_5);
            _local7.width = _arg_6;
            this.confirmButton = new SliceScalingButton(TextureParser.instance.getSliceScalingBitmap("UI", "generic_green_button"));
            this.confirmButton.setLabel(_arg_4, DefaultLabelFormat.defaultButtonLabel);
            this.confirmButton.width = _arg_6;
            _local8.push(this.confirmButton);
            _local8.push(_local7);
            super(_arg_1, _arg_2, _arg_3, _local8);
        }
        
        public var confirmButton: SliceScalingButton;
    }
}
