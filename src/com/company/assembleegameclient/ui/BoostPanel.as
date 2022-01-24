package com.company.assembleegameclient.ui {
import com.company.assembleegameclient.objects.Player;
import com.company.assembleegameclient.util.TextureRedrawer;
import com.company.util.AssetLibrary;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.TimerEvent;
import flash.filters.DropShadowFilter;
import flash.utils.Timer;

import kabam.rotmg.text.view.TextFieldDisplayConcrete;
import kabam.rotmg.text.view.stringBuilder.LineBuilder;
import kabam.rotmg.text.view.stringBuilder.StringBuilder;
import kabam.rotmg.ui.view.SignalWaiter;

import org.osflash.signals.Signal;

public class BoostPanel extends Sprite {


    public const resized:Signal = new Signal();

    private const SPACE:uint = 40;

    public function BoostPanel(_arg_1:Player) {
        super();
        this.player = _arg_1;
        this.createHeader();
        this.createBoostTimers();
        this.createTimer();
    }
    private var timer:Timer;
    private var player:Player;
    private var tierBoostTimer:BoostTimer;
    private var dropBoostTimer:BoostTimer;
    private var posY:int;

    public function dispose():void {
        this.timer.reset();
        this.destroyBoostTimers();
        this.player = null;
    }

    private function createTimer():void {
        this.timer = new Timer(1000);
        this.timer.addEventListener("timer", this.update, false, 0, true);
        this.timer.start();
    }

    private function updateTimer(_arg_1:BoostTimer, _arg_2:int):void {
        if (_arg_1) {
            if (_arg_2) {
                _arg_1.setTime(_arg_2);
            } else {
                this.destroyBoostTimers();
                this.createBoostTimers();
            }
        }
    }

    private function createHeader():void {
        var _local2:* = null;
        var _local1:* = null;
        var _local3:BitmapData = TextureRedrawer.redraw(AssetLibrary.getImageFromSet("lofiInterfaceBig", 22), 20, true, 0);
        _local2 = new Bitmap(_local3);
        _local2.x = -3;
        _local2.y = -1;
        addChild(_local2);
        _local1 = new TextFieldDisplayConcrete().setSize(16).setColor(0xff00);
        _local1.setBold(true);
        _local1.setStringBuilder(new LineBuilder().setParams("BoostPanel.activeBoosts"));
        _local1.setMultiLine(true);
        _local1.mouseEnabled = true;
        _local1.filters = [new DropShadowFilter(0, 0, 0)];
        _local1.x = 20;
        _local1.y = 4;
        addChild(_local1);
    }

    private function createBackground():void {
        graphics.clear();
        graphics.lineStyle(2, 0xffffff);
        graphics.beginFill(0x333333);
        graphics.drawRoundRect(0, 0, 150, height + 5, 10);
        this.resized.dispatch();
    }

    private function createBoostTimers():void {
        this.posY = 25;
        var _local1:SignalWaiter = new SignalWaiter();
        this.addDropTimerIfAble(_local1);
        this.addTierBoostIfAble(_local1);
        if (_local1.isEmpty()) {
            this.createBackground();
        } else {
            _local1.complete.addOnce(this.createBackground);
        }
    }

    private function addTierBoostIfAble(_arg_1:SignalWaiter):void {
        if (this.player.tierBoost) {
            this.tierBoostTimer = this.returnBoostTimer(new LineBuilder().setParams("BoostPanel.tierLevelIncreased"), this.player.tierBoost);
            this.addTimer(_arg_1, this.tierBoostTimer);
        }
    }

    private function addDropTimerIfAble(_arg_1:SignalWaiter):void {
        var _local2:* = null;
        if (this.player.dropBoost) {
            _local2 = "1.5x";
            this.dropBoostTimer = this.returnBoostTimer(new LineBuilder().setParams("BoostPanel.dropRate", {"rate": _local2}), this.player.dropBoost);
            this.addTimer(_arg_1, this.dropBoostTimer);
        }
    }

    private function addTimer(_arg_1:SignalWaiter, _arg_2:BoostTimer):void {
        _arg_1.push(_arg_2.textChanged);
        addChild(_arg_2);
        _arg_2.y = this.posY;
        _arg_2.x = 10;
        this.posY = this.posY + 40;
    }

    private function destroyBoostTimers():void {
        if (this.tierBoostTimer && this.tierBoostTimer.parent) {
            removeChild(this.tierBoostTimer);
        }
        if (this.dropBoostTimer && this.dropBoostTimer.parent) {
            removeChild(this.dropBoostTimer);
        }
        this.tierBoostTimer = null;
        this.dropBoostTimer = null;
    }

    private function returnBoostTimer(_arg_1:StringBuilder, _arg_2:int):BoostTimer {
        var _local3:BoostTimer = new BoostTimer();
        _local3.setLabelBuilder(_arg_1);
        _local3.setTime(_arg_2);
        return _local3;
    }

    private function update(_arg_1:TimerEvent):void {
        this.updateTimer(this.tierBoostTimer, this.player.tierBoost);
        this.updateTimer(this.dropBoostTimer, this.player.dropBoost);
    }
}
}
