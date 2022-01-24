package io.decagames.rotmg.pets.data.vo.requests {
    public class UpgradePetYardRequestVO implements IUpgradePetRequestVO {
        
        
        public function UpgradePetYardRequestVO(_arg_1: int, _arg_2: int) {
            super();
            this.objectID = _arg_1;
            this.paymentTransType = _arg_2;
        }
        
        public var objectID: int;
        public var paymentTransType: int;
    }
}
