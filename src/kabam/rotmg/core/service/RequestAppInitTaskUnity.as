package kabam.rotmg.core.service {
    import kabam.lib.tasks.BaseTask;
    import kabam.rotmg.account.core.Account;
    import kabam.rotmg.appengine.api.AppEngineClient;
    import kabam.rotmg.application.DynamicSettings;
    import kabam.rotmg.core.signals.AppInitDataReceivedSignal;
    
    import robotlegs.bender.framework.api.ILogger;
    
    public class RequestAppInitTaskUnity extends BaseTask {
        
        public function RequestAppInitTaskUnity() {
            super();
        }
        [Inject]
        public var logger: ILogger;
        [Inject]
        public var client: AppEngineClient;
        [Inject]
        public var account: Account;
        [Inject]
        public var appInitConfigData: AppInitDataReceivedSignal;
        
        override protected function startTask(): void {
            this.client.setMaxRetries(3);
            this.client.complete.addOnce(this.onComplete);
            var requestData: Object = {
                "guid": "",
                "game_net": "Unity",
                "play_platform": "Unity",
                "game_net_user_id": ""
            };
            if (this.account.getSecret() == "" || this.account.getSecret() == null) {
                requestData.password = "";
            } else {
                requestData.secret = "";
            }
            this.client.sendRequest("/app/init", requestData);
        }
        
        private function onComplete(param1: Boolean, param2: *): void {
            var _loc3_: XML = XML(param2);
            param1 && this.appInitConfigData.dispatch(_loc3_);
            this.initDynamicSettingsClass(_loc3_);
            completeTask(param1, param2);
        }
        
        private function initDynamicSettingsClass(settings: XML): void {
            if (settings != null) {
                DynamicSettings.xml = settings;
            }
        }
    }
}
