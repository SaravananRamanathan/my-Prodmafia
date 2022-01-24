package io.decagames.rotmg.pets.components.petPortrait {
    import flash.events.MouseEvent;
    
    import io.decagames.rotmg.pets.components.petIcon.PetIconFactory;
    import io.decagames.rotmg.pets.data.ability.AbilitiesUtil;
    import io.decagames.rotmg.pets.data.vo.PetVO;
    import io.decagames.rotmg.pets.popup.choosePet.ChoosePetPopup;
    import io.decagames.rotmg.pets.popup.releasePet.ReleasePetDialog;
    import io.decagames.rotmg.pets.signals.ReleasePetSignal;
    import io.decagames.rotmg.pets.signals.SelectPetSignal;
    import io.decagames.rotmg.pets.signals.SimulateFeedSignal;
    import io.decagames.rotmg.ui.popups.signals.ShowPopupSignal;
    
    import robotlegs.bender.bundles.mvcs.Mediator;
    
    public class PetPortraitMediator extends Mediator {
        
        
        public function PetPortraitMediator() {
            super();
        }
        
        [Inject]
        public var view: PetPortrait;
        [Inject]
        public var petIconFactory: PetIconFactory;
        [Inject]
        public var showPopupSignal: ShowPopupSignal;
        [Inject]
        public var selectPetSignal: SelectPetSignal;
        [Inject]
        public var releasePetSignal: ReleasePetSignal;
        [Inject]
        public var simulateFeedSignal: SimulateFeedSignal;
        
        override public function initialize(): void {
            if (this.view.switchable) {
                this.view.petSkin.addEventListener("click", this.onSwitchPetHandler);
            }
            if (this.view.showCurrentPet) {
                this.selectPetSignal.add(this.onPetSelected);
            }
            if (this.view.petVO && this.view.petVO.updated) {
                this.view.petVO.updated.add(this.VOUpdated);
            }
            this.view.releaseSignal.add(this.releasePetHandler);
            this.releasePetSignal.add(this.onRelease);
            this.simulateFeedSignal.add(this.simulateFeed);
        }
        
        override public function destroy(): void {
            this.view.petSkin.removeEventListener("click", this.onSwitchPetHandler);
            this.selectPetSignal.remove(this.onPetSelected);
            if (this.view.petVO && this.view.petVO.updated) {
                this.view.petVO.updated.remove(this.VOUpdated);
            }
            this.view.releaseSignal.remove(this.releasePetHandler);
            this.view.dispose();
            this.releasePetSignal.remove(this.onRelease);
            this.simulateFeedSignal.remove(this.simulateFeed);
        }
        
        private function simulateFeed(_arg_1: int): void {
            var _local2: * = null;
            if (this.view.petVO) {
                _local2 = AbilitiesUtil.simulateAbilityUpgrade(this.view.petVO, _arg_1);
                this.view.simulateFeed(_local2, _arg_1);
            }
        }
        
        private function onRelease(_arg_1: int): void {
            this.view.petVO = null;
        }
        
        private function releasePetHandler(): void {
            this.showPopupSignal.dispatch(new ReleasePetDialog(this.view.petVO.getID()));
        }
        
        private function onPetSelected(_arg_1: PetVO): void {
            var _local2: Boolean = false;
            if (this.view.petVO && this.view.petVO.updated) {
                this.view.petVO.updated.remove(this.VOUpdated);
            }
            if (this.view.enableAnimation) {
                _local2 = true;
                this.view.enableAnimation = false;
            }
            this.view.petVO = _arg_1;
            this.view.enableAnimation = _local2;
            if (this.view.petVO && this.view.petVO.updated) {
                this.view.petVO.updated.add(this.VOUpdated);
            }
        }
        
        private function VOUpdated(): void {
            this.view.petVO = this.view.petVO;
        }
        
        private function onSwitchPetHandler(_arg_1: MouseEvent): void {
            this.showPopupSignal.dispatch(new ChoosePetPopup());
        }
    }
}
