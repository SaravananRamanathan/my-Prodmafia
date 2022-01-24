package com.company.assembleegameclient.ui.exaltation {
    import flash.geom.Rectangle;
    import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
    import io.decagames.rotmg.ui.popups.modal.ModalPopup;

    public class ExaltationView extends ModalPopup {

        public static var config:Class = exaltationConfig;

        public function ExaltationView() {
            super(340, 505, "Exaltation", DefaultLabelFormat.defaultSmallPopupTitle, new Rectangle(0, 0, 340, 565));
        }
    }
}
