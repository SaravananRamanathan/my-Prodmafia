package io.decagames.rotmg.dailyQuests.view.popup {
    import io.decagames.rotmg.ui.buttons.SliceScalingButton;
    import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
    import io.decagames.rotmg.ui.labels.UILabel;
    import io.decagames.rotmg.ui.popups.modal.ModalPopup;
    import io.decagames.rotmg.ui.texture.TextureParser;
    
    public class DailyQuestExpiredPopup extends ModalPopup {
        
        
        private const TITLE: String = "Event Quest Expired";
        
        private const TEXT: String = "Sorry, this Quest has expired.";
        
        private const WIDTH: int = 300;
        
        private const HEIGHT: int = 100;
        
        public function DailyQuestExpiredPopup() {
            super(5 * 60, 100, "Event Quest Expired");
            this.init();
        }
        
        private var _okButton: SliceScalingButton;
        
        public function get okButton(): SliceScalingButton {
            return this._okButton;
        }
        
        private function init(): void {
            var _local1: * = null;
            _local1 = new UILabel();
            _local1.width = 250;
            _local1.multiline = true;
            _local1.wordWrap = true;
            _local1.text = "Sorry, this Quest has expired.";
            DefaultLabelFormat.defaultSmallPopupTitle(_local1, "center");
            _local1.x = (300 - _local1.width) / 2;
            _local1.y = 10;
            addChild(_local1);
            this._okButton = new SliceScalingButton(TextureParser.instance.getSliceScalingBitmap("UI", "generic_green_button"));
            this._okButton.setLabel("OK", DefaultLabelFormat.questButtonCompleteLabel);
            this._okButton.width = 149;
            this._okButton.x = (300 - this._okButton.width) / 2;
            this._okButton.y = (100 - this._okButton.height) / 2 + 10;
            addChild(this._okButton);
        }
    }
}
