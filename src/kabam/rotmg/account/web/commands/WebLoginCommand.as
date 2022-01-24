package kabam.rotmg.account.web.commands {
import com.company.assembleegameclient.game.GameSprite;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.screens.CharacterSelectionAndNewsScreen;
import com.company.assembleegameclient.screens.CharacterTypeSelectionScreen;

import flash.display.Sprite;

import io.decagames.rotmg.seasonalEvent.data.SeasonalEventModel;

import kabam.lib.tasks.BranchingTask;
import kabam.lib.tasks.DispatchSignalTask;
import kabam.lib.tasks.TaskMonitor;
import kabam.lib.tasks.TaskSequence;
import kabam.rotmg.account.core.services.LoginTask;
import kabam.rotmg.account.core.signals.UpdateAccountInfoSignal;
import kabam.rotmg.account.web.model.AccountData;
import kabam.rotmg.core.model.ScreenModel;
import kabam.rotmg.core.service.TrackingData;
import kabam.rotmg.core.signals.InvalidateDataSignal;
import kabam.rotmg.core.signals.SetScreenWithValidDataSignal;
import kabam.rotmg.core.signals.TaskErrorSignal;
import kabam.rotmg.core.signals.TrackEventSignal;
import kabam.rotmg.dialogs.control.CloseDialogsSignal;
import kabam.rotmg.mysterybox.services.GetMysteryBoxesTask;
import kabam.rotmg.packages.services.GetPackagesTask;

public class WebLoginCommand {


    public function WebLoginCommand() {
        super();
    }
    [Inject]
    public var data:AccountData;
    [Inject]
    public var loginTask:LoginTask;
    [Inject]
    public var monitor:TaskMonitor;
    [Inject]
    public var closeDialogs:CloseDialogsSignal;
    [Inject]
    public var loginError:TaskErrorSignal;
    [Inject]
    public var updateLogin:UpdateAccountInfoSignal;
    [Inject]
    public var track:TrackEventSignal;
    [Inject]
    public var invalidate:InvalidateDataSignal;
    [Inject]
    public var setScreenWithValidData:SetScreenWithValidDataSignal;
    [Inject]
    public var screenModel:ScreenModel;
    [Inject]
    public var getPackageTask:GetPackagesTask;
    [Inject]
    public var mysteryBoxTask:GetMysteryBoxesTask;
    [Inject]
    public var seasonalEventModel:SeasonalEventModel;
    private var setScreenTask:DispatchSignalTask;

    public function execute():void {
        var _local1:BranchingTask = new BranchingTask(this.loginTask, this.makeSuccessTask(), this.makeFailureTask());
        this.monitor.add(_local1);
        _local1.start();
    }

    private function makeSuccessTask():TaskSequence {
        this.setScreenTask = new DispatchSignalTask(this.setScreenWithValidData, this.getTargetScreen());
        Parameters.Cache_CHARLIST_valid = false;
        var _local1:TaskSequence = new TaskSequence();
        _local1.add(new DispatchSignalTask(this.closeDialogs));
        _local1.add(new DispatchSignalTask(this.updateLogin));
        _local1.add(new DispatchSignalTask(this.invalidate));
        _local1.add(this.setScreenTask);
        return _local1;
    }

    private function makeFailureTask():TaskSequence {
        Parameters.Cache_CHARLIST_valid = false;
        var _local1:TaskSequence = new TaskSequence();
        _local1.add(new DispatchSignalTask(this.loginError, this.loginTask));
        return _local1;
    }

    private function getTargetScreen():Sprite {
        var _local1:Class = this.screenModel.getCurrentScreenType();
        if (_local1 == null || _local1 == GameSprite) {
            _local1 = !this.seasonalEventModel.isSeasonalMode ? CharacterSelectionAndNewsScreen : CharacterTypeSelectionScreen;
        }
        return new _local1();
    }

    private function getTrackingData():TrackingData {
        var _local1:TrackingData = new TrackingData();
        _local1.category = "account";
        _local1.action = "signedIn";
        return _local1;
    }
}
}
