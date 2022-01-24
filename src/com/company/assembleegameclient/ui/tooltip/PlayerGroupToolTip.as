package com.company.assembleegameclient.ui.tooltip {
import com.company.assembleegameclient.objects.Player;
import com.company.assembleegameclient.ui.GameObjectListItem;

import flash.filters.DropShadowFilter;

import kabam.rotmg.text.view.TextFieldDisplayConcrete;
import kabam.rotmg.text.view.stringBuilder.LineBuilder;

public class PlayerGroupToolTip extends ToolTip {


    public function PlayerGroupToolTip(_arg_1:Vector.<Player>, _arg_2:Boolean = true) {
        playerPanels_ = new Vector.<GameObjectListItem>();
        super(0x363636, 0.5, 0xffffff, 1, _arg_2);
        this.clickMessage_ = new TextFieldDisplayConcrete().setSize(12).setColor(0xb3b3b3);
        this.clickMessage_.setStringBuilder(new LineBuilder().setParams("PlayerToolTip.clickMessage"));
        this.clickMessage_.filters = [new DropShadowFilter(0, 0, 0)];
        addChild(this.clickMessage_);
        this.setPlayers(_arg_1);
        if (!_arg_2) {
            filters = [];
        }
        waiter.push(this.clickMessage_.textChanged);
    }
    public var players_:Vector.<Player> = null;
    private var playerPanels_:Vector.<GameObjectListItem>;
    private var clickMessage_:TextFieldDisplayConcrete;

    public function setPlayers(_arg_1:Vector.<Player>):void {
        var _local2:int = 0;
        var _local4:* = null;
        var _local3:* = null;
        this.clear();
        this.players_ = _arg_1.slice();
        if (this.players_ == null || this.players_.length == 0) {
            return;
        }
        var _local6:int = 0;
        var _local5:* = _arg_1;
        for each(_local4 in _arg_1) {
            _local3 = new GameObjectListItem(0xb3b3b3, true, _local4);
            _local3.x = 0;
            _local3.y = _local2;
            addChild(_local3);
            this.playerPanels_.push(_local3);
            _local3.textReady.addOnce(this.onTextChanged);
            _local2 = _local2 + 32;
        }
        this.clickMessage_.x = width / 2 - this.clickMessage_.width / 2;
        this.clickMessage_.y = _local2;
        draw();
    }

    private function onTextChanged():void {
        var _local1:* = null;
        this.clickMessage_.x = width / 2 - this.clickMessage_.width / 2;
        draw();
        var _local3:int = 0;
        var _local2:* = this.playerPanels_;
        for each(_local1 in this.playerPanels_) {
            _local1.textReady.remove(this.onTextChanged);
        }
    }

    private function clear():void {
        var _local1:* = null;
        graphics.clear();
        var _local3:int = 0;
        var _local2:* = this.playerPanels_;
        for each(_local1 in this.playerPanels_) {
            removeChild(_local1);
        }
        this.playerPanels_.length = 0;
    }
}
}
