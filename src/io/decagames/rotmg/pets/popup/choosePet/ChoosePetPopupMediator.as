package io.decagames.rotmg.pets.popup.choosePet {
    import flash.events.MouseEvent;
    
    import io.decagames.rotmg.pets.components.petItem.PetItem;
    import io.decagames.rotmg.pets.data.PetsModel;
    import io.decagames.rotmg.pets.signals.ActivatePet;
    import io.decagames.rotmg.pets.signals.SelectPetSignal;
    import io.decagames.rotmg.pets.utils.PetItemFactory;
    import io.decagames.rotmg.ui.buttons.BaseButton;
    import io.decagames.rotmg.ui.buttons.SliceScalingButton;
    import io.decagames.rotmg.ui.popups.signals.ClosePopupSignal;
    import io.decagames.rotmg.ui.texture.TextureParser;
    
    import robotlegs.bender.bundles.mvcs.Mediator;
    
    public class ChoosePetPopupMediator extends Mediator {
        
        
        public function ChoosePetPopupMediator() {
            super();
        }
        
        [Inject]
        public var view: ChoosePetPopup;
        [Inject]
        public var closePopupSignal: ClosePopupSignal;
        [Inject]
        public var petIconFactory: PetItemFactory;
        [Inject]
        public var model: PetsModel;
        [Inject]
        public var selectPetSignal: SelectPetSignal;
        [Inject]
        public var activatePet: ActivatePet;
        private var petsList: Vector.<PetItem>;
        private var closeButton: SliceScalingButton;
        
        override public function initialize(): void {
            var _local1: * = null;
            var _local2: * = null;
            this.closeButton = new SliceScalingButton(TextureParser.instance.getSliceScalingBitmap("UI", "close_button"));
            this.closeButton.clickSignal.addOnce(this.onClose);
            this.view.header.addButton(this.closeButton, "right_button");
            this.petsList = new Vector.<PetItem>();
            var _local4: int = 0;
            var _local3: * = this.model.getAllPets();
            for each(_local1 in this.model.getAllPets()) {
                _local2 = this.petIconFactory.create(_local1, 40, 0x545454, 1);
                _local2.addEventListener("click", this.onPetSelected);
                this.petsList.push(_local2);
                this.view.addPet(_local2);
            }
        }
        
        override public function destroy(): void {
            var _local1: * = null;
            this.closeButton.dispose();
            var _local3: int = 0;
            var _local2: * = this.petsList;
            for each(_local1 in this.petsList) {
                _local1.removeEventListener("click", this.onPetSelected);
            }
            this.petsList = new Vector.<PetItem>();
        }
        
        private function onClose(_arg_1: BaseButton): void {
            this.closePopupSignal.dispatch(this.view);
        }
        
        private function onPetSelected(_arg_1: MouseEvent): void {
            var _local2: PetItem = PetItem(_arg_1.currentTarget);
            this.activatePet.dispatch(_local2.getPetVO().getID());
            this.selectPetSignal.dispatch(_local2.getPetVO());
            this.closePopupSignal.dispatch(this.view);
        }
    }
}
