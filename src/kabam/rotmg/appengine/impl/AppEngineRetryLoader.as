package kabam.rotmg.appengine.impl {
import com.company.assembleegameclient.parameters.Parameters;

import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.net.URLRequestHeader;
import flash.net.URLRequestMethod;
import flash.net.URLVariables;
import flash.utils.ByteArray;
import flash.utils.getTimer;

import kabam.rotmg.appengine.api.RetryLoader;

import org.osflash.signals.OnceSignal;

public class AppEngineRetryLoader implements RetryLoader {
    private const _complete:OnceSignal = new OnceSignal(Boolean);
    private var maxRetries:int;
    private var dataFormat:String;
    private var url:String;
    private var params:Object;
    private var urlRequest:URLRequest;
    private var urlLoader:URLLoader;
    private var retriesLeft:int;
    private var inProgress:Boolean;
    private var fromLauncher:Boolean;

    public function AppEngineRetryLoader() {
        super();
        this.inProgress = false;
        this.maxRetries = 0;
        this.dataFormat = "text";
    }

    public function get complete():OnceSignal {
        return this._complete;
    }

    public function isInProgress():Boolean {
        return this.inProgress;
    }

    public function setDataFormat(_arg_1:String):void {
        this.dataFormat = _arg_1;
    }

    public function setMaxRetries(_arg_1:int):void {
        this.maxRetries = _arg_1;
    }

    public function sendRequest(url:String, params:Object, fromLauncher:Boolean = false) : void {
        this.url = url;
        this.params = params;
        this.fromLauncher = fromLauncher;
        this.retriesLeft = this.maxRetries;
        this.inProgress = true;
        this.internalSendRequest();
    }

    private function internalSendRequest() : void {
        this.cancelPendingRequest();
        this.urlRequest = this.makeUrlRequest();
        this.urlLoader = this.makeUrlLoader();
        this.urlLoader.load(this.urlRequest);
    }

    private function makeUrlRequest():URLRequest {
        var urlReq:URLRequest = new URLRequest(this.url);
        urlReq.method = URLRequestMethod.POST;
        urlReq.data = this.makeUrlVariables();
        return urlReq;
    }

    private function makeUrlVariables():URLVariables {
        var _local2:* = undefined;
        var _local1:URLVariables = new URLVariables();
        _local1.ignore = getTimer();
        var _local4:int = 0;
        var _local3:* = this.params;
        for (_local2 in this.params) {
            _local1[_local2] = this.params[_local2];
        }
        return _local1;
    }

    private function makeUrlLoader():URLLoader {
        var _local1:URLLoader = new URLLoader();
        _local1.dataFormat = this.dataFormat;
        _local1.addEventListener("ioError", this.onIOError);
        _local1.addEventListener("securityError", this.onSecurityError);
        _local1.addEventListener("complete", this.onComplete);
        return _local1;
    }

    private function retryOrReportError(_arg_1:String):void {
        var _local2:Number = this.retriesLeft;
        this.retriesLeft--;
        if (_local2 > 0) {
            this.internalSendRequest();
        } else {
            this.cleanUpAndComplete(false, _arg_1);
        }
    }

    private function handleTextResponse(_arg_1:String):void {
        if (_arg_1.substring(0, 7) == "<Error>") {
            this.retryOrReportError(_arg_1);
        } else if (_arg_1.substring(0, 12) == "<FatalError>") {
            this.cleanUpAndComplete(false, _arg_1);
        } else {
            this.cleanUpAndComplete(true, _arg_1);
        }
    }

    private function cleanUpAndComplete(_arg_1:Boolean, _arg_2:*):void {
        if (!_arg_1 && _arg_2 is String) {
            _arg_2 = this.parseXML(_arg_2);
        }
        this.cancelPendingRequest();
        this._complete.dispatch(_arg_1, _arg_2);
    }

    private function parseXML(_arg_1:String):String {
        var _local2:Array = _arg_1.match("<.*>(.*)</.*>");
        return _local2 && _local2.length > 1 ? _local2[1] : _arg_1;
    }

    private function cancelPendingRequest():void {
        if (this.urlLoader) {
            this.urlLoader.removeEventListener("ioError", this.onIOError);
            this.urlLoader.removeEventListener("securityError", this.onSecurityError);
            this.urlLoader.removeEventListener("complete", this.onComplete);
            this.closeLoader();
            this.urlLoader = null;
        }
    }

    private function closeLoader():void {
        try {
            this.urlLoader.close();

        } catch (e:Error) {

        }
    }

    private function onIOError(_arg_1:IOErrorEvent):void {
        this.inProgress = false;
        var _local2:String = this.urlLoader.data;
        if (_local2.length == 0) {
            _local2 = "Unable to contact server";
        }
        this.retryOrReportError(_local2);
    }

    private function onSecurityError(_arg_1:SecurityErrorEvent):void {
        this.inProgress = false;
        this.cleanUpAndComplete(false, "Security Error");
    }

    private function onComplete(_arg_1:Event):void {
        this.inProgress = false;
        if (this.dataFormat == "text") {
            this.handleTextResponse(this.urlLoader.data);
        } else {
            this.cleanUpAndComplete(true, ByteArray(this.urlLoader.data));
        }
    }
}
}
