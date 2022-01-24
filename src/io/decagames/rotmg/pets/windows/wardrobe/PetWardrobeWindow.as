package io.decagames.rotmg.pets.windows.wardrobe {
    import flash.display.Sprite;
    
    import io.decagames.rotmg.pets.components.petInfoSlot.PetInfoSlot;
    import io.decagames.rotmg.pets.components.petSkinsCollection.PetSkinsCollection;
    import io.decagames.rotmg.pets.components.selectedPetSkinInfo.SelectedPetSkinInfo;
    import io.decagames.rotmg.ui.popups.UIPopup;
    import io.decagames.rotmg.ui.sliceScaling.SliceScalingBitmap;
    import io.decagames.rotmg.ui.texture.TextureParser;
    
    public class PetWardrobeWindow extends UIPopup {
        
        
        public function PetWardrobeWindow() {
            super(10 * 60, 10 * 60);
            this._contentContainer = new Sprite();
            this._contentContainer.y = 2 * 60;
            this._contentContainer.x = 10;
            addChild(this._contentContainer);
        }
        
        private var currentPet: PetInfoSlot;
        private var selectedPet: SelectedPetSkinInfo;
        private var petCollection: PetSkinsCollection;
        
        private var _closeButton: Sprite;
        
        public function get closeButton(): Sprite {
            return this._closeButton;
        }
        
        private var _contentContainer: Sprite;
        
        public function get contentContainer(): Sprite {
            return this._contentContainer;
        }
        
        public function renderCurrentPet(): void {
            this.currentPet = new PetInfoSlot(195, true, true, true, true);
            this.currentPet.x = 20;
            this.currentPet.y = 130;
            addChild(this.currentPet);
            var _local1: SliceScalingBitmap = TextureParser.instance.getSliceScalingBitmap("UI", "popup_content_inset", 195);
            _local1.height = 207;
            _local1.x = 20;
            _local1.y = 130;
            _local1.cacheAsBitmap = true;
            this.currentPet.cacheAsBitmap = true;
            addChild(_local1);
            this.currentPet.mask = _local1;
        }
        
        public function renderSelectedPet(): void {
            this.selectedPet = new SelectedPetSkinInfo(195, true);
            this.selectedPet.x = 20;
            this.selectedPet.y = 348;
            addChild(this.selectedPet);
        }
        
        public function renderCollection(_arg_1: int, _arg_2: int): void {
            this.petCollection = new PetSkinsCollection(_arg_1, _arg_2);
            this.petCollection.x = 222;
            this.petCollection.y = 130;
            addChild(this.petCollection);
        }
    }
}
