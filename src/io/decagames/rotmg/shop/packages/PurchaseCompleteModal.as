package io.decagames.rotmg.shop.packages {
    import io.decagames.rotmg.ui.buttons.BaseButton;
    import io.decagames.rotmg.ui.popups.modal.TextModal;
    import io.decagames.rotmg.ui.popups.modal.buttons.ClosePopupButton;
    
    public class PurchaseCompleteModal extends TextModal {
        
        
        public function PurchaseCompleteModal(_arg_1: String) {
            var _local2: Vector.<BaseButton> = new Vector.<BaseButton>();
            _local2.push(new ClosePopupButton("OK"));
            var _local3: String = "";
            var _local4: * = _arg_1;
            switch (_local4) {
            case "PURCHASE_TYPE_SLOTS_ONLY":
                _local3 = "Your purchase has been validated!";
                break;
            case "PURCHASE_TYPE_CONTENTS_ONLY":
                _local3 = "Your items have been sent to the Gift Chest!";
                break;
            case "PURCHASE_TYPE_MIXED":
                _local3 = "Your purchase has been validated! You will find your items in the Gift Chest.";
            }
            super(5 * 60, "Package Purchased", _local3, _local2);
        }
    }
}
