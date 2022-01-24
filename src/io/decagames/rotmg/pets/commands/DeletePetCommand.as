package io.decagames.rotmg.pets.commands {
    import com.company.assembleegameclient.editor.Command;
    
    import io.decagames.rotmg.pets.data.PetsModel;
    
    public class DeletePetCommand extends Command {
        
        
        public function DeletePetCommand() {
            super();
        }
        
        [Inject]
        public var petID: int;
        [Inject]
        public var petsModel: PetsModel;
        
        override public function execute(): void {
            this.petsModel.deletePet(this.petID);
        }
    }
}
