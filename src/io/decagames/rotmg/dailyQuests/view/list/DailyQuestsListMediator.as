package io.decagames.rotmg.dailyQuests.view.list {
    import io.decagames.rotmg.dailyQuests.model.DailyQuestsModel;
    import io.decagames.rotmg.dailyQuests.signal.ShowQuestInfoSignal;
    import io.decagames.rotmg.dailyQuests.view.info.DailyQuestInfo;
    
    import kabam.rotmg.ui.model.HUDModel;
    import kabam.rotmg.ui.signals.UpdateQuestSignal;
    
    import robotlegs.bender.bundles.mvcs.Mediator;
    
    public class DailyQuestsListMediator extends Mediator {
        
        
        public function DailyQuestsListMediator() {
            super();
        }
        
        [Inject]
        public var view: DailyQuestsList;
        [Inject]
        public var model: DailyQuestsModel;
        [Inject]
        public var hud: HUDModel;
        [Inject]
        public var updateQuestSignal: UpdateQuestSignal;
        [Inject]
        public var showInfoSignal: ShowQuestInfoSignal;
        private var hasEvent: Boolean;
        
        override public function initialize(): void {
            this.onQuestsUpdate("UpdateQuestSignal.QuestListLoaded");
            this.updateQuestSignal.add(this.onQuestsUpdate);
            this.view.tabs.tabSelectedSignal.add(this.onTabSelected);
        }
        
        override public function destroy(): void {
            this.view.tabs.buttonsRenderedSignal.remove(this.onAddedHandler);
        }
        
        private function onTabSelected(_arg_1: String): void {
            var _local2: DailyQuestListElement = this.view.getCurrentlySelected(_arg_1);
            if (_local2) {
                this.showInfoSignal.dispatch(_local2.id, _local2.category, _arg_1);
            } else {
                this.showInfoSignal.dispatch("", -1, _arg_1);
            }
        }
        
        private function onQuestsUpdate(_arg_1: String): void {
            this.view.clearQuestLists();
            var _local2: Vector.<int> = !this.hud.gameSprite.map.player_ ? new Vector.<int>() : this.hud.gameSprite.map.player_.equipment_.slice(3, 20);
            this.view.tabs.buttonsRenderedSignal.addOnce(this.onAddedHandler);
            this.addDailyQuests(_local2);
            this.addEventQuests(_local2);
        }
        
        private function addEventQuests(_arg_1: Vector.<int>): void {
            var _local4: * = null;
            var _local3: * = false;
            var _local5: * = null;
            var _local2: Boolean = true;
            var _local6: Date = new Date();
            var _local8: int = 0;
            var _local7: * = this.model.eventQuestsList;
            for each(_local4 in this.model.eventQuestsList) {
                _local3 = false;
                if (_local4.expiration != "") {
                    _local3 = parseFloat(_local4.expiration) - _local6.time / 1000 < 0;
                }
                if (!(_local4.completed || _local3)) {
                    _local5 = new DailyQuestListElement(_local4.id, _local4.name, _local4.completed, DailyQuestInfo.hasAllItems(_local4.requirements, _arg_1), _local4.category);
                    if (_local2) {
                        _local5.isSelected = true;
                    }
                    _local2 = false;
                    this.view.addEventToList(_local5);
                    this.hasEvent = true;
                }
            }
        }
        
        private function addDailyQuests(_arg_1: Vector.<int>): void {
            var _local4: * = null;
            var _local3: * = null;
            var _local2: Boolean = true;
            var _local6: int = 0;
            var _local5: * = this.model.dailyQuestsList;
            for each(_local4 in this.model.dailyQuestsList) {
                if (!_local4.completed) {
                    _local3 = new DailyQuestListElement(_local4.id, _local4.name, _local4.completed, DailyQuestInfo.hasAllItems(_local4.requirements, _arg_1), _local4.category);
                    if (_local2) {
                        _local3.isSelected = true;
                    }
                    _local2 = false;
                    this.view.addQuestToList(_local3);
                }
            }
            this.onTabSelected("Quests");
        }
        
        private function onAddedHandler(): void {
            if (this.hasEvent) {
                this.view.addIndicator(this.hasEvent);
            }
        }
    }
}
