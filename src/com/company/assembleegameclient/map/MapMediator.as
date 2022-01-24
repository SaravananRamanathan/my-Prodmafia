package com.company.assembleegameclient.map {
import kabam.rotmg.game.view.components.QueuedStatusText;

import robotlegs.bender.bundles.mvcs.Mediator;

public class MapMediator extends Mediator {


    public function MapMediator() {
        super();
    }
    [Inject]
    public var view:Map;
    [Inject]
    public var queueStatusText:QueueStatusTextSignal;

    override public function initialize():void {
        this.queueStatusText.add(this.onQueuedStatusText);
    }

    override public function destroy():void {
        this.queueStatusText.remove(this.onQueuedStatusText);
    }

    private function onQueuedStatusText(_arg_1:String, _arg_2:uint):void {
    }

    private function queueText(_arg_1:String, _arg_2:uint):void {
        var _local3:QueuedStatusText = new QueuedStatusText(this.view.player_, _arg_1, _arg_2, 2000, 0);
        this.view.mapOverlay_.addQueuedText(_local3);
    }
}
}
