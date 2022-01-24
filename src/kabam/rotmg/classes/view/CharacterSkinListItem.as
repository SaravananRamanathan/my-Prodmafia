package kabam.rotmg.classes.view {
import com.company.util.MoreColorUtil;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.filters.ColorMatrixFilter;
import flash.filters.DropShadowFilter;
import flash.geom.ColorTransform;

import kabam.rotmg.classes.model.CharacterSkin;
import kabam.rotmg.classes.model.CharacterSkinState;
import kabam.rotmg.text.view.TextFieldDisplayConcrete;
import kabam.rotmg.text.view.stringBuilder.LineBuilder;
import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;
import kabam.rotmg.text.view.stringBuilder.StringBuilder;
import kabam.rotmg.util.components.RadioButton;
import kabam.rotmg.util.components.api.BuyButton;

import org.osflash.signals.Signal;
import org.osflash.signals.natives.NativeMappedSignal;

public class CharacterSkinListItem extends Sprite {

    public static const WIDTH:int = 420;

    public static const PADDING:int = 16;

    public static const HEIGHT:int = 60;

    private static const HIGHLIGHTED_COLOR:uint = 8092539;

    private static const AVAILABLE_COLOR:uint = 5921370;

    private static const LOCKED_COLOR:uint = 2631720;


    private const grayscaleMatrix:ColorMatrixFilter = new ColorMatrixFilter(MoreColorUtil.greyscaleFilterMatrix);

    private const background:Shape = makeBackground();

    private const skinContainer:Sprite = makeSkinContainer();

    private const nameText:TextFieldDisplayConcrete = makeNameText();

    private const selectionButton:RadioButton = makeSelectionButton();

    private const lock:Bitmap = makeLock();

    private const lockText:TextFieldDisplayConcrete = makeLockText();

    private const buyButtonContainer:Sprite = makeBuyButtonContainer();

    private const limitedBanner:CharacterSkinLimitedBanner = makeLimitedBanner();

    public const buy:Signal = new NativeMappedSignal(buyButtonContainer, "click");

    public const over:Signal = new Signal();

    public const out:Signal = new Signal();

    public const selected:Signal = selectionButton.changed;

    public function CharacterSkinListItem() {
        state = CharacterSkinState.NULL;
        super();
    }
    private var model:CharacterSkin;
    private var state:CharacterSkinState;
    private var isSelected:Boolean = false;
    private var skinIcon:Bitmap;
    private var buyButton:BuyButton;
    private var isOver:Boolean;

    public function setLockIcon(_arg_1:BitmapData):void {
        this.lock.bitmapData = _arg_1;
        this.lock.x = this.lockText.x - this.lock.width - 5;
        this.lock.y = 30 - this.lock.height * 0.5;
        addChild(this.lock);
    }

    public function setBuyButton(_arg_1:BuyButton):void {
        this.buyButton = _arg_1;
        _arg_1.readyForPlacement.add(this.onReadyForPlacement);
        this.model && this.setCost();
        this.buyButtonContainer.addChild(_arg_1);
        _arg_1.x = -_arg_1.width;
        _arg_1.y = -_arg_1.height * 0.5;
        this.buyButtonContainer.visible = this.state == CharacterSkinState.PURCHASABLE;
        this.setLimitedBannerVisibility();
    }

    public function setSkin(_arg_1:Bitmap):void {
        this.skinIcon && this.skinContainer.removeChild(this.skinIcon);
        this.skinIcon = _arg_1;
        addChild(this.skinIcon);
    }

    public function getModel():CharacterSkin {
        return this.model;
    }

    public function setModel(_arg_1:CharacterSkin):void {
        this.model && this.model.changed.remove(this.onModelChanged);
        this.model = _arg_1;
        this.model && this.model.changed.add(this.onModelChanged);
        this.onModelChanged(this.model);
        addEventListener("mouseOver", this.onOver);
        addEventListener("mouseOut", this.onOut);
    }

    public function getState():CharacterSkinState {
        return this.state;
    }

    public function getIsSelected():Boolean {
        return this.isSelected;
    }

    public function setIsSelected(_arg_1:Boolean):void {
        this.isSelected = _arg_1 && this.state == CharacterSkinState.OWNED;
        this.selectionButton.setSelected(_arg_1);
        this.updateBackground();
    }

    public function setWidth(_arg_1:int):void {
        this.buyButtonContainer.x = _arg_1 - 16;
        this.lockText.x = _arg_1 - this.lockText.width - 15;
        this.lock.x = this.lockText.x - this.lock.width - 5;
        this.selectionButton.x = _arg_1 - this.selectionButton.width - 15;
        this.setLimitedBannerVisibility();
        this.drawBackground(this.background.graphics, _arg_1);
    }

    internal function removeEventListeners():void {
        removeEventListener("click", this.onClick);
    }

    private function makeBackground():Shape {
        var _local1:Shape = new Shape();
        this.drawBackground(_local1.graphics, 7 * 60);
        addChild(_local1);
        return _local1;
    }

    private function makeSkinContainer():Sprite {
        var _local1:* = null;
        _local1 = new Sprite();
        _local1.x = 8;
        _local1.y = 4;
        addChild(_local1);
        return _local1;
    }

    private function makeNameText():TextFieldDisplayConcrete {
        var _local1:* = null;
        _local1 = new TextFieldDisplayConcrete().setSize(18).setColor(0xffffff).setBold(true);
        _local1.x = 75;
        _local1.y = 15;
        _local1.filters = [new DropShadowFilter(0, 0, 0, 1, 8, 8)];
        addChild(_local1);
        return _local1;
    }

    private function makeSelectionButton():RadioButton {
        var _local1:* = null;
        _local1 = new RadioButton();
        _local1.setSelected(false);
        _local1.x = 420 - _local1.width - 15;
        _local1.y = 30 - _local1.height / 2;
        addChild(_local1);
        return _local1;
    }

    private function makeLock():Bitmap {
        var _local1:Bitmap = new Bitmap();
        _local1.scaleX = 2;
        _local1.scaleY = 2;
        _local1.visible = false;
        addChild(_local1);
        return _local1;
    }

    private function makeLockText():TextFieldDisplayConcrete {
        var _local1:TextFieldDisplayConcrete = new TextFieldDisplayConcrete().setSize(14).setColor(0xffffff);
        _local1.setVerticalAlign("middle");
        addChild(_local1);
        return _local1;
    }

    private function makeBuyButtonContainer():Sprite {
        var _local1:Sprite = new Sprite();
        _local1.x = 404;
        _local1.y = 30;
        addChild(_local1);
        return _local1;
    }

    private function makeLimitedBanner():CharacterSkinLimitedBanner {
        var _local1:* = null;
        _local1 = new CharacterSkinLimitedBanner();
        _local1.readyForPositioning.addOnce(this.setLimitedBannerVisibility);
        _local1.y = -1;
        _local1.visible = false;
        addChild(_local1);
        return _local1;
    }

    private function onReadyForPlacement():void {
        this.buyButton.x = -this.buyButton.width;
    }

    private function onModelChanged(_arg_1:CharacterSkin):void {
        this.state = !!this.model ? this.model.getState() : CharacterSkinState.NULL;
        this.updateName();
        this.updateState();
        this.buyButton && this.setCost();
        this.updateUnlockText();
        this.setLimitedBannerVisibility();
        this.setIsSelected(this.model && this.model.getIsSelected());
    }

    private function updateName():void {
        this.nameText.setStringBuilder(new LineBuilder().setParams(!!this.model ? this.model.name : ""));
    }

    private function updateState():void {
        this.setButtonVisibilities();
        this.updateBackground();
        this.setEventListeners();
        this.updateGrayFilter();
    }

    private function setLimitedBannerVisibility():void {
        this.limitedBanner.visible = false; //this.model && this.model.limited && this.state != CharacterSkinState.OWNED && this.state != CharacterSkinState.PURCHASING;
        this.limitedBanner.x = (this.state == CharacterSkinState.LOCKED || !this.buyButton ? this.lock.x - 5 : Number(this.buyButtonContainer.x + this.buyButton.x - 15)) - this.limitedBanner.width;
    }

    private function setButtonVisibilities():void {
        var _local4:* = this.state == CharacterSkinState.OWNED;
        var _local2:* = this.state == CharacterSkinState.PURCHASABLE;
        var _local1:* = this.state == CharacterSkinState.PURCHASING;
        var _local3:* = this.state == CharacterSkinState.LOCKED;
        this.selectionButton.visible = _local4;
        this.lock.visible = _local3;
        this.lockText.visible = _local3 || _local1;
    }

    private function setEventListeners():void {
        if (this.state == CharacterSkinState.OWNED) {
            this.addEventListeners();
        } else {
            this.removeEventListeners();
        }
    }

    private function setCost():void {
        var _local1:int = !!this.model ? this.model.cost : 0;
        this.buyButton.setPrice(_local1, 0);
    }

    private function updateUnlockText():void {
        if (this.model != null && this.model.unlockSpecial != null) {
            this.lockText.setStringBuilder(new StaticStringBuilder(this.model.unlockSpecial));
            this.lockText.setTextWidth(110);
            this.lockText.setWordWrap(true);
            this.lockText.setMultiLine(true);
            this.lockText.setAutoSize("left");
            this.lockText.setHorizontalAlign("left");
            this.lockText.setVerticalAlign("center");
            this.lockText.y = 8.57142857142858;
        } else {
            this.lockText.setStringBuilder(this.state == CharacterSkinState.PURCHASING ? new LineBuilder().setParams("CharacterSkinListItem.purchasing") : this.makeUnlockTextStringBuilder());
            this.lockText.y = 30;
        }
        this.lockText.x = 420 - this.lockText.width - 15;
        this.lock.x = this.lockText.x - this.lock.width - 5;
    }

    private function makeUnlockTextStringBuilder():StringBuilder {
        var _local1:LineBuilder = new LineBuilder();
        var _local2:String = !!this.model ? this.model.unlockLevel.toString() : "";
        return _local1.setParams("CharacterSkinListItem.unlock", {"level": _local2});
    }

    private function addEventListeners():void {
        addEventListener("click", this.onClick);
    }

    private function updateBackground():void {
        var _local1:ColorTransform = this.background.transform.colorTransform;
        _local1.color = this.getColor();
        this.background.transform.colorTransform = _local1;
    }

    private function getColor():uint {
        if (this.state.isDisabled()) {
            return 0x282828;
        }
        if (this.isSelected || this.isOver) {
            return 0x7b7b7b;
        }
        return 0x5a5a5a;
    }

    private function updateGrayFilter():void {
        filters = this.state == CharacterSkinState.PURCHASING ? [this.grayscaleMatrix] : [];
    }

    private function drawBackground(_arg_1:Graphics, _arg_2:int):void {
        _arg_1.clear();
        _arg_1.beginFill(0x5a5a5a);
        _arg_1.drawRect(0, 0, _arg_2, 60);
        _arg_1.endFill();
    }

    private function onClick(_arg_1:MouseEvent):void {
        this.setIsSelected(true);
    }

    private function onOver(_arg_1:MouseEvent):void {
        this.isOver = true;
        this.updateBackground();
        this.over.dispatch();
    }

    private function onOut(_arg_1:MouseEvent):void {
        this.isOver = false;
        this.updateBackground();
        this.out.dispatch();
    }
}
}
