package io.decagames.rotmg.pets.windows.yard {
    import flash.display.Sprite;
    
    import io.decagames.rotmg.pets.components.petInfoSlot.PetInfoSlot;
    import io.decagames.rotmg.pets.windows.yard.list.PetYardList;
    import io.decagames.rotmg.ui.popups.UIPopup;
    
    public class PetYardWindow extends UIPopup {
        
        
        public function PetYardWindow() {
            super(10 * 60, 10 * 60);
            this._contentContainer = new Sprite();
            this._contentContainer.y = 2 * 60;
            this._contentContainer.x = 10;
            addChild(this._contentContainer);
            this.renderYard();
            this.renderCurrentPet();
            this.renderPetInteraction();
        }
        
        private var _infoButton: Sprite;
        private var petYard: PetYardList;
        private var currentPet: PetInfoSlot;
        private var petInteraction: InteractionInfo;
        
        private var _closeButton: Sprite;
        
        public function get closeButton(): Sprite {
            return this._closeButton;
        }
        
        private var _contentContainer: Sprite;
        
        public function get contentContainer(): Sprite {
            return this._contentContainer;
        }
        
        public function renderYard(): void {
            this.petYard = new PetYardList();
            this.petYard.x = 20;
            this.petYard.y = 130;
            addChild(this.petYard);
        }
        
        public function renderCurrentPet(): void {
            this.currentPet = new PetInfoSlot(275, false, true, true, false, false, true, true, true);
            this.currentPet.x = 305;
            this.currentPet.y = 130;
            addChild(this.currentPet);
        }
        
        public function renderPetInteraction(): void {
            this.petInteraction = new InteractionInfo();
            this.petInteraction.x = 305;
            this.petInteraction.y = 347;
            addChild(this.petInteraction);
        }
    }
}
