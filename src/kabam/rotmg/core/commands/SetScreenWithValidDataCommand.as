package kabam.rotmg.core.commands {
import com.company.assembleegameclient.screens.LoadingScreen;

import flash.display.Sprite;

import io.decagames.rotmg.pets.tasks.GetOwnedPetSkinsTask;
import io.decagames.rotmg.seasonalEvent.data.SeasonalEventModel;
import io.decagames.rotmg.seasonalEvent.tasks.GetLegacySeasonsTask;
import io.decagames.rotmg.seasonalEvent.tasks.GetSeasonalEventTask;
import io.decagames.rotmg.supportCampaign.tasks.GetCampaignStatusTask;

import kabam.lib.tasks.DispatchSignalTask;
import kabam.lib.tasks.TaskMonitor;
import kabam.lib.tasks.TaskSequence;
import kabam.rotmg.account.core.services.GetCharListTask;
import kabam.rotmg.account.core.services.GetIgnoreListTask;
import kabam.rotmg.account.core.services.GetLockListTask;
import kabam.rotmg.core.model.PlayerModel;
import kabam.rotmg.core.signals.SetScreenSignal;
import kabam.rotmg.dailyLogin.tasks.FetchPlayerCalendarTask;

public class SetScreenWithValidDataCommand {


    public function SetScreenWithValidDataCommand() {
        super();
    }
    [Inject]
    public var model:PlayerModel;
    [Inject]
    public var setScreen:SetScreenSignal;
    [Inject]
    public var view:Sprite;
    [Inject]
    public var monitor:TaskMonitor;
    [Inject]
    public var task:GetCharListTask;
    [Inject]
    public var calendarTask:FetchPlayerCalendarTask;
    [Inject]
    public var campaignStatusTask:GetCampaignStatusTask;
    [Inject]
    public var petSkinsTask:GetOwnedPetSkinsTask;
    [Inject]
    public var getSeasonalEventTask:GetSeasonalEventTask;
    [Inject]
    public var getLegacySeasonsTask:GetLegacySeasonsTask;
    [Inject]
    public var seasonalEventModel:SeasonalEventModel;
    [Inject]
    public var getLockListTask:GetLockListTask;
    [Inject]
    public var getIgnoreListTask:GetIgnoreListTask;

    public function execute():void {
        if (this.model.isInvalidated) {
            this.reloadDataThenSetScreen();
        } else {
            this.setScreen.dispatch(this.view);
        }
    }

    private function reloadDataThenSetScreen():void {
        this.setScreen.dispatch(new LoadingScreen());
        var _local1:TaskSequence = new TaskSequence();
        _local1.add(this.task);
        _local1.add(this.calendarTask);
        _local1.add(this.petSkinsTask);
        _local1.add(this.campaignStatusTask);
        _local1.add(getLockListTask);
        _local1.add(getIgnoreListTask);
        if (this.seasonalEventModel.isChallenger != 1) {
            _local1.add(this.getSeasonalEventTask);
        }
        _local1.add(this.getLegacySeasonsTask);
        _local1.add(new DispatchSignalTask(this.setScreen, this.view));
        this.monitor.add(_local1);
        _local1.start();
    }
}
}
