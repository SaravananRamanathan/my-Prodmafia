package io.decagames.rotmg.pets.windows.yard.list {
    import com.company.assembleegameclient.ui.tooltip.TextToolTip;
    
    import flash.events.MouseEvent;
    
    import io.decagames.rotmg.pets.components.petItem.PetItem;
    import io.decagames.rotmg.pets.data.PetsModel;
    import io.decagames.rotmg.pets.data.rarity.PetRarityEnum;
    import io.decagames.rotmg.pets.data.vo.PetVO;
    import io.decagames.rotmg.pets.popup.upgradeYard.PetYardUpgradeDialog;
    import io.decagames.rotmg.pets.signals.ActivatePet;
    import io.decagames.rotmg.pets.signals.EvolvePetSignal;
    import io.decagames.rotmg.pets.signals.NewAbilitySignal;
    import io.decagames.rotmg.pets.signals.ReleasePetSignal;
    import io.decagames.rotmg.pets.signals.SelectPetSignal;
    import io.decagames.rotmg.pets.utils.PetItemFactory;
    import io.decagames.rotmg.seasonalEvent.data.SeasonalEventModel;
    import io.decagames.rotmg.seasonalEvent.popups.SeasonalEventErrorPopup;
    import io.decagames.rotmg.ui.buttons.BaseButton;
    import io.decagames.rotmg.ui.popups.signals.ClosePopupSignal;
    import io.decagames.rotmg.ui.popups.signals.ShowPopupSignal;
    
    import kabam.rotmg.account.core.Account;
    import kabam.rotmg.core.signals.HideTooltipsSignal;
    import kabam.rotmg.core.signals.ShowTooltipSignal;
    import kabam.rotmg.messaging.impl.EvolvePetInfo;
    import kabam.rotmg.tooltips.HoverTooltipDelegate;
    
    import robotlegs.bender.bundles.mvcs.Mediator;
    
    public class PetYardListMediator extends Mediator {
        
        
        public function PetYardListMediator() {
            super();
        }
        
        [Inject]
        public var view: PetYardList;
        [Inject]
        public var selectPetSignal: SelectPetSignal;
        [Inject]
        public var activatePet: ActivatePet;
        [Inject]
        public var petIconFactory: PetItemFactory;
        [Inject]
        public var model: PetsModel;
        [Inject]
        public var newAbilityUnlocked: NewAbilitySignal;
        [Inject]
        public var evolvePetSignal: EvolvePetSignal;
        [Inject]
        public var showTooltipSignal: ShowTooltipSignal;
        [Inject]
        public var hideTooltipSignal: HideTooltipsSignal;
        [Inject]
        public var showDialog: ShowPopupSignal;
        [Inject]
        public var account: Account;
        [Inject]
        public var release: ReleasePetSignal;
        [Inject]
        public var showPopupSignal: ShowPopupSignal;
        [Inject]
        public var closePopupSignal: ClosePopupSignal;
        [Inject]
        public var seasonalEventModel: SeasonalEventModel;
        private var toolTip: TextToolTip = null;
        private var hoverTooltipDelegate: HoverTooltipDelegate;
        private var petsList: Vector.<PetItem>;
        private var seasonalEventErrorPopUp: SeasonalEventErrorPopup;
        
        override public function initialize(): void {
            this.model.activeUIVO = null;
            this.refreshPetsList();
            this.selectPetVO(this.model.getActivePet());
            this.newAbilityUnlocked.add(this.abilityUnlocked);
            this.evolvePetSignal.add(this.evolvePetHandler);
            var _local1: PetRarityEnum = PetRarityEnum.selectByOrdinal(this.model.getPetYardType() - 1);
            var _local2: PetRarityEnum = PetRarityEnum.selectByOrdinal(this.model.getPetYardType());
            this.view.showPetYardRarity(_local1.rarityName, _local1.ordinal < PetRarityEnum.DIVINE.ordinal && this.account.isRegistered());
            if (this.view.upgradeButton) {
                this.view.upgradeButton.clickSignal.add(this.upgradeYard);
                this.toolTip = new TextToolTip(0x363636, 0x9b9b9b, "Upgrade Pet Yard", "Upgrading your yard allows you to fuse pets up to " + _local2.rarityName, 3 * 60);
                this.hoverTooltipDelegate = new HoverTooltipDelegate();
                this.hoverTooltipDelegate.setShowToolTipSignal(this.showTooltipSignal);
                this.hoverTooltipDelegate.setHideToolTipsSignal(this.hideTooltipSignal);
                this.hoverTooltipDelegate.setDisplayObject(this.view.upgradeButton);
                this.hoverTooltipDelegate.tooltip = this.toolTip;
            }
            this.release.add(this.onRelease);
        }
        
        override public function destroy(): void {
            this.clearList();
            this.newAbilityUnlocked.remove(this.abilityUnlocked);
            this.evolvePetSignal.remove(this.evolvePetHandler);
            if (this.view.upgradeButton) {
                this.view.upgradeButton.clickSignal.add(this.upgradeYard);
            }
            this.release.remove(this.onRelease);
        }
        
        private function upgradeYard(_arg_1: BaseButton): void {
            if (this.seasonalEventModel.isChallenger && this.model.getPetYardType() == this.seasonalEventModel.maxPetYardLevel) {
                this.showSeasonalErrorPopUp("You cannot upgrade your pet yard any higher this season");
            } else {
                this.showDialog.dispatch(new PetYardUpgradeDialog(PetRarityEnum.selectByOrdinal(this.model.getPetYardType()), this.model.getPetYardUpgradeGoldPrice(), this.model.getPetYardUpgradeFamePrice()));
            }
        }
        
        private function showSeasonalErrorPopUp(_arg_1: String): void {
            this.seasonalEventErrorPopUp = new SeasonalEventErrorPopup(_arg_1);
            this.seasonalEventErrorPopUp.okButton.addEventListener("click", this.onSeasonalErrorPopUpClose);
            this.showPopupSignal.dispatch(this.seasonalEventErrorPopUp);
        }
        
        private function selectPetVO(_arg_1: PetVO): void {
            var _local2: * = null;
            this.model.activeUIVO = _arg_1;
            var _local4: int = 0;
            var _local3: * = this.petsList;
            for each(_local2 in this.petsList) {
                _local2.selected = _local2.getPetVO() == _arg_1;
            }
        }
        
        private function clearList(): void {
            var _local1: * = null;
            var _local3: int = 0;
            var _local2: * = this.petsList;
            for each(_local1 in this.petsList) {
                _local1.removeEventListener("click", this.onPetSelected);
            }
            this.petsList = new Vector.<PetItem>();
        }
        
        private function refreshPetsList(): void {
            var _local2: PetVO = null;
            var _local1: * = null;
            this.clearList();
            this.view.clearPetsList();
            this.petsList = new Vector.<PetItem>();
            var _local3: Vector.<PetVO> = this.model.getAllPets();
            _local3 = _local3.sort(this.sortByFamily);
            for each(_local2 in _local3) {
                _local1 = this.petIconFactory.create(_local2, 40, 0x545454, 1);
                _local1.addEventListener("click", this.onPetSelected);
                this.petsList.push(_local1);
                this.view.addPet(_local1);
            }
        }
        
        private function sortByPower(_arg_1: PetVO, _arg_2: PetVO): int {
            if (_arg_1.totalAbilitiesLevel() < _arg_2.totalAbilitiesLevel()) {
                return 1;
            }
            return -1;
        }
        
        private function sortByFamily(_arg_1: PetVO, _arg_2: PetVO): int {
            if (_arg_1.family == _arg_2.family) {
                return this.sortByPower(_arg_1, _arg_2);
            }
            if (_arg_1.family > _arg_2.family) {
                return 1;
            }
            return -1;
        }
        
        private function abilityUnlocked(_arg_1: int): void {
            this.refreshPetsList();
            this.selectPetVO(!this.model.activeUIVO ? this.model.getActivePet() : this.model.activeUIVO);
        }
        
        private function evolvePetHandler(_arg_1: EvolvePetInfo): void {
            this.refreshPetsList();
            this.selectPetVO(!this.model.activeUIVO ? this.model.getActivePet() : this.model.activeUIVO);
        }
        
        private function onRelease(_arg_1: int): void {
            this.model.deletePet(_arg_1);
            this.refreshPetsList();
        }
        
        private function onSeasonalErrorPopUpClose(_arg_1: MouseEvent): void {
            this.seasonalEventErrorPopUp.okButton.removeEventListener("click", this.onSeasonalErrorPopUpClose);
            this.closePopupSignal.dispatch(this.seasonalEventErrorPopUp);
        }
        
        private function onPetSelected(_arg_1: MouseEvent): void {
            var _local2: PetItem = PetItem(_arg_1.currentTarget);
            this.selectPetSignal.dispatch(_local2.getPetVO());
            this.selectPetVO(_local2.getPetVO());
        }
    }
}
