package io.decagames.rotmg.pets.components.selectedPetSkinInfo {
    import com.company.assembleegameclient.objects.Player;
    
    import io.decagames.rotmg.pets.data.PetsModel;
    import io.decagames.rotmg.pets.data.vo.IPetVO;
    import io.decagames.rotmg.pets.data.vo.PetVO;
    import io.decagames.rotmg.pets.signals.ChangePetSkinSignal;
    import io.decagames.rotmg.pets.signals.SelectPetSignal;
    import io.decagames.rotmg.pets.signals.SelectPetSkinSignal;
    import io.decagames.rotmg.shop.NotEnoughResources;
    import io.decagames.rotmg.shop.ShopBuyButton;
    import io.decagames.rotmg.ui.buttons.BaseButton;
    import io.decagames.rotmg.ui.popups.signals.ShowPopupSignal;
    
    import kabam.rotmg.core.model.PlayerModel;
    import kabam.rotmg.game.model.GameModel;
    import kabam.rotmg.ui.model.HUDModel;
    
    import robotlegs.bender.bundles.mvcs.Mediator;
    
    public class SelectedPetSkinInfoMediator extends Mediator {
        
        
        public function SelectedPetSkinInfoMediator() {
            super();
        }
        
        [Inject]
        public var view: SelectedPetSkinInfo;
        [Inject]
        public var selectPetSkinSignal: SelectPetSkinSignal;
        [Inject]
        public var model: PetsModel;
        [Inject]
        public var hudModel: HUDModel;
        [Inject]
        public var selectPetSignal: SelectPetSignal;
        [Inject]
        public var showPopupSignal: ShowPopupSignal;
        [Inject]
        public var gameModel: GameModel;
        [Inject]
        public var playerModel: PlayerModel;
        [Inject]
        public var changePetSkinSignal: ChangePetSkinSignal;
        private var selectedSkin: IPetVO;
        private var selectedPet: PetVO;
        
        private function get currentPet(): PetVO {
            return !!this.selectedPet ? this.selectedPet : this.model.getActivePet();
        }
        
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
            this.selectPetSkinSignal.add(this.onSkinSelected);
            this.selectPetSignal.add(this.onPetSelected);
            if (this.currentPet) {
                this.currentPet.updated.add(this.currentPetUpdate);
            }
        }
        
        override public function destroy(): void {
            this.selectPetSkinSignal.remove(this.onSkinSelected);
            if (this.currentPet) {
                this.currentPet.updated.remove(this.currentPetUpdate);
            }
            this.selectPetSignal.remove(this.onPetSelected);
        }
        
        private function currentPetUpdate(): void {
            this.onSkinSelected(this.selectedSkin);
        }
        
        private function onSkinSelected(_arg_1: IPetVO): void {
            this.selectedSkin = _arg_1;
            this.view.showPetInfo(_arg_1);
            if (this.currentPet == null || _arg_1 == null) {
                this.setAction(1, _arg_1);
            } else if (_arg_1.family != this.currentPet.skinVO.family) {
                this.setAction(3, _arg_1);
            } else if (_arg_1.skinType != this.currentPet.skinVO.skinType) {
                this.setAction(2, _arg_1);
            } else {
                this.setAction(1, _arg_1);
            }
        }
        
        private function onPetSelected(_arg_1: PetVO): void {
            this.selectedPet = _arg_1;
            this.onSkinSelected(this.selectedSkin);
        }
        
        private function setAction(_arg_1: int, _arg_2: IPetVO): void {
            if (this.view.goldActionButton) {
                this.view.goldActionButton.clickSignal.remove(this.onActionButtonClickHandler);
            }
            if (this.view.fameActionButton) {
                this.view.fameActionButton.clickSignal.remove(this.onActionButtonClickHandler);
            }
            this.view.actionButtonType = _arg_1;
            if (this.view.goldActionButton) {
                this.view.goldActionButton.clickSignal.add(this.onActionButtonClickHandler);
            }
            if (this.view.fameActionButton) {
                this.view.fameActionButton.clickSignal.add(this.onActionButtonClickHandler);
            }
        }
        
        private function onActionButtonClickHandler(_arg_1: BaseButton): void {
            var _local2: ShopBuyButton = ShopBuyButton(_arg_1);
            switch (int(this.view.actionButtonType) - 2) {
            case 0:
            case 1:
                if (_local2.currency == 0 && this.currentGold < _local2.price || _local2.currency == 1 && this.currentFame < _local2.price) {
                    this.showPopupSignal.dispatch(new NotEnoughResources(5 * 60, _local2.currency));
                    return;
                }
                break;
            }
            this.hudModel.gameSprite.gsc_.changePetSkin(this.currentPet.getID(), this.selectedSkin.skinType, _local2.currency);
            this.onSkinSelected(null);
        }
    }
}
