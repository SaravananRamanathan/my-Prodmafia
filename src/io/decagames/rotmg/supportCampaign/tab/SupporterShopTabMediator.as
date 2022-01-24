package io.decagames.rotmg.supportCampaign.tab {
import com.company.assembleegameclient.objects.Player;
import com.company.assembleegameclient.ui.tooltip.TextToolTip;

import flash.display.DisplayObject;
import flash.display.Loader;
import flash.events.Event;

import io.decagames.rotmg.shop.NotEnoughResources;
import io.decagames.rotmg.supportCampaign.data.SupporterCampaignModel;
import io.decagames.rotmg.supportCampaign.signals.TierSelectedSignal;
import io.decagames.rotmg.supportCampaign.signals.UpdateCampaignProgress;
import io.decagames.rotmg.ui.buttons.BaseButton;
import io.decagames.rotmg.ui.imageLoader.ImageLoader;
import io.decagames.rotmg.ui.popups.modal.error.ErrorModal;
import io.decagames.rotmg.ui.popups.signals.RemoveLockFade;
import io.decagames.rotmg.ui.popups.signals.ShowLockFade;
import io.decagames.rotmg.ui.popups.signals.ShowPopupSignal;

import kabam.rotmg.account.core.Account;
import kabam.rotmg.appengine.api.AppEngineClient;
import kabam.rotmg.core.model.PlayerModel;
import kabam.rotmg.core.signals.HideTooltipsSignal;
import kabam.rotmg.core.signals.ShowTooltipSignal;
import kabam.rotmg.game.model.GameModel;
import kabam.rotmg.text.view.stringBuilder.LineBuilder;
import kabam.rotmg.tooltips.HoverTooltipDelegate;
import kabam.rotmg.ui.model.HUDModel;
import kabam.rotmg.ui.signals.HUDModelInitialized;

import robotlegs.bender.bundles.mvcs.Mediator;

public class SupporterShopTabMediator extends Mediator {


    public function SupporterShopTabMediator() {
        super();
    }
    [Inject]
    public var view:SupporterShopTabView;
    [Inject]
    public var model:SupporterCampaignModel;
    [Inject]
    public var gameModel:GameModel;
    [Inject]
    public var playerModel:PlayerModel;
    [Inject]
    public var initHUDModelSignal:HUDModelInitialized;
    [Inject]
    public var hudModel:HUDModel;
    [Inject]
    public var showTooltipSignal:ShowTooltipSignal;
    [Inject]
    public var hideTooltipSignal:HideTooltipsSignal;
    [Inject]
    public var showPopup:ShowPopupSignal;
    [Inject]
    public var showFade:ShowLockFade;
    [Inject]
    public var removeFade:RemoveLockFade;
    [Inject]
    public var client:AppEngineClient;
    [Inject]
    public var account:Account;
    [Inject]
    public var updatePointsSignal:UpdateCampaignProgress;
    [Inject]
    public var selectedSignal:TierSelectedSignal;
    private var infoToolTip:TextToolTip;
    private var hoverTooltipDelegate:HoverTooltipDelegate;
    private var _loader:Loader;
    private var _imageLoader:ImageLoader;

    private function get currentGold():int {
        var _local1:Player = this.gameModel.player;
        if (_local1 != null) {
            return _local1.credits_;
        }
        if (this.playerModel != null) {
            return this.playerModel.getCredits();
        }
        return 0;
    }

    override public function initialize():void {
        this.updatePointsSignal.add(this.onPointsUpdate);
        var _local1:DisplayObject = this.model.getCampaignImageByUrl(this.model.campaignBannerUrl);
        if (_local1) {
            this.showCampaignView(_local1);
        } else {
            this._imageLoader = new ImageLoader();
            this._imageLoader.loadImage(this.model.campaignBannerUrl, this.onBannerLoaded);
        }
    }

    override public function destroy():void {
        this.updatePointsSignal.remove(this.onPointsUpdate);
        if (this.view.unlockButton) {
            this.view.unlockButton.clickSignal.remove(this.unlockClick);
        }
        this.view.removeEventListener("enterFrame", this.updateStartCountdown);
    }

    private function initView():void {
        if (!this.model.isStarted) {
            this.view.addEventListener("enterFrame", this.updateStartCountdown);
        }
        if (this.model.isUnlocked) {
            this.updateCampaignInformation();
        }
        if (this.view.unlockButton) {
            this.view.unlockButton.clickSignal.add(this.unlockClick);
        }
    }

    private function showCampaignView(_arg_1:DisplayObject):void {
        this.view.show(this.hudModel.getPlayerName(), this.model.isUnlocked, this.model.isStarted, this.model.unlockPrice, this.model.donatePointsRatio, this.model.isEnded, _arg_1);
        this.initView();
    }

    private function updateCampaignInformation():void {
        this.view.updatePoints(this.model.points, this.model.rank);
        this.view.drawProgress(this.model.points, this.model.rankConfig, this.model.rank, this.model.claimed);
        this.updateInfoTooltip();
        this.showCampaignTier();
        this.view.updateTime(this.model.endDate.time - new Date().time);
    }

    private function showCampaignTier():void {
        var _local1:String = this.model.getCampaignPictureUrlByRank(this.model.nextClaimableTier);
        var _local2:DisplayObject = this.model.getCampaignImageByUrl(_local1);
        if (_local2) {
            this.showTier(_local2);
        } else {
            this._imageLoader = new ImageLoader();
            this._imageLoader.loadImage(_local1, this.onCampaignTierImageLoaded);
        }
    }

    private function showTier(_arg_1:DisplayObject):void {
        this.view.showTier(this.model.nextClaimableTier, this.model.ranks, this.model.rank, this.model.claimed, _arg_1);
    }

    private function onPointsUpdate():void {
        this.view.updatePoints(this.model.points, this.model.rank);
        this.showCampaignTier();
        this.view.drawProgress(this.model.points, this.model.rankConfig, this.model.rank, this.model.claimed);
        this.updateInfoTooltip();
        this.selectedSignal.dispatch(this.model.nextClaimableTier);
        var _local1:Player = this.gameModel.player;
        if (_local1.hasSupporterFeature(1)) {
            _local1.supporterPoints = this.model.points;
            _local1.clearTextureCache();
        }
    }

    private function updateInfoTooltip():void {
        if (this.view.infoButton) {
            if (this.model.hasMaxRank()) {
                this.infoToolTip = new TextToolTip(0x363636, 15585539, "Bonus Points", "You have reached the maximum rank and therefore completed the Bonus Campaign - Congratulation!", 220);
            } else {
                this.infoToolTip = new TextToolTip(0x363636, 0x9b9b9b, "Bonus Points", "This is the amount of Bonus Points you have collected so far. Collect more Points and claim Rewards!", 220);
            }
            this.hoverTooltipDelegate = new HoverTooltipDelegate();
            this.hoverTooltipDelegate.setShowToolTipSignal(this.showTooltipSignal);
            this.hoverTooltipDelegate.setHideToolTipsSignal(this.hideTooltipSignal);
            this.hoverTooltipDelegate.setDisplayObject(this.view.infoButton);
            this.hoverTooltipDelegate.tooltip = this.infoToolTip;
        }
    }

    private function unlockClick(_arg_1:BaseButton):void {
        if (this.currentGold < this.model.unlockPrice) {
            this.showPopup.dispatch(new NotEnoughResources(5 * 60, 0));
            return;
        }
        this.showFade.dispatch();
        var _local2:Object = this.account.getCredentials();
        this.client.sendRequest("/supportCampaign/unlock", _local2);
        this.client.complete.addOnce(this.onUnlockComplete);
    }

    private function onUnlockComplete(_arg_1:Boolean, _arg_2:*):void {
        var _local5:* = null;
        var _local3:* = null;
        var _local7:* = null;
        var _local4:* = _arg_1;
        var _local6:* = _arg_2;
        this.removeFade.dispatch();
        if (_local4) {
            try {
                _local5 = new XML(_local6);
                if (_local5.hasOwnProperty("Gold")) {
                    this.updateUserGold(_local5.Gold);
                }
                this.view.show(null, true, this.model.isStarted, this.model.unlockPrice, this.model.donatePointsRatio, this.model.isEnded, this._loader);
                this.model.parseUpdateData(_local5);
                this.updateCampaignInformation();
                return;
            } catch (e:Error) {
                showPopup.dispatch(new ErrorModal(5 * 60, "Campaign Error", "General campaign error."));
                return;
            }
            return;
        }
        try {
            _local3 = new XML(_local6);
            _local7 = LineBuilder.getLocalizedStringFromKey(_local3.toString(), {});
            this.showPopup.dispatch(new ErrorModal(5 * 60, "Campaign Error", _local7 == "" ? _local3.toString() : _local7));

        } catch (e:Error) {
            showPopup.dispatch(new ErrorModal(5 * 60, "Campaign Error", "General campaign error."));

        }
    }

    private function updateUserGold(_arg_1:int):void {
        var _local2:Player = this.gameModel.player;
        if (_local2 != null) {
            _local2.setCredits(_arg_1);
        } else {
            this.playerModel.setCredits(_arg_1);
        }
    }

    private function onBannerLoaded(_arg_1:Event):void {
        this._imageLoader.removeLoaderListeners();
        var _local2:DisplayObject = this._imageLoader.loader;
        this.model.addCampaignImageByUrl(this.model.campaignBannerUrl, _local2);
        this.showCampaignView(_local2);
    }

    private function onCampaignTierImageLoaded(_arg_1:Event):void {
        this._imageLoader.removeLoaderListeners();
        var _local2:DisplayObject = this._imageLoader.loader;
        this.model.addCampaignImageByUrl(this.model.getCampaignPictureUrlByRank(this.model.nextClaimableTier), _local2);
        this.showTier(_local2);
    }

    private function updateStartCountdown(_arg_1:Event):void {
        var _local2:String = this.model.getStartTimeString();
        if (_local2 == "") {
            this.view.removeEventListener("enterFrame", this.updateStartCountdown);
            this.view.unlockButton.disabled = false;
        }
        this.view.updateStartCountdown(_local2);
    }
}
}
