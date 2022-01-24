package kabam.rotmg.ui.view {
import com.company.assembleegameclient.account.ui.NewChooseNameFrame;
import com.company.assembleegameclient.appengine.SavedCharacter;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.screens.CharacterSelectionAndNewsScreen;
import com.company.assembleegameclient.screens.NewCharacterScreen;
import com.company.assembleegameclient.screens.ServersScreen;
import com.company.util.MoreDateUtil;

import flash.events.MouseEvent;

import io.decagames.rotmg.seasonalEvent.data.SeasonalEventModel;
import io.decagames.rotmg.seasonalEvent.popups.SeasonalEventComingPopup;
import io.decagames.rotmg.seasonalEvent.popups.SeasonalEventErrorPopup;
import io.decagames.rotmg.seasonalEvent.signals.ShowSeasonComingPopupSignal;
import io.decagames.rotmg.ui.popups.signals.ClosePopupSignal;
import io.decagames.rotmg.ui.popups.signals.ShowPopupSignal;

import kabam.rotmg.account.securityQuestions.data.SecurityQuestionsModel;
import kabam.rotmg.account.securityQuestions.view.SecurityQuestionsInfoDialog;
import kabam.rotmg.classes.model.CharacterClass;
import kabam.rotmg.classes.model.ClassesModel;
import kabam.rotmg.core.model.PlayerModel;
import kabam.rotmg.core.service.TrackingData;
import kabam.rotmg.core.signals.SetScreenSignal;
import kabam.rotmg.core.signals.SetScreenWithValidDataSignal;
import kabam.rotmg.core.signals.TrackEventSignal;
import kabam.rotmg.core.signals.TrackPageViewSignal;
import kabam.rotmg.dialogs.control.AddPopupToStartupQueueSignal;
import kabam.rotmg.dialogs.control.FlushPopupStartupQueueSignal;
import kabam.rotmg.dialogs.control.OpenDialogSignal;
import kabam.rotmg.game.model.GameInitData;
import kabam.rotmg.game.signals.PlayGameSignal;
import kabam.rotmg.packages.control.InitPackagesSignal;
import kabam.rotmg.ui.signals.NameChangedSignal;

import robotlegs.bender.bundles.mvcs.Mediator;

public class CurrentCharacterMediator extends Mediator {


    private const DAY_IN_MILLISECONDS:int = 86400000;

    private const MINUTES_IN_MILLISECONDS:int = 60000;

    public function CurrentCharacterMediator() {
        super();
    }
    [Inject]
    public var view:CharacterSelectionAndNewsScreen;
    [Inject]
    public var playerModel:PlayerModel;
    [Inject]
    public var classesModel:ClassesModel;
    [Inject]
    public var track:TrackEventSignal;
    [Inject]
    public var setScreen:SetScreenSignal;
    [Inject]
    public var setScreenWithValidData:SetScreenWithValidDataSignal;
    [Inject]
    public var playGame:PlayGameSignal;
    [Inject]
    public var nameChanged:NameChangedSignal;
    [Inject]
    public var trackPage:TrackPageViewSignal;
    [Inject]
    public var initPackages:InitPackagesSignal;
    [Inject]
    public var openDialog:OpenDialogSignal;
    [Inject]
    public var securityQuestionsModel:SecurityQuestionsModel;
    [Inject]
    public var seasonalEventModel:SeasonalEventModel;
    [Inject]
    public var showPopupSignal:ShowPopupSignal;
    [Inject]
    public var closePopupSignal:ClosePopupSignal;
    [Inject]
    public var addToQueueSignal:AddPopupToStartupQueueSignal;
    [Inject]
    public var flushQueueSignal:FlushPopupStartupQueueSignal;
    [Inject]
    public var showSeasonComingPopupSignal:ShowSeasonComingPopupSignal;
    private var seasonalEventErrorPopUp:SeasonalEventErrorPopup;

    override public function initialize():void {
        var _local1:Number = NaN;
        var _local2:Number = NaN;
        this.trackSomething();
        this.view.initialize(this.playerModel);
        this.view.close.add(this.onClose);
        this.view.newCharacter.add(this.onNewCharacter);
        this.view.showClasses.add(this.onNewCharacter);
        this.view.playGame.add(this.onPlayGame);
        this.view.serversClicked.add(this.showServersScreen);
        this.view.chooseName.add(this.onChooseName);
        this.trackPage.dispatch("/currentCharScreen");
        this.nameChanged.add(this.onNameChanged);
        this.initPackages.dispatch();
        if (this.securityQuestionsModel.showSecurityQuestionsOnStartup) {
            this.openDialog.dispatch(new SecurityQuestionsInfoDialog());
        }
        if (this.seasonalEventModel.scheduledSeasonalEvent) {
            if (Parameters.data["challenger_info_popup"]) {
                _local1 = Parameters.data["challenger_info_popup"];
                _local2 = new Date().time;
                if (_local2 - (_local1 + 24 * 60 * 60 * 1000) > 0) {
                    this.showSeasonsComingPopup();
                    Parameters.data["challenger_info_popup"] = _local2;
                }
            } else {
                this.showSeasonsComingPopup();
                Parameters.data["challenger_info_popup"] = new Date().time;
            }
        }
    }

    override public function destroy():void {
        this.nameChanged.remove(this.onNameChanged);
        this.view.close.remove(this.onClose);
        this.view.newCharacter.remove(this.onNewCharacter);
        this.view.showClasses.remove(this.onNewCharacter);
        this.view.playGame.remove(this.onPlayGame);
        this.view.chooseName.remove(this.onChooseName);
    }

    private function onChooseName() : void {
        this.openDialog.dispatch(new NewChooseNameFrame());
    }

    private function onNameChanged(_arg_1:String):void {
        this.view.setName(_arg_1);
    }

    private function showSeasonsComingPopup():void {
        this.showPopupSignal.dispatch(new SeasonalEventComingPopup(this.seasonalEventModel.scheduledSeasonalEvent));
    }

    private function showServersScreen():void {
        this.setScreen.dispatch(new ServersScreen(this.seasonalEventModel.isChallenger == 1));
    }

    private function trackSomething():void {
        var _local2:* = null;
        var _local1:String = MoreDateUtil.getDayStringInPT();
        if (Parameters.data.lastDailyAnalytics != _local1) {
            _local2 = new TrackingData();
            _local2.category = "joinDate";
            _local2.action = Parameters.data.joinDate;
            this.track.dispatch(_local2);
            Parameters.data.lastDailyAnalytics = _local1;
            Parameters.save();
        }
    }

    private function onNewCharacter():void {
        if (this.seasonalEventModel.isChallenger && this.seasonalEventModel.remainingCharacters == 0) {
            this.showSeasonalErrorPopUp("You cannot create more characters");
        } else {
            this.setScreen.dispatch(new NewCharacterScreen());
        }
    }

    private function showSeasonalErrorPopUp(_arg_1:String):void {
        this.seasonalEventErrorPopUp = new SeasonalEventErrorPopup(_arg_1);
        this.seasonalEventErrorPopUp.okButton.addEventListener("click", this.onSeasonalErrorPopUpClose);
        this.showPopupSignal.dispatch(this.seasonalEventErrorPopUp);
    }

    private function onClose():void {
        this.seasonalEventModel.isChallenger = 0;
        this.playerModel.isInvalidated = true;
        this.playerModel.isLogOutLogIn = true;
        this.setScreenWithValidData.dispatch(new TitleView());
    }

    private function onPlayGame():void {
        var _local4:SavedCharacter = this.playerModel.getCharacterByIndex(0);
        this.playerModel.currentCharId = _local4.charId();
        var _local2:CharacterClass = this.classesModel.getCharacterClass(_local4.objectType());
        _local2.setIsSelected(true);
        _local2.skins.getSkin(_local4.skinType()).setIsSelected(true);
        var _local1:TrackingData = new TrackingData();
        _local1.category = "character";
        _local1.action = "select";
        _local1.label = _local4.displayId();
        _local1.value = _local4.level();
        this.track.dispatch(_local1);
        var _local3:GameInitData = new GameInitData();
        _local3.createCharacter = false;
        _local3.charId = _local4.charId();
        _local3.isNewGame = true;
        this.playGame.dispatch(_local3);
    }

    private function onSeasonalErrorPopUpClose(_arg_1:MouseEvent):void {
        this.seasonalEventErrorPopUp.okButton.removeEventListener("click", this.onSeasonalErrorPopUpClose);
        this.closePopupSignal.dispatch(this.seasonalEventErrorPopUp);
    }
}
}
