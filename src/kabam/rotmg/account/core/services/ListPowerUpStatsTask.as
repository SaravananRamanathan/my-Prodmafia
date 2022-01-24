package kabam.rotmg.account.core.services {
    import com.company.util.MoreObjectUtil;
    
    import kabam.lib.tasks.BaseTask;
    import kabam.rotmg.account.core.Account;
    import kabam.rotmg.appengine.api.AppEngineClient;
    
    public class ListPowerUpStatsTask extends BaseTask {
        
        public function ListPowerUpStatsTask() {
            super();
        }
        [Inject]
        public var account: Account;
        [Inject]
        public var client: AppEngineClient;
        private var requestData: Object;
        
        override protected function startTask(): void {
            this.requestData = this.makeRequestData();
            this.sendRequest();
        }
        
        public function makeRequestData(): Object {
            var requestData: * = {};
            MoreObjectUtil.addToObject(requestData, this.account.getCredentials());
            MoreObjectUtil.addToObject(requestData, this.account.getCredentials());
            requestData.game_net_user_id = this.account.gameNetworkUserId();
            requestData.game_net = this.account.gameNetwork();
            requestData.play_platform = this.account.playPlatform();
            return requestData;
        }
        
        private function sendRequest(): void {
            this.client.complete.addOnce(this.onComplete);
            this.client.sendRequest("/account/listPowerUpStats", this.requestData);
        }
        
        private function onComplete(result: Boolean, data: *): void {
            completeTask(true);
        }
    }
}
