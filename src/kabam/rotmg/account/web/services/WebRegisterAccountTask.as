package kabam.rotmg.account.web.services {
    import kabam.lib.tasks.BaseTask;
    import kabam.rotmg.account.core.Account;
    import kabam.rotmg.account.core.services.RegisterAccountTask;
    import kabam.rotmg.account.web.model.AccountData;
    import kabam.rotmg.appengine.api.AppEngineClient;
    import kabam.rotmg.core.model.PlayerModel;
    
    public class WebRegisterAccountTask extends BaseTask implements RegisterAccountTask {
        
        
        public function WebRegisterAccountTask() {
            super();
        }
        
        [Inject]
        public var data: AccountData;
        [Inject]
        public var account: Account;
        [Inject]
        public var model: PlayerModel;
        [Inject]
        public var client: AppEngineClient;
        
        override protected function startTask(): void {
            this.client.complete.addOnce(this.onComplete);
            this.client.sendRequest("/account/register", this.makeDataPacket());
        }
        
        private function makeDataPacket(): Object {
            var _local1: * = {};
            _local1.guid = this.account.getUserId();
            _local1.newGUID = this.data.username;
            _local1.newPassword = this.data.password;
            _local1.name = this.data.name;
            _local1.entrytag = this.account.getEntryTag();
            _local1.signedUpKabamEmail = this.data.signedUpKabamEmail;
            _local1.isAgeVerified = 1;
            return _local1;
        }
        
        private function onComplete(_arg_1: Boolean, _arg_2: *): void {
            _arg_1 && this.onRegisterDone(_arg_2);
            completeTask(_arg_1, _arg_2);
        }
        
        private function onRegisterDone(_arg_1: String): void {
            this.model.setIsAgeVerified(true);
            if (this.data.name) {
                this.model.setName(this.data.name);
                this.model.isNameChosen = true;
            }
            var _local2: XML = new XML(_arg_1);
            if ("token" in _local2) {
                this.data.token = _local2.token;
                this.account.updateUser(this.data.username, this.data.password, _local2.token, "");
            } else {
                this.account.updateUser(this.data.username, this.data.password, "", "");
            }
        }
    }
}
