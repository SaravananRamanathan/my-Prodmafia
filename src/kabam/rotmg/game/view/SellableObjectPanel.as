package kabam.rotmg.game.view {
import com.company.assembleegameclient.game.GameSprite;
import com.company.assembleegameclient.objects.Merchant;
import com.company.assembleegameclient.objects.Player;
import com.company.assembleegameclient.objects.SellableObject;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.ui.ConfirmBuyModal;
import com.company.assembleegameclient.ui.RankText;
import com.company.assembleegameclient.ui.panels.Panel;
import com.company.assembleegameclient.util.GuildUtil;

import flash.display.Bitmap;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;

import io.decagames.rotmg.nexusShop.NexusShopPopupView;
import io.decagames.rotmg.ui.popups.signals.ClosePopupByClassSignal;
import io.decagames.rotmg.ui.popups.signals.ShowPopupSignal;

import kabam.rotmg.account.core.Account;
import kabam.rotmg.core.StaticInjectorContext;
import kabam.rotmg.core.signals.HideTooltipsSignal;
import kabam.rotmg.core.signals.ShowTooltipSignal;
import kabam.rotmg.text.view.TextFieldDisplayConcrete;
import kabam.rotmg.text.view.stringBuilder.LineBuilder;
import kabam.rotmg.tooltips.HoverTooltipDelegate;
import kabam.rotmg.tooltips.TooltipAble;
import kabam.rotmg.util.components.LegacyBuyButton;

import org.osflash.signals.Signal;

public class SellableObjectPanel extends Panel implements TooltipAble {


    private const BUTTON_OFFSET:int = 17;

    private static function createRankReqText(_arg_1:int):Sprite {
        _arg_1 = _arg_1;
        var param1:int = _arg_1;
        var rankReq:int = param1;
        var rankReqText:Sprite = new Sprite();
        var requiredText:TextFieldDisplayConcrete = new TextFieldDisplayConcrete().setSize(16).setColor(0xffffff).setBold(true).setAutoSize("center");
        requiredText.filters = [new DropShadowFilter(0, 0, 0)];
        rankReqText.addChild(requiredText);
        var rankText:Sprite = new RankText(rankReq, false, false);
        rankReqText.addChild(rankText);
        requiredText.textChanged.addOnce(function ():void {
            rankText.x = requiredText.width * 0.5 + 4;
            rankText.y = -rankText.height / 2;
        });
        requiredText.setStringBuilder(new LineBuilder().setParams("SellableObjectPanel.requireRankSprite"));
        return rankReqText;
    }

    private static function createGuildRankReqText(_arg_1:int):TextFieldDisplayConcrete {
        var _local2:* = null;
        _local2 = new TextFieldDisplayConcrete().setSize(16).setColor(0xff0000).setBold(true).setAutoSize("center");
        var _local3:String = GuildUtil.rankToString(_arg_1);
        _local2.setStringBuilder(new LineBuilder().setParams("SellableObjectPanel.requireRank", {"amount": _local3}));
        _local2.filters = [new DropShadowFilter(0, 0, 0)];
        return _local2;
    }

    public function SellableObjectPanel(_arg_1:GameSprite, _arg_2:SellableObject) {
        hoverTooltipDelegate = new HoverTooltipDelegate();
        buyItem = new Signal(SellableObject);
        super(_arg_1);
        this.nameText_ = new TextFieldDisplayConcrete().setSize(16).setColor(0xffffff).setTextWidth(144);
        this.nameText_.setBold(true);
        this.nameText_.setStringBuilder(new LineBuilder().setParams("SellableObjectPanel.text"));
        this.nameText_.setWordWrap(true);
        this.nameText_.setMultiLine(true);
        this.nameText_.setAutoSize("center");
        this.nameText_.filters = [new DropShadowFilter(0, 0, 0)];
        addChild(this.nameText_);
        this.icon_ = new Sprite();
        addChild(this.icon_);
        this.bitmap_ = new Bitmap(null);
        this.icon_.addChild(this.bitmap_);
        this.buyButton_ = new LegacyBuyButton("SellableObjectPanel.buy", 16, 0, -1);
        this.buyButton_.addEventListener("click", this.onBuyButtonClick);
        addChild(this.buyButton_);
        this.setOwner(_arg_2);
        addEventListener("addedToStage", this.onAddedToStage);
        addEventListener("removedFromStage", this.onRemovedFromStage);
        this.hoverTooltipDelegate.setDisplayObject(this);
        this.hoverTooltipDelegate.tooltip = _arg_2.getTooltip();
    }
    [Inject]
    public var showPopupSignal:ShowPopupSignal;
    [Inject]
    public var closePopupByClassSignal:ClosePopupByClassSignal;
    public var hoverTooltipDelegate:HoverTooltipDelegate;
    public var buyItem:Signal;
    private var owner_:SellableObject;
    private var nameText_:TextFieldDisplayConcrete;
    private var buyButton_:LegacyBuyButton;
    private var rankReqText_:Sprite;
    private var guildRankReqText_:TextFieldDisplayConcrete;
    private var icon_:Sprite;
    private var bitmap_:Bitmap;
    private var confirmBuyModal:ConfirmBuyModal;
    private var availableInventoryNumber:int;

    override public function draw():void {
        var _local1:Player = gs_.map.player_;
        this.nameText_.y = this.nameText_.height > 30 ? 0 : 12;
        var _local2:int = this.owner_.rankReq_;
        if (_local1.numStars_ < _local2) {
            if (contains(this.buyButton_)) {
                removeChild(this.buyButton_);
            }
            if (this.rankReqText_ == null || !contains(this.rankReqText_)) {
                this.rankReqText_ = createRankReqText(_local2);
                this.rankReqText_.x = 94 - this.rankReqText_.width / 2;
                this.rankReqText_.y = 84 - this.rankReqText_.height / 2 - 20;
                addChild(this.rankReqText_);
            }
        } else if (_local1.guildRank_ < this.owner_.guildRankReq_) {
            if (contains(this.buyButton_)) {
                removeChild(this.buyButton_);
            }
            if (this.guildRankReqText_ == null || !contains(this.guildRankReqText_)) {
                this.guildRankReqText_ = createGuildRankReqText(this.owner_.guildRankReq_);
                this.guildRankReqText_.x = 94 - this.guildRankReqText_.width / 2;
                this.guildRankReqText_.y = 84 - this.guildRankReqText_.height / 2 - 20;
                addChild(this.guildRankReqText_);
            }
        } else {
            this.buyButton_.setPrice(this.owner_.price_, this.owner_.currency_);
            this.buyButton_.setEnabled(gs_.gsc_.outstandingBuy_ == null);
            this.buyButton_.x = int(94 - this.buyButton_.width / 2);
            this.buyButton_.y = 84 - this.buyButton_.height / 2 - 17;
            if (!contains(this.buyButton_)) {
                addChild(this.buyButton_);
            }
            if (this.rankReqText_ != null && contains(this.rankReqText_)) {
                removeChild(this.rankReqText_);
            }
        }
    }

    public function setOwner(_arg_1:SellableObject):void {
        if (_arg_1 == this.owner_) {
            return;
        }
        this.owner_ = _arg_1;
        this.buyButton_.setPrice(this.owner_.price_, this.owner_.currency_);
        var _local2:String = this.owner_.soldObjectName();
        this.nameText_.setStringBuilder(new LineBuilder().setParams(_local2));
        this.bitmap_.bitmapData = this.owner_.getIcon();
    }

    public function setInventorySpaceAmount(_arg_1:int):void {
        this.availableInventoryNumber = _arg_1;
    }

    public function setShowToolTipSignal(_arg_1:ShowTooltipSignal):void {
        this.hoverTooltipDelegate.setShowToolTipSignal(_arg_1);
    }

    public function getShowToolTip():ShowTooltipSignal {
        return this.hoverTooltipDelegate.getShowToolTip();
    }

    public function setHideToolTipsSignal(_arg_1:HideTooltipsSignal):void {
        this.hoverTooltipDelegate.setHideToolTipsSignal(_arg_1);
    }

    public function getHideToolTips():HideTooltipsSignal {
        return this.hoverTooltipDelegate.getHideToolTips();
    }

    private function buyEvent():void {
        var _local2:* = null;
        var _local1:* = null;
        var _local3:Account = StaticInjectorContext.getInjector().getInstance(Account);
        if (parent != null && _local3.isRegistered() && this.owner_ is Merchant) {
            _local2 = StaticInjectorContext.getInjector();
            _local1 = _local2.getInstance(ShowPopupSignal);
            _local1.dispatch(new NexusShopPopupView(this.buyItem, this.owner_, this.buyButton_.width, this.availableInventoryNumber));
        } else {
            this.buyItem.dispatch(this.owner_);
        }
    }

    private function onAddedToStage(_arg_1:Event):void {
        stage.addEventListener("keyDown", this.onKeyDown);
        this.icon_.x = -4;
        this.icon_.y = -8;
        this.nameText_.x = 44;
    }

    private function onRemovedFromStage(_arg_1:Event):void {
        var _local2:* = null;
        var _local3:* = null;
        stage.removeEventListener("keyDown", this.onKeyDown);
        if (NexusShopPopupView != null) {
            _local2 = StaticInjectorContext.getInjector();
            _local3 = _local2.getInstance(ClosePopupByClassSignal);
            _local3.dispatch(NexusShopPopupView);
        }
        if (parent != null && this.confirmBuyModal != null && this.confirmBuyModal.open) {
            parent.removeChild(this.confirmBuyModal);
        }
    }

    private function onBuyButtonClick(_arg_1:MouseEvent):void {
        if (ConfirmBuyModal.free) {
            this.buyEvent();
        }
    }

    private function onKeyDown(_arg_1:KeyboardEvent):void {
        if (_arg_1.keyCode == Parameters.data.interact && stage.focus == null && ConfirmBuyModal.free) {
            this.buyEvent();
        }
    }
}
}
