package com.company.assembleegameclient.util.offer {
public class Offers {

    private static const BEST_DEAL:String = "(Best deal)";

    private static const MOST_POPULAR:String = "(Most popular)";

    public function Offers(_arg_1:XML) {
        super();
        this.tok = _arg_1.Tok;
        this.exp = _arg_1.Exp;
        this.makeOffers(_arg_1);
    }
    public var tok:String;
    public var exp:String;
    public var offerList:Vector.<Offer>;

    private function makeOffers(_arg_1:XML):void {
        this.makeOfferList(_arg_1);
        this.sortOfferList();
        this.defineBonuses();
        this.defineMostPopularTagline();
        this.defineBestDealTagline();
    }

    private function makeOfferList(_arg_1:XML):void {
        var _local2:* = null;
        this.offerList = new Vector.<Offer>(0);
        var _local4:int = 0;
        var _local3:* = _arg_1.Offer;
        for each(_local2 in _arg_1.Offer) {
            this.offerList.push(this.makeOffer(_local2));
        }
    }

    private function makeOffer(_arg_1:XML):Offer {
        var _local2:String = _arg_1.Id;
        var _local6:Number = _arg_1.Price;
        var _local3:int = _arg_1.RealmGold;
        var _local7:String = _arg_1.CheckoutJWT;
        var _local5:String = _arg_1.Data;
        var _local4:String = "Currency" in _arg_1 ? _arg_1.Currency : null;
        return new Offer(_local2, _local6, _local3, _local7, _local5, _local4);
    }

    private function sortOfferList():void {
        this.offerList.sort(this.sortOffers);
    }

    private function defineBonuses():void {
        var _local8:int = 0;
        var _local5:int = 0;
        var _local4:Number = NaN;
        var _local7:Number = NaN;
        if (this.offerList.length == 0) {
            return;
        }
        var _local6:int = this.offerList[0].realmGold_;
        var _local2:int = this.offerList[0].price_;
        var _local1:Number = _local6 / _local2;
        var _local3:int = 1;
        while (_local3 < this.offerList.length) {
            _local8 = this.offerList[_local3].realmGold_;
            _local5 = this.offerList[_local3].price_;
            _local4 = _local5 * _local1;
            _local7 = _local8 - _local4;
            this.offerList[_local3].bonus = _local7 / _local5;
            _local3++;
        }
    }

    private function sortOffers(_arg_1:Offer, _arg_2:Offer):int {
        return _arg_1.price_ - _arg_2.price_;
    }

    private function defineMostPopularTagline():void {
        var _local1:* = null;
        var _local3:int = 0;
        var _local2:* = this.offerList;
        for each(_local1 in this.offerList) {
            if (_local1.price_ == 10) {
                _local1.tagline = "(Most popular)";
            }
        }
    }

    private function defineBestDealTagline():void {
        this.offerList[this.offerList.length - 1].tagline = "(Best deal)";
    }
}
}
