package kabam.rotmg.chat.control {
import kabam.rotmg.chat.model.TellModel;

import robotlegs.bender.bundles.mvcs.Command;

public class ClearTellModelCommand extends Command {


    public function ClearTellModelCommand() {
        super();
    }
    [Inject]
    public var tellModel:TellModel;

    override public function execute():void {
        this.tellModel.clearRecipients();
    }
}
}
