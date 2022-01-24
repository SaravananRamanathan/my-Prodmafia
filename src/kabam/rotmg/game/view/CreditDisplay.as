package kabam.rotmg.game.view {
import com.company.assembleegameclient.game.GameSprite;
import com.company.assembleegameclient.util.FameUtil;
import com.company.assembleegameclient.util.TextureRedrawer;
import com.company.util.AssetLibrary;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;

import io.decagames.rotmg.fame.FameContentPopup;
import io.decagames.rotmg.ui.buttons.SliceScalingButton;
import io.decagames.rotmg.ui.popups.signals.ShowPopupSignal;
import io.decagames.rotmg.ui.texture.TextureParser;

import kabam.rotmg.core.StaticInjectorContext;
import kabam.rotmg.text.view.TextFieldDisplayConcrete;
import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;
import kabam.rotmg.ui.view.SignalWaiter;

import org.osflash.signals.Signal;
import org.swiftsuspenders.Injector;

public class CreditDisplay extends Sprite {
    private static const FONT_SIZE:int = 18;
    public static const IMAGE_NAME:String = "lofiObj3";
    public static const IMAGE_ID:int = 225;
    public static const waiter:SignalWaiter = new SignalWaiter();

    public var gs:GameSprite;
    public var openAccountDialog:Signal;
    public var displayFameTooltip:Signal;
    public var resourcePadding:int;
    public var _creditsButton:SliceScalingButton;

    private var creditsText_:TextFieldDisplayConcrete;
    private var fameText_:TextFieldDisplayConcrete;
    private var coinIcon_:Bitmap;
    private var fameIcon_:Bitmap;
    private var credits_:int = -1;
    private var fame_:int = -1;
    private var displayFame_:Boolean = true;

    public function CreditDisplay(_arg_1:GameSprite = null, _arg_2:Boolean = true, _arg_4:Number = 0) {
        var _local6:* = null;
        openAccountDialog = new Signal();
        displayFameTooltip = new Signal();
        super();
        this.displayFame_ = _arg_2;
        this.gs = _arg_1;
        this.creditsText_ = this.makeTextField();
        waiter.push(this.creditsText_.textChanged);
        addChild(this.creditsText_);
        var _local5:BitmapData = AssetLibrary.getImageFromSet("lofiObj3", 225);
        _local5 = TextureRedrawer.redraw(_local5, 40, true, 0);
        this.coinIcon_ = new Bitmap(_local5);
        addChild(this.coinIcon_);
        if (this.displayFame_) {
            this.fameText_ = this.makeTextField();
            waiter.push(this.fameText_.textChanged);
            addChild(this.fameText_);
            this.fameIcon_ = new Bitmap(FameUtil.getFameIcon());
            addChild(this.fameIcon_);
        }
        this.draw(0, 0, 0);
        waiter.complete.add(this.onAlignHorizontal);
    }

    public function get creditsButton():SliceScalingButton {
        return this._creditsButton;
    }

    public var _fameButton:SliceScalingButton;

    public function get fameButton():SliceScalingButton {
        return this._fameButton;
    }

    public function addResourceButtons():void {
        this.resourcePadding = 30;
        this._creditsButton = new SliceScalingButton(TextureParser.instance.getSliceScalingBitmap("UI", "resourcesAddButton"));
        this._fameButton = new SliceScalingButton(TextureParser.instance.getSliceScalingBitmap("UI", "tab_info_button"));
        addChild(this._creditsButton);
        addChild(this._fameButton);
    }

    public function removeResourceButtons():void {
        this.resourcePadding = 5;
        if (this._creditsButton) {
            removeChild(this._creditsButton);
        }
        if (this._fameButton) {
            removeChild(this._fameButton);
        }
    }

    public function makeTextField(_arg_1:uint = 16777215):TextFieldDisplayConcrete {
        var _local2:TextFieldDisplayConcrete = new TextFieldDisplayConcrete().setSize(18).setColor(_arg_1).setTextHeight(16);
        _local2.filters = [new DropShadowFilter(0, 0, 0, 1, 4, 4, 2)];
        _local2.mouseChildren = false;
        return _local2;
    }

    public function draw(_arg_1:int, _arg_2:int, _arg_3:int = 0):void {
        if (_arg_1 == this.credits_ && (this.displayFame_ && _arg_2 == this.fame_)) {
            return;
        }
        this.credits_ = _arg_1;
        this.creditsText_.setStringBuilder(new StaticStringBuilder(this.credits_.toString()));
        if (this.displayFame_) {
            this.fame_ = _arg_2;
            this.fameText_.setStringBuilder(new StaticStringBuilder(this.fame_.toString()));
        }
        if (waiter.isEmpty()) {
            this.onAlignHorizontal();
        }
    }

    private function onAlignHorizontal():void {
            this.coinIcon_.x = -this.coinIcon_.width;
            this.creditsText_.x = this.coinIcon_.x - this.creditsText_.width + 8;
            this.creditsText_.y = this.coinIcon_.y + this.coinIcon_.height / 2 - this.creditsText_.height / 2;
        if (this._creditsButton) {
            this._creditsButton.x = this.coinIcon_.x - this.creditsText_.width - 16;
            this._creditsButton.y = 7;
        }
        if (this.displayFame_) {
            this.fameIcon_.x = this.creditsText_.x - this.fameIcon_.width - this.resourcePadding;
            this.fameText_.x = this.fameIcon_.x - this.fameText_.width + 8;
            this.fameText_.y = this.fameIcon_.y + this.fameIcon_.height / 2 - this.fameText_.height / 2;
            if (this._fameButton) {
                this._fameButton.x = this.fameIcon_.x - this.fameText_.width - 16;
                this._fameButton.y = 7;
            }
        }
    }

    private function onFameMask():void {
        var _local1:Injector = StaticInjectorContext.getInjector();
        var _local2:ShowPopupSignal = _local1.getInstance(ShowPopupSignal);
        _local2.dispatch(new FameContentPopup());
    }

    public function onFameClick(_arg_1:MouseEvent):void {
        this.onFameMask();
    }

    public function onCreditsClick(_arg_1:MouseEvent):void {
        if (!this.gs || this.gs.evalIsNotInCombatMapArea()) {
            this.openAccountDialog.dispatch();
        }
    }
}
}
