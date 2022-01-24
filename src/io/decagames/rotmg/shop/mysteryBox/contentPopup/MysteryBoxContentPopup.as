package io.decagames.rotmg.shop.mysteryBox.contentPopup {
    import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
    import io.decagames.rotmg.ui.labels.UILabel;
    import io.decagames.rotmg.ui.popups.modal.ModalPopup;
    
    import kabam.rotmg.mysterybox.model.MysteryBoxInfo;
    
    public class MysteryBoxContentPopup extends ModalPopup {
        
        
        public function MysteryBoxContentPopup(_arg_1: MysteryBoxInfo) {
            this._info = _arg_1;
            super(280, 0, _arg_1.title, DefaultLabelFormat.defaultSmallPopupTitle);
            var _local2: UILabel = new UILabel();
            DefaultLabelFormat.mysteryBoxContentInfo(_local2);
            _local2.multiline = true;
            switch (int(_arg_1.rolls) - 1) {
            case 0:
                _local2.text = "You will win one\nof the rewards listed below!";
                break;
            case 1:
                _local2.text = "You will win two\nof the rewards listed below!";
                break;
            case 2:
                _local2.text = "You will win three\nof the rewards listed below!";
            }
            _local2.x = (280 - _local2.textWidth) / 2;
            addChild(_local2);
        }
        
        private var _info: MysteryBoxInfo;
        
        public function get info(): MysteryBoxInfo {
            return this._info;
        }
    }
}
