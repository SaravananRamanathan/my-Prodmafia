package kabam.rotmg.death.view {
import flash.display.BitmapData;

import kabam.rotmg.death.control.HandleNormalDeathSignal;
import kabam.rotmg.death.model.DeathModel;
import kabam.rotmg.dialogs.control.CloseDialogsSignal;

import robotlegs.bender.bundles.mvcs.Mediator;

public class ZombifyDialogMediator extends Mediator {


    public function ZombifyDialogMediator() {
        super();
    }
    [Inject]
    public var view:ZombifyDialog;
    [Inject]
    public var closeDialogs:CloseDialogsSignal;
    [Inject]
    public var handleDeath:HandleNormalDeathSignal;
    [Inject]
    public var death:DeathModel;

    override public function initialize():void {
        this.view.closed.addOnce(this.onClosed);
    }

    private function onClosed():void {
        var _local1:* = null;
        _local1 = this.death.getLastDeath();
        var _local2:BitmapData = new BitmapData(this.view.stage.width, this.view.stage.height, true, 0);
        _local2.draw(this.view.stage);
        _local1.background = _local2;
        this.closeDialogs.dispatch();
        this.handleDeath.dispatch(_local1);
    }
}
}
