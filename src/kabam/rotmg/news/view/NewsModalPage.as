package kabam.rotmg.news.view {
import com.company.assembleegameclient.ui.Scrollbar;

import flash.display.Sprite;
import flash.events.Event;
import flash.filters.DropShadowFilter;
import flash.text.TextField;

import kabam.rotmg.core.StaticInjectorContext;
import kabam.rotmg.text.model.FontModel;
import kabam.rotmg.text.view.TextFieldDisplayConcrete;

public class NewsModalPage extends Sprite {

    public static const TEXT_MARGIN:int = 22;

    public static const TEXT_MARGIN_HTML:int = 26;

    public static const TEXT_TOP_MARGIN_HTML:int = 40;

    private static const SCROLLBAR_WIDTH:int = 10;

    public static const WIDTH:int = 136;

    public static const HEIGHT:int = 310;

    private static function disableMouseOnText(_arg_1:TextField):void {
        _arg_1.mouseWheelEnabled = false;
    }

    public function NewsModalPage(_arg_1:String, _arg_2:String) {
        var _local4:* = null;
        var _local3:* = null;
        super();
        this.doubleClickEnabled = false;
        this.mouseEnabled = false;
        this.innerModalWidth = 386;
        this.htmlText = new TextField();
        var _local6:FontModel = StaticInjectorContext.getInjector().getInstance(FontModel);
        _local6.apply(this.htmlText, 16, 15792127, false, false);
        this.htmlText.width = this.innerModalWidth;
        this.htmlText.multiline = true;
        this.htmlText.wordWrap = true;
        this.htmlText.htmlText = _arg_2;
        this.htmlText.filters = [new DropShadowFilter(0, 0, 0)];
        this.htmlText.height = this.htmlText.textHeight + 8;
        _local4 = new Sprite();
        _local4.addChild(this.htmlText);
        _local4.y = 40;
        _local4.x = 26;
        _local3 = new Sprite();
        _local3.graphics.beginFill(0xff0000);
        _local3.graphics.drawRect(0, 0, this.innerModalWidth, 310);
        _local3.x = 26;
        _local3.y = 40;
        addChild(_local3);
        _local4.mask = _local3;
        disableMouseOnText(this.htmlText);
        addChild(_local4);
        var _local5:TextFieldDisplayConcrete = NewsModal.getText(_arg_1, 22, 6, true);
        addChild(_local5);
        if (this.htmlText.height >= 310) {
            this.scrollBar_ = new Scrollbar(10, 310, 0.1, _local4);
            this.scrollBar_.x = 7 * 60;
            this.scrollBar_.y = 40;
            this.scrollBar_.setIndicatorSize(310, _local4.height);
            addChild(this.scrollBar_);
        }
        this.addEventListener("addedToStage", this.onAddedHandler);
    }
    protected var scrollBar_:Scrollbar;
    private var innerModalWidth:int;
    private var htmlText:TextField;

    protected function onScrollBarChange(_arg_1:Event):void {
        this.htmlText.y = -this.scrollBar_.pos() * (this.htmlText.height - 310);
    }

    private function onAddedHandler(_arg_1:Event):void {
        this.addEventListener("removedFromStage", this.onRemovedFromStage);
        if (this.scrollBar_) {
            this.scrollBar_.addEventListener("change", this.onScrollBarChange);
        }
    }

    private function onRemovedFromStage(_arg_1:Event):void {
        this.removeEventListener("removedFromStage", this.onRemovedFromStage);
        this.removeEventListener("addedToStage", this.onAddedHandler);
        if (this.scrollBar_) {
            this.scrollBar_.removeEventListener("change", this.onScrollBarChange);
        }
    }
}
}
