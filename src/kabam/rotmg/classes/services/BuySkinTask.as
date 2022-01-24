package kabam.rotmg.classes.services {
import com.company.assembleegameclient.ui.dialogs.ErrorDialog;

import io.decagames.rotmg.seasonalEvent.data.SeasonalEventModel;

import kabam.lib.tasks.BaseTask;
import kabam.rotmg.account.core.Account;
import kabam.rotmg.appengine.api.AppEngineClient;
import kabam.rotmg.classes.model.CharacterSkin;
import kabam.rotmg.classes.model.CharacterSkinState;
import kabam.rotmg.core.model.PlayerModel;
import kabam.rotmg.dialogs.control.OpenDialogSignal;

public class BuySkinTask extends BaseTask {


    public function BuySkinTask() {
        super();
    }
    [Inject]
    public var skin:CharacterSkin;
    [Inject]
    public var client:AppEngineClient;
    [Inject]
    public var account:Account;
    [Inject]
    public var player:PlayerModel;
    [Inject]
    public var seasonalEventModel:SeasonalEventModel;
    [Inject]
    public var openDialog:OpenDialogSignal;

    override protected function startTask():void {
        this.skin.setState(CharacterSkinState.PURCHASING);
        this.player.changeCredits(-this.skin.cost);
        this.client.complete.addOnce(this.onComplete);
        this.client.sendRequest("account/purchaseSkin", this.makeCredentials());
    }

    private function makeCredentials():Object {
        var _local1:Object = this.account.getCredentials();
        _local1.skinType = this.skin.id;
        _local1.isChallenger = this.seasonalEventModel.isChallenger;
        return _local1;
    }

    private function onComplete(_arg_1:Boolean, _arg_2:*):void {
        if (_arg_1) {
            this.completePurchase();
        } else {
            this.abandonPurchase(_arg_2);
        }
        completeTask(_arg_1, _arg_2);
    }

    private function completePurchase():void {
        this.skin.setState(CharacterSkinState.OWNED);
        this.skin.setIsSelected(true);
    }

    private function abandonPurchase(_arg_1:String):void {
        var _local2:ErrorDialog = new ErrorDialog(_arg_1);
        this.openDialog.dispatch(_local2);
        this.skin.setState(CharacterSkinState.PURCHASABLE);
        this.player.changeCredits(this.skin.cost);
    }
}
}
