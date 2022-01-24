package io.decagames.rotmg.dailyQuests.model {
    import io.decagames.rotmg.dailyQuests.view.info.DailyQuestInfo;
    import io.decagames.rotmg.dailyQuests.view.slot.DailyQuestItemSlot;
    
    import kabam.rotmg.ui.model.HUDModel;
    import kabam.rotmg.ui.signals.UpdateQuestSignal;
    
    public class DailyQuestsModel {
        
        
        public function DailyQuestsModel() {
            categoriesWeight = [1, 0, 2, 3, 4];
            slots = new Vector.<DailyQuestItemSlot>(0);
            _dailyQuestsList = new Vector.<DailyQuest>(0);
            _eventQuestsList = new Vector.<DailyQuest>(0);
            super();
        }
        
        public var currentQuest: DailyQuest;
        public var isPopupOpened: Boolean;
        public var categoriesWeight: Array;
        public var selectedItem: int = -1;
        [Inject]
        public var hud: HUDModel;
        [Inject]
        public var updateQuestSignal: UpdateQuestSignal;
        private var slots: Vector.<DailyQuestItemSlot>;
        
        private var _questsList: Vector.<DailyQuest>;
        
        public function get questsList(): Vector.<DailyQuest> {
            var _local1: Vector.<DailyQuest> = this._questsList.concat();
            return _local1.sort(this.questsCompleteSort);
        }
        
        private var _dailyQuestsList: Vector.<DailyQuest>;
        
        public function get dailyQuestsList(): Vector.<DailyQuest> {
            return this._dailyQuestsList;
        }
        
        private var _eventQuestsList: Vector.<DailyQuest>;
        
        public function get eventQuestsList(): Vector.<DailyQuest> {
            return this._eventQuestsList;
        }
        
        private var _nextRefreshPrice: int;
        
        public function get nextRefreshPrice(): int {
            return this._nextRefreshPrice;
        }
        
        public function set nextRefreshPrice(_arg_1: int): void {
            this._nextRefreshPrice = _arg_1;
        }
        
        private var _hasQuests: Boolean;
        
        public function get hasQuests(): Boolean {
            return this._hasQuests;
        }
        
        public function get playerItemsFromInventory(): Vector.<int> {
            return !this.hud.gameSprite.map.player_ ? new Vector.<int>() : this.hud.gameSprite.map.player_.equipment_.slice(3, 20);
        }
        
        public function get numberOfActiveQuests(): int {
            return this._questsList.length;
        }
        
        public function get numberOfCompletedQuests(): int {
            var _local1: int = 0;
            var _local2: * = null;
            var _local4: int = 0;
            var _local3: * = this._questsList;
            for each(_local2 in this._questsList) {
                if (_local2.completed) {
                    _local1++;
                }
            }
            return _local1;
        }
        
        public function get first(): DailyQuest {
            if (this._questsList.length > 0) {
                return this.questsList[0];
            }
            return null;
        }
        
        public function registerSelectableSlot(_arg_1: DailyQuestItemSlot): void {
            this.slots.push(_arg_1);
        }
        
        public function unregisterSelectableSlot(_arg_1: DailyQuestItemSlot): void {
            var _local2: int = this.slots.indexOf(_arg_1);
            if (_local2 != -1) {
                this.slots.splice(_local2, 1);
            }
        }
        
        public function unselectAllSlots(_arg_1: int): void {
            var _local2: * = null;
            var _local4: int = 0;
            var _local3: * = this.slots;
            for each(_local2 in this.slots) {
                if (_local2.itemID != _arg_1) {
                    _local2.selected = false;
                }
            }
        }
        
        public function clear(): void {
            this._dailyQuestsList.length = 0;
            this._eventQuestsList.length = 0;
            if (this._questsList) {
                this._questsList.length = 0;
            }
        }
        
        public function addQuests(_arg_1: Vector.<DailyQuest>): void {
            var _local2: * = null;
            this._questsList = _arg_1;
            if (this._questsList.length > 0) {
                this._hasQuests = true;
            }
            var _local4: int = 0;
            var _local3: * = this._questsList;
            for each(_local2 in this._questsList) {
                this.addQuestToCategoryList(_local2);
            }
            this.updateQuestSignal.dispatch("UpdateQuestSignal.QuestListLoaded");
        }
        
        public function addQuestToCategoryList(_arg_1: DailyQuest): void {
            if (_arg_1.category == 7) {
                this._eventQuestsList.push(_arg_1);
            } else {
                this._dailyQuestsList.push(_arg_1);
            }
        }
        
        public function markAsCompleted(_arg_1: String): void {
            var _local2: * = null;
            var _local4: int = 0;
            var _local3: * = this._questsList;
            for each(_local2 in this._questsList) {
                if (_local2.id == _arg_1 && !_local2.repeatable) {
                    _local2.completed = true;
                }
            }
        }
        
        public function getQuestById(_arg_1: String): DailyQuest {
            var _local2: * = null;
            var _local4: int = 0;
            var _local3: * = this._questsList;
            for each(_local2 in this._questsList) {
                if (_local2.id == _arg_1) {
                    return _local2;
                }
            }
            return null;
        }
        
        public function removeQuestFromlist(_arg_1: DailyQuest): void {
            var _local2: int = 0;
            var _local3: int = 0;
            while (_local2 < this._eventQuestsList.length) {
                if (_arg_1.id == this._eventQuestsList[_local2].id) {
                    this._eventQuestsList.splice(_local2, 1);
                }
                _local2++;
            }
            while (_local3 < this._questsList.length) {
                if (_arg_1.id == this._questsList[_local3].id) {
                    this._questsList.splice(_local3, 1);
                }
                _local3++;
            }
        }
        
        private function questsNameSort(_arg_1: DailyQuest, _arg_2: DailyQuest): int {
            if (_arg_1.name > _arg_2.name) {
                return 1;
            }
            return -1;
        }
        
        private function sortByCategory(_arg_1: DailyQuest, _arg_2: DailyQuest): int {
            if (this.categoriesWeight[_arg_1.category] < this.categoriesWeight[_arg_2.category]) {
                return -1;
            }
            if (this.categoriesWeight[_arg_1.category] > this.categoriesWeight[_arg_2.category]) {
                return 1;
            }
            return this.questsNameSort(_arg_1, _arg_2);
        }
        
        private function questsReadySort(_arg_1: DailyQuest, _arg_2: DailyQuest): int {
            var _local4: Boolean = DailyQuestInfo.hasAllItems(_arg_1.requirements, this.playerItemsFromInventory);
            var _local3: Boolean = DailyQuestInfo.hasAllItems(_arg_2.requirements, this.playerItemsFromInventory);
            if (_local4 && !_local3) {
                return -1;
            }
            if (_local4 && _local3) {
                return this.questsNameSort(_arg_1, _arg_2);
            }
            return 1;
        }
        
        private function questsCompleteSort(_arg_1: DailyQuest, _arg_2: DailyQuest): int {
            if (_arg_1.completed && !_arg_2.completed) {
                return 1;
            }
            if (_arg_1.completed && _arg_2.completed) {
                return this.sortByCategory(_arg_1, _arg_2);
            }
            if (!_arg_1.completed && !_arg_2.completed) {
                return this.sortByCategory(_arg_1, _arg_2);
            }
            return -1;
        }
    }
}
