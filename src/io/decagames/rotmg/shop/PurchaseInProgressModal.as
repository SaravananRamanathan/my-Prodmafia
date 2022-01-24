package io.decagames.rotmg.shop {
    import io.decagames.rotmg.ui.buttons.BaseButton;
    import io.decagames.rotmg.ui.popups.modal.TextModal;
    
    public class PurchaseInProgressModal extends TextModal {
        
        
        public function PurchaseInProgressModal() {
            super(5 * 60, "Shop", "Transaction in progress", new Vector.<BaseButton>());
        }
    }
}
