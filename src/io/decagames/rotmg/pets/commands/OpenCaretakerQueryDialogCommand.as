package io.decagames.rotmg.pets.commands {
    import io.decagames.rotmg.pets.components.caretaker.CaretakerQueryDialog;
    
    import kabam.rotmg.dialogs.control.OpenDialogSignal;
    
    public class OpenCaretakerQueryDialogCommand {
        
        
        public function OpenCaretakerQueryDialogCommand() {
            super();
        }
        
        [Inject]
        public var openDialog: OpenDialogSignal;
        
        public function execute(): void {
            var _local1: CaretakerQueryDialog = new CaretakerQueryDialog();
            this.openDialog.dispatch(_local1);
        }
    }
}
