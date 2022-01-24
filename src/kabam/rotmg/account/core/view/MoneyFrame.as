package kabam.rotmg.account.core.view {
import com.company.assembleegameclient.account.ui.Frame;
import com.company.assembleegameclient.account.ui.OfferRadioButtons;
import com.company.assembleegameclient.account.ui.PaymentMethodRadioButtons;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.ui.DeprecatedClickableText;
import com.company.assembleegameclient.ui.DeprecatedTextButton;
import com.company.assembleegameclient.util.PaymentMethod;
import com.company.assembleegameclient.util.offer.Offer;
import com.company.assembleegameclient.util.offer.Offers;

import flash.display.Shape;
import flash.display.Sprite;
import flash.events.MouseEvent;

import kabam.rotmg.account.core.model.MoneyConfig;

import org.osflash.signals.Signal;

public class MoneyFrame extends Sprite {

    private static const TITLE:String = "MoneyFrame.title";

    private static const TRACKING:String = "/money";

    private static const PAYMENT_SUBTITLE:String = "MoneyFrame.payment";

    private static const GOLD_SUBTITLE:String = "MoneyFrame.gold";

    private static const BUY_NOW:String = "MoneyFrame.buy";

    private static const WIDTH:int = 550;

    public function MoneyFrame() {
        super();
        this.buyNow = new Signal(Offer, String);
        this.cancel = new Signal();
    }
    public var buyNow:Signal;
    public var cancel:Signal;
    public var buyNowButton:DeprecatedTextButton;
    public var cancelButton:DeprecatedClickableText;
    private var offers:Offers;
    private var config:MoneyConfig;
    private var frame:Frame;
    private var paymentMethodButtons:PaymentMethodRadioButtons;
    private var offerButtons:OfferRadioButtons;

    public function initialize(_arg_1:Offers, _arg_2:MoneyConfig):void {
        this.offers = _arg_1;
        this.config = _arg_2;
        this.frame = new Frame("MoneyFrame.title", "", "", "/money", 550);
        _arg_2.showPaymentMethods() && this.addPaymentMethods();
        this.addOffers();
        this.addBuyNowButton();
        addChild(this.frame);
        this.addCancelButton("MoneyFrame.rightButton");
        this.cancelButton.addEventListener("click", this.onCancel);
    }

    public function addPaymentMethods():void {
        this.makePaymentMethodRadioButtons();
        this.frame.addTitle("MoneyFrame.payment");
        this.frame.addRadioBox(this.paymentMethodButtons);
        this.frame.addSpace(14);
        this.addLine(0x7f7f7f, 536, 2, 10);
        this.frame.addSpace(6);
    }

    public function addBuyNowButton():void {
        this.buyNowButton = new DeprecatedTextButton(16, "MoneyFrame.buy");
        this.buyNowButton.addEventListener("click", this.onBuyNowClick);
        this.buyNowButton.x = 8;
        this.buyNowButton.y = this.frame.h_ - 52;
        this.frame.addChild(this.buyNowButton);
    }

    public function addCancelButton(_arg_1:String):void {
        this.cancelButton = new DeprecatedClickableText(18, true, _arg_1);
        if (_arg_1 != "") {
            this.cancelButton.buttonMode = true;
            this.cancelButton.x = 400 + this.frame.w_ / 2 - this.cancelButton.width - 26;
            this.cancelButton.y = 5 * 60 + this.frame.h_ / 2 - 52;
            this.cancelButton.setAutoSize("right");
            addChild(this.cancelButton);
        }
    }

    public function disable():void {
        this.frame.disable();
        this.cancelButton.setDefaultColor(0xb3b3b3);
        this.cancelButton.mouseEnabled = false;
        this.cancelButton.mouseChildren = false;
    }

    public function enableOnlyCancel():void {
        this.cancelButton.removeOnHoverEvents();
        this.cancelButton.mouseEnabled = true;
        this.cancelButton.mouseChildren = true;
    }

    private function makePaymentMethodRadioButtons():void {
        var _local1:Vector.<String> = this.makePaymentMethodLabels();
        this.paymentMethodButtons = new PaymentMethodRadioButtons(_local1);
        this.paymentMethodButtons.setSelected(Parameters.data.paymentMethod);
    }

    private function makePaymentMethodLabels():Vector.<String> {
        var _local2:* = null;
        var _local1:Vector.<String> = new Vector.<String>();
        var _local4:int = 0;
        var _local3:* = PaymentMethod.PAYMENT_METHODS;
        for each(_local2 in PaymentMethod.PAYMENT_METHODS) {
            _local1.push(_local2.label_);
        }
        return _local1;
    }

    private function addLine(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:int):void {
        var _local5:Shape = new Shape();
        _local5.graphics.beginFill(_arg_1);
        _local5.graphics.drawRect(_arg_4, 0, _arg_2 - _arg_4 * 2, _arg_3);
        _local5.graphics.endFill();
        this.frame.addComponent(_local5, 0);
    }

    private function addOffers():void {
        this.offerButtons = new OfferRadioButtons(this.offers, this.config);
        this.offerButtons.showBonuses(this.config.showBonuses());
        this.frame.addTitle("MoneyFrame.gold");
        this.frame.addComponent(this.offerButtons);
    }

    protected function onBuyNowClick(_arg_1:MouseEvent):void {
        this.disable();
        var _local2:Offer = this.offerButtons.getChoice().offer;
        var _local3:String = !!this.paymentMethodButtons ? this.paymentMethodButtons.getSelected() : null;
        this.buyNow.dispatch(_local2, _local3 || false);
    }

    protected function onCancel(_arg_1:MouseEvent):void {
        stage.focus = stage;
        this.cancel.dispatch();
    }
}
}
