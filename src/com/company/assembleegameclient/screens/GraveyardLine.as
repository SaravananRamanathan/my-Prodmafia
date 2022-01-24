package com.company.assembleegameclient.screens {
import com.company.ui.BaseSimpleText;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;

import org.osflash.signals.Signal;

public class GraveyardLine extends Sprite {

    public static const WIDTH:int = 415;

    public static const HEIGHT:int = 52;

    public static const COLOR:uint = 11776947;

    public static const OVER_COLOR:uint = 16762880;

    public function GraveyardLine(_arg_1:BitmapData, _arg_2:String, _arg_3:String, _arg_4:String, _arg_5:int, _arg_6:String) {
        viewCharacterFame = new Signal(int);
        super();
        this.link = _arg_4;
        this.accountId = _arg_6;
        buttonMode = true;
        useHandCursor = true;
        tabEnabled = false;
        this.icon_ = new Bitmap();
        this.icon_.bitmapData = _arg_1;
        this.icon_.x = 12;
        this.icon_.y = 26 - _arg_1.height / 2 - 3;
        addChild(this.icon_);
        this.titleText_ = new BaseSimpleText(18, 0xb3b3b3, false, 0, 0);
        _arg_2 = _arg_2.replace("????", "Samurai");
        this.titleText_.text = _arg_2;
        this.titleText_.updateMetrics();
        this.titleText_.filters = [new DropShadowFilter(0, 0, 0, 1, 8, 8)];
        this.titleText_.x = 73;
        addChild(this.titleText_);
        this.taglineText_ = new BaseSimpleText(14, 0xb3b3b3, false, 0, 0);
        this.taglineText_.text = _arg_3;
        this.taglineText_.updateMetrics();
        this.taglineText_.filters = [new DropShadowFilter(0, 0, 0, 1, 8, 8)];
        this.taglineText_.x = 73;
        this.taglineText_.y = 24;
        addChild(this.taglineText_);
        this.dtText_ = new BaseSimpleText(16, 0xb3b3b3, false, 0, 0);
        this.dtText_.text = this.getTimeDiff(_arg_5);
        this.dtText_.updateMetrics();
        this.dtText_.filters = [new DropShadowFilter(0, 0, 0, 1, 8, 8)];
        this.dtText_.x = 415 - this.dtText_.width;
        addChild(this.dtText_);
        addEventListener("mouseOver", this.onMouseOver);
        addEventListener("rollOut", this.onRollOut);
        addEventListener("mouseDown", this.onMouseDown);
    }
    public var viewCharacterFame:Signal;
    public var icon_:Bitmap;
    public var titleText_:BaseSimpleText;
    public var taglineText_:BaseSimpleText;
    public var dtText_:BaseSimpleText;
    public var link:String;
    public var accountId:String;

    private function getTimeDiff(_arg_1:int):String {
        var _local2:Number = new Date().getTime() / 1000;
        var _local3:int = _local2 - _arg_1;
        if (_local3 <= 0) {
            return "now";
        }
        if (_local3 < 60) {
            return _local3 + " secs";
        }
        if (_local3 < 60 * 60) {
            return int(_local3 / 60) + " mins";
        }
        if (_local3 < 24 * 60 * 60) {
            return int(_local3 / 3600) + " hours";
        }
        return int(_local3 / 86400) + " days";
    }

    protected function onMouseOver(_arg_1:MouseEvent):void {
        this.titleText_.setColor(16762880);
        this.taglineText_.setColor(16762880);
        this.dtText_.setColor(16762880);
    }

    protected function onRollOut(_arg_1:MouseEvent):void {
        this.titleText_.setColor(0xb3b3b3);
        this.taglineText_.setColor(0xb3b3b3);
        this.dtText_.setColor(0xb3b3b3);
    }

    protected function onMouseDown(_arg_1:MouseEvent):void {
        var _local2:Array = this.link.split(":", 2);
        var _local3:* = _local2[0];
        switch (_local3) {
            case "fame":
                this.viewCharacterFame.dispatch(int(_local2[1]));
                return;
            case "http":
            case "https":
            default:
                return;
        }
    }
}
}
