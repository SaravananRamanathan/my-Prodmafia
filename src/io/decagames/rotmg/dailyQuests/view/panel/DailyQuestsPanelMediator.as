package io.decagames.rotmg.dailyQuests.view.panel {
    import com.company.assembleegameclient.parameters.Parameters;
    
    import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;
    
    import io.decagames.rotmg.dailyQuests.model.DailyQuestsModel;
    import io.decagames.rotmg.dailyQuests.view.DailyQuestWindow;
    import io.decagames.rotmg.ui.popups.signals.ClosePopupByClassSignal;
    import io.decagames.rotmg.ui.popups.signals.ShowPopupSignal;
    
    import kabam.rotmg.ui.signals.UpdateQuestSignal;
    
    import robotlegs.bender.bundles.mvcs.Mediator;
    
    public class DailyQuestsPanelMediator extends Mediator {
        
        
        public function DailyQuestsPanelMediator() {
            super();
        }
        
        [Inject]
        public var view: DailyQuestsPanel;
        [Inject]
        public var questModel: DailyQuestsModel;
        [Inject]
        public var openDialogSignal: ShowPopupSignal;
        [Inject]
        public var closePopupByClassSignal: ClosePopupByClassSignal;
        [Inject]
        public var updateQuestSignal: UpdateQuestSignal;
        
        override public function initialize(): void {
            this.addSeeQuestsText();
        }
        
        override public function destroy(): void {
            if (this.view.feedButton) {
                this.view.feedButton.removeEventListener("click", this.onButtonLeftClick);
            }
            WebMain.STAGE.removeEventListener("keyDown", this.onKeyDown);
            this.closePopupByClassSignal.dispatch(DailyQuestWindow);
        }
        
        private function addSeeQuestsText(): void {
            this.view.addSeeOffersButton();
            this.view.feedButton.addEventListener("click", this.onButtonLeftClick);
            WebMain.STAGE.addEventListener("keyDown", this.onKeyDown);
        }
        
        protected function onButtonLeftClick(_arg_1: MouseEvent): void {
            if (!this.questModel.isPopupOpened) {
                this.openDialogSignal.dispatch(new DailyQuestWindow());
            }
        }
        
        private function onKeyDown(_arg_1: KeyboardEvent): void {
            if (_arg_1.keyCode == Parameters.data.interact && WebMain.STAGE.focus == null) {
                this.onButtonLeftClick(null);
            }
        }
    }
}
