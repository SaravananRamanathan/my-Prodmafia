package com.company.assembleegameclient.ui {
import com.company.assembleegameclient.game.AGameSprite;
import com.company.ui.BaseSimpleText;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;

import kabam.rotmg.messaging.impl.data.TradeItem;
import kabam.rotmg.text.view.TextFieldDisplayConcrete;
import kabam.rotmg.text.view.stringBuilder.LineBuilder;

public class TradeInventory extends Sprite {

    private static const NO_CUT:Array = [0, 0, 0, 0];

    private static const cuts:Array = [[1, 0, 0, 1], NO_CUT, NO_CUT, [0, 1, 1, 0], [1, 0, 0, 0], NO_CUT, NO_CUT, [0, 1, 0, 0], [0, 0, 0, 1], NO_CUT, NO_CUT, [0, 0, 1, 0]];

    public static const CLICKITEMS_MESSAGE:int = 0;

    public static const NOTENOUGHSPACE_MESSAGE:int = 1;

    public static const TRADEACCEPTED_MESSAGE:int = 2;

    public static const TRADEWAITING_MESSAGE:int = 3;

    public function TradeInventory(_arg_1:AGameSprite, _arg_2:String, _arg_3:Vector.<TradeItem>, _arg_4:Boolean) {
        var _local6:* = null;
        var _local5:* = null;
        var _local7:int = 0;
        slots_ = new Vector.<TradeSlot>();
        super();
        this.gs_ = _arg_1;
        this.playerName_ = _arg_2;
        this.nameText_ = new BaseSimpleText(20, 0xb3b3b3, false, 0, 0);
        this.nameText_.setBold(true);
        this.nameText_.x = 0;
        this.nameText_.y = 0;
        this.nameText_.text = this.playerName_;
        this.nameText_.updateMetrics();
        this.nameText_.filters = [new DropShadowFilter(0, 0, 0)];
        addChild(this.nameText_);
        this.taglineText_ = new TextFieldDisplayConcrete().setSize(12).setColor(0xb3b3b3);
        this.taglineText_.x = 0;
        this.taglineText_.y = 22;
        this.taglineText_.filters = [new DropShadowFilter(0, 0, 0)];
        addChild(this.taglineText_);
        while (_local7 < 12) {
            _local6 = _arg_3[_local7];
            _local5 = new TradeSlot(_local6.item_, _local6.tradeable_, _local6.included_, _local6.slotType_, _local7 - 3, cuts[_local7], _local7);
            _local5.setPlayer(this.gs_.map.player_);
            _local5.x = _local7 % 4 * 44;
            _local5.y = int(_local7 / 4) * 44 + 46;
            if (_arg_4 && _local6.tradeable_) {
                _local5.addEventListener("mouseDown", this.onSlotClick, false, 0, true);
            }
            this.slots_.push(_local5);
            addChild(_local5);
            _local7++;
        }
    }
    public var gs_:AGameSprite;
    public var playerName_:String;
    public var slots_:Vector.<TradeSlot>;
    private var message_:int;
    private var nameText_:BaseSimpleText;
    private var taglineText_:TextFieldDisplayConcrete;

    public function getOffer():Vector.<Boolean> {
        var _local2:int = 0;
        var _local1:Vector.<Boolean> = new Vector.<Boolean>();
        while (_local2 < this.slots_.length) {
            _local1.push(this.slots_[_local2].included_);
            _local2++;
        }
        return _local1;
    }

    public function setOffer(_arg_1:Vector.<Boolean>):void {
        var _local2:int = 0;
        while (_local2 < this.slots_.length) {
            this.slots_[_local2].setIncluded(_arg_1[_local2]);
            _local2++;
        }
    }

    public function isOffer(_arg_1:Vector.<Boolean>):Boolean {
        var _local2:int = 0;
        while (_local2 < this.slots_.length) {
            if (_arg_1[_local2] != this.slots_[_local2].included_) {
                return false;
            }
            _local2++;
        }
        return true;
    }

    public function numIncluded():int {
        var _local1:int = 0;
        var _local2:int = 0;
        while (_local2 < this.slots_.length) {
            if (this.slots_[_local2].included_) {
                _local1++;
            }
            _local2++;
        }
        return _local1;
    }

    public function numEmpty():int {
        var _local1:int = 0;
        var _local2:int = 4;
        while (_local2 < this.slots_.length) {
            if (this.slots_[_local2].isEmpty()) {
                _local1++;
            }
            _local2++;
        }
        return _local1;
    }

    public function setMessage(_arg_1:int):void {
        var _local2:String = "";
        switch (int(_arg_1)) {
            case 0:
                this.nameText_.setColor(0xb3b3b3);
                this.taglineText_.setColor(0xb3b3b3);
                _local2 = "TradeInventory.clickItemsToTrade";
                break;
            case 1:
                this.nameText_.setColor(0xff0000);
                this.taglineText_.setColor(0xff0000);
                _local2 = "TradeInventory.notEnoughSpace";
                break;
            case 2:
                this.nameText_.setColor(9022300);
                this.taglineText_.setColor(9022300);
                _local2 = "TradeInventory.tradeAccepted";
                break;
            case 3:
                this.nameText_.setColor(0xb3b3b3);
                this.taglineText_.setColor(0xb3b3b3);
                _local2 = "TradeInventory.playerIsSelectingItems";
        }
        this.taglineText_.setStringBuilder(new LineBuilder().setParams(_local2));
    }

    private function onSlotClick(_arg_1:MouseEvent):void {
        var _local2:TradeSlot = _arg_1.currentTarget as TradeSlot;
        _local2.setIncluded(!_local2.included_);
        dispatchEvent(new Event("change"));
    }
}
}
