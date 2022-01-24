package kabam.rotmg.promotions.model {
import com.company.assembleegameclient.util.TimeUtil;
import com.company.assembleegameclient.util.offer.Offer;

import kabam.rotmg.account.core.Account;
import kabam.rotmg.account.core.model.OfferModel;
import kabam.rotmg.promotions.signals.PackageStatusUpdateSignal;

import org.osflash.signals.Signal;

public class BeginnersPackageModel {

    public static const STATUS_CANNOT_BUY:int = 0;

    public static const STATUS_CAN_BUY_SHOW_POP_UP:int = 1;

    public static const STATUS_CAN_BUY_DONT_SHOW_POP_UP:int = 2;

    private static const REALM_GOLD_FOR_BEGINNERS_PKG:int = 2600;

    private static const ONE_WEEK_IN_SECONDS:int = 604800;

    public function BeginnersPackageModel() {
        markedAsPurchased = new Signal();
        super();
    }
    [Inject]
    public var account:Account;
    [Inject]
    public var model:OfferModel;
    [Inject]
    public var packageStatusUpdateSignal:PackageStatusUpdateSignal;
    public var markedAsPurchased:Signal;
    private var beginnersOfferSecondsLeft:Number;
    private var beginnersOfferSetTimestamp:Number;

    private var _status:int;

    public function get status():int {
        return this._status;
    }

    public function set status(_arg_1:int):void {
        this._status = _arg_1;
        this.packageStatusUpdateSignal.dispatch();
    }

    public function isBeginnerAvailable():Boolean {
        return this._status == 1 || this._status == 2;
    }

    public function getBeginnersOfferSecondsLeft():Number {
        return this.beginnersOfferSecondsLeft - (this.getNowTimeSeconds() - this.beginnersOfferSetTimestamp);
    }

    public function getUserCreatedAt():Number {
        return this.getNowTimeSeconds() + this.getBeginnersOfferSecondsLeft() - 604800;
    }

    public function getDaysRemaining():Number {
        return Math.ceil(TimeUtil.secondsToDays(this.getBeginnersOfferSecondsLeft()));
    }

    public function getOffer():Offer {
        var _local1:* = null;
        if (!this.model.offers) {
            return null;
        }
        var _local3:int = 0;
        var _local2:* = this.model.offers.offerList;
        for each(_local1 in this.model.offers.offerList) {
            if (_local1.realmGold_ == 2600) {
                return _local1;
            }
        }
        return null;
    }

    public function markAsPurchased():void {
        this.markedAsPurchased.dispatch();
    }

    private function getNowTimeSeconds():Number {
        var _local1:Date = new Date();
        return Math.round(_local1.time * 0.001);
    }
}
}
