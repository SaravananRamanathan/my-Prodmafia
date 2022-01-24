package io.decagames.rotmg.pets.components.tooltip {
    import robotlegs.bender.bundles.mvcs.Mediator;
    
    public class PetTooltipMediator extends Mediator {
        
        
        public function PetTooltipMediator() {
            super();
        }
        
        [Inject]
        public var view: PetTooltip;
        
        override public function initialize(): void {
            this.view.init();
        }
    }
}
