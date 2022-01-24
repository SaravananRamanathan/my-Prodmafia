package io.decagames.rotmg.pets.commands {
    import io.decagames.rotmg.pets.signals.OpenCaretakerQueryDialogSignal;
    
    import kabam.lib.console.signals.RegisterConsoleActionSignal;
    import kabam.lib.console.vo.ConsoleAction;
    
    public class AddPetsConsoleActionsCommand {
        
        
        public function AddPetsConsoleActionsCommand() {
            super();
        }
        
        [Inject]
        public var register: RegisterConsoleActionSignal;
        [Inject]
        public var openCaretakerQuerySignal: OpenCaretakerQueryDialogSignal;
        
        public function execute(): void {
            var _local1: * = null;
            _local1 = new ConsoleAction();
            _local1.name = "caretaker";
            _local1.description = "opens the pets caretaker query UI";
            this.register.dispatch(_local1, this.openCaretakerQuerySignal);
        }
    }
}
