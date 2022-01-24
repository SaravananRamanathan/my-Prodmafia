package io.decagames.rotmg.supportCampaign.tooltips {
import io.decagames.rotmg.supportCampaign.data.SupporterCampaignModel;

import robotlegs.bender.bundles.mvcs.Mediator;

public class PointsTooltipMediator extends Mediator {


    public function PointsTooltipMediator() {
        super();
    }
    [Inject]
    public var view:PointsTooltip;
    [Inject]
    public var model:SupporterCampaignModel;

    override public function initialize():void {
        this.view.updatePoints(this.view.shopButton.price * this.model.shopPurchasePointsRatio);
    }

    override public function destroy():void {
    }
}
}
