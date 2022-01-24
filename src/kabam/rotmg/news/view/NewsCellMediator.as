package kabam.rotmg.news.view {
import flash.net.URLRequest;

import kabam.rotmg.news.controller.OpenSkinSignal;
import kabam.rotmg.news.model.NewsCellLinkType;
import kabam.rotmg.news.model.NewsCellVO;
import kabam.rotmg.packages.control.OpenPackageSignal;

import robotlegs.bender.bundles.mvcs.Mediator;

public class NewsCellMediator extends Mediator {


    public function NewsCellMediator() {
        super();
    }
    [Inject]
    public var view:NewsCell;
    [Inject]
    public var openPackageSignal:OpenPackageSignal;
    [Inject]
    public var openSkinSignal:OpenSkinSignal;

    override public function initialize():void {
        this.view.clickSignal.add(this.onNewsClicked);
    }

    override public function destroy():void {
        this.view.clickSignal.remove(this.onNewsClicked);
    }

    private function onNewsClicked(_arg_1:NewsCellVO):void {
        var _local2:* = null;
        var _local3:* = _arg_1.linkType;
        switch (_local3) {
            case NewsCellLinkType.OPENS_LINK:
                _local2 = new URLRequest(_arg_1.linkDetail);
                return;
            case NewsCellLinkType.OPENS_PACKAGE:
                this.openPackageSignal.dispatch(_arg_1.linkDetail);
                return;
            case NewsCellLinkType.OPENS_SKIN:
                this.openSkinSignal.dispatch(_arg_1.linkDetail);
                return;
            default:
                return;
        }
    }
}
}
