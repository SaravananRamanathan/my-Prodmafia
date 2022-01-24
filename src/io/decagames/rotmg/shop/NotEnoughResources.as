package io.decagames.rotmg.shop {
    import io.decagames.rotmg.ui.buttons.BaseButton;
    import io.decagames.rotmg.ui.popups.modal.TextModal;
    import io.decagames.rotmg.ui.popups.modal.buttons.BuyGoldButton;
    import io.decagames.rotmg.ui.popups.modal.buttons.ClosePopupButton;
    
    public class NotEnoughResources extends TextModal {
        
        
        public function NotEnoughResources(_arg_1: int, _arg_2: int) {
            var _local5: String = _arg_2 == 0 ? "gold" : "fame";
            var _local4: String = _arg_2 == 0 ? "You do not have enough Gold for this item. Would you like to buy Gold?" : "You do not have enough Fame for this item. You gain Fame when your character dies after having accomplished great things.";
            var _local3: Vector.<BaseButton> = new Vector.<BaseButton>();
            _local3.push(new ClosePopupButton("Cancel"));
            if (_arg_2 == 0) {
                _local3.push(new BuyGoldButton());
            }
            super(_arg_1, "Not enough " + _local5, _local4, _local3);
        }
    }
}
