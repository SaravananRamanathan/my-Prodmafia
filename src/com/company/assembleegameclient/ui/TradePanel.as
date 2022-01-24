package com.company.assembleegameclient.ui {
import com.company.assembleegameclient.game.AGameSprite;
import com.company.assembleegameclient.parameters.Parameters;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;

import kabam.rotmg.messaging.impl.incoming.TradeStart;

public class TradePanel extends Sprite {

    public static const WIDTH:int = 200;

    public static const HEIGHT:int = 400;

    public function TradePanel(_arg_1:AGameSprite, _arg_2:TradeStart) {
        super();
        this.gs_ = _arg_1;
        var _local3:String = this.gs_.map.player_.name_;
        this.myInv_ = new TradeInventory(_arg_1, _local3, _arg_2.myItems_, true);
        this.myInv_.x = 14;
        this.myInv_.y = 0;
        this.myInv_.addEventListener("change", this.onMyInvChange, false, 0, true);
        addChild(this.myInv_);
        this.yourInv_ = new TradeInventory(_arg_1, _arg_2.yourName_, _arg_2.yourItems_, false);
        this.yourInv_.x = 14;
        this.yourInv_.y = 174;
        addChild(this.yourInv_);
        this.cancelButton_ = new DeprecatedTextButton(16, "Frame.cancel", 80);
        this.cancelButton_.addEventListener("click", this.onCancelClick, false, 0, true);
        this.cancelButton_.textChanged.addOnce(this.onCancelTextChanged);
        addChild(this.cancelButton_);
        this.tradeButton_ = new TradeButton(16, 80);
        this.tradeButton_.x = 150 - this.tradeButton_.bWidth / 2;
        this.tradeButton_.addEventListener("click", this.onTradeClick, false, 0, true);
        this.tradeButton_.addEventListener("rightClick", this.onTradeRightClick, false, 0, true);
        addChild(this.tradeButton_);
        this.checkTrade();
        addEventListener("addedToStage", this.onAddedToStage, false, 0, true);
        addEventListener("removedFromStage", this.onRemovedFromStage, false, 0, true);
    }
    public var gs_:AGameSprite;
    private var myInv_:TradeInventory;
    private var yourInv_:TradeInventory;
    private var cancelButton_:DeprecatedTextButton;
    private var tradeButton_:TradeButton;

    public function setYourOffer(_arg_1:Vector.<Boolean>):void {
        this.yourInv_.setOffer(_arg_1);
        this.checkTrade();
    }

    public function youAccepted(_arg_1:Vector.<Boolean>, _arg_2:Vector.<Boolean>):void {
        if (this.myInv_.isOffer(_arg_1) && this.yourInv_.isOffer(_arg_2)) {
            this.yourInv_.setMessage(2);
        }
    }

    public function checkTrade():void {
        var _local5:int = this.myInv_.numIncluded();
        var _local2:int = this.myInv_.numEmpty();
        var _local1:int = this.yourInv_.numIncluded();
        var _local4:int = this.yourInv_.numEmpty();
        var _local3:Boolean = true;
        if (_local1 - _local5 - _local2 > 0) {
            this.myInv_.setMessage(1);
            _local3 = false;
        } else {
            this.myInv_.setMessage(0);
        }
        if (_local5 - _local1 - _local4 > 0) {
            this.yourInv_.setMessage(1);
            _local3 = false;
        } else {
            this.yourInv_.setMessage(3);
        }
        if (_local3) {
            this.tradeButton_.reset();
        } else {
            this.tradeButton_.disable();
        }
    }

    private function onCancelTextChanged():void {
        this.cancelButton_.x = 50 - this.cancelButton_.bWidth / 2;
        this.cancelButton_.y = 400 - this.cancelButton_.height - 10;
        this.tradeButton_.y = this.cancelButton_.y;
    }

    private function onAddedToStage(_arg_1:Event):void {
        stage.addEventListener("activate", this.onActivate, false, 0, true);
    }

    private function onRemovedFromStage(_arg_1:Event):void {
        removeEventListener("addedToStage", this.onAddedToStage);
        removeEventListener("removedFromStage", this.onRemovedFromStage);
        this.myInv_.removeEventListener("change", this.onMyInvChange);
        this.cancelButton_.removeEventListener("click", this.onCancelClick);
        this.cancelButton_.textChanged.removeAll();
        this.tradeButton_.removeEventListener("click", this.onTradeClick);
        this.tradeButton_.removeEventListener("rightClick", this.onTradeRightClick);
        stage.removeEventListener("activate", this.onActivate);
    }

    private function onActivate(_arg_1:Event):void {
        this.tradeButton_.reset();
    }

    private function onMyInvChange(_arg_1:Event):void {
        this.gs_.gsc_.changeTrade(this.myInv_.getOffer());
        this.checkTrade();
    }

    private function onCancelClick(_arg_1:MouseEvent):void {
        this.gs_.gsc_.cancelTrade();
        dispatchEvent(new Event("cancel"));
    }

    private function onTradeClick(_arg_1:MouseEvent):void {
        this.gs_.gsc_.acceptTrade(this.myInv_.getOffer(), this.yourInv_.getOffer());
        this.myInv_.setMessage(2);
    }

    private function onTradeRightClick(_arg_1:MouseEvent):void {
        var _local3:* = undefined;
        var _local2:int = 0;
        if (Parameters.data.rightClickSelectAll) {
            _local3 = new Vector.<Boolean>(12);
            _local3[0] = false;
            _local3[1] = false;
            _local3[2] = false;
            _local3[3] = false;
            _local2 = 4;
            while (_local2 < 12) {
                _local3[_local2] = this.gs_.map.player_.equipment_[_local2] != -1 && this.myInv_.slots_[_local2].included_;
                _local2++;
            }
            this.myInv_.setOffer(_local3);
            onMyInvChange(null);
        }
    }
}
}
