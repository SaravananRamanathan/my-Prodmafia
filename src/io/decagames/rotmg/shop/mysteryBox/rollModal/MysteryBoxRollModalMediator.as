package io.decagames.rotmg.shop.mysteryBox.rollModal {
    import flash.events.TimerEvent;
    import flash.utils.Dictionary;
    import flash.utils.Timer;
    import flash.utils.clearTimeout;
    import flash.utils.setTimeout;
    
    import io.decagames.rotmg.seasonalEvent.data.SeasonalEventModel;
    import io.decagames.rotmg.shop.genericBox.BoxUtils;
    import io.decagames.rotmg.supportCampaign.data.SupporterCampaignModel;
    import io.decagames.rotmg.ui.buttons.BaseButton;
    import io.decagames.rotmg.ui.buttons.SliceScalingButton;
    import io.decagames.rotmg.ui.popups.modal.error.ErrorModal;
    import io.decagames.rotmg.ui.popups.signals.ClosePopupSignal;
    import io.decagames.rotmg.ui.popups.signals.ShowPopupSignal;
    import io.decagames.rotmg.ui.texture.TextureParser;
    import io.decagames.rotmg.utils.dictionary.DictionaryUtils;
    
    import kabam.rotmg.account.core.Account;
    import kabam.rotmg.appengine.api.AppEngineClient;
    import kabam.rotmg.core.model.PlayerModel;
    import kabam.rotmg.game.model.GameModel;
    import kabam.rotmg.mysterybox.services.GetMysteryBoxesTask;
    import kabam.rotmg.text.view.stringBuilder.LineBuilder;
    
    import robotlegs.bender.bundles.mvcs.Mediator;
    
    public class MysteryBoxRollModalMediator extends Mediator {
        
        
        public function MysteryBoxRollModalMediator() {
            swapImageTimer = new Timer(80);
            rewardsList = [];
            super();
        }
        
        [Inject]
        public var view: MysteryBoxRollModal;
        [Inject]
        public var client: AppEngineClient;
        [Inject]
        public var account: Account;
        [Inject]
        public var closePopupSignal: ClosePopupSignal;
        [Inject]
        public var gameModel: GameModel;
        [Inject]
        public var playerModel: PlayerModel;
        [Inject]
        public var showPopupSignal: ShowPopupSignal;
        [Inject]
        public var getMysteryBoxesTask: GetMysteryBoxesTask;
        [Inject]
        public var supportCampaignModel: SupporterCampaignModel;
        [Inject]
        public var seasonalEventModel: SeasonalEventModel;
        private var boxConfig: Array;
        private var swapImageTimer: Timer;
        private var totalRollDelay: int = 2000;
        private var nextRollDelay: int = 550;
        private var quantity: int = 1;
        private var requestComplete: Boolean;
        private var timerComplete: Boolean;
        private var rollNumber: int = 0;
        private var timeout: uint;
        private var rewardsList: Array;
        private var totalRewards: int = 0;
        private var closeButton: SliceScalingButton;
        private var totalRolls: int = 1;
        
        override public function initialize(): void {
            this.configureRoll();
            this.swapImageTimer.addEventListener("timer", this.swapItems);
            this.closeButton = new SliceScalingButton(TextureParser.instance.getSliceScalingBitmap("UI", "close_button"));
            this.closeButton.clickSignal.addOnce(this.onClose);
            this.view.header.addButton(this.closeButton, "right_button");
            this.boxConfig = this.parseBoxContents();
            this.quantity = this.view.quantity;
            this.playRollAnimation();
            this.sendRollRequest();
        }
        
        override public function destroy(): void {
            this.closeButton.clickSignal.remove(this.onClose);
            this.closeButton.dispose();
            this.swapImageTimer.removeEventListener("timer", this.swapItems);
            this.view.spinner.valueWasChanged.remove(this.changeAmountHandler);
            this.view.buyButton.clickSignal.remove(this.buyMore);
            this.view.finishedShowingResult.remove(this.onAnimationFinished);
        }
        
        private function sendRollRequest(): void {
            this.view.spinner.valueWasChanged.remove(this.changeAmountHandler);
            this.view.buyButton.clickSignal.remove(this.buyMore);
            this.closeButton.clickSignal.remove(this.onClose);
            this.requestComplete = false;
            this.timerComplete = false;
            var _local1: Object = this.account.getCredentials();
            _local1.isChallenger = this.seasonalEventModel.isChallenger;
            _local1.boxId = this.view.info.id;
            if (this.view.info.isOnSale()) {
                _local1.quantity = this.quantity;
                _local1.price = this.view.info.saleAmount;
                _local1.currency = this.view.info.saleCurrency;
            } else {
                _local1.quantity = this.quantity;
                _local1.price = this.view.info.priceAmount;
                _local1.currency = this.view.info.priceCurrency;
            }
            this.client.sendRequest("/account/purchaseMysteryBox", _local1);
            this.client.complete.addOnce(this.onRollRequestComplete);
            this.timeout = setTimeout(this.showRewards, this.totalRollDelay);
        }
        
        private function showRewards(): void {
            var _local1: * = null;
            this.timerComplete = true;
            clearTimeout(this.timeout);
            if (this.requestComplete) {
                this.view.finishedShowingResult.add(this.onAnimationFinished);
                this.view.bigSpinner.pause();
                this.view.littleSpinner.pause();
                this.swapImageTimer.stop();
                _local1 = this.rewardsList[this.rollNumber];
                if (this.rollNumber == 0) {
                    this.view.prepareResultGrid(this.totalRewards);
                }
                this.view.displayResult([_local1]);
            }
        }
        
        private function onRollRequestComplete(_arg_1: Boolean, _arg_2: *): void {
            var _local10: * = null;
            var _local12: * = null;
            var _local11: * = null;
            var _local9: * = null;
            var _local7: * = null;
            var _local3: * = null;
            var _local6: * = null;
            var _local5: int = 0;
            var _local13: * = null;
            var _local8: int = 0;
            var _local4: * = null;
            this.requestComplete = true;
            if (_arg_1) {
                _local10 = new XML(_arg_2);
                this.rewardsList = [];
                if (_local10.hasOwnProperty("CampaignProgress")) {
                    this.supportCampaignModel.parseUpdateData(_local10.CampaignProgress);
                }
                var _local15: int = 0;
                var _local14: * = _local10.elements("Awards");
                for each(_local12 in _local10.elements("Awards")) {
                    _local9 = _local12.toString().split(",");
                    _local7 = this.convertItemsToAmountDictionary(_local9);
                    this.totalRewards = this.totalRewards + DictionaryUtils.countKeys(_local7);
                    this.rewardsList.push(_local7);
                }
                if (_local10.hasOwnProperty("Left") && this.view.info.unitsLeft != -1) {
                    this.view.info.unitsLeft = _local10.Left;
                    if (this.view.info.unitsLeft == 0) {
                        this.view.buyButton.soldOut = true;
                    }
                }
                _local11 = this.gameModel.player;
                if (_local11 != null) {
                    if (_local10.hasOwnProperty("Gold")) {
                        _local11.setCredits(_local10.Gold);
                    } else if (_local10.hasOwnProperty("Fame")) {
                        _local11.setFame(_local10.Fame);
                    }
                } else if (this.playerModel != null) {
                    if (_local10.hasOwnProperty("Gold")) {
                        this.playerModel.setCredits(_local10.Gold);
                    } else if (_local10.hasOwnProperty("Fame")) {
                        this.playerModel.setFame(_local10.Fame);
                    }
                }
                if (_local10.hasOwnProperty("PurchaseLeft") && this.view.info.purchaseLeft != -1) {
                    this.view.info.purchaseLeft = _local10.PurchaseLeft;
                    if (this.view.info.purchaseLeft <= 0) {
                        this.view.buyButton.soldOut = true;
                    }
                }
                if (this.timerComplete) {
                    this.showRewards();
                }
            } else {
                clearTimeout(this.timeout);
                _local3 = "MysteryBoxRollModal.pleaseTryAgainString";
                if (LineBuilder.getLocalizedStringFromKey(_arg_2) != "") {
                    _local3 = _arg_2;
                }
                if (_arg_2.indexOf("MysteryBoxError.soldOut") >= 0) {
                    _local6 = _arg_2.split("|");
                    if (_local6.length == 2) {
                        _local5 = _local6[1];
                        this.view.info.unitsLeft = _local5;
                        if (_local5 == 0) {
                            _local3 = "MysteryBoxError.soldOutAll";
                        } else {
                            _local3 = LineBuilder.getLocalizedStringFromKey("MysteryBoxError.soldOutLeft", {
                                "left": this.view.info.unitsLeft,
                                "box": (this.view.info.unitsLeft == 1 ? LineBuilder.getLocalizedStringFromKey("MysteryBoxError.box") : LineBuilder.getLocalizedStringFromKey("MysteryBoxError.boxes"))
                            });
                        }
                    }
                }
                if (_arg_2.indexOf("MysteryBoxError.maxPurchase") >= 0) {
                    _local13 = _arg_2.split("|");
                    if (_local13.length == 2) {
                        _local8 = _local13[1];
                        if (_local8 == 0) {
                            _local3 = "MysteryBoxError.maxPurchase";
                        } else {
                            _local3 = LineBuilder.getLocalizedStringFromKey("MysteryBoxError.maxPurchaseLeft", {"left": _local8});
                        }
                    }
                }
                if (_arg_2.indexOf("blockedForUser") >= 0) {
                    _local4 = _arg_2.split("|");
                    if (_local4.length == 2) {
                        _local3 = LineBuilder.getLocalizedStringFromKey("MysteryBoxError.blockedForUser", {"date": _local4[1]});
                    }
                }
                this.showErrorMessage(_local3);
            }
        }
        
        private function showErrorMessage(_arg_1: String): void {
            this.closePopupSignal.dispatch(this.view);
            this.showPopupSignal.dispatch(new ErrorModal(5 * 60, LineBuilder.getLocalizedStringFromKey("MysteryBoxRollModal.purchaseFailedString", {}), LineBuilder.getLocalizedStringFromKey(_arg_1, {})));
            this.getMysteryBoxesTask.start();
        }
        
        private function configureRoll(): void {
            if (this.view.info.quantity > 1) {
                this.totalRollDelay = 1000;
            }
        }
        
        private function convertItemsToAmountDictionary(_arg_1: Array): Dictionary {
            var _local3: * = null;
            var _local2: Dictionary = new Dictionary();
            var _local8: int = 0;
            var _local7: * = _arg_1;
            for each(_local3 in _arg_1) {
                if (_local2[_local3]) {
                    var _local4: * = _local2;
                    var _local5: * = _local3;
                    var _local6: * = Number(_local4[_local5]) + 1;
                    _local4[_local5] = _local6;
                } else {
                    _local2[_local3] = 1;
                }
            }
            return _local2;
        }
        
        private function parseBoxContents(): Array {
            var _local1: int = 0;
            var _local3: * = null;
            var _local7: * = null;
            var _local5: * = null;
            var _local4: * = null;
            var _local6: Array = this.view.info.contents.split("|");
            var _local2: * = [];
            var _local11: int = 0;
            var _local10: * = _local6;
            for each(_local3 in _local6) {
                _local7 = [];
                _local5 = _local3.split(";");
                var _local9: int = 0;
                var _local8: * = _local5;
                for each(_local4 in _local5) {
                    _local7.push(this.convertItemsToAmountDictionary(_local4.split(",")));
                }
                _local2[_local1] = _local7;
                _local1++;
            }
            this.totalRolls = _local1;
            return _local2;
        }
        
        private function onAnimationFinished(): void {
            this.rollNumber++;
            if (this.rollNumber < this.view.quantity) {
                this.playRollAnimation();
                this.timeout = setTimeout(this.showRewards, this.view.totalAnimationTime(this.totalRolls) + this.nextRollDelay);
            } else {
                this.closeButton.clickSignal.addOnce(this.onClose);
                this.view.spinner.valueWasChanged.add(this.changeAmountHandler);
                this.view.spinner.value = this.view.quantity;
                this.view.showBuyButton();
                this.view.buyButton.clickSignal.add(this.buyMore);
            }
        }
        
        private function changeAmountHandler(_arg_1: int): void {
            if (this.view.info.isOnSale()) {
                this.view.buyButton.price = _arg_1 * this.view.info.saleAmount;
            } else {
                this.view.buyButton.price = _arg_1 * this.view.info.priceAmount;
            }
        }
        
        private function buyMore(_arg_1: BaseButton): void {
            var _local2: Boolean = BoxUtils.moneyCheckPass(this.view.info, this.view.spinner.value, this.gameModel, this.playerModel, this.showPopupSignal);
            if (_local2) {
                this.rollNumber = 0;
                this.totalRewards = 0;
                this.view.buyMore(this.view.spinner.value);
                this.configureRoll();
                this.quantity = this.view.quantity;
                this.playRollAnimation();
                this.sendRollRequest();
            }
        }
        
        private function playRollAnimation(): void {
            this.view.bigSpinner.resume();
            this.view.littleSpinner.resume();
            this.swapImageTimer.start();
            this.swapItems(null);
        }
        
        private function onClose(_arg_1: BaseButton): void {
            this.closePopupSignal.dispatch(this.view);
        }
        
        private function swapItems(_arg_1: TimerEvent): void {
            var _local3: int = 0;
            var _local4: * = null;
            var _local2: * = [];
            var _local6: int = 0;
            var _local5: * = this.boxConfig;
            for each(_local4 in this.boxConfig) {
                _local3 = Math.floor(Math.random() * _local4.length);
                _local2.push(_local4[_local3]);
            }
            this.view.displayItems(_local2);
        }
    }
}
