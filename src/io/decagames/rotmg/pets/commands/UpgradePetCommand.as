package io.decagames.rotmg.pets.commands {
    import io.decagames.rotmg.pets.data.vo.requests.FeedPetRequestVO;
    import io.decagames.rotmg.pets.data.vo.requests.FusePetRequestVO;
    import io.decagames.rotmg.pets.data.vo.requests.IUpgradePetRequestVO;
    import io.decagames.rotmg.pets.data.vo.requests.UpgradePetYardRequestVO;
    
    import kabam.lib.net.api.MessageProvider;
    import kabam.lib.net.impl.SocketServer;
    import kabam.rotmg.account.core.Account;
    import kabam.rotmg.account.core.view.RegisterPromptDialog;
    import kabam.rotmg.dialogs.control.OpenDialogSignal;
    import kabam.rotmg.messaging.impl.PetUpgradeRequest;
    
    import robotlegs.bender.bundles.mvcs.Command;
    
    public class UpgradePetCommand extends Command {
        
        private static const PET_YARD_REGISTER_STRING: String = "In order to upgradeYard your yard you must be a registered user.";
        
        public function UpgradePetCommand() {
            super();
        }
        
        [Inject]
        public var vo: IUpgradePetRequestVO;
        [Inject]
        public var messages: MessageProvider;
        [Inject]
        public var server: SocketServer;
        [Inject]
        public var account: Account;
        [Inject]
        public var openDialog: OpenDialogSignal;
        
        override public function execute(): void {
            var _local1: * = null;
            if (this.vo is UpgradePetYardRequestVO) {
                if (!this.account.isRegistered()) {
                    this.showPromptToRegister("In order to upgradeYard your yard you must be a registered user.");
                }
                _local1 = this.messages.require(16) as PetUpgradeRequest;
                _local1.petTransType = 1;
                _local1.objectId = UpgradePetYardRequestVO(this.vo).objectID;
                _local1.paymentTransType = UpgradePetYardRequestVO(this.vo).paymentTransType;
            }
            if (this.vo is FeedPetRequestVO) {
                _local1 = this.messages.require(16) as PetUpgradeRequest;
                _local1.petTransType = 2;
                _local1.PIDOne = FeedPetRequestVO(this.vo).petInstanceId;
                _local1.slotsObject = FeedPetRequestVO(this.vo).slotObjects;
                _local1.paymentTransType = FeedPetRequestVO(this.vo).paymentTransType;
            }
            if (this.vo is FusePetRequestVO) {
                _local1 = this.messages.require(16) as PetUpgradeRequest;
                _local1.petTransType = 3;
                _local1.PIDOne = FusePetRequestVO(this.vo).petInstanceIdOne;
                _local1.PIDTwo = FusePetRequestVO(this.vo).petInstanceIdTwo;
                _local1.paymentTransType = FusePetRequestVO(this.vo).paymentTransType;
            }
            if (_local1) {
                this.server.sendMessage(_local1);
            }
        }
        
        private function showPromptToRegister(_arg_1: String): void {
            this.openDialog.dispatch(new RegisterPromptDialog(_arg_1));
        }
    }
}
