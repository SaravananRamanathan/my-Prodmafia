package io.decagames.rotmg.pets.windows.yard.feed {
    import com.company.assembleegameclient.objects.ObjectLibrary;
    import com.company.assembleegameclient.objects.Player;
    import com.company.assembleegameclient.ui.panels.itemgrids.itemtiles.InventoryTile;
    
    import io.decagames.rotmg.pets.data.PetsModel;
    import io.decagames.rotmg.pets.data.vo.PetVO;
    import io.decagames.rotmg.pets.data.vo.requests.FeedPetRequestVO;
    import io.decagames.rotmg.pets.signals.SelectFeedItemSignal;
    import io.decagames.rotmg.pets.signals.SelectPetSignal;
    import io.decagames.rotmg.pets.signals.SimulateFeedSignal;
    import io.decagames.rotmg.pets.signals.UpgradePetSignal;
    import io.decagames.rotmg.pets.utils.FeedFuseCostModel;
    import io.decagames.rotmg.pets.windows.yard.feed.items.FeedItem;
    import io.decagames.rotmg.seasonalEvent.data.SeasonalEventModel;
    import io.decagames.rotmg.shop.NotEnoughResources;
    import io.decagames.rotmg.ui.buttons.BaseButton;
    import io.decagames.rotmg.ui.popups.modal.error.ErrorModal;
    import io.decagames.rotmg.ui.popups.signals.RemoveLockFade;
    import io.decagames.rotmg.ui.popups.signals.ShowLockFade;
    import io.decagames.rotmg.ui.popups.signals.ShowPopupSignal;
    
    import kabam.rotmg.core.model.PlayerModel;
    import kabam.rotmg.game.model.GameModel;
    import kabam.rotmg.game.view.components.InventoryTabContent;
    import kabam.rotmg.messaging.impl.data.SlotObjectData;
    import kabam.rotmg.text.view.stringBuilder.LineBuilder;
    import kabam.rotmg.ui.model.HUDModel;
    
    import robotlegs.bender.bundles.mvcs.Mediator;
    
    public class FeedTabMediator extends Mediator {
        
        
        public function FeedTabMediator() {
            super();
        }
        
        [Inject]
        public var view: FeedTab;
        [Inject]
        public var hud: HUDModel;
        [Inject]
        public var model: PetsModel;
        [Inject]
        public var selectFeedItemSignal: SelectFeedItemSignal;
        [Inject]
        public var selectPetSignal: SelectPetSignal;
        [Inject]
        public var gameModel: GameModel;
        [Inject]
        public var playerModel: PlayerModel;
        [Inject]
        public var showPopup: ShowPopupSignal;
        [Inject]
        public var upgradePet: UpgradePetSignal;
        [Inject]
        public var showFade: ShowLockFade;
        [Inject]
        public var removeFade: RemoveLockFade;
        [Inject]
        public var simulateFeed: SimulateFeedSignal;
        [Inject]
        public var seasonalEventModel: SeasonalEventModel;
        private var currentPet: PetVO;
        private var items: Vector.<FeedItem>;
        
        private function get currentGold(): int {
            var _local1: Player = this.gameModel.player;
            if (_local1 != null) {
                return _local1.credits_;
            }
            if (this.playerModel != null) {
                return this.playerModel.getCredits();
            }
            return 0;
        }
        
        private function get currentFame(): int {
            var _local1: Player = this.gameModel.player;
            if (_local1 != null) {
                return _local1.fame_;
            }
            if (this.playerModel != null) {
                return this.playerModel.getFame();
            }
            return 0;
        }
        
        override public function initialize(): void {
            this.currentPet = !this.model.activeUIVO ? this.model.getActivePet() : this.model.activeUIVO;
            this.selectPetSignal.add(this.onPetSelected);
            this.items = new Vector.<FeedItem>();
            this.selectFeedItemSignal.add(this.refreshFeedPower);
            this.view.feedGoldButton.clickSignal.add(this.purchaseGold);
            this.view.feedFameButton.clickSignal.add(this.purchaseFame);
            this.view.displaySignal.add(this.showHideSignal);
            this.renderItems();
            this.refreshFeedPower();
        }
        
        override public function destroy(): void {
            this.items = new Vector.<FeedItem>();
            this.selectFeedItemSignal.remove(this.refreshFeedPower);
            this.selectPetSignal.remove(this.onPetSelected);
            this.view.feedGoldButton.clickSignal.remove(this.purchaseGold);
            this.view.feedFameButton.clickSignal.remove(this.purchaseFame);
            this.view.displaySignal.remove(this.showHideSignal);
        }
        
        private function showHideSignal(_arg_1: Boolean): void {
            var _local2: * = null;
            if (!_arg_1) {
                var _local4: int = 0;
                var _local3: * = this.items;
                for each(_local2 in this.items) {
                    _local2.selected = false;
                }
                this.refreshFeedPower();
            }
        }
        
        private function renderItems(): void {
            var _local1: * = null;
            var _local4: int = 0;
            var _local3: * = null;
            this.view.clearGrid();
            this.items = new Vector.<FeedItem>();
            var _local5: InventoryTabContent = this.hud.gameSprite.hudView.tabStrip.getTabView(InventoryTabContent);
            var _local2: Vector.<InventoryTile> = new Vector.<InventoryTile>();
            if (_local5) {
                _local2 = _local2.concat(_local5.storage.tiles);
            }
            var _local7: int = 0;
            var _local6: * = _local2;
            for each(_local1 in _local2) {
                _local4 = _local1.getItemId();
                if (_local4 != -1 && this.hasFeedPower(_local4)) {
                    _local3 = new FeedItem(_local1);
                    this.items.push(_local3);
                    this.view.addItem(_local3);
                }
            }
        }
        
        private function refreshFeedPower(): void {
            var _local1: * = null;
            var _local3: int = 0;
            var _local2: int = 0;
            var _local5: int = 0;
            var _local4: * = this.items;
            for each(_local1 in this.items) {
                if (_local1.selected) {
                    _local3 = _local3 + _local1.feedPower;
                    _local2++;
                }
            }
            if (this.currentPet) {
                this.view.feedGoldButton.price = this.seasonalEventModel.isChallenger != 1 ? FeedFuseCostModel.getFeedGoldCost(this.currentPet.rarity) * _local2 : 0;
                this.view.feedFameButton.price = this.seasonalEventModel.isChallenger != 1 ? FeedFuseCostModel.getFeedFameCost(this.currentPet.rarity) * _local2 : 0;
                this.view.updateFeedPower(_local3, this.currentPet.maxedAvailableAbilities());
            } else {
                this.view.feedGoldButton.price = 0;
                this.view.feedFameButton.price = 0;
                this.view.updateFeedPower(0, false);
            }
            this.simulateFeed.dispatch(_local3);
        }
        
        private function hasFeedPower(_arg_1: int): Boolean {
            var _local3: * = null;
            var _local2: XML = ObjectLibrary.xmlLibrary_[_arg_1];
            return _local2.hasOwnProperty("feedPower");
        }
        
        private function purchaseFame(_arg_1: BaseButton): void {
            this.purchase(1, this.view.feedFameButton.price);
        }
        
        private function purchaseGold(_arg_1: BaseButton): void {
            this.purchase(0, this.view.feedGoldButton.price);
        }
        
        private function purchase(_arg_1: int, _arg_2: int): void {
            var _local4: * = null;
            var _local3: * = null;
            var _local5: * = null;
            if (!this.checkYardType()) {
                return;
            }
            if (_arg_1 == 0 && this.currentGold < _arg_2) {
                this.showPopup.dispatch(new NotEnoughResources(5 * 60, 0));
                return;
            }
            if (_arg_1 == 1 && this.currentFame < _arg_2) {
                this.showPopup.dispatch(new NotEnoughResources(5 * 60, 1));
                return;
            }
            var _local6: Vector.<SlotObjectData> = new Vector.<SlotObjectData>();
            var _local8: int = 0;
            var _local7: * = this.items;
            for each(_local4 in this.items) {
                if (_local4.selected) {
                    _local5 = new SlotObjectData();
                    _local5.objectId_ = _local4.item.ownerGrid.owner.objectId_;
                    _local5.objectType_ = _local4.item.getItemId();
                    _local5.slotId_ = _local4.item.tileId;
                    _local6.push(_local5);
                }
            }
            this.currentPet.abilityUpdated.addOnce(this.abilityUpdated);
            this.showFade.dispatch();
            _local3 = new FeedPetRequestVO(this.currentPet.getID(), _local6, _arg_1);
            this.upgradePet.dispatch(_local3);
        }
        
        private function abilityUpdated(): void {
            var _local1: * = null;
            this.removeFade.dispatch();
            this.renderItems();
            var _local3: int = 0;
            var _local2: * = this.items;
            for each(_local1 in this.items) {
                _local1.selected = false;
            }
            this.refreshFeedPower();
        }
        
        private function onPetSelected(_arg_1: PetVO): void {
            var _local2: * = null;
            this.currentPet = _arg_1;
            var _local4: int = 0;
            var _local3: * = this.items;
            for each(_local2 in this.items) {
                _local2.selected = false;
            }
            this.refreshFeedPower();
        }
        
        private function checkYardType(): Boolean {
            if (this.currentPet.rarity.ordinal >= this.model.getPetYardType()) {
                this.showPopup.dispatch(new ErrorModal(350, "Feed Pets", LineBuilder.getLocalizedStringFromKey("server.upgrade_petyard_first")));
                return false;
            }
            return true;
        }
    }
}
