package com.company.assembleegameclient.screens {
import flash.events.TimerEvent;
import flash.utils.Timer;

import io.decagames.rotmg.seasonalEvent.signals.ShowSeasonHasEndedPopupSignal;

import robotlegs.bender.bundles.mvcs.Mediator;

public class LeagueItemMediator extends Mediator {


    public function LeagueItemMediator() {
        super();
    }
    [Inject]
    public var view:LeagueItem;
    [Inject]
    public var showSeasonHasEndedPopupSignal:ShowSeasonHasEndedPopupSignal;
    private var _timer:Timer;

    override public function initialize():void {
        if (this.view.endDate) {
            this._timer = new Timer(1000);
            this._timer.addEventListener("timer", this.onTime);
            this._timer.start();
        }
    }

    override public function destroy():void {
        super.destroy();
        if (this._timer) {
            this._timer.removeEventListener("timer", this.onTime);
            this._timer = null;
        }
    }

    private function onTime(_arg_1:TimerEvent):void {
        var _local2:Number = this.view.endDate.time - new Date().time;
        this.view.updateTimeLabel(_local2);
        if (_local2 <= 0) {
            this._timer.stop();
            this._timer.removeEventListener("timer", this.onTime);
            this.showSeasonHasEndedPopupSignal.dispatch();
        }
    }
}
}
