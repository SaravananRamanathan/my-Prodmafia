package io.decagames.rotmg.social.popups {
    import io.decagames.rotmg.ui.buttons.SliceScalingButton;
    import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
    import io.decagames.rotmg.ui.popups.modal.ModalPopup;
    import io.decagames.rotmg.ui.textField.InputTextField;
    import io.decagames.rotmg.ui.texture.TextureParser;
    
    public class InviteFriendPopup extends ModalPopup {
        
        
        public function InviteFriendPopup() {
            var _local1: * = null;
            super(400, 85, "Send invitation");
            _local1 = TextureParser.instance.getSliceScalingBitmap("UI", "popup_content_inset", 5 * 60);
            addChild(_local1);
            _local1.height = 30;
            _local1.x = 50;
            _local1.y = 10;
            this.search = new InputTextField("Account name");
            DefaultLabelFormat.defaultSmallPopupTitle(this.search, "center");
            addChild(this.search);
            this.search.width = 290;
            this.search.x = _local1.x + 5;
            this.search.y = _local1.y + 7;
            this.sendButton = new SliceScalingButton(TextureParser.instance.getSliceScalingBitmap("UI", "generic_green_button"));
            this.sendButton.width = 100;
            this.sendButton.setLabel("Send", DefaultLabelFormat.defaultButtonLabel);
            this.sendButton.y = 50;
            this.sendButton.x = Math.round(_contentWidth - this.sendButton.width) / 2;
            addChild(this.sendButton);
        }
        
        public var sendButton: SliceScalingButton;
        public var search: InputTextField;
    }
}
