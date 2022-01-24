package kabam.rotmg.game.focus.control {
import kabam.lib.console.signals.RegisterConsoleActionSignal;
import kabam.lib.console.vo.ConsoleAction;

public class AddGameFocusConsoleActionCommand {


    public function AddGameFocusConsoleActionCommand() {
        super();
    }
    [Inject]
    public var register:RegisterConsoleActionSignal;
    [Inject]
    public var setFocus:SetGameFocusSignal;

    public function execute():void {
        var _local1:ConsoleAction = new ConsoleAction();
        _local1.name = "follow";
        _local1.description = "follow a game object (by name)";
        this.register.dispatch(_local1, this.setFocus);
    }
}
}
