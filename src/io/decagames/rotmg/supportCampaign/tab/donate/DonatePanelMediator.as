package io.decagames.rotmg.supportCampaign.tab.donate {
import com.company.assembleegameclient.ui.tooltip.TextToolTip;

import flash.events.Event;

import io.decagames.rotmg.supportCampaign.data.SupporterCampaignModel;
import io.decagames.rotmg.supportCampaign.signals.MaxRankReachedSignal;
import io.decagames.rotmg.supportCampaign.signals.UpdateCampaignProgress;
import io.decagames.rotmg.supportCampaign.tab.donate.popup.DonateConfirmationPopup;
import io.decagames.rotmg.ui.buttons.BaseButton;
import io.decagames.rotmg.ui.popups.signals.ShowPopupSignal;

import kabam.rotmg.core.signals.HideTooltipsSignal;
import kabam.rotmg.core.signals.ShowTooltipSignal;
import kabam.rotmg.tooltips.HoverTooltipDelegate;

import robotlegs.bender.bundles.mvcs.Mediator;

public class DonatePanelMediator extends Mediator {


    public function DonatePanelMediator() {
        super();
    }
    [Inject]
    public var view:DonatePanel;
    [Inject]
    public var showPopupSignal:ShowPopupSignal;
    [Inject]
    public var model:SupporterCampaignModel;
    [Inject]
    public var showTooltipSignal:ShowTooltipSignal;
    [Inject]
    public var hideTooltipSignal:HideTooltipsSignal;
    [Inject]
    public var maxRankReachedSignal:MaxRankReachedSignal;
    [Inject]
    public var updateCampaignProgress:UpdateCampaignProgress;
    private var infoToolTip:TextToolTip;
    private var hoverTooltipDelegate:HoverTooltipDelegate;

    override public function initialize():void {
        this.maxRankReachedSignal.add(this.onMaxRankReached);
        this.updateCampaignProgress.add(this.onCampaignUpdate);
        if (!this.model.isEnded) {
            this.view.upArrow.clickSignal.add(this.upClickHandler);
            this.view.downArrow.clickSignal.add(this.downClickHandler);
            this.view.amountTextfield.addEventListener("change", this.onAmountChange);
        }
        if (this.model.hasMaxRank()) {
            this.setDonateButtonState(true);
            this.onMaxRankReached();
        } else if (this.view.donateButton) {
            this.view.donateButton.clickSignal.add(this.donateClickHandler);
        }
        if (this.model.donatePointsRatio == 0) {
            this.infoToolTip = new TextToolTip(0x363636, 15585539, "Donation not possible", "You cannot spend Gold to progress in this Campaign", 220);
            this.hoverTooltipDelegate = new HoverTooltipDelegate();
            this.hoverTooltipDelegate.setShowToolTipSignal(this.showTooltipSignal);
            this.hoverTooltipDelegate.setHideToolTipsSignal(this.hideTooltipSignal);
            this.hoverTooltipDelegate.setDisplayObject(this.view);
            this.hoverTooltipDelegate.tooltip = this.infoToolTip;
        }
    }

    override public function destroy():void {
        if (!this.model.isEnded) {
            this.view.upArrow.clickSignal.remove(this.upClickHandler);
            this.view.downArrow.clickSignal.remove(this.downClickHandler);
            this.view.donateButton.clickSignal.remove(this.donateClickHandler);
            this.view.amountTextfield.removeEventListener("change", this.onAmountChange);
        }
        if (this.model.donatePointsRatio == 0) {
            this.hoverTooltipDelegate = null;
            this.infoToolTip = null;
        }
        this.maxRankReachedSignal.remove(this.onMaxRankReached);
        this.updateCampaignProgress.remove(this.onCampaignUpdate);
    }

    public function onCampaignUpdate():void {
        this.onAmountChange();
    }

    private function onMaxRankReached():void {
        this.setDonateButtonState(true);
        this.view.setCompleteText(this.model.campaignTitle + " Complete!");
    }

    private function setDonateButtonState(_arg_1:Boolean):void {
        if (this.view.donateButton) {
            this.view.donateButton.disabled = _arg_1;
        }
    }

    private function upClickHandler(_arg_1:BaseButton):void {
        if (this.model.ranks[this.model.ranks.length - 1] - this.model.points > 0) {
            this.view.addDonateAmount(this.getDonationPoints(100));
        }
    }

    private function downClickHandler(_arg_1:BaseButton):void {
        this.view.addDonateAmount(this.getDonationPoints(-100));
    }

    private function donateClickHandler(_arg_1:BaseButton):void {
        this.showPopupSignal.dispatch(new DonateConfirmationPopup(this.view.gold, this.view.gold * this.model.donatePointsRatio));
    }

    private function getDonationPoints(_arg_1:int):int {
        var _local2:* = 0;
        var _local4:int = parseInt(this.view.amountTextfield.text);
        var _local3:int = (this.model.ranks[this.model.ranks.length - 1] - this.model.points) / this.model.donatePointsRatio;
        if (_local4 + _arg_1 > _local3) {
            _local2 = int(_local3 - _local4);
            this.view.upArrow.disabled = true;
        } else {
            this.view.upArrow.disabled = false;
            _local2 = _arg_1;
        }
        return _local2;
    }

    private function onAmountChange(_arg_1:Event = null):void {
        var _local2:int = (this.model.ranks[this.model.ranks.length - 1] - this.model.points) / this.model.donatePointsRatio;
        if (int(this.view.amountTextfield.text) > _local2) {
            this.view.amountTextfield.text = _local2.toString();
        }
        this.view.updateDonateAmount();
    }
}
}
