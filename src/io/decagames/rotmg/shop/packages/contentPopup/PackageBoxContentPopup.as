package io.decagames.rotmg.shop.packages.contentPopup {
    import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
    import io.decagames.rotmg.ui.labels.UILabel;
    import io.decagames.rotmg.ui.popups.modal.ModalPopup;
    
    import kabam.rotmg.packages.model.PackageInfo;
    
    public class PackageBoxContentPopup extends ModalPopup {
        
        
        public function PackageBoxContentPopup(_arg_1: PackageInfo) {
            this._info = _arg_1;
            super(280, 0, _arg_1.title, DefaultLabelFormat.defaultSmallPopupTitle);
            this._infoLabel = new UILabel();
            DefaultLabelFormat.mysteryBoxContentInfo(this._infoLabel);
            this._infoLabel.multiline = true;
            this._infoLabel.wordWrap = true;
            this._infoLabel.width = 255;
            this._infoLabel.text = _arg_1.description != "" ? _arg_1.description : "The package contains all the following items:";
            this._infoLabel.x = 10;
            addChild(this._infoLabel);
        }
        
        private var _info: PackageInfo;
        
        public function get info(): PackageInfo {
            return this._info;
        }
        
        private var _infoLabel: UILabel;
        
        public function get infoLabel(): UILabel {
            return this._infoLabel;
        }
    }
}
