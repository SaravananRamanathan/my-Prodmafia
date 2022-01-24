package io.decagames.rotmg.dailyQuests.view.list {
    import flash.events.MouseEvent;
    
    import io.decagames.rotmg.dailyQuests.signal.ShowQuestInfoSignal;
    
    import robotlegs.bender.bundles.mvcs.Mediator;
    
    public class DailyQuestListElementMediator extends Mediator {
        
        
        public function DailyQuestListElementMediator() {
            super();
        }
        
        [Inject]
        public var view: DailyQuestListElement;
        [Inject]
        public var showInfoSignal: ShowQuestInfoSignal;
        
        override public function initialize(): void {
            this.showInfoSignal.add(this.resetElement);
            this.view.addEventListener("click", this.onClickHandler);
        }
        
        override public function destroy(): void {
            this.view.removeEventListener("click", this.onClickHandler);
        }
        
        private function resetElement(_arg_1: String, _arg_2: int, _arg_3: String): void {
            if (_arg_1 == "" || _arg_2 == -1) {
                return;
            }
            if (_arg_1 != this.view.id) {
                if (_arg_2 != 7 && this.view.category != 7) {
                    this.view.isSelected = false;
                } else if (_arg_2 == this.view.category) {
                    this.view.isSelected = false;
                }
            }
        }
        
        private function onClickHandler(_arg_1: MouseEvent): void {
            this.view.isSelected = true;
            var _local2: String = this.view.category == 7 ? "Events" : "Quests";
            this.showInfoSignal.dispatch(this.view.id, this.view.category, _local2);
        }
    }
}
