package kabam.rotmg.account.core.services {
import com.company.assembleegameclient.objects.ObjectLibrary;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.screens.CharacterSelectionAndNewsScreen;
import com.company.util.MoreObjectUtil;

import flash.events.MouseEvent;
import flash.events.TimerEvent;
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

public class GetCharListTask extends BaseTask {

    private static const ONE_SECOND_IN_MS:int = 1000;

    private static const MAX_RETRIES:int = 7;

    public function GetCharListTask() {
        super();
    }
    [Inject]
    public var account:Account;
    [Inject]
    public var client:AppEngineClient;
    [Inject]
    public var model:PlayerModel;
    [Inject]
    public var seasonalEventModel:SeasonalEventModel;
    [Inject]
    public var setLoadingMessage:SetLoadingMessageSignal;
    [Inject]
    public var charListData:CharListDataSignal;
    [Inject]
    public var charListLoadedSignal:CharListLoadedSignal;
    [Inject]
    public var logger:ILogger;
    [Inject]
    public var openDialog:OpenDialogSignal;
    [Inject]
    public var closeDialogs:CloseDialogsSignal;
    [Inject]
    public var securityQuestionsModel:SecurityQuestionsModel;
    [Inject]
    public var setScreenWithValidData:SetScreenWithValidDataSignal;
    [Inject]
    public var closePopupSignal:ClosePopupSignal;
    [Inject]
    public var showPopupSignal:ShowPopupSignal;
    private var requestData:Object;
    private var retryTimer:Timer;
    private var numRetries:int = 0;
    private var fromMigration:Boolean = false;
    private var seasonalEventErrorPopUp:SeasonalEventErrorPopup;

    override protected function startTask():void {
        this.logger.info("GetUserDataTask start");
        this.requestData = this.makeRequestData();
        this.sendRequest();
        Parameters.sendLogin_ = false;
    }

    public function makeRequestData():Object {
        var _local1:* = {};
        _local1.game_net_user_id = this.account.gameNetworkUserId();
        _local1.game_net = this.account.gameNetwork();
        _local1.play_platform = this.account.playPlatform();
        _local1.do_login = Parameters.sendLogin_;
        _local1.challenger = this.seasonalEventModel.isChallenger == 1;
        MoreObjectUtil.addToObject(_local1, this.account.getCredentials());
        MoreObjectUtil.addToObject(_local1, {"muleDump": "true"});
        return _local1;
    }

    private function sendRequest():void {
        this.client.complete.addOnce(this.onComplete);
        this.client.sendRequest("/char/list", this.requestData);
    }

    private function onComplete(_arg_1:Boolean, _arg_2:*):void {
        if (_arg_2 && _arg_2 is String) {
            if (_arg_2.indexOf("rror>Internal Error") != -1 || _arg_2.indexOf("rror>Internal error") != -1) {
                if (Parameters.Cache_CHARLIST_valid && Parameters.data.cacheCharList) {
                    _arg_2 = Parameters.Cache_CHARLIST_data;
                    _arg_1 = true;
                } else {
                    Parameters.preload = true;
                }
            }
        }
        if (_arg_1) {
            this.onListComplete(_arg_2);
            Parameters.Cache_CHARLIST_valid = true;
            Parameters.Cache_CHARLIST_data = _arg_2;
        } else {
            this.onTextError(_arg_2);
        }
    }

    private function onListComplete(_arg_1:String):void {
        var _local5:Number = NaN;
        var _local4:* = null;
        var _local3:* = null;
        var _local2:XML = new XML(_arg_1);
        if ("MigrateStatus" in _local2) {
            _local5 = _local2.MigrateStatus;
            if (_local5 == 5) {
                this.sendRequest();
            }
            _local4 = new MigrationDialog(this.account, _local5);
            this.fromMigration = true;
            _local4.done.addOnce(this.sendRequest);
            _local4.cancel.addOnce(this.clearAccountAndReloadCharacters);
            this.openDialog.dispatch(_local4);
        } else {
            if ("Account" in _local2) {
                if (this.account is WebAccount) {
                    WebAccount(this.account).userDisplayName = _local2.Account[0].Name;
                    WebAccount(this.account).paymentProvider = _local2.Account[0].PaymentProvider;
                    if ("PaymentData" in _local2.Account[0]) {
                        WebAccount(this.account).paymentData = _local2.Account[0].PaymentData;
                    }
                }
                this.account.creationDate = new Date(_local2.Account[0].CreationTimestamp * 1000);
                if ("SecurityQuestions" in _local2.Account[0]) {
                    this.securityQuestionsModel.showSecurityQuestionsOnStartup = !Parameters.data.skipPopups && !Parameters.ignoringSecurityQuestions && _local2.Account[0].SecurityQuestions[0].ShowSecurityQuestionsDialog[0] == "1";
                    this.securityQuestionsModel.clearQuestionsList();
                    var _local7:int = 0;
                    var _local6:* = _local2.Account[0].SecurityQuestions[0].SecurityQuestionsKeys[0].SecurityQuestionsKey;
                    for each(_local3 in _local2.Account[0].SecurityQuestions[0].SecurityQuestionsKeys[0].SecurityQuestionsKey) {
                        this.securityQuestionsModel.addSecurityQuestion(_local3.toString());
                    }
                }
            }
            if (_local2 && this.seasonalEventModel.isChallenger == 1 && _local2.Account[0].hasOwnProperty("RemainingLives")) {
                this.seasonalEventModel.remainingCharacters = _local2.Account[0].RemainingLives;
            }
            this.charListData.dispatch(_local2);
            if (!this.model.isLogOutLogIn) {
                this.charListLoadedSignal.dispatch();
            }
            this.model.isLogOutLogIn = false;
            completeTask(true);
        }
        if (this.retryTimer != null) {
            this.stopRetryTimer();
        }
    }

    private function onTextError(_arg_1:String):void {
        var _local2:* = null;
        if (this.numRetries < 7) {
            this.setLoadingMessage.dispatch("Loading.text");
        } else {
            this.setLoadingMessage.dispatch("error.loadError");
        }
        if (_arg_1 == "Account credentials not valid") {
            if (this.fromMigration) {
                _local2 = new WebLoginDialog();
                _local2.setError("Error.invalidPassword");
                _local2.setEmail(this.account.getUserId());
                StaticInjectorContext.getInjector().getInstance(OpenDialogSignal).dispatch(_local2);
            }
            this.clearAccountAndReloadCharacters();
        } else if (_arg_1 == "Account is under maintenance") {
            this.setLoadingMessage.dispatch("This account has been banned");
            this.account.clear();
            Parameters.Cache_CHARLIST_valid = false;
        } else if (_arg_1 == "Account has fame lower than minimal for the season") {
            this.showSeasonalErrorPopUp(_arg_1);
        } else if (_arg_1 == "No more live left for the current season.") {
            this.showSeasonalErrorPopUp(_arg_1);
        } else {
            this.waitForASecondThenRetryRequest();
        }
    }

    private function showSeasonalErrorPopUp(_arg_1:String):void {
        this.seasonalEventErrorPopUp = new SeasonalEventErrorPopup(_arg_1);
        this.seasonalEventErrorPopUp.okButton.addEventListener("click", this.onSeasonalErrorPopUpClose);
        this.showPopupSignal.dispatch(this.seasonalEventErrorPopUp);
    }

    private function clearAccountAndReloadCharacters():void {
        this.logger.info("GetUserDataTask invalid credentials");
        this.account.clear();
        Parameters.Cache_CHARLIST_valid = false;
        this.client.complete.addOnce(this.onComplete);
        this.requestData = this.makeRequestData();
        this.client.sendRequest("/char/list", this.requestData);
    }

    private function waitForASecondThenRetryRequest():void {
        this.logger.info("GetUserDataTask error - retrying");
        this.retryTimer = new Timer(1000, 1);
        this.retryTimer.addEventListener("timerComplete", this.onRetryTimer);
        this.retryTimer.start();
    }

    private function stopRetryTimer():void {
        this.retryTimer.stop();
        this.retryTimer.removeEventListener("timerComplete", this.onRetryTimer);
        this.retryTimer = null;
    }

    private function onSeasonalErrorPopUpClose(_arg_1:MouseEvent):void {
        this.seasonalEventErrorPopUp.okButton.removeEventListener("click", this.onSeasonalErrorPopUpClose);
        var _local2:String = this.seasonalEventErrorPopUp.message;
        this.closePopupSignal.dispatch(this.seasonalEventErrorPopUp);
        this.seasonalEventModel.isChallenger = 0;
        ObjectLibrary.usePatchedData = false;
        if (_local2 == "Account has fame lower than minimal for the season" || _local2 == "No more live left for the current season.") {
            this.setScreenWithValidData.dispatch(new CharacterSelectionAndNewsScreen());
        }
    }

    private function onRetryTimer(_arg_1:TimerEvent):void {
        this.stopRetryTimer();
        if (this.numRetries < 7) {
            this.sendRequest();
            this.numRetries++;
        } else {
            this.clearAccountAndReloadCharacters();
            this.setLoadingMessage.dispatch("LoginError.tooManyFails");
        }
    }
}
}
