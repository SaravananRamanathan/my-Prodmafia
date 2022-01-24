package kabam.rotmg.game.view {
import com.company.assembleegameclient.game.GameSprite;
import com.company.assembleegameclient.objects.SellableObject;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.ui.DeprecatedTextButton;
import com.company.assembleegameclient.ui.panels.Panel;
import com.company.assembleegameclient.util.Currency;

import flash.display.Bitmap;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;

import io.decagames.rotmg.shop.ShopPopupView;
import io.decagames.rotmg.ui.popups.signals.ShowPopupSignal;

import kabam.rotmg.account.core.Account;
import kabam.rotmg.account.core.view.RegisterPromptDialog;
import kabam.rotmg.arena.util.ArenaViewAssetFactory;
import kabam.rotmg.core.StaticInjectorContext;
import kabam.rotmg.dialogs.control.OpenDialogSignal;
import kabam.rotmg.mysterybox.services.GetMysteryBoxesTask;
import kabam.rotmg.mysterybox.services.MysteryBoxModel;
import kabam.rotmg.text.view.TextFieldDisplayConcrete;
import kabam.rotmg.text.view.stringBuilder.LineBuilder;
import kabam.rotmg.util.components.LegacyBuyButton;

import org.osflash.signals.Signal;
import org.swiftsuspenders.Injector;

public class MysteryBoxPanel extends Panel {


    private const BUTTON_OFFSET:int = 17;

    public function MysteryBoxPanel(_arg_1:GameSprite, _arg_2:uint) {
        buyItem = new Signal(SellableObject);
        var _local6:Injector = StaticInjectorContext.getInjector();
        var _local3:GetMysteryBoxesTask = _local6.getInstance(GetMysteryBoxesTask);
        _local3.start();
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
        var _local8:MysteryBoxModel = _local6.getInstance(MysteryBoxModel);
        var _local7:Account = _local6.getInstance(Account);
        if (_local8.isInitialized() || !_local7.isRegistered()) {
            this.infoButton_ = new DeprecatedTextButton(16, "MysteryBoxPanel.open");
            this.infoButton_.addEventListener("click", this.onInfoButtonClick);
            addChild(this.infoButton_);
        } else {
            this.infoButton_ = new DeprecatedTextButton(16, "MysteryBoxPanel.checkBackLater");
            addChild(this.infoButton_);
        }
        this.nameText_.setStringBuilder(new LineBuilder().setParams("Shop"));
        this.bitmap_.bitmapData = ArenaViewAssetFactory.returnHostBitmap(_arg_2).bitmapData;
        addEventListener("addedToStage", this.onAddedToStage);
        addEventListener("removedFromStage", this.onRemovedFromStage);
    }
    public var buyItem:Signal;
    private var owner_:SellableObject;
    private var nameText_:TextFieldDisplayConcrete;
    private var buyButton_:LegacyBuyButton;
    private var infoButton_:DeprecatedTextButton;
    private var icon_:Sprite;
    private var bitmap_:Bitmap;

    override public function draw():void {
        this.nameText_.y = this.nameText_.height > 30 ? 0 : 12;
        this.infoButton_.x = 94 - this.infoButton_.width / 2;
        this.infoButton_.y = 84 - this.infoButton_.height / 2 - 17;
        if (!contains(this.infoButton_)) {
            addChild(this.infoButton_);
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

    private function onInfoButton():void {
        var _local3:* = null;
        var _local5:Injector = StaticInjectorContext.getInjector();
        var _local2:MysteryBoxModel = _local5.getInstance(MysteryBoxModel);
        var _local1:Account = _local5.getInstance(Account);
        var _local4:OpenDialogSignal = _local5.getInstance(OpenDialogSignal);
        if (_local2.isInitialized() && _local1.isRegistered()) {
            _local3 = _local5.getInstance(ShowPopupSignal);
            _local3.dispatch(new ShopPopupView());
        } else if (!_local1.isRegistered()) {
            _local4.dispatch(new RegisterPromptDialog("SellableObjectPanelMediator.text", {"type": Currency.typeToName(0)}));
        }
    }

    private function onAddedToStage(_arg_1:Event):void {
        stage.addEventListener("keyDown", this.onKeyDown);
        this.icon_.x = -4;
        this.icon_.y = -8;
        this.nameText_.x = 44;
    }

    private function onRemovedFromStage(_arg_1:Event):void {
        stage.removeEventListener("keyDown", this.onKeyDown);
        this.infoButton_.removeEventListener("click", this.onInfoButtonClick);
    }

    private function onInfoButtonClick(_arg_1:MouseEvent):void {
        this.onInfoButton();
    }

    private function onKeyDown(_arg_1:KeyboardEvent):void {
        if (_arg_1.keyCode == Parameters.data.interact && stage.focus == null) {
            this.onInfoButton();
        }
    }
}
}
