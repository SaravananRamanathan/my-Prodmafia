package kabam.rotmg.account.ui.components {
import com.company.ui.BaseSimpleText;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.FocusEvent;
import flash.events.TextEvent;
import flash.filters.DropShadowFilter;

import kabam.lib.util.DateValidator;
import kabam.rotmg.text.view.TextFieldDisplayConcrete;
import kabam.rotmg.text.view.stringBuilder.LineBuilder;

import org.osflash.signals.Signal;

public class DateField extends Sprite {

    private static const BACKGROUND_COLOR:uint = 3355443;

    private static const ERROR_BORDER_COLOR:uint = 16549442;

    private static const NORMAL_BORDER_COLOR:uint = 4539717;

    private static const TEXT_COLOR:uint = 11776947;

    private static const INPUT_RESTRICTION:String = "1234567890";

    private static const FORMAT_HINT_COLOR:uint = 5592405;

    public function DateField() {
        super();
        this.validator = new DateValidator();
        this.thisYear = new Date().getFullYear();
        this.label = new TextFieldDisplayConcrete().setSize(18).setColor(0xb3b3b3);
        this.label.setBold(true);
        this.label.setStringBuilder(new LineBuilder().setParams(name));
        this.label.filters = [new DropShadowFilter(0, 0, 0)];
        addChild(this.label);
        this.months = new BaseSimpleText(20, 0xb3b3b3, true, 35, 30);
        this.months.restrict = "1234567890";
        this.months.maxChars = 2;
        this.months.y = 30;
        this.months.x = 6;
        this.months.border = false;
        this.months.updateMetrics();
        this.months.addEventListener("textInput", this.onMonthInput);
        this.months.addEventListener("focusOut", this.onMonthFocusOut);
        this.months.addEventListener("change", this.onEditMonth);
        this.monthFormatText = this.createFormatHint(this.months, "DateField.Months");
        addChild(this.monthFormatText);
        addChild(this.months);
        this.days = new BaseSimpleText(20, 0xb3b3b3, true, 35, 30);
        this.days.restrict = "1234567890";
        this.days.maxChars = 2;
        this.days.y = 30;
        this.days.x = 63;
        this.days.border = false;
        this.days.updateMetrics();
        this.days.addEventListener("textInput", this.onDayInput);
        this.days.addEventListener("focusOut", this.onDayFocusOut);
        this.days.addEventListener("change", this.onEditDay);
        this.dayFormatText = this.createFormatHint(this.days, "DateField.Days");
        addChild(this.dayFormatText);
        addChild(this.days);
        this.years = new BaseSimpleText(20, 0xb3b3b3, true, 55, 30);
        this.years.restrict = "1234567890";
        this.years.maxChars = 4;
        this.years.y = 30;
        this.years.x = 118;
        this.years.border = false;
        this.years.updateMetrics();
        this.years.restrict = "1234567890";
        this.years.addEventListener("textInput", this.onYearInput);
        this.years.addEventListener("change", this.onEditYear);
        this.yearFormatText = this.createFormatHint(this.years, "DateField.Years");
        addChild(this.yearFormatText);
        addChild(this.years);
        this.setErrorHighlight(false);
    }
    public var label:TextFieldDisplayConcrete;
    public var days:BaseSimpleText;
    public var months:BaseSimpleText;
    public var years:BaseSimpleText;
    private var dayFormatText:TextFieldDisplayConcrete;
    private var monthFormatText:TextFieldDisplayConcrete;
    private var yearFormatText:TextFieldDisplayConcrete;
    private var thisYear:int;
    private var validator:DateValidator;

    public function setTitle(_arg_1:String):void {
        this.label.setStringBuilder(new LineBuilder().setParams(_arg_1));
    }

    public function setErrorHighlight(_arg_1:Boolean):void {
        this.drawSimpleTextBackground(this.months, 0, 0, _arg_1);
        this.drawSimpleTextBackground(this.days, 0, 0, _arg_1);
        this.drawSimpleTextBackground(this.years, 0, 0, _arg_1);
    }

    public function isValidDate():Boolean {
        var _local2:int = parseInt(this.months.text);
        var _local1:int = parseInt(this.days.text);
        var _local3:int = parseInt(this.years.text);
        return this.validator.isValidDate(_local2, _local1, _local3, 100);
    }

    public function getDate():String {
        var _local2:String = this.getFixedLengthString(this.months.text, 2);
        var _local1:String = this.getFixedLengthString(this.days.text, 2);
        var _local3:String = this.getFixedLengthString(this.years.text, 4);
        return _local2 + "/" + _local1 + "/" + _local3;
    }

    public function getTextChanged():Signal {
        return this.label.textChanged;
    }

    private function drawSimpleTextBackground(_arg_1:BaseSimpleText, _arg_2:int, _arg_3:int, _arg_4:Boolean):void {
        var _local5:uint = !!_arg_4 ? 16549442 : 0x454545;
        graphics.lineStyle(2, _local5, 1, false, "normal", "round", "round");
        graphics.beginFill(0x333333, 1);
        graphics.drawRect(_arg_1.x - _arg_2 - 5, _arg_1.y - _arg_3, _arg_1.width + _arg_2 * 2, _arg_1.height + _arg_3 * 2);
        graphics.endFill();
        graphics.lineStyle();
    }

    private function createFormatHint(_arg_1:BaseSimpleText, _arg_2:String):TextFieldDisplayConcrete {
        var _local3:TextFieldDisplayConcrete = new TextFieldDisplayConcrete().setSize(16).setColor(0x555555);
        _local3.setTextWidth(_arg_1.width + 4).setTextHeight(_arg_1.height);
        _local3.x = _arg_1.x - 6;
        _local3.y = _arg_1.y + 3;
        _local3.setStringBuilder(new LineBuilder().setParams(_arg_2));
        _local3.setAutoSize("center");
        return _local3;
    }

    private function getEarliestYear(_arg_1:String):int {
        while (_arg_1.length < 4) {
            _arg_1 = _arg_1 + "0";
        }
        return int(_arg_1);
    }

    private function getFixedLengthString(_arg_1:String, _arg_2:int):String {
        while (_arg_1.length < _arg_2) {
            _arg_1 = "0" + _arg_1;
        }
        return _arg_1;
    }

    private function onMonthInput(_arg_1:TextEvent):void {
        var _local2:String = this.months.text + _arg_1.text;
        var _local3:int = parseInt(_local2);
        if (_local2 != "0" && !this.validator.isValidMonth(_local3)) {
            _arg_1.preventDefault();
        }
    }

    private function onMonthFocusOut(_arg_1:FocusEvent):void {
        var _local2:int = parseInt(this.months.text);
        if (_local2 < 10 && this.days.text != "") {
            this.months.text = "0" + _local2.toString();
        }
    }

    private function onEditMonth(_arg_1:Event):void {
        this.monthFormatText.visible = !this.months.text;
    }

    private function onDayInput(_arg_1:TextEvent):void {
        var _local2:String = this.days.text + _arg_1.text;
        var _local3:int = parseInt(_local2);
        if (_local2 != "0" && !this.validator.isValidDay(_local3)) {
            _arg_1.preventDefault();
        }
    }

    private function onDayFocusOut(_arg_1:FocusEvent):void {
        var _local2:int = parseInt(this.days.text);
        if (_local2 < 10 && this.days.text != "") {
            this.days.text = "0" + _local2.toString();
        }
    }

    private function onEditDay(_arg_1:Event):void {
        this.dayFormatText.visible = !this.days.text;
    }

    private function onYearInput(_arg_1:TextEvent):void {
        var _local2:String = this.years.text + _arg_1.text;
        var _local3:int = this.getEarliestYear(_local2);
        if (_local3 > this.thisYear) {
            _arg_1.preventDefault();
        }
    }

    private function onEditYear(_arg_1:Event):void {
        this.yearFormatText.visible = !this.years.text;
    }
}
}
