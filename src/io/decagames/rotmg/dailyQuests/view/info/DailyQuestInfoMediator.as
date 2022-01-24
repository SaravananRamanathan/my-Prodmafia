package io.decagames.rotmg.dailyQuests.view.info {
    import com.company.assembleegameclient.ui.panels.itemgrids.itemtiles.InventoryTile;
    import com.company.assembleegameclient.ui.tooltip.TextToolTip;
    
    import flash.events.Event;
    import flash.events.MouseEvent;
    
    import io.decagames.rotmg.dailyQuests.model.DailyQuest;
    import io.decagames.rotmg.dailyQuests.model.DailyQuestsModel;
    import io.decagames.rotmg.dailyQuests.signal.LockQuestScreenSignal;
    import io.decagames.rotmg.dailyQuests.signal.SelectedItemSlotsSignal;
    import io.decagames.rotmg.dailyQuests.signal.ShowQuestInfoSignal;
    import io.decagames.rotmg.dailyQuests.view.popup.DailyQuestExpiredPopup;
    import io.decagames.rotmg.ui.popups.signals.ShowPopupSignal;
    
    import kabam.rotmg.core.signals.HideTooltipsSignal;
    import kabam.rotmg.core.signals.ShowTooltipSignal;
    import kabam.rotmg.dailyLogin.model.DailyLoginModel;
    import kabam.rotmg.game.view.components.BackpackTabContent;
    import kabam.rotmg.game.view.components.InventoryTabContent;
    import kabam.rotmg.messaging.impl.data.SlotObjectData;
    import kabam.rotmg.tooltips.HoverTooltipDelegate;
    import kabam.rotmg.ui.model.HUDModel;
    
    import robotlegs.bender.bundles.mvcs.Mediator;
    
    public class DailyQuestInfoMediator extends Mediator {
        
        
        public function DailyQuestInfoMediator() {
            hoverTooltipDelegate = new HoverTooltipDelegate();
            super();
        }
        
        [Inject]
        public var showInfoSignal: ShowQuestInfoSignal;
        [Inject]
        public var view: DailyQuestInfo;
        [Inject]
        public var model: DailyQuestsModel;
        [Inject]
        public var hud: HUDModel;
        [Inject]
        public var lockScreen: LockQuestScreenSignal;
        [Inject]
        public var selectedItemSlotsSignal: SelectedItemSlotsSignal;
        [Inject]
        public var showTooltipSignal: ShowTooltipSignal;
        [Inject]
        public var hideTooltipsSignal: HideTooltipsSignal;
        [Inject]
        public var dailyLoginModel: DailyLoginModel;
        [Inject]
        public var showPopupSignal: ShowPopupSignal;
        private var tooltip: TextToolTip;
        private var hoverTooltipDelegate: HoverTooltipDelegate;
        
        override public function initialize(): void {
            this.showInfoSignal.add(this.showQuestInfo);
            this.tooltip = new TextToolTip(0x363636, 0x9b9b9b, "", "You must select a reward first!", 190, null);
            this.hoverTooltipDelegate.setHideToolTipsSignal(this.hideTooltipsSignal);
            this.hoverTooltipDelegate.setShowToolTipSignal(this.showTooltipSignal);
            this.hoverTooltipDelegate.tooltip = this.tooltip;
            this.view.completeButton.addEventListener("click", this.onCompleteButtonClickHandler);
            this.selectedItemSlotsSignal.add(this.itemSelectedHandler);
        }
        
        override public function destroy(): void {
            this.view.completeButton.removeEventListener("click", this.onCompleteButtonClickHandler);
            this.showInfoSignal.remove(this.showQuestInfo);
            this.selectedItemSlotsSignal.remove(this.itemSelectedHandler);
        }
        
        private function itemSelectedHandler(_arg_1: int): void {
            this.view.completeButton.disabled = !!this.model.currentQuest.completed ? true : Boolean(this.model.selectedItem == -1 ? true : !DailyQuestInfo.hasAllItems(this.model.currentQuest.requirements, this.model.playerItemsFromInventory));
            if (this.model.selectedItem == -1) {
                this.hoverTooltipDelegate.setDisplayObject(this.view.completeButton);
            } else {
                this.hoverTooltipDelegate.removeDisplayObject();
            }
        }
        
        private function showQuestInfo(_arg_1: String, _arg_2: int, _arg_3: String): void {
            if (_arg_1 != "" && _arg_2 != -1) {
                this.setupQuestInfo(_arg_1);
                if (this.view.hasEventListener("enterFrame")) {
                    this.view.removeEventListener("enterFrame", this.updateQuestAvailable);
                }
            } else if (_arg_3 == "Quests") {
                this.view.dailyQuestsCompleted();
                this.view.addEventListener("enterFrame", this.updateQuestAvailable);
            } else {
                this.view.eventQuestsCompleted();
            }
        }
        
        private function setupQuestInfo(_arg_1: String): void {
            this.model.selectedItem = -1;
            this.view.dailyQuestsCompleted();
            this.model.currentQuest = this.model.getQuestById(_arg_1);
            this.view.show(this.model.currentQuest, this.model.playerItemsFromInventory);
            if (!this.view.completeButton.completed && this.model.currentQuest.itemOfChoice) {
                this.view.completeButton.disabled = true;
                this.hoverTooltipDelegate.setDisplayObject(this.view.completeButton);
            }
        }
        
        private function tileToSlot(_arg_1: InventoryTile): SlotObjectData {
            var _local2: SlotObjectData = new SlotObjectData();
            _local2.objectId_ = _arg_1.ownerGrid.owner.objectId_;
            _local2.objectType_ = _arg_1.getItemId();
            _local2.slotId_ = _arg_1.tileId;
            return _local2;
        }
        
        private function completeQuest(): void {
            var _local2: * = undefined;
            var _local1: * = null;
            var _local6: * = null;
            var _local5: * = undefined;
            var _local4: * = undefined;
            var _local3: int = 0;
            var _local7: * = null;
            if (!this.view.completeButton.disabled && !this.view.completeButton.completed) {
                _local2 = new Vector.<SlotObjectData>();
                _local1 = this.hud.gameSprite.hudView.tabStrip.getTabView(BackpackTabContent);
                _local6 = this.hud.gameSprite.hudView.tabStrip.getTabView(InventoryTabContent);
                _local5 = this.model.currentQuest.requirements.concat();
                _local4 = new Vector.<InventoryTile>();
                if (_local1) {
                    _local4 = _local4.concat(_local1.backpack.tiles);
                }
                if (_local6) {
                    _local4 = _local4.concat(_local6.storage.tiles);
                }
                var _local11: int = 0;
                var _local10: * = _local5;
                for each(_local3 in _local5) {
                    var _local9: int = 0;
                    var _local8: * = _local4;
                    for each(_local7 in _local4) {
                        if (_local7.getItemId() == _local3) {
                            _local4.splice(_local4.indexOf(_local7), 1);
                            _local2.push(this.tileToSlot(_local7));
                            break;
                        }
                    }
                }
                this.lockScreen.dispatch();
                this.hud.gameSprite.gsc_.questRedeem(this.model.currentQuest.id, _local2, this.model.selectedItem);
                if (!this.model.currentQuest.repeatable) {
                    this.model.currentQuest.completed = true;
                }
                this.view.completeButton.completed = true;
                this.view.completeButton.disabled = true;
            }
        }
        
        private function checkIfQuestHasExpired(): Boolean {
            var _local3: * = false;
            var _local2: DailyQuest = this.model.currentQuest;
            var _local1: Date = new Date();
            if (_local2.expiration != "") {
                _local3 = parseFloat(_local2.expiration) - _local1.time / 1000 < 0;
            }
            return _local3;
        }
        
        private function updateQuestAvailable(_arg_1: Event): void {
            var _local2: String = "New quests available in " + this.dailyLoginModel.getFormatedQuestRefreshTime();
            this.view.setQuestAvailableTime(_local2);
        }
        
        private function onCompleteButtonClickHandler(_arg_1: MouseEvent): void {
            if (this.checkIfQuestHasExpired()) {
                this.showPopupSignal.dispatch(new DailyQuestExpiredPopup());
            } else {
                this.completeQuest();
            }
        }
    }
}
