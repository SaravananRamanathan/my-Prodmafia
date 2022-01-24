package io.decagames.rotmg.service.tracking {
    import flash.crypto.generateRandomBytes;
    import flash.display.Loader;
    import flash.net.SharedObject;
    import flash.net.URLRequest;
    import flash.utils.ByteArray;
    
    import robotlegs.bender.framework.api.ILogger;
    
    public class GoogleAnalyticsTracker {
        
        public static const VERSION: String = "1";
        
        public function GoogleAnalyticsTracker(_arg_1: String, _arg_2: ILogger, _arg_3: String, _arg_4: Boolean = false) {
            super();
            this.account = _arg_1;
            this.logger = _arg_2;
            this._debug = _arg_4;
            if (_arg_4) {
                this.trackingURL = "http://www.google-analytics.com/debug/collect";
            }
            this.clientID = this.getClientID();
        }
        
        private var trackingURL: String = "https://www.google-analytics.com/collect";
        private var account: String;
        private var logger: ILogger;
        private var clientID: String;
        
        private var _debug: Boolean = false;
        
        public function get debug(): Boolean {
            return this._debug;
        }
        
        public function trackEvent(_arg_1: String, _arg_2: String, _arg_3: String = "", _arg_4: Number = NaN): void {
            this.triggerEvent("&t=event&ec=" + _arg_1 + "&ea=" + _arg_2 + (_arg_3 != "" ? "&el=" + _arg_3 : "") + (!!isNaN(_arg_4) ? "" : "&ev=" + _arg_4));
        }
        
        public function trackPageView(_arg_1: String): void {
            this.triggerEvent("&t=pageview&dp=" + _arg_1);
        }
        
        private function getClientID(): String {
            var _local2: * = null;
            var _local1: SharedObject = SharedObject.getLocal("_ga2");
            if (!_local1.data.clientid) {
                this.logger.debug("CID not found, generate Client ID");
                _local2 = this._generateUUID();
                _local1.data.clientid = _local2;
                try {
                    _local1.flush(1024);
                } catch (e: Error) {
                    logger.debug("Could not write SharedObject to disk: " + e.message);
                }
            } else {
                this.logger.debug("CID found, restore from SharedObject: " + _local1.data.clientid);
                _local2 = _local1.data.clientid;
            }
            return _local2;
        }
        
        private function _generateUUID(): String {
            var randomBytes: ByteArray = generateRandomBytes(16);
            randomBytes[6] = randomBytes[6] & 15;
            randomBytes[6] = randomBytes[6] | 64;
            randomBytes[8] = randomBytes[8] & 63;
            randomBytes[8] = randomBytes[8] | 128;
            var toHex: Function = function (param1: uint): String {
                var _local2: String = param1.toString(16);
                return _local2.length > 1 ? _local2 : "0" + _local2;
            };
            var str: String = "";
            var l: uint = randomBytes.length;
            randomBytes.position = 0;
            var i: uint = 0;
            while (i < l) {
                var b: uint = randomBytes[i];
                str = str + toHex(b);
                i = Number(i) + 1;
            }
            var uuid: String = "";
            uuid = uuid + str.substr(0, 8);
            uuid = uuid + "-";
            uuid = uuid + str.substr(8, 4);
            uuid = uuid + "-";
            uuid = uuid + str.substr(12, 4);
            uuid = uuid + "-";
            uuid = uuid + str.substr(16, 4);
            uuid = uuid + "-";
            uuid = uuid + str.substr(20, 12);
            return uuid;
        }
        
        private function prepareURL(_arg_1: String): String {
            return this.trackingURL + "?v=" + "1" + "&tid=" + this.account + "&cid=" + this.clientID + _arg_1;
        }
        
        private function triggerEvent(url: String): void {
            var _local3: * = null;
            var _local2: * = null;
            url = this.prepareURL(url);
            if (this._debug) {
                this.logger.debug("DEBUGGING GA:" + url);
                return;
            }
            try {
                _local3 = new Loader();
                _local2 = new URLRequest(url);
                _local3.load(_local2);
                
            } catch (e: Error) {
                logger.error("Tracking Error:" + e.message + ", " + e.name + ", " + e.getStackTrace());
                
            }
        }
    }
}
