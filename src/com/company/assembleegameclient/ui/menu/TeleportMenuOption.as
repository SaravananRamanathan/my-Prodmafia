package com.company.assembleegameclient.ui.menu {
import com.company.assembleegameclient.objects.Player;
import com.company.util.AssetLibrary;

import flash.display.Shape;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.ColorTransform;

import kabam.rotmg.text.view.TextFieldDisplayConcrete;
import kabam.rotmg.text.view.stringBuilder.LineBuilder;

public class TeleportMenuOption extends MenuOption {

    private static const inactiveCT:ColorTransform = new ColorTransform(0.329411764705882, 0.329411764705882, 0.329411764705882);

    public function TeleportMenuOption(_arg_1:Player) {
        barMask = new Shape();
        super(AssetLibrary.getImageFromSet("lofiInterface2", 3), 0xffffff, "TeleportMenuOption.title");
        this.player_ = _arg_1;
        this.barText_ = new TextFieldDisplayConcrete().setSize(18).setColor(0xffffff);
        this.barText_.setBold(true);
        this.barText_.setStringBuilder(new LineBuilder().setParams("TeleportMenuOption.title"));
        var _local2:* = text_.x;
        this.barMask.x = _local2;
        this.barText_.x = _local2;
        _local2 = text_.y;
        this.barMask.y = _local2;
        this.barText_.y = _local2;
        this.barText_.textChanged.add(this.onTextChanged);
        addEventListener("addedToStage", this.onAddedToStage, false, 0, true);
        addEventListener("removedFromStage", this.onRemovedFromStage, false, 0, true);
    }
    private var player_:Player;
    private var mouseOver_:Boolean = false;
    private var barText_:TextFieldDisplayConcrete;
    private var barTextOrigWidth_:int;
    private var barMask:Shape;

    private function onTextChanged():void {
        this.barTextOrigWidth_ = this.barText_.textField.width;
        this.barMask.graphics.beginFill(0xff00ff);
        this.barMask.graphics.drawRect(0, 0, this.barText_.textField.width, this.barText_.textField.height);
    }

    override protected function onMouseOver(_arg_1:MouseEvent):void {
        this.mouseOver_ = true;
    }

    override protected function onMouseOut(_arg_1:MouseEvent):void {
        this.mouseOver_ = false;
    }

    private function onAddedToStage(_arg_1:Event):void {
        addEventListener("enterFrame", this.onEnterFrame, false, 0, true);
    }

    private function onRemovedFromStage(_arg_1:Event):void {
        removeEventListener("enterFrame", this.onEnterFrame);
    }

    private function onEnterFrame(_arg_1:Event):void {
        var _local4:int = 0;
        var _local3:Number = NaN;
        var _local2:int = this.player_.msUtilTeleport();
        if (_local2 > 0) {
            _local4 = _local2 <= 10000 ? 10000 : 120000;
            if (!contains(this.barText_)) {
                addChild(this.barText_);
                addChild(this.barMask);
                this.barText_.mask = this.barMask;
            }
            _local3 = this.barTextOrigWidth_ * (1 - _local2 / _local4);
            this.barMask.width = _local3;
            setColorTransform(inactiveCT);
        } else {
            if (contains(this.barText_)) {
                removeChild(this.barText_);
            }
            if (this.mouseOver_) {
                setColorTransform(mouseOverCT);
            } else {
                setColorTransform(null);
            }
        }
    }
}
}
