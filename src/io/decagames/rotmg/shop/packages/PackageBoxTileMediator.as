package io.decagames.rotmg.shop.packages {
    import flash.events.MouseEvent;
    
    import io.decagames.rotmg.seasonalEvent.data.SeasonalEventModel;
    import io.decagames.rotmg.shop.PurchaseInProgressModal;
    import io.decagames.rotmg.shop.genericBox.BoxUtils;
    import io.decagames.rotmg.shop.packages.contentPopup.PackageBoxContentPopup;
    import io.decagames.rotmg.supportCampaign.data.SupporterCampaignModel;
    import io.decagames.rotmg.ui.buttons.BaseButton;
    import io.decagames.rotmg.ui.popups.modal.error.ErrorModal;
    import io.decagames.rotmg.ui.popups.signals.ClosePopupSignal;
    import io.decagames.rotmg.ui.popups.signals.ShowPopupSignal;
    
    import kabam.rotmg.account.core.Account;
    import kabam.rotmg.appengine.api.AppEngineClient;
    import kabam.rotmg.core.model.PlayerModel;
    import kabam.rotmg.dialogs.control.OpenDialogSignal;
    import kabam.rotmg.game.model.GameModel;
    import kabam.rotmg.packages.model.PackageInfo;
    import kabam.rotmg.text.view.stringBuilder.LineBuilder;
    
    import robotlegs.bender.bundles.mvcs.Mediator;
    
    public class PackageBoxTileMediator extends Mediator {
        
        
        public function PackageBoxTileMediator() {
            super();
        }
        
        [Inject]
        public var view: PackageBoxTile;
        [Inject]
        public var gameModel: GameModel;
        [Inject]
        public var playerModel: PlayerModel;
        [Inject]
        public var showPopupSignal: ShowPopupSignal;
        [Inject]
        public var openDialogSignal: OpenDialogSignal;
        [Inject]
        public var client: AppEngineClient;
        [Inject]
        public var account: Account;
        [Inject]
        public var closePopupSignal: ClosePopupSignal;
        [Inject]
        public var supportCampaignModel: SupporterCampaignModel;
        [Inject]
        public var seasonalEventModel: SeasonalEventModel;
        private var inProgressModal: PurchaseInProgressModal;
        
        override public function initialize(): void {
            this.view.spinner.valueWasChanged.add(this.changeAmountHandler);
            this.view.buyButton.clickSignal.add(this.onBuyHandler);
            if (this.view.infoButton) {
                this.view.infoButton.clickSignal.add(this.onInfoClick);
            }
            if (this.view.clickMask) {
                this.view.clickMask.addEventListener("click", this.onBoxClickHandler);
            }
        }
        
        override public function destroy(): void {
            this.view.spinner.valueWasChanged.remove(this.changeAmountHandler);
            this.view.buyButton.clickSignal.remove(this.onBuyHandler);
            if (this.view.infoButton) {
                this.view.infoButton.clickSignal.remove(this.onInfoClick);
            }
            if (this.view.clickMask) {
                this.view.clickMask.removeEventListener("click", this.onBoxClickHandler);
            }
        }
        
        private function changeAmountHandler(_arg_1: int): void {
            if (this.view.boxInfo.isOnSale()) {
                this.view.buyButton.price = _arg_1 * this.view.boxInfo.saleAmount;
            } else {
                this.view.buyButton.price = _arg_1 * this.view.boxInfo.priceAmount;
            }
        }
        
        private function onBuyHandler(_arg_1: BaseButton): void {
            var _local2: Boolean = BoxUtils.moneyCheckPass(this.view.boxInfo, this.view.spinner.value, this.gameModel, this.playerModel, this.showPopupSignal);
            if (_local2) {
                this.inProgressModal = new PurchaseInProgressModal();
                this.showPopupSignal.dispatch(this.inProgressModal);
                this.sendPurchaseRequest();
            }
        }
        
        private function sendPurchaseRequest(): void {
            var _local1: Object = this.account.getCredentials();
            _local1.isChallenger = this.seasonalEventModel.isChallenger;
            _local1.boxId = this.view.boxInfo.id;
            if (this.view.boxInfo.isOnSale()) {
                _local1.quantity = this.view.spinner.value;
                _local1.price = this.view.boxInfo.saleAmount;
                _local1.currency = this.view.boxInfo.saleCurrency;
            } else {
                _local1.quantity = this.view.spinner.value;
                _local1.price = this.view.boxInfo.priceAmount;
                _local1.currency = this.view.boxInfo.priceCurrency;
            }
            this.client.sendRequest("/account/purchasePackage", _local1);
            this.client.complete.addOnce(this.onRollRequestComplete);
        }
        
        private function onRollRequestComplete(_arg_1: Boolean, _arg_2: *): void {
            var _local7: * = null;
            var _local4: * = null;
            var _local10: * = null;
            var _local6: * = null;
            var _local5: int = 0;
            var _local9: * = null;
            var _local3: int = 0;
            var _local8: * = null;
            if (_arg_1) {
                _local7 = new XML(_arg_2);
                if (_local7.hasOwnProperty("CampaignProgress")) {
                    this.supportCampaignModel.parseUpdateData(_local7.CampaignProgress);
                }
                if (_local7.hasOwnProperty("Left") && this.view.boxInfo.unitsLeft != -1) {
                    this.view.boxInfo.unitsLeft = _local7.Left;
                }
                if (_local7.hasOwnProperty("PurchaseLeft") && this.view.boxInfo.purchaseLeft != -1) {
                    this.view.boxInfo.purchaseLeft = _local7.PurchaseLeft;
                }
                _local4 = this.gameModel.player;
                if (_local4 != null) {
                    if (_local7.hasOwnProperty("Gold")) {
                        _local4.setCredits(_local7.Gold);
                    } else if (_local7.hasOwnProperty("Fame")) {
                        _local4.setFame(_local7.Fame);
                    }
                } else if (this.playerModel != null) {
                    if (_local7.hasOwnProperty("Gold")) {
                        this.playerModel.setCredits(_local7.Gold);
                    } else if (_local7.hasOwnProperty("Fame")) {
                        this.playerModel.setFame(_local7.Fame);
                    }
                }
                this.closePopupSignal.dispatch(this.inProgressModal);
                this.showPopupSignal.dispatch(new PurchaseCompleteModal(PackageInfo(this.view.boxInfo).purchaseType));
            } else {
                _local10 = "MysteryBoxRollModal.pleaseTryAgainString";
                if (LineBuilder.getLocalizedStringFromKey(_arg_2) != "") {
                    _local10 = _arg_2;
                }
                if (_arg_2.indexOf("MysteryBoxError.soldOut") >= 0) {
                    _local6 = _arg_2.split("|");
                    if (_local6.length == 2) {
                        _local5 = _local6[1];
                        this.view.boxInfo.unitsLeft = _local5;
                        if (_local5 == 0) {
                            _local10 = "MysteryBoxError.soldOutAll";
                        } else {
                            _local10 = LineBuilder.getLocalizedStringFromKey("MysteryBoxError.soldOutLeft", {
                                "left": this.view.boxInfo.unitsLeft,
                                "box": (this.view.boxInfo.unitsLeft == 1 ? LineBuilder.getLocalizedStringFromKey("MysteryBoxError.box") : LineBuilder.getLocalizedStringFromKey("MysteryBoxError.boxes"))
                            });
                        }
                    }
                }
                if (_arg_2.indexOf("MysteryBoxError.maxPurchase") >= 0) {
                    _local9 = _arg_2.split("|");
                    if (_local9.length == 2) {
                        _local3 = _local9[1];
                        if (_local3 == 0) {
                            _local10 = "MysteryBoxError.maxPurchase";
                        } else {
                            _local10 = LineBuilder.getLocalizedStringFromKey("MysteryBoxError.maxPurchaseLeft", {"left": _local3});
                        }
                    }
                }
                if (_arg_2.indexOf("blockedForUser") >= 0) {
                    _local8 = _arg_2.split("|");
                    if (_local8.length == 2) {
                        _local10 = LineBuilder.getLocalizedStringFromKey("MysteryBoxError.blockedForUser", {"date": _local8[1]});
                    }
                }
                this.showErrorMessage(_local10);
            }
        }
        
        private function showErrorMessage(_arg_1: String): void {
            this.closePopupSignal.dispatch(this.inProgressModal);
            this.showPopupSignal.dispatch(new ErrorModal(5 * 60, LineBuilder.getLocalizedStringFromKey("MysteryBoxRollModal.purchaseFailedString", {}), LineBuilder.getLocalizedStringFromKey(_arg_1, {}).replace("box", "package")));
        }
        
        private function onInfoClick(_arg_1: BaseButton): void {
            this.showPopupSignal.dispatch(new PackageBoxContentPopup(PackageInfo(this.view.boxInfo)));
        }
        
        private function onBoxClickHandler(_arg_1: MouseEvent): void {
            this.onInfoClick(null);
        }
    }
}
