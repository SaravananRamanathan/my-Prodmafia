package kabam.rotmg.news.view {
import com.company.assembleegameclient.sound.SoundEffectLibrary;
import com.company.util.AssetLibrary;
import com.company.util.MoreColorUtil;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;
import flash.filters.GlowFilter;
import flash.geom.ColorTransform;
import flash.text.TextField;

import kabam.rotmg.account.core.view.EmptyFrame;
import kabam.rotmg.core.StaticInjectorContext;
import kabam.rotmg.dialogs.control.FlushPopupStartupQueueSignal;
import kabam.rotmg.news.model.NewsModel;
import kabam.rotmg.pets.view.components.PopupWindowBackground;
import kabam.rotmg.text.model.FontModel;
import kabam.rotmg.text.view.TextFieldDisplayConcrete;
import kabam.rotmg.text.view.stringBuilder.LineBuilder;
import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;
import kabam.rotmg.ui.model.HUDModel;

public class NewsModal extends EmptyFrame {

    public static const MODAL_WIDTH:int = 440;

    public static const MODAL_HEIGHT:int = 400;

    private static const OVER_COLOR_TRANSFORM:ColorTransform = new ColorTransform(1, 0.862745098039216, 0.52156862745098);

    private static const DROP_SHADOW_FILTER:DropShadowFilter = new DropShadowFilter(0, 0, 0);

    private static const GLOW_FILTER:GlowFilter = new GlowFilter(0xff0000, 1, 11, 5);

    private static const filterWithGlow:Array = [DROP_SHADOW_FILTER, GLOW_FILTER];

    private static const filterNoGlow:Array = [DROP_SHADOW_FILTER];

    public static var modalWidth:int = 440;

    public static var modalHeight:int = 400;

    public static var backgroundImageEmbed:Class = NewsModal_backgroundImageEmbed;

    public static var foregroundImageEmbed:Class = NewsModal_foregroundImageEmbed;

    public static function getText(_arg_1:String, _arg_2:int, _arg_3:int, _arg_4:Boolean):TextFieldDisplayConcrete {
        var _local5:TextFieldDisplayConcrete = new TextFieldDisplayConcrete().setSize(18).setColor(0xffffff).setTextWidth(NewsModal.modalWidth - 40 - 10);
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

    public function NewsModal(_arg_1:Boolean = false) {
        this.triggeredOnStartup = _arg_1;
        this.newsModel = StaticInjectorContext.getInjector().getInstance(NewsModel);
        this.fontModel = StaticInjectorContext.getInjector().getInstance(FontModel);
        modalWidth = 440;
        modalHeight = 400;
        super(modalWidth, modalHeight);
        this.setCloseButton(true);
        this.pageIndicator = new TextField();
        this.initNavButtons();
        this.setPage(this.currentPageNumber);
        WebMain.STAGE.addEventListener("keyDown", this.keyDownListener);
        addEventListener("addedToStage", this.onAdded);
        addEventListener("removedFromStage", this.destroy);
        closeButton.clicked.add(this.onCloseButtonClicked);
    }
    private var currentPage:NewsModalPage;
    private var currentPageNum:int = -1;
    private var pageOneNav:TextField;
    private var pageTwoNav:TextField;
    private var pageThreeNav:TextField;
    private var pageFourNav:TextField;
    private var pageNavs:Vector.<TextField>;
    private var pageIndicator:TextField;
    private var fontModel:FontModel;
    private var leftNavSprite:Sprite;
    private var rightNavSprite:Sprite;
    private var newsModel:NewsModel;
    private var currentPageNumber:int = 1;
    private var triggeredOnStartup:Boolean;

    override protected function makeModalBackground():Sprite {
        var _local4:Sprite = new Sprite();
        var _local2:DisplayObject = new backgroundImageEmbed();
        _local2.width = modalWidth + 1;
        _local2.height = modalHeight - 25;
        _local2.y = 27;
        _local2.alpha = 0.95;
        var _local1:DisplayObject = new foregroundImageEmbed();
        _local1.width = modalWidth + 1;
        _local1.height = modalHeight - 67;
        _local1.y = 27;
        _local1.alpha = 1;
        var _local3:PopupWindowBackground = new PopupWindowBackground();
        _local3.draw(modalWidth, modalHeight, 1);
        _local4.addChild(_local2);
        _local4.addChild(_local1);
        _local4.addChild(_local3);
        return _local4;
    }

    public function onCloseButtonClicked():void {
        var _local1:FlushPopupStartupQueueSignal = StaticInjectorContext.getInjector().getInstance(FlushPopupStartupQueueSignal);
        closeButton.clicked.remove(this.onCloseButtonClicked);
        if (this.triggeredOnStartup) {
            _local1.dispatch();
        }
    }

    private function updateIndicator():void {
        this.fontModel.apply(this.pageIndicator, 24, 0xffffff, true);
        this.pageIndicator.text = this.currentPageNumber + " / " + this.newsModel.numberOfNews;
        addChild(this.pageIndicator);
        this.pageIndicator.y = modalHeight - 33;
        this.pageIndicator.x = modalWidth / 2 - this.pageIndicator.textWidth / 2;
        this.pageIndicator.width = this.pageIndicator.textWidth + 4;
    }

    private function initNavButtons():void {
        this.updateIndicator();
        this.leftNavSprite = this.makeLeftNav();
        this.rightNavSprite = this.makeRightNav();
        this.leftNavSprite.x = modalWidth * 4 / 11 - this.rightNavSprite.width / 2;
        this.leftNavSprite.y = modalHeight - 4;
        addChild(this.leftNavSprite);
        this.rightNavSprite.x = modalWidth * 7 / 11 - this.rightNavSprite.width / 2;
        this.rightNavSprite.y = modalHeight - 4;
        addChild(this.rightNavSprite);
    }

    private function setPage(_arg_1:int):void {
        this.currentPageNumber = _arg_1;
        if (this.currentPage && this.currentPage.parent) {
            removeChild(this.currentPage);
        }
        this.currentPage = this.newsModel.getModalPage(_arg_1);
        addChild(this.currentPage);
        this.updateIndicator();
    }

    private function refreshNewsButton():void {
        var _local1:HUDModel = StaticInjectorContext.getInjector().getInstance(HUDModel);
        if (_local1 != null && _local1.gameSprite != null) {
            _local1.gameSprite.refreshNewsUpdateButton();
        }
    }

    private function makeLeftNav():Sprite {
        var _local3:BitmapData = AssetLibrary.getImageFromSet("lofiInterface", 54);
        var _local2:Bitmap = new Bitmap(_local3);
        _local2.scaleX = 4;
        _local2.scaleY = 4;
        _local2.rotation = -90;
        var _local1:Sprite = new Sprite();
        _local1.addChild(_local2);
        _local1.addEventListener("mouseOver", this.onArrowHover);
        _local1.addEventListener("mouseOut", this.onArrowHoverOut);
        _local1.addEventListener("click", this.onClick);
        return _local1;
    }

    private function makeRightNav():Sprite {
        var _local3:BitmapData = AssetLibrary.getImageFromSet("lofiInterface", 55);
        var _local2:Bitmap = new Bitmap(_local3);
        _local2.scaleX = 4;
        _local2.scaleY = 4;
        _local2.rotation = -90;
        var _local1:Sprite = new Sprite();
        _local1.addChild(_local2);
        _local1.addEventListener("mouseOver", this.onArrowHover);
        _local1.addEventListener("mouseOut", this.onArrowHoverOut);
        _local1.addEventListener("click", this.onClick);
        return _local1;
    }

    override public function onCloseClick(_arg_1:MouseEvent):void {
        SoundEffectLibrary.play("button_click");
    }

    public function onClick(_arg_1:MouseEvent):void {
        var _local2:* = _arg_1.currentTarget;
        switch (_local2) {
            case this.rightNavSprite:
                if (this.currentPageNumber + 1 <= this.newsModel.numberOfNews) {
                    this.setPage(this.currentPageNumber + 1);
                }
                return;
            case this.leftNavSprite:
                if (this.currentPageNumber - 1 >= 1) {
                    this.setPage(this.currentPageNumber - 1);
                }
                return;
            default:
                return;
        }
    }

    private function onAdded(_arg_1:Event):void {
        this.newsModel.markAsRead();
        this.refreshNewsButton();
    }

    private function destroy(_arg_1:Event):void {
        removeEventListener("addedToStage", this.onAdded);
        WebMain.STAGE.removeEventListener("keyDown", this.keyDownListener);
        removeEventListener("removedFromStage", this.destroy);
        this.leftNavSprite.removeEventListener("click", this.onClick);
        this.leftNavSprite.removeEventListener("mouseOver", this.onArrowHover);
        this.leftNavSprite.removeEventListener("mouseOut", this.onArrowHoverOut);
        this.rightNavSprite.removeEventListener("click", this.onClick);
        this.rightNavSprite.removeEventListener("mouseOver", this.onArrowHover);
        this.rightNavSprite.removeEventListener("mouseOut", this.onArrowHoverOut);
    }

    private function keyDownListener(_arg_1:KeyboardEvent):void {
        if (_arg_1.keyCode == 39) {
            if (this.currentPageNumber + 1 <= this.newsModel.numberOfNews) {
                this.setPage(this.currentPageNumber + 1);
            }
        } else if (_arg_1.keyCode == 37) {
            if (this.currentPageNumber - 1 >= 1) {
                this.setPage(this.currentPageNumber - 1);
            }
        }
    }

    private function onArrowHover(_arg_1:MouseEvent):void {
        _arg_1.currentTarget.transform.colorTransform = OVER_COLOR_TRANSFORM;
    }

    private function onArrowHoverOut(_arg_1:MouseEvent):void {
        _arg_1.currentTarget.transform.colorTransform = MoreColorUtil.identity;
    }
}
}
