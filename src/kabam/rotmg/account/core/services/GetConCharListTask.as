package kabam.rotmg.account.core.services {
    import com.company.assembleegameclient.parameters.Parameters;
    import com.company.assembleegameclient.screens.CharacterSelectionAndNewsScreen;
    import com.company.util.MoreObjectUtil;
    
    import flash.events.MouseEvent;
    import flash.utils.Timer;
    
    import io.decagames.rotmg.seasonalEvent.data.SeasonalEventModel;
    import io.decagames.rotmg.seasonalEvent.popups.SeasonalEventErrorPopup;
    import io.decagames.rotmg.ui.popups.signals.ClosePopupSignal;
    import io.decagames.rotmg.ui.popups.signals.ShowPopupSignal;
    
    import kabam.lib.tasks.BaseTask;
    import kabam.rotmg.account.core.Account;
    import kabam.rotmg.account.core.signals.CharListDataSignal;
    import kabam.rotmg.account.securityQuestions.data.SecurityQuestionsModel;
    import kabam.rotmg.account.web.WebAccount;
    import kabam.rotmg.account.web.view.MigrationDialog;
    import kabam.rotmg.account.web.view.WebLoginDialog;
    import kabam.rotmg.appengine.api.AppEngineClient;
    import kabam.rotmg.core.StaticInjectorContext;
    import kabam.rotmg.core.model.PlayerModel;
    import kabam.rotmg.core.signals.CharListLoadedSignal;
    import kabam.rotmg.core.signals.SetLoadingMessageSignal;
    import kabam.rotmg.core.signals.SetScreenWithValidDataSignal;
    import kabam.rotmg.dialogs.control.CloseDialogsSignal;
    import kabam.rotmg.dialogs.control.OpenDialogSignal;
    
    import robotlegs.bender.framework.api.ILogger;
    
    public class GetConCharListTask extends BaseTask {
        
        private static const ONE_SECOND_IN_MS: int = 1000;
        
        private static const MAX_RETRIES: int = 7;
        
        public function GetConCharListTask() {
            super();
        }
        [Inject]
        public var account: Account;
        [Inject]
        public var client: AppEngineClient;
        [Inject]
        public var model: PlayerModel;
        [Inject]
        public var seasonalEventModel: SeasonalEventModel;
        [Inject]
        public var setLoadingMessage: SetLoadingMessageSignal;
        [Inject]
        public var charListData: CharListDataSignal;
        [Inject]
        public var charListLoadedSignal: CharListLoadedSignal;
        [Inject]
        public var logger: ILogger;
        [Inject]
        public var openDialog: OpenDialogSignal;
        [Inject]
        public var closeDialogs: CloseDialogsSignal;
        [Inject]
        public var securityQuestionsModel: SecurityQuestionsModel;
        [Inject]
        public var setScreenWithValidData: SetScreenWithValidDataSignal;
        [Inject]
        public var closePopupSignal: ClosePopupSignal;
        [Inject]
        public var showPopupSignal: ShowPopupSignal;
        private var requestData: Object;
        private var retryTimer: Timer;
        private var numRetries: int = 0;
        private var fromMigration: Boolean = false;
        private var seasonalEventErrorPopUp: SeasonalEventErrorPopup;
        
        override protected function startTask(): void {
            this.requestData = this.makeRequestData();
            this.sendRequest();
        }
        
        public function makeRequestData(): Object {
            var _loc1_: * = {};
            MoreObjectUtil.addToObject(_loc1_, this.account.getCredentials());
            MoreObjectUtil.addToObject(_loc1_, this.account.getCredentials());
            _loc1_.game_net_user_id = this.account.gameNetworkUserId();
            _loc1_.game_net = this.account.gameNetwork();
            _loc1_.play_platform = this.account.playPlatform();
            return _loc1_;
        }
        
        private function sendRequest(): void {
            this.client.complete.addOnce(this.onComplete);
            this.client.sendRequest("/char/list", this.requestData);
        }
        
        private function onComplete(param1: Boolean, param2: *): void {
            if (param2 && param2 is String) {
                if (param2.indexOf("rror>Internal Error") != -1 || param2.indexOf("rror>Internal error") != -1) {
                    if (Parameters.Cache_CHARLIST_valid) {
                        param2 = Parameters.Cache_CHARLIST_data;
                        param1 = true;
                    } else {
                        Parameters.preload = true;
                    }
                }
            }
            if (param1) {
                this.onListComplete(param2);
                Parameters.Cache_CHARLIST_valid = true;
                Parameters.Cache_CHARLIST_data = param2;
            } else {
                this.onTextError(param2);
            }
        }
        
        private function onListComplete(param1: String): void {
            var _loc5_: int = 0;
            var _loc4_: * = undefined;
            var _loc7_: Number = NaN;
            var _loc6_: * = null;
            var _loc3_: * = null;
            var _loc2_: XML = new XML(param1);
            if ("MigrateStatus" in _loc2_) {
                _loc7_ = _loc2_.MigrateStatus;
                if (_loc7_ == 5) {
                    this.sendRequest();
                }
                _loc6_ = new MigrationDialog(this.account, _loc7_);
                this.fromMigration = true;
                _loc6_.done.addOnce(this.sendRequest);
                _loc6_.cancel.addOnce(this.clearAccountAndReloadCharacters);
                this.openDialog.dispatch(_loc6_);
            } else {
                if ("Account" in _loc2_) {
                    if (this.account is WebAccount) {
                        WebAccount(this.account).userDisplayName = _loc2_.Account[0].Name;
                        WebAccount(this.account).paymentProvider = _loc2_.Account[0].PaymentProvider;
                        if ("PaymentData" in _loc2_.Account[0]) {
                            WebAccount(this.account).paymentData = _loc2_.Account[0].PaymentData;
                        }
                    }
                    this.account.creationDate = new Date(_loc2_.Account[0].CreationTimestamp * 1000);
                    if ("SecurityQuestions" in _loc2_.Account[0]) {
                        this.securityQuestionsModel.showSecurityQuestionsOnStartup = !Parameters.data.skipPopups && !Parameters.ignoringSecurityQuestions && _loc2_.Account[0].SecurityQuestions[0].ShowSecurityQuestionsDialog[0] == "1";
                        this.securityQuestionsModel.clearQuestionsList();
                        _loc5_ = 0;
                        _loc4_ = _loc2_.Account[0].SecurityQuestions[0].SecurityQuestionsKeys[0].SecurityQuestionsKey;
                        var _loc9_: int = 0;
                        var _loc8_: * = _loc2_.Account[0].SecurityQuestions[0].SecurityQuestionsKeys[0].SecurityQuestionsKey;
                        for each(_loc3_ in _loc2_.Account[0].SecurityQuestions[0].SecurityQuestionsKeys[0].SecurityQuestionsKey) {
                            this.securityQuestionsModel.addSecurityQuestion(_loc3_.toString());
                        }
                    }
                }
                if (_loc2_ && this.seasonalEventModel.isChallenger == 1 && _loc2_.Account[0].hasOwnProperty("RemainingLives")) {
                    this.seasonalEventModel.remainingCharacters = _loc2_.Account[0].RemainingLives;
                }
                this.charListData.dispatch(_loc2_);
                if (!this.model.isLogOutLogIn) {
                    this.charListLoadedSignal.dispatch();
                }
                this.model.isLogOutLogIn = false;
                completeTask(true);
            }
        }
        
        private function onTextError(param1: String): void {
            var _loc2_: * = null;
            if (this.numRetries < 7) {
                this.setLoadingMessage.dispatch("Loading.text");
            } else {
                this.setLoadingMessage.dispatch("error.loadError");
            }
            if (param1 == "Account credentials not valid") {
                if (this.fromMigration) {
                    _loc2_ = new WebLoginDialog();
                    _loc2_.setError("Error.invalidPassword");
                    _loc2_.setEmail(this.account.getUserId());
                    StaticInjectorContext.getInjector().getInstance(OpenDialogSignal).dispatch(_loc2_);
                }
                this.clearAccountAndReloadCharacters();
            } else if (param1 == "Account is under maintenance") {
                this.setLoadingMessage.dispatch("This account has been banned");
                this.account.clear();
                Parameters.Cache_CHARLIST_valid = false;
            } else if (param1 == "Account has fame lower than minimal for the season") {
                this.showSeasonalErrorPopUp(param1);
            } else if (param1 == "No more live left for the current season.") {
                this.showSeasonalErrorPopUp(param1);
            }
        }
        
        private function showSeasonalErrorPopUp(param1: String): void {
            this.seasonalEventErrorPopUp = new SeasonalEventErrorPopup(param1);
            this.seasonalEventErrorPopUp.okButton.addEventListener("click", this.onSeasonalErrorPopUpClose);
            this.showPopupSignal.dispatch(this.seasonalEventErrorPopUp);
        }
        
        private function clearAccountAndReloadCharacters(): void {
            this.logger.info("GetUserDataTask invalid credentials");
            this.account.clear();
            Parameters.Cache_CHARLIST_valid = false;
            this.client.complete.addOnce(this.onComplete);
            this.requestData = this.makeRequestData();
            this.client.sendRequest("/char/list", this.requestData);
        }
        
        private function onSeasonalErrorPopUpClose(param1: MouseEvent): void {
            this.seasonalEventErrorPopUp.okButton.removeEventListener("click", this.onSeasonalErrorPopUpClose);
            var _loc2_: String = this.seasonalEventErrorPopUp.message;
            this.closePopupSignal.dispatch(this.seasonalEventErrorPopUp);
            this.seasonalEventModel.isChallenger = 0;
            if (_loc2_ == "Account has fame lower than minimal for the season" || _loc2_ == "No more live left for the current season.") {
                this.setScreenWithValidData.dispatch(new CharacterSelectionAndNewsScreen());
            }
        }
    }
}
