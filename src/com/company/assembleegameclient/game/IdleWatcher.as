package com.company.assembleegameclient.game {
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;

import kabam.rotmg.chat.model.ChatMessage;
import kabam.rotmg.core.StaticInjectorContext;
import kabam.rotmg.game.signals.AddTextLineSignal;

public class IdleWatcher {

    private static const MINUTE_IN_MS:int = 60000;

    private static const FIRST_WARNING_MINUTES:int = 10;

    private static const SECOND_WARNING_MINUTES:int = 15;

    private static const KICK_MINUTES:int = 20;

    public function IdleWatcher() {
        super();
        this.addTextLine = StaticInjectorContext.getInjector().getInstance(AddTextLineSignal);
    }
    public var gs_:GameSprite = null;
    public var idleTime_:int = 0;
    private var addTextLine:AddTextLineSignal;

    public function start(_arg_1:GameSprite):void {
        this.gs_ = _arg_1;
        this.idleTime_ = 0;
        this.gs_.stage.addEventListener("mouseMove", this.onMouseMove);
        this.gs_.stage.addEventListener("keyDown", this.onKeyDown);
    }

    public function update(_arg_1:int):Boolean {
        var _local2:int = this.idleTime_;
        this.idleTime_ = this.idleTime_ + _arg_1;
        if (this.idleTime_ < 10 * 60 * 1000) {
            return false;
        }
        if (this.idleTime_ >= 10 * 60 * 1000 && _local2 < 10 * 60 * 1000) {
            this.addTextLine.dispatch(this.makeFirstWarning());
            return false;
        }
        if (this.idleTime_ >= 250 * 60 * 60 && _local2 < 250 * 60 * 60) {
            this.addTextLine.dispatch(this.makeSecondWarning());
            return false;
        }
        if (this.idleTime_ >= 20 * 60 * 1000 && _local2 < 20 * 60 * 1000) {
            this.addTextLine.dispatch(this.makeThirdWarning());
            return true;
        }
        return false;
    }

    public function stop():void {
        this.gs_.stage.removeEventListener("mouseMove", this.onMouseMove);
        this.gs_.stage.removeEventListener("keyDown", this.onKeyDown);
        this.gs_ = null;
    }

    private function makeFirstWarning():ChatMessage {
        var _local1:ChatMessage = new ChatMessage();
        _local1.name = "*Error*";
        _local1.text = "You have been idle for 10 minutes, you will be disconnected if you are idle for more than 20 minutes.";
        return _local1;
    }

    private function makeSecondWarning():ChatMessage {
        var _local1:ChatMessage = new ChatMessage();
        _local1.name = "*Error*";
        _local1.text = "You have been idle for 15 minutes, you will be disconnected if you are idle for more than 20 minutes.";
        return _local1;
    }

    private function makeThirdWarning():ChatMessage {
        var _local1:ChatMessage = new ChatMessage();
        _local1.name = "*Error*";
        _local1.text = "You have been idle for 20 minutes, disconnecting.";
        return _local1;
    }

    private function onMouseMove(_arg_1:MouseEvent):void {
        this.idleTime_ = 0;
    }

    private function onKeyDown(_arg_1:KeyboardEvent):void {
        this.idleTime_ = 0;
    }
}
}
