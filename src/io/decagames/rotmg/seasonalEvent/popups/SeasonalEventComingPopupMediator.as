package io.decagames.rotmg.seasonalEvent.popups {
import flash.events.MouseEvent;

import io.decagames.rotmg.ui.popups.signals.ClosePopupSignal;

import robotlegs.bender.bundles.mvcs.Mediator;

public class SeasonalEventComingPopupMediator extends Mediator {


    public function SeasonalEventComingPopupMediator() {
        super();
    }
    [Inject]
    public var view:SeasonalEventComingPopup;
    [Inject]
    public var closePopupSignal:ClosePopupSignal;

    override public function destroy():void {
        this.view.okButton.removeEventListener("click", this.onOK);
    }

    override public function initialize():void {
        this.view.okButton.addEventListener("click", this.onOK);
    }

    private function onOK(_arg_1:MouseEvent):void {
        this.view.okButton.removeEventListener("click", this.onOK);
        this.closePopupSignal.dispatch(this.view);
    }
}
}
