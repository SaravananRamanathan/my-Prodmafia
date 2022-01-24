package kabam.rotmg.mysterybox.components {
import com.company.assembleegameclient.map.ParticleModalMap;
import com.company.assembleegameclient.objects.ObjectLibrary;
import com.company.assembleegameclient.objects.Player;
import com.company.assembleegameclient.ui.dialogs.Dialog;
import com.gskinner.motion.GTween;
import com.gskinner.motion.easing.Sine;

import flash.display.Bitmap;
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.filters.DropShadowFilter;
import flash.filters.GlowFilter;
import flash.utils.Timer;

import io.decagames.rotmg.pets.utils.PetsViewAssetFactory;
import io.decagames.rotmg.shop.ShopPopupView;
import io.decagames.rotmg.ui.popups.signals.ShowPopupSignal;

import kabam.rotmg.account.core.Account;
import kabam.rotmg.appengine.api.AppEngineClient;
import kabam.rotmg.assets.EmbeddedAssets;
import kabam.rotmg.core.StaticInjectorContext;
import kabam.rotmg.core.model.PlayerModel;
import kabam.rotmg.dialogs.control.OpenDialogSignal;
import kabam.rotmg.game.model.GameModel;
import kabam.rotmg.mysterybox.model.MysteryBoxInfo;
import kabam.rotmg.mysterybox.services.GetMysteryBoxesTask;
import kabam.rotmg.pets.view.components.DialogCloseButton;
import kabam.rotmg.pets.view.components.PopupWindowBackground;
import kabam.rotmg.text.view.TextFieldDisplayConcrete;
import kabam.rotmg.text.view.stringBuilder.LineBuilder;
import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;
import kabam.rotmg.ui.view.NotEnoughGoldDialog;
import kabam.rotmg.ui.view.components.Spinner;
import kabam.rotmg.util.components.ItemWithTooltip;
import kabam.rotmg.util.components.LegacyBuyButton;
import kabam.rotmg.util.components.UIAssetsHelper;

import org.swiftsuspenders.Injector;

public class MysteryBoxRollModal extends Sprite {

    public static const WIDTH:int = 415;

    public static const HEIGHT:int = 400;

    public static const TEXT_MARGIN:int = 20;
    private const ROLL_STATE:int = 1;
    private const IDLE_STATE:int = 0;
    private const iconSize:Number = 160;
    private const playAgainString:String = "MysteryBoxRollModal.playAgainString";
    private const playAgainXTimesString:String = "MysteryBoxRollModal.playAgainXTimesString";
    private const youWonString:String = "MysteryBoxRollModal.youWonString";
    private const rewardsInVaultString:String = "MysteryBoxRollModal.rewardsInVaultString";
    public static var open:Boolean;

    private static function makeModalBackground(_arg_1:int, _arg_2:int):PopupWindowBackground {
        var _local3:PopupWindowBackground = new PopupWindowBackground();
        _local3.draw(_arg_1, _arg_2, 1);
        return _local3;
    }

    public function MysteryBoxRollModal(_arg_1:MysteryBoxInfo, _arg_2:int) {
        var _local3:int = 0;
        spinners = new Sprite();
        itemBitmaps = new Vector.<Bitmap>();
        rewardsArray = new Vector.<ItemWithTooltip>();
        closeButton = PetsViewAssetFactory.returnCloseButton(415);
        boxButton = new LegacyBuyButton("MysteryBoxRollModal.playAgainString", 16, 0, -1);
        descTexts = new Vector.<TextFieldDisplayConcrete>();
        swapImageTimer = new Timer(50);
        totalRollTimer = new Timer(2000);
        nextRollTimer = new Timer(800);
        indexInRolls = new Vector.<int>();
        goldBackground = new EmbeddedAssets.EvolveBackground();
        goldBackgroundMask = new EmbeddedAssets.EvolveBackground();
        super();
        this.mbi = _arg_1;
        this.closeButton.disableLegacyCloseBehavior();
        this.closeButton.addEventListener("click", this.onCloseClick);
        addEventListener("removedFromStage", this.onRemovedFromStage);
        this.infoText = this.getText("MysteryBoxRollModal.rewardsInVaultString", 20, 220).setSize(20).setColor(0);
        this.infoText.y = 40;
        this.infoText.filters = [];
        this.addComponemts();
        open = true;
        this.boxButton.x = this.boxButton.x + 107.5;
        this.boxButton.y = this.boxButton.y + 357;
        this.boxButton._width = 200;
        this.boxButton.addEventListener("click", this.onRollClick);
        this.minusNavSprite = UIAssetsHelper.createLeftNevigatorIcon("left", 3);
        this.minusNavSprite.addEventListener("click", this.onNavClick);
        this.minusNavSprite.filters = [new GlowFilter(0, 1, 2, 2, 10, 1)];
        this.minusNavSprite.x = 317.5;
        this.minusNavSprite.y = 365;
        this.minusNavSprite.alpha = 0;
        addChild(this.minusNavSprite);
        this.plusNavSprite = UIAssetsHelper.createLeftNevigatorIcon("right", 3);
        this.plusNavSprite.addEventListener("click", this.onNavClick);
        this.plusNavSprite.filters = [new GlowFilter(0, 1, 2, 2, 10, 1)];
        this.plusNavSprite.x = 317.5;
        this.plusNavSprite.y = 350;
        this.plusNavSprite.alpha = 0;
        addChild(this.plusNavSprite);
        var _local4:Injector = StaticInjectorContext.getInjector();
        this.client = _local4.getInstance(AppEngineClient);
        this.account = _local4.getInstance(Account);
        while (_local3 < this.mbi._rollsWithContents.length) {
            this.indexInRolls.push(0);
            _local3++;
        }
        this.centerModal();
        this.configureRollByQuantity(_arg_2);
        this.sendRollRequest();
    }
    public var client:AppEngineClient;
    public var account:Account;
    public var parentSelectModal:MysteryBoxSelectModal;
    private var state:int;
    private var isShowReward:Boolean = false;
    private var rollCount:int = 0;
    private var rollTarget:int = 0;
    private var quantity_:int = 0;
    private var mbi:MysteryBoxInfo;
    private var spinners:Sprite;
    private var itemBitmaps:Vector.<Bitmap>;
    private var rewardsArray:Vector.<ItemWithTooltip>;
    private var closeButton:DialogCloseButton;
    private var particleModalMap:ParticleModalMap;
    private var minusNavSprite:Sprite;
    private var plusNavSprite:Sprite;
    private var boxButton:LegacyBuyButton;
    private var titleText:TextFieldDisplayConcrete;
    private var infoText:TextFieldDisplayConcrete;
    private var descTexts:Vector.<TextFieldDisplayConcrete>;
    private var swapImageTimer:Timer;
    private var totalRollTimer:Timer;
    private var nextRollTimer:Timer;
    private var indexInRolls:Vector.<int>;
    private var lastReward:String = "";
    private var requestComplete:Boolean = false;
    private var timerComplete:Boolean = false;
    private var goldBackground:DisplayObject;
    private var goldBackgroundMask:DisplayObject;
    private var rewardsList:Array;

    public function getText(_arg_1:String, _arg_2:int, _arg_3:int, _arg_4:Boolean = false):TextFieldDisplayConcrete {
        var _local5:TextFieldDisplayConcrete = new TextFieldDisplayConcrete().setSize(16).setColor(0xffffff).setTextWidth(375);
        _local5.setBold(true);
        if (_arg_4) {
            _local5.setStringBuilder(new StaticStringBuilder(_arg_1));
        } else {
            _local5.setStringBuilder(new LineBuilder().setParams(_arg_1));
        }
        _local5.setWordWrap(true);
        _local5.setMultiLine(true);
        _local5.setAutoSize("center");
        _local5.setHorizontalAlign("center");
        _local5.filters = [new DropShadowFilter(0, 0, 0)];
        _local5.x = _arg_2;
        _local5.y = _arg_3;
        return _local5;
    }

    public function moneyCheckPass():Boolean {
        var _local6:int = 0;
        var _local2:int = 0;
        var _local4:* = null;
        var _local7:* = null;
        var _local3:int = 0;
        var _local8:int = 0;
        if (this.mbi.isOnSale() && this.mbi.saleAmount > 0) {
            _local6 = this.mbi.saleCurrency;
            _local2 = this.mbi.saleAmount * this.quantity_;
        } else {
            _local6 = this.mbi.priceCurrency;
            _local2 = this.mbi.priceAmount * this.quantity_;
        }
        var _local1:Boolean = true;
        var _local5:Player = StaticInjectorContext.getInjector().getInstance(GameModel).player;
        if (_local5 != null) {
            _local8 = _local5.credits_;
            _local3 = _local5.fame_;
        } else {
            _local7 = StaticInjectorContext.getInjector().getInstance(PlayerModel);
            if (_local7 != null) {
                _local8 = _local7.getCredits();
                _local3 = _local7.getFame();
            }
        }
        if (_local6 == 0 && _local8 < _local2) {
            _local4 = StaticInjectorContext.getInjector().getInstance(ShowPopupSignal);
            _local4.dispatch(new NotEnoughGoldDialog());
            _local1 = false;
        } else if (_local6 == 1 && _local3 < _local2) {
            _local4 = StaticInjectorContext.getInjector().getInstance(ShowPopupSignal);
            _local4.dispatch(new NotEnoughGoldDialog());
            _local1 = false;
        }
        return _local1;
    }

    private function configureRollByQuantity(_arg_1:int):void {
        var _local2:int = 0;
        var _local3:int = 0;
        this.quantity_ = _arg_1;
        switch (int(_arg_1) - 1) {
            case 0:
                this.rollCount = 1;
                this.rollTarget = 1;
                this.swapImageTimer.delay = 50;
                this.totalRollTimer.delay = 2000;
                break;
            default:
                this.rollCount = 1;
                this.rollTarget = 1;
                this.swapImageTimer.delay = 50;
                this.totalRollTimer.delay = 2000;
                break;
            case 4:
                this.rollCount = 0;
                this.rollTarget = 4;
                this.swapImageTimer.delay = 50;
                this.totalRollTimer.delay = 1000;
                break;
            case 9:
                this.rollCount = 0;
                this.rollTarget = 9;
                this.swapImageTimer.delay = 50;
                this.totalRollTimer.delay = 1000;
        }
        if (this.mbi.isOnSale()) {
            _local2 = this.mbi.saleAmount * this.quantity_;
            _local3 = this.mbi.saleCurrency;
        } else {
            _local2 = this.mbi.priceAmount * this.quantity_;
            _local3 = this.mbi.priceCurrency;
        }
        if (this.quantity_ == 1) {
            this.boxButton.setPrice(_local2, this.mbi.priceCurrency);
        } else {
            this.boxButton.currency = _local3;
            this.boxButton.price = _local2;
            this.boxButton.setStringBuilder(new LineBuilder().setParams("MysteryBoxRollModal.playAgainXTimesString", {
                "cost": _local2.toString(),
                "repeat": this.quantity_.toString()
            }));
        }
    }

    private function addComponemts():void {
        var _local3:* = 27;
        this.goldBackground.y = _local3;
        this.goldBackgroundMask.y = _local3;
        _local3 = 1;
        this.goldBackground.x = _local3;
        this.goldBackgroundMask.x = _local3;
        _local3 = 414;
        this.goldBackground.width = _local3;
        this.goldBackgroundMask.width = _local3;
        _local3 = 372;
        this.goldBackground.height = _local3;
        this.goldBackgroundMask.height = _local3;
        addChild(this.goldBackground);
        addChild(this.goldBackgroundMask);
        var _local1:Spinner = new Spinner();
        var _local5:Spinner = new Spinner();
        _local1.degreesPerSecond = 50;
        _local5.degreesPerSecond = _local1.degreesPerSecond * 1.5;
        _local5.width = _local1.width * 0.7;
        _local5.height = _local1.height * 0.7;
        _local3 = 0.7;
        _local1.alpha = _local3;
        _local5.alpha = _local3;
        this.spinners.addChild(_local1);
        this.spinners.addChild(_local5);
        this.spinners.mask = this.goldBackgroundMask;
        this.spinners.x = 207.5;
        this.spinners.y = 173.333333333333;
        this.spinners.alpha = 0;
        addChild(this.spinners);
        addChild(makeModalBackground(415, 400));
        addChild(this.closeButton);
        this.particleModalMap = new ParticleModalMap(2);
        addChild(this.particleModalMap);
    }

    private function sendRollRequest():void {
        if (!this.moneyCheckPass()) {
            return;
        }
        this.state = 1;
        this.closeButton.visible = false;
        var _local1:Object = this.account.getCredentials();
        _local1.boxId = this.mbi.id;
        if (this.mbi.isOnSale()) {
            _local1.quantity = this.quantity_;
            _local1.price = this.mbi.saleAmount;
            _local1.currency = this.mbi.saleCurrency;
        } else {
            _local1.quantity = this.quantity_;
            _local1.price = this.mbi.priceAmount;
            _local1.currency = this.mbi.priceCurrency;
        }
        this.client.sendRequest("/account/purchaseMysteryBox", _local1);
        this.titleText = this.getText(this.mbi.title, 20, 6, true).setSize(18);
        this.titleText.setColor(16768512);
        addChild(this.titleText);
        addChild(this.infoText);
        this.playRollAnimation();
        this.lastReward = "";
        this.rewardsList = [];
        this.requestComplete = false;
        this.timerComplete = false;
        this.totalRollTimer.addEventListener("timer", this.onTotalRollTimeComplete);
        this.totalRollTimer.start();
        this.client.complete.addOnce(this.onComplete);
    }

    private function playRollAnimation():void {
        var _local2:* = null;
        var _local1:int = 0;
        while (_local1 < this.mbi._rollsWithContents.length) {
            _local2 = new Bitmap(ObjectLibrary.getRedrawnTextureFromType(this.mbi._rollsWithContentsUnique[this.indexInRolls[_local1]], 160, true));
            this.itemBitmaps.push(_local2);
            _local1++;
        }
        this.displayItems(this.itemBitmaps);
        this.swapImageTimer.addEventListener("timer", this.swapItemImage);
        this.swapImageTimer.start();
    }

    private function prepareNextRoll():void {
        this.titleText = this.getText(this.mbi.title, 20, 6, true).setSize(18);
        this.titleText.setColor(16768512);
        addChild(this.titleText);
        addChild(this.infoText);
        this.playRollAnimation();
        this.timerComplete = false;
        this.lastReward = this.rewardsList[0];
        this.totalRollTimer.addEventListener("timer", this.onTotalRollTimeComplete);
        this.totalRollTimer.start();
    }

    private function displayItems(_arg_1:Vector.<Bitmap>):void {
        var _local2:* = null;
        switch (int(_arg_1.length) - 1) {
            case 0:
                _arg_1[0].x = _arg_1[0].x + 167.5;
                _arg_1[0].y = _arg_1[0].y + 133.333333333333;
                break;
            case 1:
                _arg_1[0].x = _arg_1[0].x + 227.5;
                _arg_1[0].y = _arg_1[0].y + 133.333333333333;
                _arg_1[1].x = _arg_1[1].x + 107.5;
                _arg_1[1].y = _arg_1[1].y + 133.333333333333;
                break;
            case 2:
                _arg_1[0].x = _arg_1[0].x + 67.5;
                _arg_1[0].y = _arg_1[0].y + 133.333333333333;
                _arg_1[1].x = _arg_1[1].x + 167.5;
                _arg_1[1].y = _arg_1[1].y + 133.333333333333;
                _arg_1[2].x = _arg_1[2].x + 267.5;
                _arg_1[2].y = _arg_1[2].y + 133.333333333333;
        }
        var _local4:int = 0;
        var _local3:* = _arg_1;
        for each(_local2 in _arg_1) {
            addChild(_local2);
        }
    }

    private function onComplete(_arg_1:Boolean, _arg_2:*):void {
        var _local12:* = null;
        var _local4:* = null;
        var _local6:* = null;
        var _local10:* = null;
        var _local15:* = null;
        var _local8:* = null;
        var _local7:* = null;
        var _local9:* = null;
        var _local14:* = null;
        var _local16:* = null;
        var _local5:int = 0;
        var _local3:* = null;
        var _local11:int = 0;
        var _local13:* = null;
        this.requestComplete = true;
        if (_arg_1) {
            _local12 = new XML(_arg_2);
            var _local18:int = 0;
            var _local17:* = _local12.elements("Awards");
            for each(_local4 in _local12.elements("Awards")) {
                this.rewardsList.push(_local4.toString());
            }
            this.lastReward = this.rewardsList[0];
            if (this.timerComplete) {
                this.showReward();
            }
            if (_local12.hasOwnProperty("Left") && this.mbi.unitsLeft != -1) {
                this.mbi.unitsLeft = _local12.Left;
            }
            _local6 = StaticInjectorContext.getInjector().getInstance(GameModel).player;
            if (_local6 != null) {
                if (_local12.hasOwnProperty("Gold")) {
                    _local6.setCredits(_local12.Gold);
                } else if (_local12.hasOwnProperty("Fame")) {
                    _local6.fame_ = _local12.Fame;
                }
            } else {
                _local10 = StaticInjectorContext.getInjector().getInstance(PlayerModel);
                if (_local10 != null) {
                    if (_local12.hasOwnProperty("Gold")) {
                        _local10.setCredits(_local12.Gold);
                    } else if (_local12.hasOwnProperty("Fame")) {
                        _local10.setFame(_local12.Fame);
                    }
                }
            }
            if (_local12.hasOwnProperty("PurchaseLeft") && this.mbi.purchaseLeft != -1) {
                this.mbi.purchaseLeft = _local12.PurchaseLeft;
            }
        } else {
            this.totalRollTimer.removeEventListener("timer", this.onTotalRollTimeComplete);
            this.totalRollTimer.stop();
            _local15 = StaticInjectorContext.getInjector().getInstance(OpenDialogSignal);
            _local8 = "MysteryBoxRollModal.pleaseTryAgainString";
            if (LineBuilder.getLocalizedStringFromKey(_arg_2) != "") {
                _local8 = _arg_2;
            }
            if (_arg_2.indexOf("MysteryBoxError.soldOut") >= 0) {
                _local16 = _arg_2.split("|");
                if (_local16.length == 2) {
                    _local5 = _local16[1];
                    if (_local5 == 0) {
                        _local8 = "MysteryBoxError.soldOutAll";
                    } else {
                        _local8 = LineBuilder.getLocalizedStringFromKey("MysteryBoxError.soldOutLeft", {
                            "left": this.mbi.unitsLeft,
                            "box": (this.mbi.unitsLeft == 1 ? LineBuilder.getLocalizedStringFromKey("MysteryBoxError.box") : LineBuilder.getLocalizedStringFromKey("MysteryBoxError.boxes"))
                        });
                    }
                }
            }
            if (_arg_2.indexOf("MysteryBoxError.maxPurchase") >= 0) {
                _local3 = _arg_2.split("|");
                if (_local3.length == 2) {
                    _local11 = _local3[1];
                    if (_local11 == 0) {
                        _local8 = "MysteryBoxError.maxPurchase";
                    } else {
                        _local8 = LineBuilder.getLocalizedStringFromKey("MysteryBoxError.maxPurchaseLeft", {"left": _local11});
                    }
                }
            }
            if (_arg_2.indexOf("blockedForUser") >= 0) {
                _local13 = _arg_2.split("|");
                if (_local13.length == 2) {
                    _local8 = LineBuilder.getLocalizedStringFromKey("MysteryBoxError.blockedForUser", {"date": _local13[1]});
                }
            }
            _local7 = new Dialog("MysteryBoxRollModal.purchaseFailedString", _local8, "MysteryBoxRollModal.okString", null, null);
            _local7.addEventListener("dialogLeftButton", this.onErrorOk);
            _local15.dispatch(_local7);
            _local9 = StaticInjectorContext.getInjector();
            _local14 = _local9.getInstance(GetMysteryBoxesTask);
            _local14.start();
            this.close(true);
        }
    }

    private function close(_arg_1:Boolean = false):void {
        var _local2:* = null;
        if (this.state == 1) {
            return;
        }
        if (!_arg_1) {
            _local2 = StaticInjectorContext.getInjector().getInstance(OpenDialogSignal);
            if (this.parentSelectModal != null) {
                this.parentSelectModal.updateContent();
                _local2.dispatch(this.parentSelectModal);
            } else {
                _local2.dispatch(new ShopPopupView());
            }
        }
        open = false;
    }

    private function showReward():void {
        var _local3:int = 0;
        var _local4:* = null;
        var _local5:* = null;
        this.swapImageTimer.removeEventListener("timer", this.swapItemImage);
        this.swapImageTimer.stop();
        this.state = 0;
        if (this.rollCount < this.rollTarget) {
            this.nextRollTimer.addEventListener("timer", this.onNextRollTimerComplete);
            this.nextRollTimer.start();
        }
        this.closeButton.visible = true;
        var _local6:String = this.rewardsList.shift();
        var _local2:Array = _local6.split(",");
        removeChild(this.infoText);
        this.titleText.setStringBuilder(new LineBuilder().setParams("MysteryBoxRollModal.youWonString"));
        this.titleText.setColor(16768512);
        var _local1:int = 40;
        var _local8:int = 0;
        var _local7:* = _local2;
        for each(_local4 in _local2) {
            _local5 = this.getText(ObjectLibrary.typeToDisplayId_[_local4], 20, _local1).setSize(16).setColor(0);
            _local5.filters = [];
            _local5.setSize(18);
            _local5.x = 20;
            addChild(_local5);
            this.descTexts.push(_local5);
            _local1 = _local1 + 25;
        }
        _local3 = 0;
        while (_local3 < _local2.length) {
            if (_local3 < this.itemBitmaps.length) {
                this.itemBitmaps[_local3].bitmapData = new Bitmap(ObjectLibrary.getRedrawnTextureFromType(_local2[_local3], 160, true)).bitmapData;
            }
            _local3++;
        }
        _local3 = 0;
        while (_local3 < this.itemBitmaps.length) {
            this.doEaseInAnimation(this.itemBitmaps[_local3], {
                "scaleX": 1.25,
                "scaleY": 1.25
            }, {
                "scaleX": 1,
                "scaleY": 1
            });
            _local3++;
        }
        this.boxButton.alpha = 0;
        addChild(this.boxButton);
        if (this.rollCount == this.rollTarget) {
            this.doEaseInAnimation(this.boxButton, {"alpha": 0}, {"alpha": 1});
            this.doEaseInAnimation(this.minusNavSprite, {"alpha": 0}, {"alpha": 1});
            this.doEaseInAnimation(this.plusNavSprite, {"alpha": 0}, {"alpha": 1});
        }
        this.doEaseInAnimation(this.spinners, {"alpha": 0}, {"alpha": 1});
        this.isShowReward = true;
    }

    private function doEaseInAnimation(_arg_1:DisplayObject, _arg_2:Object = null, _arg_3:Object = null):void {
        var _local4:GTween = new GTween(_arg_1, 0.5, _arg_2, {"ease": Sine.easeOut});
        _local4.nextTween = new GTween(_arg_1, 0.5, _arg_3, {"ease": Sine.easeIn});
        _local4.nextTween.paused = true;
    }

    private function shelveReward():void {
        var _local2:* = null;
        var _local1:int = 0;
        var _local3:int = 0;
        var _local8:int = 0;
        var _local5:int = 0;
        var _local4:int = 0;
        var _local7:int = 0;
        var _local6:Array = this.lastReward.split(",");
        if (_local6.length > 0) {
            _local2 = new ItemWithTooltip(_local6[0], 64);
            _local1 = 56;
            _local3 = 350;
            _local2.x = 5 + _local3 * (int(this.rollCount / 5));
            _local2.y = 80 + _local1 * (this.rollCount % 5);
            _local8 = 167.5 + this.itemBitmaps[0].width * 0.5;
            _local5 = 133.333333333333 + this.itemBitmaps[0].height * 0.5;
            _local4 = _local2.x + _local2.height * 0.5;
            _local7 = 100 + _local1 * (this.rollCount % 5) + 23.3333333333333;
            this.particleModalMap.doLightning(_local8, _local5, _local4, _local7, 115, 15787660, 0.2);
            addChild(_local2);
            this.rewardsArray.push(_local2);
        }
    }

    private function clearReward():void {
        var _local1:* = null;
        var _local2:* = null;
        this.spinners.alpha = 0;
        this.minusNavSprite.alpha = 0;
        this.plusNavSprite.alpha = 0;
        removeChild(this.titleText);
        var _local4:int = 0;
        var _local3:* = this.descTexts;
        for each(_local1 in this.descTexts) {
            removeChild(_local1);
        }
        while (this.descTexts.length > 0) {
            this.descTexts.pop();
        }
        removeChild(this.boxButton);
        var _local6:int = 0;
        var _local5:* = this.itemBitmaps;
        for each(_local2 in this.itemBitmaps) {
            removeChild(_local2);
        }
        while (this.itemBitmaps.length > 0) {
            this.itemBitmaps.pop();
        }
    }

    private function clearShelveReward():void {
        var _local1:* = null;
        var _local3:int = 0;
        var _local2:* = this.rewardsArray;
        for each(_local1 in this.rewardsArray) {
            removeChild(_local1);
        }
        while (this.rewardsArray.length > 0) {
            this.rewardsArray.pop();
        }
    }

    private function centerModal():void {
        x = WebMain.STAGE.stageWidth / 2 - 207.5;
        y = WebMain.STAGE.stageHeight / 2 - 200;
    }

    public function onCloseClick(_arg_1:MouseEvent):void {
        this.close();
    }

    private function onTotalRollTimeComplete(_arg_1:TimerEvent):void {
        this.totalRollTimer.stop();
        this.timerComplete = true;
        if (this.requestComplete) {
            this.showReward();
        }
        this.totalRollTimer.removeEventListener("timer", this.onTotalRollTimeComplete);
    }

    private function onNextRollTimerComplete(_arg_1:TimerEvent):void {
        this.nextRollTimer.stop();
        this.nextRollTimer.removeEventListener("timer", this.onNextRollTimerComplete);
        this.shelveReward();
        this.clearReward();
        this.rollCount++;
        this.prepareNextRoll();
    }

    private function swapItemImage(_arg_1:TimerEvent):void {
        var _local2:int = 0;
        this.swapImageTimer.stop();
        while (_local2 < this.indexInRolls.length) {
            if (this.indexInRolls[_local2] < this.mbi._rollsWithContentsUnique.length - 1) {
                var _local3:* = this.indexInRolls;
                var _local4:* = _local2;
                var _local5:* = Number(_local3[_local4]) + 1;
                _local3[_local4] = _local5;
            } else {
                this.indexInRolls[_local2] = 0;
            }
            this.itemBitmaps[_local2].bitmapData = new Bitmap(ObjectLibrary.getRedrawnTextureFromType(this.mbi._rollsWithContentsUnique[this.indexInRolls[_local2]], 160, true)).bitmapData;
            _local2++;
        }
        this.swapImageTimer.start();
    }

    private function onErrorOk(_arg_1:Event):void {
        var _local2:* = null;
        _local2 = StaticInjectorContext.getInjector().getInstance(OpenDialogSignal);
        _local2.dispatch(new MysteryBoxSelectModal());
    }

    private function onRemovedFromStage(_arg_1:Event):void {
        open = false;
    }

    private function onNavClick(_arg_1:MouseEvent):void {
        if (_arg_1.currentTarget == this.minusNavSprite) {
            switch (int(this.quantity_) - 5) {
                case 0:
                    this.configureRollByQuantity(1);
                    break;
                default:
                    break;
                case 5:
                    this.configureRollByQuantity(5);
            }
        } else if (_arg_1.currentTarget == this.plusNavSprite) {
            switch (int(this.quantity_) - 1) {
                case 0:
                    this.configureRollByQuantity(5);
                    return;
                default:
                case 4:
                    this.configureRollByQuantity(10);
            }
        }
    }

    private function onRollClick(_arg_1:MouseEvent):void {
        this.configureRollByQuantity(this.quantity_);
        this.clearReward();
        this.clearShelveReward();
        this.sendRollRequest();
    }
}
}
