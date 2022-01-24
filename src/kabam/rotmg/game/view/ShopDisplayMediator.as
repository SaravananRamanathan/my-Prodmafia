package kabam.rotmg.game.view {
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.ui.tooltip.TextToolTip;

import kabam.rotmg.core.signals.HideTooltipsSignal;
import kabam.rotmg.core.signals.ShowTooltipSignal;
import kabam.rotmg.packages.model.PackageInfo;
import kabam.rotmg.packages.services.PackageModel;
import kabam.rotmg.tooltips.HoverTooltipDelegate;

import robotlegs.bender.bundles.mvcs.Mediator;

public class ShopDisplayMediator extends Mediator {


    public function ShopDisplayMediator() {
        super();
    }
    [Inject]
    public var view:ShopDisplay;
    [Inject]
    public var packageBoxModel:PackageModel;
    [Inject]
    public var showTooltipSignal:ShowTooltipSignal;
    [Inject]
    public var hideTooltipSignal:HideTooltipsSignal;
    private var toolTip:TextToolTip = null;
    private var hoverTooltipDelegate:HoverTooltipDelegate;

    override public function initialize():void {
        var _local1:* = null;
        if (this.view.shopButton && this.view.isOnNexus) {
            this.view.shopButton.addEventListener("click", this.view.onShopClick);
            this.toolTip = new TextToolTip(0x363636, 0x9b9b9b, null, "Click to open!", 95);
            this.hoverTooltipDelegate = new HoverTooltipDelegate();
            this.hoverTooltipDelegate.setShowToolTipSignal(this.showTooltipSignal);
            this.hoverTooltipDelegate.setHideToolTipsSignal(this.hideTooltipSignal);
            this.hoverTooltipDelegate.setDisplayObject(this.view.shopButton);
            this.hoverTooltipDelegate.tooltip = this.toolTip;
        }
        var _local3:Vector.<PackageInfo> = this.packageBoxModel.getTargetingBoxesForGrid().concat(this.packageBoxModel.getBoxesForGrid());
        var _local2:Date = new Date();
        _local2.setTime(Parameters.data["packages_indicator"]);
        var _local5:int = 0;
        var _local4:* = _local3;
        for each(_local1 in _local3) {
            if (_local1 != null && (!_local1.endTime || _local1.getSecondsToEnd() > 0)) {
                if (_local1.isNew() && (_local1.startTime.getTime() > _local2.getTime() || !Parameters.data["packages_indicator"])) {
                    this.view.newIndicator(true);
                }
            }
        }
    }
}
}
