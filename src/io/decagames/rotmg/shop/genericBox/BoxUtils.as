package io.decagames.rotmg.shop.genericBox {
    import com.company.assembleegameclient.objects.Player;
    
    import io.decagames.rotmg.shop.NotEnoughResources;
    import io.decagames.rotmg.shop.genericBox.data.GenericBoxInfo;
    import io.decagames.rotmg.ui.popups.signals.ShowPopupSignal;
    
    import kabam.rotmg.core.model.PlayerModel;
    import kabam.rotmg.game.model.GameModel;
    
    public class BoxUtils {
        
        
        public static function moneyCheckPass(_arg_1: GenericBoxInfo, _arg_2: int, _arg_3: GameModel, _arg_4: PlayerModel, _arg_5: ShowPopupSignal): Boolean {
            var _local8: int = 0;
            var _local11: int = 0;
            var _local6: int = 0;
            var _local7: int = 0;
            if (_arg_1.isOnSale() && _arg_1.saleAmount > 0) {
                _local8 = _arg_1.saleCurrency;
                _local11 = _arg_1.saleAmount * _arg_2;
            } else {
                _local8 = _arg_1.priceCurrency;
                _local11 = _arg_1.priceAmount * _arg_2;
            }
            var _local9: Boolean = true;
            var _local10: Player = _arg_3.player;
            if (_local10 != null) {
                _local7 = _local10.credits_;
                _local6 = _local10.fame_;
            } else if (_arg_4 != null) {
                _local7 = _arg_4.getCredits();
                _local6 = _arg_4.getFame();
            }
            if (_local8 == 0 && _local7 < _local11) {
                _arg_5.dispatch(new NotEnoughResources(5 * 60, 0));
                _local9 = false;
            } else if (_local8 == 1 && _local6 < _local11) {
                _arg_5.dispatch(new NotEnoughResources(5 * 60, 1));
                _local9 = false;
            }
            return _local9;
        }
        
        public function BoxUtils() {
            super();
        }
    }
}
