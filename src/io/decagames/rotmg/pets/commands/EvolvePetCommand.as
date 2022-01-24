package io.decagames.rotmg.pets.commands {
    import com.company.assembleegameclient.editor.Command;
    
    import io.decagames.rotmg.pets.data.PetsModel;
    import io.decagames.rotmg.pets.data.vo.SkinVO;
    import io.decagames.rotmg.pets.popup.evolving.PetEvolvingDialog;
    import io.decagames.rotmg.ui.popups.signals.ShowPopupSignal;
    
    import kabam.rotmg.messaging.impl.EvolvePetInfo;
    
    public class EvolvePetCommand extends Command {
        
        
        public function EvolvePetCommand() {
            super();
        }
        
        [Inject]
        public var openDialog: ShowPopupSignal;
        [Inject]
        public var evolvePetInfo: EvolvePetInfo;
        [Inject]
        public var model: PetsModel;
        
        override public function execute(): void {
            var _local1: SkinVO = this.model.getSkinVOById(this.evolvePetInfo.finalPet.skinType);
            var _local2: Boolean = _local1.isOwned;
            this.model.unlockSkin(this.evolvePetInfo.finalPet.skinType);
            this.openDialog.dispatch(new PetEvolvingDialog(this.evolvePetInfo, _local2));
        }
    }
}
