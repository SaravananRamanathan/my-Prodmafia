package kabam.rotmg.account.web.services {
    import com.company.assembleegameclient.parameters.Parameters;
    import com.company.assembleegameclient.util.PaymentMethod;
    import com.company.assembleegameclient.util.offer.Offer;
    import com.company.assembleegameclient.util.offer.Offers;
    
    import flash.net.URLRequest;
    import flash.net.navigateToURL;
    
    import kabam.lib.tasks.BaseTask;
    import kabam.rotmg.account.core.Account;
    import kabam.rotmg.account.core.model.OfferModel;
    import kabam.rotmg.account.core.services.PurchaseGoldTask;
    
    public class WebPurchaseGoldTask extends BaseTask implements PurchaseGoldTask {
        
        
        public function WebPurchaseGoldTask() {
            super();
        }
        
        [Inject]
        public var account: Account;
        [Inject]
        public var offer: Offer;
        [Inject]
        public var offersModel: OfferModel;
        [Inject]
        public var paymentMethod: String;
        
        override protected function startTask(): void {
            Parameters.data.paymentMethod = this.paymentMethod;
            Parameters.save();
            var _local3: Offers = this.offersModel.offers;
            var _local2: PaymentMethod = PaymentMethod.getPaymentMethodByLabel(this.paymentMethod);
            var _local1: String = _local2.getURL(_local3.tok, _local3.exp, this.offer);
            navigateToURL(new URLRequest(_local1), "_blank");
            completeTask(true);
        }
    }
}
