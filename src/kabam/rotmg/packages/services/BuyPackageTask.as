package kabam.rotmg.packages.services {
import com.company.assembleegameclient.map.QueueStatusTextSignal;

import kabam.lib.tasks.BaseTask;
import kabam.rotmg.account.core.Account;
import kabam.rotmg.appengine.api.AppEngineClient;
import kabam.rotmg.core.model.PlayerModel;
import kabam.rotmg.packages.control.BuyPackageSuccessfulSignal;
import kabam.rotmg.packages.model.PackageInfo;

public class BuyPackageTask extends BaseTask {

    private static const ERROR_MESSAGES_THAT_REFRESH:Array = ["Package is not Available", "Package is not Available Right Now", "Invalid PackageId"];

    public function BuyPackageTask() {
        super();
    }
    [Inject]
    public var client:AppEngineClient;
    [Inject]
    public var account:Account;
    [Inject]
    public var getPackageTask:GetPackagesTask;
    [Inject]
    public var playerModel:PlayerModel;
    [Inject]
    public var queueStatusText:QueueStatusTextSignal;
    [Inject]
    public var packageInfo:PackageInfo;
    [Inject]
    public var buyPackageSuccessful:BuyPackageSuccessfulSignal;

    override protected function startTask():void {
        var _local1:Object = this.account.getCredentials();
        this.client.complete.addOnce(this.onComplete);
        this.client.sendRequest("/account/purchasePackage", _local1);
    }

    private function onComplete(_arg_1:Boolean, _arg_2:*):void {
        var _local3:XML = new XML(_arg_2);
        if (_arg_1) {
            this.completePurchase(_local3);
        } else {
            this.abandonPurchase(_local3);
        }
        completeTask(true, _arg_2);
    }

    private function completePurchase(_arg_1:XML):void {
        this.queueStatusText.dispatch("BuyPackageTask.newGifts", 11495650);
        this.buyPackageSuccessful.dispatch();
    }

    private function abandonPurchase(_arg_1:XML):void {
        this.reportFailureAndRefreshPackages(_arg_1[0]);
    }

    private function reportFailureAndRefreshPackages(_arg_1:String):void {
        this.queueStatusText.dispatch(_arg_1, 0xff8080);
        if (ERROR_MESSAGES_THAT_REFRESH.indexOf(_arg_1) != -1) {
            this.getPackageTask.start();
        }
    }
}
}
