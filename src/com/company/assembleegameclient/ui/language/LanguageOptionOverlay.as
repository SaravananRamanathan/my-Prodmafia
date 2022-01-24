package com.company.assembleegameclient.ui.language {
import com.company.assembleegameclient.screens.TitleMenuOption;
import com.company.rotmg.graphics.ScreenGraphic;

import flash.display.Shape;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;

import kabam.rotmg.text.view.TextFieldDisplayConcrete;
import kabam.rotmg.text.view.stringBuilder.LineBuilder;
import kabam.rotmg.ui.view.components.ScreenBase;
import kabam.rotmg.ui.view.components.dropdown.LocalizedDropDown;

import org.osflash.signals.Signal;

public class LanguageOptionOverlay extends ScreenBase {


    public function LanguageOptionOverlay() {
        languageSelected = new Signal(String);
        back = new Signal();
        this.title_ = this.makeTitle();
        this.continueButton_ = this.makeContinueButton();
        this.languageDropDownLabel = this.makeDropDownLabel();
        super();
        addChild(this.makeLine());
        addChild(this.title_);
        addChild(new ScreenGraphic());
        addChild(this.continueButton_);
    }
    public var languageSelected:Signal;
    public var back:Signal;
    private var title_:TextFieldDisplayConcrete;
    private var continueButton_:TitleMenuOption;
    private var languageDropDownLabel:TextFieldDisplayConcrete;
    private var languageDropDown:LocalizedDropDown;

    public function setLanguageDropdown(_arg_1:Vector.<String>):void {
        this.languageDropDown = new LocalizedDropDown(_arg_1);
        this.languageDropDown.y = 100;
        this.languageDropDown.addEventListener("change", this.onLanguageSelected);
        addChild(this.languageDropDown);
        this.languageDropDownLabel.textChanged.addOnce(this.positionDropdownLabel);
        addChild(this.languageDropDownLabel);
        this.languageDropDownLabel.y = this.languageDropDown.y + this.languageDropDown.getClosedHeight() / 2;
    }

    public function setSelected(_arg_1:String):void {
    }

    public function clear():void {
        if (this.languageDropDown && contains(this.languageDropDown)) {
            removeChild(this.languageDropDown);
        }
    }

    private function positionDropdownLabel():void {
        this.languageDropDown.x = 400 - (this.languageDropDown.width + this.languageDropDownLabel.width + 10) / 2;
        this.languageDropDownLabel.x = this.languageDropDown.x + this.languageDropDown.width + 10;
    }

    private function makeTitle():TextFieldDisplayConcrete {
        var _local1:* = null;
        _local1 = new TextFieldDisplayConcrete().setSize(36).setColor(0xffffff);
        _local1.setBold(true);
        _local1.setStringBuilder(new LineBuilder().setParams("LanguagesScreen.title"));
        _local1.setAutoSize("center");
        _local1.filters = [new DropShadowFilter(0, 0, 0)];
        _local1.x = 400 - _local1.width / 2;
        _local1.y = 16;
        return _local1;
    }

    private function makeContinueButton():TitleMenuOption {
        var _local1:* = null;
        _local1 = new TitleMenuOption("Options.continueButton", 36, false);
        _local1.setAutoSize("center");
        _local1.setVerticalAlign("middle");
        _local1.addEventListener("click", this.onContinueClick);
        _local1.x = 400;
        _local1.y = 550;
        return _local1;
    }

    private function makeDropDownLabel():TextFieldDisplayConcrete {
        var _local1:TextFieldDisplayConcrete = new TextFieldDisplayConcrete().setSize(16).setColor(0xb3b3b3).setBold(true);
        _local1.setVerticalAlign("middle");
        _local1.filters = [new DropShadowFilter(0, 0, 0, 0.5, 12, 12)];
        _local1.setStringBuilder(new LineBuilder().setParams("LanguagesScreen.option"));
        return _local1;
    }

    private function makeLine():Shape {
        var _local1:Shape = new Shape();
        _local1.graphics.lineStyle(1, 0x5e5e5e);
        _local1.graphics.moveTo(0, 70);
        _local1.graphics.lineTo(800, 70);
        _local1.graphics.lineStyle();
        return _local1;
    }

    private function onContinueClick(_arg_1:MouseEvent):void {
        this.back.dispatch();
    }

    private function onLanguageSelected(_arg_1:Event):void {
        this.languageSelected.dispatch(this.languageDropDown.getValue());
    }
}
}
