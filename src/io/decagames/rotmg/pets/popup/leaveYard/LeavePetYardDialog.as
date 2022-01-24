package io.decagames.rotmg.pets.popup.leaveYard {
    import io.decagames.rotmg.ui.buttons.BaseButton;
    import io.decagames.rotmg.ui.buttons.SliceScalingButton;
    import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
    import io.decagames.rotmg.ui.popups.modal.TextModal;
    import io.decagames.rotmg.ui.popups.modal.buttons.ClosePopupButton;
    import io.decagames.rotmg.ui.texture.TextureParser;
    
    import kabam.rotmg.text.view.stringBuilder.LineBuilder;
    
    public class LeavePetYardDialog extends TextModal {
        
        
        public function LeavePetYardDialog() {
            var _local1: * = undefined;
            _leaveButton = new SliceScalingButton(TextureParser.instance.getSliceScalingBitmap("UI", "generic_green_button"));
            _local1 = new Vector.<BaseButton>();
            this._leaveButton.width = 100;
            this._leaveButton.setLabel(LineBuilder.getLocalizedStringFromKey("PetsDialog.leave"), DefaultLabelFormat.defaultButtonLabel);
            _local1.push(new ClosePopupButton(LineBuilder.getLocalizedStringFromKey("PetsDialog.remain")));
            _local1.push(this.leaveButton);
            super(5 * 60, LineBuilder.getLocalizedStringFromKey("LeavePetYardDialog.title"), LineBuilder.getLocalizedStringFromKey("LeavePetYardDialog.text"), _local1);
        }
        
        private var _leaveButton: SliceScalingButton;
        
        public function get leaveButton(): SliceScalingButton {
            return this._leaveButton;
        }
    }
}
