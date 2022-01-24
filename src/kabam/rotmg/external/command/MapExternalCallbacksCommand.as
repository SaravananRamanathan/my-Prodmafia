package kabam.rotmg.external.command {
import kabam.rotmg.external.service.ExternalServiceHelper;

import robotlegs.bender.bundles.mvcs.Command;

public class MapExternalCallbacksCommand extends Command {


    public function MapExternalCallbacksCommand() {
        super();
    }
    [Inject]
    public var externalServiceHelper:ExternalServiceHelper;

    override public function execute():void {
        this.externalServiceHelper.mapExternalCallbacks();
    }
}
}
