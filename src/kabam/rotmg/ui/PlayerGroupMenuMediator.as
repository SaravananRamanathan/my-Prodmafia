package kabam.rotmg.ui {
import com.company.assembleegameclient.ui.menu.PlayerGroupMenu;

import kabam.rotmg.chat.model.ChatMessage;
import kabam.rotmg.core.StaticInjectorContext;
import kabam.rotmg.game.signals.AddTextLineSignal;

import org.swiftsuspenders.Injector;

import robotlegs.bender.bundles.mvcs.Mediator;

public class PlayerGroupMenuMediator extends Mediator {


    public function PlayerGroupMenuMediator() {
        super();
    }
    [Inject]
    public var view:PlayerGroupMenu;

    override public function initialize():void {
        this.view.unableToTeleport.add(this.onUnableToTeleport);
    }

    override public function destroy():void {
        this.view.unableToTeleport.remove(this.onUnableToTeleport);
    }

    private function onUnableToTeleport():void {
        var _local1:Injector = StaticInjectorContext.getInjector();
        var _local2:AddTextLineSignal = _local1.getInstance(AddTextLineSignal);
        _local2.dispatch(ChatMessage.make("*Error*", "No players are eligible for teleporting."));
    }
}
}
