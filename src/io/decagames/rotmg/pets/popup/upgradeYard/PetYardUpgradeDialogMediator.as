package io.decagames.rotmg.pets.popup.upgradeYard {
    import com.company.assembleegameclient.objects.Player;
    
    import io.decagames.rotmg.pets.data.PetsModel;
    import io.decagames.rotmg.pets.data.vo.requests.UpgradePetYardRequestVO;
    import io.decagames.rotmg.pets.signals.UpgradePetSignal;
    import io.decagames.rotmg.shop.NotEnoughResources;
    import io.decagames.rotmg.ui.buttons.BaseButton;
    import io.decagames.rotmg.ui.buttons.SliceScalingButton;
    import io.decagames.rotmg.ui.popups.signals.ClosePopupSignal;
    import io.decagames.rotmg.ui.popups.signals.ShowPopupSignal;
    import io.decagames.rotmg.ui.texture.TextureParser;
    
    import kabam.rotmg.core.model.PlayerModel;
    import kabam.rotmg.game.model.GameModel;
    
    import robotlegs.bender.bundles.mvcs.Mediator;
    
    public class PetYardUpgradeDialogMediator extends Mediator {
        
        
        public function PetYardUpgradeDialogMediator() {
            super();
        }
        
        [Inject]
        public var view: PetYardUpgradeDialog;
        [Inject]
        public var closePopupSignal: ClosePopupSignal;
        [Inject]
        public var gameModel: GameModel;
        [Inject]
        public var playerModel: PlayerModel;
        [Inject]
        public var showDialog: ShowPopupSignal;
        [Inject]
        public var model: PetsModel;
        [Inject]
        public var upgradePet: UpgradePetSignal;
        private var closeButton: SliceScalingButton;
        
        private function get currentGold(): int {
            var _local1: Player = this.gameModel.player;
            if (_local1 != null) {
                return _local1.credits_;
            }
            if (this.playerModel != null) {
                return this.playerModel.getCredits();
            }
            return 0;
        }
        
        private function get currentFame(): int {
            var _local1: Player = this.gameModel.player;
            if (_local1 != null) {
                return _local1.fame_;
            }
            if (this.playerModel != null) {
                return this.playerModel.getFame();
            }
            return 0;
        }
        
        override public function initialize(): void {
            this.closeButton = new SliceScalingButton(TextureParser.instance.getSliceScalingBitmap("UI", "close_button"));
            this.closeButton.clickSignal.addOnce(this.onClose);
            this.view.header.addButton(this.closeButton, "right_button");
            this.view.upgradeFameButton.clickSignal.add(this.onFamePurchase);
            this.view.upgradeGoldButton.clickSignal.add(this.onGoldPurchase);
        }
        
        override public function destroy(): void {
            this.closeButton.clickSignal.remove(this.onClose);
            this.closeButton.dispose();
            this.view.upgradeFameButton.clickSignal.remove(this.onFamePurchase);
            this.view.upgradeGoldButton.clickSignal.remove(this.onGoldPurchase);
        }
        
        private function onClose(_arg_1: BaseButton): void {
            this.closePopupSignal.dispatch(this.view);
        }
        
        private function onFamePurchase(_arg_1: BaseButton): void {
            this.purchase(1, this.model.getPetYardUpgradeFamePrice());
        }
        
        private function onGoldPurchase(_arg_1: BaseButton): void {
            this.purchase(0, this.model.getPetYardUpgradeGoldPrice());
        }
        
        private function purchase(_arg_1: int, _arg_2: int): void {
            if (_arg_1 == 0 && this.currentGold < _arg_2) {
                this.showDialog.dispatch(new NotEnoughResources(5 * 60, 0));
                return;
            }
            if (_arg_1 == 1 && this.currentFame < _arg_2) {
                this.showDialog.dispatch(new NotEnoughResources(5 * 60, 1));
                return;
            }
            var _local4: int = this.model.getPetYardObjectID();
            var _local3: UpgradePetYardRequestVO = new UpgradePetYardRequestVO(_local4, _arg_1);
            this.closePopupSignal.dispatch(this.view);
            this.upgradePet.dispatch(_local3);
        }
    }
}
