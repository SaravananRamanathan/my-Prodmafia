package kabam.rotmg.account.web.services {
    import kabam.lib.tasks.BaseTask;
    import kabam.rotmg.account.core.Account;
    import kabam.rotmg.account.core.services.LoginTask;
    import kabam.rotmg.account.web.model.AccountData;
    import kabam.rotmg.appengine.api.AppEngineClient;
    
    public class WebLoginTask extends BaseTask implements LoginTask {
        
        
        public function WebLoginTask() {
            super();
        }
        
        [Inject]
        public var account: Account;
        [Inject]
        public var data: AccountData;
        [Inject]
        public var client: AppEngineClient;
        
        override protected function startTask(): void {
            this.client.complete.addOnce(this.onComplete);
            if (this.data.secret != "") {
                this.client.sendRequest("/account/verify", {
                    "game_net": "Unity",
                    "play_platform": "Unity",
                    "game_net_user_id": "",
                    "guid": this.data.username,
                    "secret": this.data.secret
                });
            } else {
                this.client.sendRequest("/account/verify", {
                    "game_net": "Unity",
                    "play_platform": "Unity",
                    "game_net_user_id": "",
                    "guid": this.data.username,
                    "password": this.data.password
                });
            }
        }
        
        private function onComplete(result: Boolean, _arg_2: *): void {
            if (result) {
                this.updateUser(_arg_2);
            }
            completeTask(result, _arg_2);
        }
        
        private function updateUser(username: String): void {
            this.account.updateUser(this.data.username, this.data.password, "", this.data.secret);
        }
    }
}
