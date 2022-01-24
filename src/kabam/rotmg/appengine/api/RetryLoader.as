package kabam.rotmg.appengine.api {
import org.osflash.signals.OnceSignal;

public interface RetryLoader {
    function get complete():OnceSignal;
    function setMaxRetries(_arg_1:int):void;
    function setDataFormat(_arg_1:String):void;
    function sendRequest(url:String, params:Object, fromLauncher:Boolean = false) : void;
    function isInProgress():Boolean;
}
}