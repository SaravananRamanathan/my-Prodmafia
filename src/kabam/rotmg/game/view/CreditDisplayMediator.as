package kabam.rotmg.game.view {
import com.company.assembleegameclient.ui.tooltip.TextToolTip;

import flash.events.MouseEvent;

import kabam.rotmg.account.core.signals.OpenMoneyWindowSignal;
import kabam.rotmg.core.model.PlayerModel;
import kabam.rotmg.core.signals.HideTooltipsSignal;
import kabam.rotmg.core.signals.ShowTooltipSignal;
import kabam.rotmg.tooltips.HoverTooltipDelegate;

import robotlegs.bender.bundles.mvcs.Mediator;

public class CreditDisplayMediator extends Mediator {


    public function CreditDisplayMediator() {
        super();
    }
    [Inject]
    public var view:CreditDisplay;
    [Inject]
    public var model:PlayerModel;
    [Inject]
    public var openMoneyWindow:OpenMoneyWindowSignal;
    [Inject]
    public var showTooltipSignal:ShowTooltipSignal;
    [Inject]
    public var hideTooltipSignal:HideTooltipsSignal;
    private var toolTip:TextToolTip = null;
    private var hoverTooltipDelegate:HoverTooltipDelegate;

    override public function initialize():void {
        this.model.creditsChanged.add(this.onCreditsChanged);
        this.model.fameChanged.add(this.onFameChanged);
        this.model.tokensChanged.add(this.onTokensChanged);
        this.view.openAccountDialog.add(this.onOpenAccountDialog);
        var _local1:Boolean = this.view.gs && this.view.gs.map.name_ == "Nexus";
        if (_local1) {
            this.view.addResourceButtons();
        } else {
            this.view.removeResourceButtons();
        }
        if (this.view.creditsButton && _local1) {
            this.view.creditsButton.addEventListener("click", this.view.onCreditsClick, false, 0, true);
            this.toolTip = new TextToolTip(0x363636, 0x9b9b9b, "Buy Gold", "Click to buy more Realm Gold!", 190);
            this.hoverTooltipDelegate = new HoverTooltipDelegate();
            this.hoverTooltipDelegate.setShowToolTipSignal(this.showTooltipSignal);
            this.hoverTooltipDelegate.setHideToolTipsSignal(this.hideTooltipSignal);
            this.hoverTooltipDelegate.setDisplayObject(this.view.creditsButton);
            this.hoverTooltipDelegate.tooltip = this.toolTip;
        }
        if (this.view.fameButton && _local1) {
            this.view.fameButton.addEventListener("click", this.view.onFameClick);
            this.toolTip = new TextToolTip(0x363636, 0x9b9b9b, "Fame", "Click to get an Overview!", 160);
            this.hoverTooltipDelegate = new HoverTooltipDelegate();
            this.hoverTooltipDelegate.setShowToolTipSignal(this.showTooltipSignal);
            this.hoverTooltipDelegate.setHideToolTipsSignal(this.hideTooltipSignal);
            this.hoverTooltipDelegate.setDisplayObject(this.view.fameButton);
            this.hoverTooltipDelegate.tooltip = this.toolTip;
        }
        this.view.displayFameTooltip.add(this.forceShowingTooltip);
    }

    override public function destroy():void {
        this.model.creditsChanged.remove(this.onCreditsChanged);
        this.model.fameChanged.remove(this.onFameChanged);
        this.model.tokensChanged.remove(this.onTokensChanged);
        this.view.openAccountDialog.remove(this.onOpenAccountDialog);
        var _local1:Boolean = this.view.gs && this.view.gs.map.name_ == "Nexus";
        if (this.view.fameButton && _local1) {
            this.view.fameButton.removeEventListener("click", this.view.onFameClick);
        }
        if (this.view.creditsButton && _local1) {
            this.view.creditsButton.removeEventListener("click", this.view.onCreditsClick);
        }
        this.view.displayFameTooltip.remove(this.forceShowingTooltip);
    }

    private function forceShowingTooltip():void {
        if (this.toolTip) {
            this.hoverTooltipDelegate.getDisplayObject().dispatchEvent(new MouseEvent("mouseOver", true));
            this.toolTip.x = 267;
            this.toolTip.y = 41;
        }
    }

    private function onCreditsChanged(_arg_1:int):void {
        this.view.draw(_arg_1, this.model.getFame());
    }

    private function onFameChanged(_arg_1:int):void {
        this.view.draw(this.model.getCredits(), _arg_1);
    }

    private function onTokensChanged(_arg_1:int):void {
        this.view.draw(this.model.getCredits(), this.model.getFame(), _arg_1);
    }

    private function onOpenAccountDialog():void {
        this.openMoneyWindow.dispatch();
    }
}
}
