package kabam.rotmg.news.view {
import kabam.rotmg.dialogs.control.OpenDialogSignal;

import robotlegs.bender.bundles.mvcs.Mediator;

public class NewsTickerMediator extends Mediator {


    public function NewsTickerMediator() {
        super();
    }
    [Inject]
    public var view:NewsTicker;
    [Inject]
    public var openDialog:OpenDialogSignal;

    override public function initialize():void {
    }

    override public function destroy():void {
    }
}
}
