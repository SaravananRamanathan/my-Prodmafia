package kabam.rotmg.errors.view {
import flash.display.DisplayObjectContainer;
import flash.display.LoaderInfo;
import flash.events.ErrorEvent;
import flash.events.IEventDispatcher;

import kabam.rotmg.errors.control.ErrorSignal;

import robotlegs.bender.bundles.mvcs.Mediator;
import robotlegs.bender.framework.api.ILogger;

public class ErrorMediator extends Mediator {


    private const UNCAUGHT_ERROR_EVENTS:String = "uncaughtErrorEvents";

    private const UNCAUGHT_ERROR:String = "uncaughtError";

    public function ErrorMediator() {
        super();
    }
    [Inject]
    public var contextView:DisplayObjectContainer;
    [Inject]
    public var error:ErrorSignal;
    [Inject]
    public var logger:ILogger;
    private var loaderInfo:LoaderInfo;

    override public function initialize():void {
        this.loaderInfo = this.contextView.loaderInfo;
        if (this.canCatchGlobalErrors()) {
            this.addGlobalErrorListener();
        }
    }

    override public function destroy():void {
        if (this.canCatchGlobalErrors()) {
            this.removeGlobalErrorListener();
        }
    }

    private function canCatchGlobalErrors():Boolean {
        return "uncaughtErrorEvents" in this.loaderInfo;
    }

    private function addGlobalErrorListener():void {
        var _local1:IEventDispatcher = IEventDispatcher(this.loaderInfo["uncaughtErrorEvents"]);
        _local1.addEventListener("uncaughtError", this.handleUncaughtError);
    }

    private function removeGlobalErrorListener():void {
        var _local1:IEventDispatcher = IEventDispatcher(this.loaderInfo["uncaughtErrorEvents"]);
        _local1.removeEventListener("uncaughtError", this.handleUncaughtError);
    }

    private function handleUncaughtError(_arg_1:ErrorEvent):void {
        this.error.dispatch(_arg_1);
    }
}
}
