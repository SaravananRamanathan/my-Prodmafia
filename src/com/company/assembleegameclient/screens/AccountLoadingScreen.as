package com.company.assembleegameclient.screens {
import com.company.rotmg.graphics.ScreenGraphic;

import flash.display.Sprite;
import flash.events.Event;
import flash.filters.DropShadowFilter;

import kabam.rotmg.core.StaticInjectorContext;
import kabam.rotmg.core.signals.SetLoadingMessageSignal;
import kabam.rotmg.text.view.TextFieldDisplayConcrete;
import kabam.rotmg.text.view.stringBuilder.LineBuilder;

public class AccountLoadingScreen extends Sprite {


    public function AccountLoadingScreen() {
        super();
        addChild(new ScreenGraphic());
        this.loadingText_ = new TextFieldDisplayConcrete().setSize(30).setColor(0xffffff).setBold(true);
        this.loadingText_.setStringBuilder(new LineBuilder().setParams("Loading.text"));
        this.loadingText_.filters = [new DropShadowFilter(0, 0, 0, 1, 4, 4)];
        this.loadingText_.setAutoSize("center").setVerticalAlign("middle");
        addChild(this.loadingText_);
        this.setMessage = StaticInjectorContext.getInjector().getInstance(SetLoadingMessageSignal);
        this.setMessage.add(this.onSetMessage);
        addEventListener("addedToStage", this.onAddedToStage);
        addEventListener("removedFromStage", this.onRemovedFromStage);
    }
    private var loadingText_:TextFieldDisplayConcrete;
    private var setMessage:SetLoadingMessageSignal;

    private function onSetMessage(_arg_1:String):void {
        this.loadingText_.setStringBuilder(new LineBuilder().setParams(_arg_1));
    }

    protected function onRemovedFromStage(_arg_1:Event):void {
        removeEventListener("removedFromStage", this.onRemovedFromStage);
        this.setMessage.remove(this.onSetMessage);
    }

    protected function onAddedToStage(_arg_1:Event):void {
        removeEventListener("addedToStage", this.onAddedToStage);
        this.loadingText_.x = 400;
        this.loadingText_.y = 550;
    }
}
}
