package io.decagames.rotmg.dailyQuests.view.popup {
    import flash.events.MouseEvent;
    
    import io.decagames.rotmg.dailyQuests.signal.CloseRedeemPopupSignal;
    
    import robotlegs.bender.bundles.mvcs.Mediator;
    
    public class DailyQuestRedeemPopupMediator extends Mediator {
        
        
        public function DailyQuestRedeemPopupMediator() {
            super();
        }
        
        [Inject]
        public var view: DailyQuestRedeemPopup;
        [Inject]
        public var closeRedeem: CloseRedeemPopupSignal;
        
        override public function destroy(): void {
            this.view.thanksButton.removeEventListener("click", this.onThanksClickedHandler);
        }
        
        override public function initialize(): void {
            this.view.thanksButton.addEventListener("click", this.onThanksClickedHandler);
        }
        
        private function onThanksClickedHandler(_arg_1: MouseEvent): void {
            this.view.thanksButton.removeEventListener("click", this.onThanksClickedHandler);
            this.closeRedeem.dispatch();
        }
    }
}
