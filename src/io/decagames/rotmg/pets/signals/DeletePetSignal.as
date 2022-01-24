package io.decagames.rotmg.pets.signals {
    import org.osflash.signals.Signal;
    
    public class DeletePetSignal extends Signal {
        
        
        public function DeletePetSignal() {
            super(int);
        }
        
        public var petID: int;
    }
}
