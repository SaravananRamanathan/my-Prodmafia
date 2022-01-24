package kabam.rotmg.news.view {
import com.company.assembleegameclient.game.events.DisplayAreaChangedSignal;

import flash.display.Sprite;
import flash.events.TimerEvent;
import flash.text.TextField;
import flash.utils.Timer;

import kabam.rotmg.core.StaticInjectorContext;
import kabam.rotmg.text.model.FontModel;

public class NewsTicker extends Sprite {

    private const WIDTH:int = 280;
    private const HEIGHT:int = 25;
    private const MAX_REPEATS:int = 2;
    private const SCROLL_PREPEND:String = "                                                                               ";
    private const SCROLL_APPEND:String = "                                                                                ";
    private static var pendingScrollText:String = "";

    public static function setPendingScrollText(_arg_1:String):void {
        NewsTicker.pendingScrollText = _arg_1;
    }

    public function NewsTicker() {
        super();
        this.scrollText = this.createScrollText();
        this.timer = new Timer(0.17, 0);
        this.drawBackground();
        this.align();
        this.visible = false;
        if (NewsTicker.pendingScrollText != "") {
            this.activateNewScrollText(NewsTicker.pendingScrollText);
            NewsTicker.pendingScrollText = "";
        }
    }
    public var scrollText:TextField;
    private var timer:Timer;
    private var currentRepeat:uint = 0;
    private var scrollOffset:int = 0;

    public function activateNewScrollText(_arg_1:String):void {
        if (this.visible == false) {
            this.visible = true;
            StaticInjectorContext.getInjector().getInstance(DisplayAreaChangedSignal).dispatch();
            this.scrollText.text = "                                                                               " + _arg_1 + "                                                                                ";
            this.timer.addEventListener("timer", this.scrollAnimation);
            this.currentRepeat = 1;
            this.timer.start();
        }
    }

    private function align():void {
        this.scrollText.x = 5;
        this.scrollText.y = 2;
    }

    private function drawBackground():void {
        graphics.beginFill(0, 0.4);
        graphics.drawRoundRect(0, 0, 280, 25, 12, 12);
        graphics.endFill();
    }

    private function createScrollText():TextField {
        var _local1:* = null;
        _local1 = new TextField();
        var _local2:FontModel = StaticInjectorContext.getInjector().getInstance(FontModel);
        _local2.apply(_local1, 16, 0xffffff, false);
        _local1.selectable = false;
        _local1.doubleClickEnabled = false;
        _local1.mouseEnabled = false;
        _local1.mouseWheelEnabled = false;
        _local1.text = "";
        _local1.wordWrap = false;
        _local1.multiline = false;
        _local1.selectable = false;
        _local1.width = 270;
        _local1.height = 25;
        addChild(_local1);
        return _local1;
    }

    private function scrollAnimation(_arg_1:TimerEvent):void {
        this.timer.stop();
        if (this.scrollText.scrollH < this.scrollText.maxScrollH) {
            this.scrollOffset++;
            this.scrollText.scrollH = this.scrollOffset;
            this.timer.start();
        } else if (this.currentRepeat >= 1 && this.currentRepeat < 2) {
            this.currentRepeat++;
            this.scrollOffset = 0;
            this.scrollText.scrollH = 0;
            this.timer.start();
        } else {
            this.currentRepeat = 0;
            this.scrollOffset = 0;
            this.scrollText.scrollH = 0;
            this.timer.removeEventListener("timer", this.scrollAnimation);
            this.visible = false;
            StaticInjectorContext.getInjector().getInstance(DisplayAreaChangedSignal).dispatch();
        }
    }
}
}
