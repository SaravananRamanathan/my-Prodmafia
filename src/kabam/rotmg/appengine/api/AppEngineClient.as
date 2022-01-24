package kabam.rotmg.appengine.api {
    import org.osflash.signals.OnceSignal;
    
    public interface AppEngineClient {
        function get complete(): OnceSignal;
        
        function setDataFormat(format: String): void;
        
        function setSendEncrypted(encrypt: Boolean): void;
        
        function setMaxRetries(retries: int): void;
        
        function sendRequest(url: String, params: Object, unknown: Boolean = false): void;
        
        function requestInProgress(): Boolean;
    }
}