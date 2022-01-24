package io.decagames.rotmg.pets.components.caretaker {
    import flash.display.BitmapData;
    
    import io.decagames.rotmg.pets.data.PetsModel;
    import io.decagames.rotmg.pets.utils.PetsViewAssetFactory;
    
    import kabam.rotmg.dialogs.control.CloseDialogsSignal;
    
    import robotlegs.bender.bundles.mvcs.Mediator;
    
    public class CaretakerQueryDialogMediator extends Mediator {
        
        
        public function CaretakerQueryDialogMediator() {
            super();
        }
        
        [Inject]
        public var view: CaretakerQueryDialog;
        [Inject]
        public var model: PetsModel;
        [Inject]
        public var closeDialogs: CloseDialogsSignal;
        
        override public function initialize(): void {
            this.view.closed.addOnce(this.onClosed);
            this.view.setCaretakerIcon(this.makeCaretakerIcon());
        }
        
        override public function destroy(): void {
            this.view.closed.removeAll();
        }
        
        private function makeCaretakerIcon(): BitmapData {
            var _local1: int = this.model.getPetYardObjectID();
            return PetsViewAssetFactory.returnCaretakerBitmap(_local1).bitmapData;
        }
        
        private function onClosed(): void {
            this.closeDialogs.dispatch();
        }
    }
}
