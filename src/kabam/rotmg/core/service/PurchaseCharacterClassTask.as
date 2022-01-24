package kabam.rotmg.core.service {
import com.company.assembleegameclient.parameters.Parameters;
import com.company.util.MoreObjectUtil;

import kabam.lib.tasks.BaseTask;
import kabam.rotmg.account.core.Account;
import kabam.rotmg.appengine.api.AppEngineClient;
import kabam.rotmg.core.model.PlayerModel;

import robotlegs.bender.framework.api.ILogger;

public class PurchaseCharacterClassTask extends BaseTask {


    public function PurchaseCharacterClassTask() {
        super();
    }
    [Inject]
    public var classType:int;
    [Inject]
    public var account:Account;
    [Inject]
    public var client:AppEngineClient;
    [Inject]
    public var playerModel:PlayerModel;
    [Inject]
    public var logger:ILogger;

    override protected function startTask():void {
        this.logger.info("PurchaseCharacterClassTask.startTask: Started ");
        this.client.complete.addOnce(this.onComplete);
        this.client.sendRequest("/char/purchaseClassUnlock", this.makeRequestPacket());
    }

    public function makeRequestPacket():Object {
        var _local1:* = {};
        _local1.game_net_user_id = this.account.gameNetworkUserId();
        _local1.game_net = this.account.gameNetwork();
        _local1.play_platform = this.account.playPlatform();
        _local1.do_login = Parameters.sendLogin_;
        _local1.classType = this.classType;
        MoreObjectUtil.addToObject(_local1, this.account.getCredentials());
        return _local1;
    }

    private function onComplete(_arg_1:Boolean, _arg_2:*):void {
        this.logger.info("PurchaseCharacterClassTask.onComplete: Ended ");
        _arg_1 && this.onReceiveResponseFromClassPurchase();
        completeTask(_arg_1, _arg_2);
    }

    private function onReceiveResponseFromClassPurchase():void {
        this.playerModel.setClassAvailability(this.classType, "unrestricted");
        completeTask(true);
    }
}
}
