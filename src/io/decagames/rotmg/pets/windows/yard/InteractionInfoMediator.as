package io.decagames.rotmg.pets.windows.yard {
    import robotlegs.bender.bundles.mvcs.Mediator;
    
    public class InteractionInfoMediator extends Mediator {
        
        
        public function InteractionInfoMediator() {
            super();
        }
        
        [Inject]
        public var view: InteractionInfo;
        
        override public function initialize(): void {
        }
    }
}
