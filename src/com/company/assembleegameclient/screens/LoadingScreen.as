package com.company.assembleegameclient.screens {
import com.company.rotmg.graphics.ScreenGraphic;

import flash.display.Sprite;
import flash.events.Event;
import flash.filters.DropShadowFilter;

import kabam.rotmg.text.view.TextFieldDisplayConcrete;
import kabam.rotmg.text.view.stringBuilder.LineBuilder;
import kabam.rotmg.ui.view.components.ScreenBase;

public class LoadingScreen extends Sprite {

    private static const DEFAULT_FILTER:DropShadowFilter = new DropShadowFilter(0, 0, 0, 1, 4, 4);

    public function LoadingScreen() {
        text = new TextFieldDisplayConcrete();
        super();
        addChild(new ScreenBase());
        addChild(new ScreenGraphic());
        this.text.setSize(30).setColor(0xffffff).setVerticalAlign("middle").setAutoSize("center").setBold(true);
        this.text.y = 550;
        addEventListener("addedToStage", this.onAdded);
        this.text.setStringBuilder(new LineBuilder().setParams("Loading.text"));
        this.text.filters = [DEFAULT_FILTER];
        addChild(this.text);
    }
    private var text:TextFieldDisplayConcrete;

    public function setTextKey(_arg_1:String):void {
        this.text.setStringBuilder(new LineBuilder().setParams(_arg_1));
    }

    private function onAdded(_arg_1:Event):void {
        removeEventListener("addedToStage", this.onAdded);
        this.text.x = stage.stageWidth * 0.5;
    }
}
}
