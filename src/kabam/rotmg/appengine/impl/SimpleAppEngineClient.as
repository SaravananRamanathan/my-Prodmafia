package kabam.rotmg.appengine.impl {
    import kabam.rotmg.account.core.Account;
    import kabam.rotmg.appengine.api.AppEngineClient;
    import kabam.rotmg.appengine.api.RetryLoader;
    import kabam.rotmg.application.api.ApplicationSetup;
    
    import org.osflash.signals.OnceSignal;
    
    public class SimpleAppEngineClient implements AppEngineClient {
        
        
        public function SimpleAppEngineClient() {
            super();
            this.isEncrypted = true;
            this.maxRetries = 0;
            this.dataFormat = "text";
        }
        
        [Inject]
        public var loader: RetryLoader;
        [Inject]
        public var setup: ApplicationSetup;
        [Inject]
        public var account: Account;
        private var isEncrypted: Boolean;
        private var maxRetries: int;
        private var dataFormat: String;
        
        public function get complete(): OnceSignal {
            return this.loader.complete;
        }
        
        public function setDataFormat(_arg_1: String): void {
            this.loader.setDataFormat(_arg_1);
        }
        
        public function setSendEncrypted(_arg_1: Boolean): void {
            this.isEncrypted = _arg_1;
        }
        
        public function setMaxRetries(_arg_1: int): void {
            this.loader.setMaxRetries(_arg_1);
        }
        
        public function sendRequest(url: String, params: Object): void {
            if (params != null && params.guid)
                this.loader.sendRequest(this.makeURL(url + "?g=" + escape(params.guid)), params);
            else
                this.loader.sendRequest(this.makeURL(url), params);
        }
        
        public function requestInProgress(): Boolean {
            return this.loader.isInProgress();
        }
        
        private function makeURL(_arg_1: String): String {
            if (_arg_1.charAt(0) != "/") {
                _arg_1 = "/" + _arg_1;
            }
            return this.setup.getAppEngineUrl() + _arg_1;
        }
    }
}
