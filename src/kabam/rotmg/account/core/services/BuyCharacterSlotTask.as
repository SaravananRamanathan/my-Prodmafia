package kabam.rotmg.account.core.services {
import io.decagames.rotmg.seasonalEvent.data.SeasonalEventModel;

import kabam.lib.tasks.BaseTask;
import kabam.rotmg.account.core.Account;
import kabam.rotmg.appengine.api.AppEngineClient;
import kabam.rotmg.core.model.PlayerModel;
import kabam.rotmg.dialogs.control.OpenDialogSignal;

public class BuyCharacterSlotTask extends BaseTask {


    public function BuyCharacterSlotTask() {
        super();
    }
    [Inject]
    public var account:Account;
    [Inject]
    public var price:int;
    [Inject]
    public var client:AppEngineClient;
    [Inject]
    public var openDialog:OpenDialogSignal;
    [Inject]
    public var model:PlayerModel;
    [Inject]
    public var seasonalEventModel:SeasonalEventModel;

    override protected function startTask():void {
        var _local1:Object = this.account.getCredentials();
        _local1.isChallenger = this.seasonalEventModel.isChallenger;
        this.client.setMaxRetries(2);
        this.client.complete.addOnce(this.onComplete);
        this.client.sendRequest("/account/purchaseCharSlot", this.account.getCredentials());
        this.client.sendRequest("/account/purchaseCharSlot", _local1);
    }

    private function onComplete(_arg_1:Boolean, _arg_2:*):void {
        _arg_1 && this.updatePlayerData();
        completeTask(_arg_1, _arg_2);
    }

    private function updatePlayerData():void {
        this.model.setMaxCharacters(this.model.getMaxCharacters() + 1);
        this.model.changeCredits(-this.price);
    }
}
}
