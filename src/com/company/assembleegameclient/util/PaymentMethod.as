package com.company.assembleegameclient.util {
import com.company.assembleegameclient.util.offer.Offer;

import flash.net.URLVariables;

import kabam.rotmg.account.core.Account;
import kabam.rotmg.application.api.ApplicationSetup;
import kabam.rotmg.core.StaticInjectorContext;

public class PaymentMethod {

    public static const GO_METHOD:PaymentMethod = new PaymentMethod("Payments.GoogleCheckout", "co", "");

    public static const PAYPAL_METHOD:PaymentMethod = new PaymentMethod("Payments.Paypal", "ps", "P3");

    public static const CREDITS_METHOD:PaymentMethod = new PaymentMethod("Payments.CreditCards", "ps", "CH");

    public static const PAYMENT_METHODS:Vector.<PaymentMethod> = new <PaymentMethod>[GO_METHOD, PAYPAL_METHOD, CREDITS_METHOD];

    public static function getPaymentMethodByLabel(_arg_1:String):PaymentMethod {
        var _local2:* = null;
        var _local4:int = 0;
        var _local3:* = PAYMENT_METHODS;
        for each(_local2 in PAYMENT_METHODS) {
            if (_local2.label_ == _arg_1) {
                return _local2;
            }
        }
        return null;
    }

    public function PaymentMethod(_arg_1:String, _arg_2:String, _arg_3:String) {
        super();
        this.label_ = _arg_1;
        this.provider_ = _arg_2;
        this.paymentid_ = _arg_3;
    }
    public var label_:String;
    public var provider_:String;
    public var paymentid_:String;

    public function getURL(_arg_1:String, _arg_2:String, _arg_3:Offer):String {
        var _local4:Account = StaticInjectorContext.getInjector().getInstance(Account);
        var _local6:ApplicationSetup = StaticInjectorContext.getInjector().getInstance(ApplicationSetup);
        var _local5:URLVariables = new URLVariables();
        _local5["tok"] = _arg_1;
        _local5["exp"] = _arg_2;
        _local5["guid"] = _local4.getUserId();
        _local5["provider"] = this.provider_;
        var _local7:* = this.provider_;
        switch (_local7) {
            case "co":
                _local5["jwt"] = _arg_3.jwt_;
                break;
            case "ps":
                _local5["jwt"] = _arg_3.jwt_;
                _local5["price"] = _arg_3.price_.toString();
                _local5["paymentid"] = this.paymentid_;
        }
        return _local6.getAppEngineUrl(true) + "/credits/add?" + _local5.toString();
    }
}
}
