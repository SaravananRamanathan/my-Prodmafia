package kabam.rotmg.packages.services {
import com.company.assembleegameclient.util.TimeUtil;

import kabam.lib.tasks.BaseTask;
import kabam.rotmg.account.core.Account;
import kabam.rotmg.appengine.api.AppEngineClient;
import kabam.rotmg.language.model.LanguageModel;
import kabam.rotmg.packages.model.PackageInfo;

import robotlegs.bender.framework.api.ILogger;

public class GetPackagesTask extends BaseTask {

    private static var version:String = "0";

    public function GetPackagesTask() {
        super();
    }
    [Inject]
    public var client:AppEngineClient;
    [Inject]
    public var packageModel:PackageModel;
    [Inject]
    public var account:Account;
    [Inject]
    public var logger:ILogger;
    [Inject]
    public var languageModel:LanguageModel;

    override protected function startTask():void {
        var _local1:Object = this.account.getCredentials();
        _local1.language = this.languageModel.getLanguage();
        _local1.version = version;
        this.client.sendRequest("/package/getPackages", _local1);
        this.client.complete.addOnce(this.onComplete);
    }

    private function onComplete(_arg_1:Boolean, _arg_2:*):void {
        if (_arg_1) {
            this.handleOkay(_arg_2);
        } else {
            this.logger.warn("GetPackageTask.onComplete: Request failed.");
            completeTask(true);
        }
        reset();
    }

    private function handleOkay(_arg_1:*):void {
        version = XML(_arg_1).attribute("version").toString();
        var _local2:XMLList = XML(_arg_1).child("Package");
        var _local3:XMLList = XML(_arg_1).child("SoldCounter");
        if (_local3.length() > 0) {
            this.updateSoldCounters(_local3);
        }
        if (_local2.length() > 0) {
            this.parse(_local2);
        } else if (this.packageModel.getInitialized()) {
            this.packageModel.updateSignal.dispatch();
        }
        completeTask(true);
    }

    private function updateSoldCounters(_arg_1:XMLList):void {
        var _local2:* = null;
        var _local3:* = null;
        var _local5:int = 0;
        var _local4:* = _arg_1;
        for each(_local2 in _arg_1) {
            _local3 = this.packageModel.getPackageById(_local2.attribute("id").toString());
            if (_local3 != null) {
                if (_local2.attribute("left") != "-1") {
                    _local3.unitsLeft = _local2.attribute("left");
                }
                if (_local2.attribute("purchaseLeft") != "-1") {
                    _local3.purchaseLeft = _local2.attribute("purchaseLeft");
                }
            }
        }
    }

    private function hasNoPackage(_arg_1:*):Boolean {
        var _local2:XMLList = XML(_arg_1).children();
        return _local2.length() == 0;
    }

    private function parse(_arg_1:XMLList):void {
        var _local4:* = null;
        var _local3:* = null;
        var _local2:* = [];
        var _local6:int = 0;
        var _local5:* = _arg_1;
        for each(_local4 in _arg_1) {
            _local3 = new PackageInfo();
            _local3.id = _local4.attribute("id").toString();
            _local3.title = _local4.attribute("title").toString();
            _local3.weight = _local4.attribute("weight").toString();
            _local3.description = _local4.Description.toString();
            _local3.contents = _local4.Contents.toString();
            _local3.priceAmount = _local4.Price.attribute("amount").toString();
            _local3.priceCurrency = _local4.Price.attribute("currency").toString();
            if (_local4.hasOwnProperty("Sale")) {
                _local3.saleAmount = _local4.Sale.attribute("price").toString();
                _local3.saleCurrency = _local4.Sale.attribute("currency").toString();
            }
            if (_local4.hasOwnProperty("Left")) {
                _local3.unitsLeft = _local4.Left;
            }
            if (_local4.hasOwnProperty("MaxPurchase")) {
                _local3.maxPurchase = _local4.MaxPurchase;
            }
            if (_local4.hasOwnProperty("PurchaseLeft")) {
                _local3.purchaseLeft = _local4.PurchaseLeft;
            }
            if (_local4.hasOwnProperty("ShowOnLogin")) {
                _local3.showOnLogin = _local4.ShowOnLogin == 1;
            }
            if (_local4.hasOwnProperty("Total")) {
                _local3.totalUnits = _local4.Total;
            }
            if (_local4.hasOwnProperty("Slot")) {
                _local3.slot = _local4.Slot;
            }
            if (_local4.hasOwnProperty("Tags")) {
                _local3.tags = _local4.Tags;
            }
            if (_local4.StartTime.toString()) {
                _local3.startTime = TimeUtil.parseUTCDate(_local4.StartTime.toString());
            }
            _local3.startTime = TimeUtil.parseUTCDate(_local4.StartTime.toString());
            if (_local4.EndTime.toString()) {
                _local3.endTime = TimeUtil.parseUTCDate(_local4.EndTime.toString());
            }
            _local3.image = _local4.Image.toString();
            _local3.charSlot = _local4.CharSlot.toString();
            _local3.vaultSlot = _local4.VaultSlot.toString();
            _local3.gold = _local4.Gold.toString();
            if (_local4.PopupImage.toString() != "") {
                _local3.popupImage = _local4.PopupImage.toString();
            }
            _local2.push(_local3);
        }
        this.packageModel.setPackages(_local2);
    }
}
}
