package kabam.rotmg.mysterybox.components {
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.ui.dialogs.Dialog;

import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.filters.ColorMatrixFilter;
import flash.filters.DropShadowFilter;
import flash.geom.Point;
import flash.utils.getTimer;

import kabam.rotmg.core.StaticInjectorContext;
import kabam.rotmg.dialogs.control.OpenDialogSignal;
import kabam.rotmg.mysterybox.model.MysteryBoxInfo;
import kabam.rotmg.pets.view.components.PopupWindowBackground;
import kabam.rotmg.text.view.TextFieldDisplayConcrete;
import kabam.rotmg.text.view.stringBuilder.LineBuilder;
import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;
import kabam.rotmg.util.components.LegacyBuyButton;
import kabam.rotmg.util.components.UIAssetsHelper;

public class MysteryBoxSelectEntry extends Sprite {

    private const newString:String = "MysteryBoxSelectEntry.newString";
    private const onSaleString:String = "MysteryBoxSelectEntry.onSaleString";
    private const saleEndString:String = "MysteryBoxSelectEntry.saleEndString";
    public static var redBarEmbed:Class = MysteryBoxSelectEntry_redBarEmbed;

    public function MysteryBoxSelectEntry(_arg_1:MysteryBoxInfo) {
        var _local2:* = null;
        super();
        this.redbar = new redBarEmbed();
        this.redbar.y = -5;
        this.redbar.width = MysteryBoxSelectModal.modalWidth - 5;
        this.redbar.height = MysteryBoxSelectModal.aMysteryBoxHeight - 8;
        addChild(this.redbar);
        _local2 = new redBarEmbed();
        _local2.y = 0;
        _local2.width = MysteryBoxSelectModal.modalWidth - 5;
        _local2.height = MysteryBoxSelectModal.aMysteryBoxHeight - 8 + 5;
        _local2.alpha = 0;
        addChild(_local2);
        this.mbi = _arg_1;
        this._quantity = 1;
        this.title = this.getText(this.mbi.title, 74, 20, 18, true);
        this.title.textChanged.addOnce(this.updateTextPosition);
        addChild(this.title);
        this.addNewText();
        this.buyButton = new LegacyBuyButton("", 16, 0, -1, false, this.mbi.isOnSale());
        if (this.mbi.unitsLeft == 0) {
            this.buyButton.setText(LineBuilder.getLocalizedStringFromKey("MysteryBoxError.soldOutButton"));
        } else if (this.mbi.isOnSale()) {
            this.buyButton.setPrice(this.mbi.saleAmount, this.mbi.saleCurrency);
        } else {
            this.buyButton.setPrice(this.mbi.priceAmount, this.mbi.priceCurrency);
        }
        this.buyButton.x = MysteryBoxSelectModal.modalWidth - 120;
        this.buyButton.y = 16;
        this.buyButton._width = 70;
        this.addSaleText();
        if (this.mbi.unitsLeft > 0 || this.mbi.unitsLeft == -1) {
            this.buyButton.addEventListener("click", this.onBoxBuy);
        }
        addChild(this.buyButton);
        this.iconImage = this.mbi.iconImage;
        this.infoImage = this.mbi.infoImage;
        if (this.iconImage == null) {
            this.mbi.loader.contentLoaderInfo.addEventListener("complete", this.onImageLoadComplete);
        } else {
            this.addIconImageChild();
        }
        if (this.infoImage == null) {
            this.mbi.infoImageLoader.contentLoaderInfo.addEventListener("complete", this.onInfoLoadComplete);
        } else {
            this.addInfoImageChild();
        }
        this.mbi.quantity = this._quantity;
        if (this.mbi.unitsLeft > 0 || this.mbi.unitsLeft == -1) {
            this.leftNavSprite = UIAssetsHelper.createLeftNevigatorIcon("left", 3);
            this.leftNavSprite.x = this.buyButton.x + this.buyButton.width + 45;
            this.leftNavSprite.y = this.buyButton.y + this.buyButton.height / 2 - 2;
            this.leftNavSprite.addEventListener("click", this.onClick);
            addChild(this.leftNavSprite);
            this.rightNavSprite = UIAssetsHelper.createLeftNevigatorIcon("right", 3);
            this.rightNavSprite.x = this.buyButton.x + this.buyButton.width + 45;
            this.rightNavSprite.y = this.buyButton.y + this.buyButton.height / 2 - 16;
            this.rightNavSprite.addEventListener("click", this.onClick);
            addChild(this.rightNavSprite);
        }
        this.addUnitsLeftText();
        addEventListener("rollOver", this.onHover);
        addEventListener("rollOut", this.onRemoveHover);
        addEventListener("enterFrame", this.onEnterFrame);
    }
    public var mbi:MysteryBoxInfo;
    private var buyButton:LegacyBuyButton;
    private var leftNavSprite:Sprite;
    private var rightNavSprite:Sprite;
    private var iconImage:DisplayObject;
    private var infoImageBorder:PopupWindowBackground;
    private var infoImage:DisplayObject;
    private var newText:TextFieldDisplayConcrete;
    private var sale:TextFieldDisplayConcrete;
    private var left:TextFieldDisplayConcrete;
    private var hoverState:Boolean = false;
    private var descriptionShowing:Boolean = false;
    private var redbar:DisplayObject;
    private var soldOut:Boolean;
    private var _quantity:int;
    private var title:TextFieldDisplayConcrete;

    public function updateContent():void {
        if (this.left) {
            this.left.setStringBuilder(new LineBuilder().setParams(this.mbi.unitsLeft + " " + LineBuilder.getLocalizedStringFromKey("MysteryBoxSelectEntry.left")));
        }
    }

    public function getText(_arg_1:String, _arg_2:int, _arg_3:int, _arg_4:int = 12, _arg_5:Boolean = false):TextFieldDisplayConcrete {
        var _local6:TextFieldDisplayConcrete = new TextFieldDisplayConcrete().setSize(_arg_4).setColor(0xffffff).setTextWidth(MysteryBoxSelectModal.modalWidth - 185);
        _local6.setBold(true);
        if (_arg_5) {
            _local6.setStringBuilder(new StaticStringBuilder(_arg_1));
        } else {
            _local6.setStringBuilder(new LineBuilder().setParams(_arg_1));
        }
        _local6.setWordWrap(true);
        _local6.setMultiLine(true);
        _local6.setAutoSize("left");
        _local6.setHorizontalAlign("left");
        _local6.filters = [new DropShadowFilter(0, 0, 0)];
        _local6.x = _arg_2;
        _local6.y = _arg_3;
        return _local6;
    }

    private function updateTextPosition():void {
        this.title.y = Math.round((this.redbar.height - (this.title.getTextHeight() + (this.title.textField.numLines == 1 ? 8 : 10))) / 2);
        if ((this.mbi.isNew() || this.mbi.isOnSale()) && this.title.textField.numLines == 2) {
            this.title.y = this.title.y + 6;
        }
    }

    private function addUnitsLeftText():void {
        var _local1:int = 0;
        var _local2:int = 0;
        if (this.mbi.unitsLeft >= 0) {
            _local2 = this.mbi.unitsLeft / this.mbi.totalUnits;
            if (_local2 <= 0.1) {
                _local1 = 0xff0000;
            } else if (_local2 <= 0.5) {
                _local1 = 16754944;
            } else {
                _local1 = 0xff00;
            }
            this.left = this.getText(this.mbi.unitsLeft + " left", 20, 46, 11).setColor(_local1);
            addChild(this.left);
        }
    }

    private function markAsSold():void {
        this.buyButton.setPrice(0, -1);
        this.buyButton.setText(LineBuilder.getLocalizedStringFromKey("MysteryBoxError.soldOutButton"));
        if (this.leftNavSprite && this.leftNavSprite.parent == this) {
            removeChild(this.leftNavSprite);
            this.leftNavSprite.removeEventListener("click", this.onClick);
        }
        if (this.rightNavSprite && this.rightNavSprite.parent == this) {
            removeChild(this.rightNavSprite);
            this.rightNavSprite.removeEventListener("click", this.onClick);
        }
    }

    private function addNewText():void {
        if (this.mbi.isNew() && !this.mbi.isOnSale()) {
            this.newText = this.getText("MysteryBoxSelectEntry.newString", 74, 0).setColor(16768512);
            addChild(this.newText);
        }
    }

    private function addSaleText():void {
        var _local1:* = null;
        if (this.mbi.isOnSale()) {
            this.sale = this.getText("MysteryBoxSelectEntry.onSaleString", 74, 0).setColor(0xff00);
            addChild(this.sale);
            _local1 = this.getText(LineBuilder.getLocalizedStringFromKey("MysteryBoxSelectEntry.was") + " " + this.mbi.priceAmount + " " + this.mbi.currencyName, this.buyButton.x, this.buyButton.y - 14, 10).setColor(0xff0000);
            addChild(_local1);
        }
    }

    private function addIconImageChild():void {
        if (this.iconImage == null) {
            return;
        }
        this.iconImage.width = 58;
        this.iconImage.height = 58;
        this.iconImage.x = 14;
        if (this.mbi.unitsLeft != -1) {
            this.iconImage.y = -6;
        } else {
            this.iconImage.y = 1;
        }
        addChild(this.iconImage);
    }

    private function addInfoImageChild():void {
        var _local1:* = null;
        var _local3:* = null;
        if (this.infoImage == null) {
            return;
        }
        this.infoImage.width = 283;
        this.infoImage.height = 580;
        var _local2:Point = this.globalToLocal(new Point(MysteryBoxSelectModal.getRightBorderX() + 1 + 14, 10));
        this.infoImage.x = _local2.x;
        this.infoImage.y = _local2.y;
        if (this.hoverState && !this.descriptionShowing) {
            this.descriptionShowing = true;
            addChild(this.infoImage);
            this.infoImageBorder = new PopupWindowBackground();
            this.infoImageBorder.draw(this.infoImage.width, this.infoImage.height + 2, 2);
            this.infoImageBorder.x = this.infoImage.x;
            this.infoImageBorder.y = this.infoImage.y - 1;
            addChild(this.infoImageBorder);
            _local1 = [3.0742, -1.8282, -0.246, 0, 50, -0.9258, 2.1718, -0.246, 0, 50, -0.9258, -1.8282, 3.754, 0, 50, 0, 0, 0, 1, 0];
            _local3 = new ColorMatrixFilter(_local1);
            this.redbar.filters = [_local3];
        }
    }

    private function removeInfoImageChild():void {
        if (this.descriptionShowing) {
            removeChild(this.infoImageBorder);
            removeChild(this.infoImage);
            this.descriptionShowing = false;
            this.redbar.filters = [];
        }
    }

    private function onHover(_arg_1:MouseEvent):void {
        this.hoverState = true;
        this.addInfoImageChild();
    }

    private function onRemoveHover(_arg_1:MouseEvent):void {
        this.hoverState = false;
        this.removeInfoImageChild();
    }

    private function onClick(_arg_1:MouseEvent):void {
        var _local2:* = _arg_1.currentTarget;
        switch (_local2) {
            case this.rightNavSprite:
                if (this._quantity == 1) {
                    this._quantity = this._quantity + 4;
                    break;
                }
                if (this._quantity < 10) {
                    this._quantity = this._quantity + 5;
                    break;
                }
                break;
            case this.leftNavSprite:
                if (this._quantity == 10) {
                    this._quantity = this._quantity - 5;
                    break;
                }
                if (this._quantity > 1) {
                    this._quantity = this._quantity - 4;
                    break;
                }
                break;
        }
        this.mbi.quantity = this._quantity;
        if (this.mbi.isOnSale()) {
            this.buyButton.setPrice(this.mbi.saleAmount * this._quantity, this.mbi.saleCurrency);
        } else {
            this.buyButton.setPrice(this.mbi.priceAmount * this._quantity, this.mbi.priceCurrency);
        }
    }

    private function onEnterFrame(_arg_1:Event):void {
        var _local2:Number = 1.05 + 0.05 * Math.sin(getTimer() / 200);
        if (this.sale) {
            this.sale.scaleX = _local2;
            this.sale.scaleY = _local2;
        }
        if (this.newText) {
            this.newText.scaleX = _local2;
            this.newText.scaleY = _local2;
        }
        if (this.mbi.unitsLeft == 0 && !this.soldOut) {
            this.soldOut = true;
            this.markAsSold();
        }
    }

    private function onImageLoadComplete(_arg_1:Event):void {
        this.mbi.loader.contentLoaderInfo.removeEventListener("complete", this.onImageLoadComplete);
        this.iconImage = DisplayObject(this.mbi.loader);
        this.addIconImageChild();
    }

    private function onInfoLoadComplete(_arg_1:Event):void {
        this.mbi.infoImageLoader.contentLoaderInfo.removeEventListener("complete", this.onInfoLoadComplete);
        this.infoImage = DisplayObject(this.mbi.infoImageLoader);
        this.addInfoImageChild();
    }

    private function onBoxBuy(_arg_1:MouseEvent):void {
        var _local2:* = null;
        var _local6:* = null;
        var _local4:* = null;
        var _local3:* = null;
        var _local5:Boolean = false;
        if (this.mbi.unitsLeft != -1 && this._quantity > this.mbi.unitsLeft) {
            _local2 = StaticInjectorContext.getInjector().getInstance(OpenDialogSignal);
            _local6 = "";
            if (this.mbi.unitsLeft == 0) {
                _local6 = "MysteryBoxError.soldOutAll";
            } else {
                _local6 = LineBuilder.getLocalizedStringFromKey("MysteryBoxError.soldOutLeft", {
                    "left": this.mbi.unitsLeft,
                    "box": (this.mbi.unitsLeft == 1 ? LineBuilder.getLocalizedStringFromKey("MysteryBoxError.box") : LineBuilder.getLocalizedStringFromKey("MysteryBoxError.boxes"))
                });
            }
            _local4 = new Dialog("MysteryBoxRollModal.purchaseFailedString", _local6, "MysteryBoxRollModal.okString", null, null);
            _local4.addEventListener("dialogLeftButton", this.onErrorOk);
            _local2.dispatch(_local4);
        } else {
            _local3 = new MysteryBoxRollModal(this.mbi, this._quantity);
            _local5 = _local3.moneyCheckPass();
            if (_local5) {
                _local3.parentSelectModal = MysteryBoxSelectModal(parent.parent);
                _local2 = StaticInjectorContext.getInjector().getInstance(OpenDialogSignal);
                _local2.dispatch(_local3);
            }
        }
    }

    private function onErrorOk(_arg_1:Event):void {
        var _local2:* = null;
        _local2 = StaticInjectorContext.getInjector().getInstance(OpenDialogSignal);
        _local2.dispatch(new MysteryBoxSelectModal());
    }
}
}
