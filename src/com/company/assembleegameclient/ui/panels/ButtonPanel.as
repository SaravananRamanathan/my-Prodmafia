package com.company.assembleegameclient.ui.panels {
import com.company.assembleegameclient.game.GameSprite;
import com.company.assembleegameclient.ui.DeprecatedTextButton;

import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;

import kabam.rotmg.text.view.TextFieldDisplayConcrete;
import kabam.rotmg.text.view.stringBuilder.LineBuilder;

public class ButtonPanel extends Panel {


    public function ButtonPanel(_arg_1:GameSprite, _arg_2:String, _arg_3:String) {
        super(_arg_1);
        this.titleText_ = new TextFieldDisplayConcrete().setSize(18).setColor(0xffffff).setTextWidth(188).setHTML(true).setWordWrap(true).setMultiLine(true).setAutoSize("center");
        this.titleText_.setBold(true);
        this.titleText_.setStringBuilder(new LineBuilder().setParams(_arg_2).setPrefix("<p align=\"center\">").setPostfix("</p>"));
        this.titleText_.filters = [new DropShadowFilter(0, 0, 0)];
        this.titleText_.y = 6;
        addChild(this.titleText_);
        this.button_ = new DeprecatedTextButton(16, _arg_3);
        this.button_.addEventListener("click", this.onButtonClick);
        this.button_.textChanged.addOnce(this.alignButton);
        addChild(this.button_);
    }
    protected var button_:DeprecatedTextButton;
    private var titleText_:TextFieldDisplayConcrete;

    private function alignButton():void {
        this.button_.x = int(94 - this.button_.width / 2);
        this.button_.y = 84 - this.button_.height - 4;
    }

    protected function onButtonClick(_arg_1:MouseEvent):void {
    }
}
}
