package com.company.assembleegameclient.objects {
import com.company.assembleegameclient.map.Camera;
import com.company.assembleegameclient.map.Map;
import com.company.assembleegameclient.ui.tooltip.EquipmentToolTip;
import com.company.assembleegameclient.ui.tooltip.ToolTip;
import com.company.ui.BaseSimpleText;
import com.company.util.IntPoint;
import com.gskinner.motion.GTween;
import com.gskinner.motion.easing.Sine;

import flash.display.BitmapData;
import flash.geom.ColorTransform;
import flash.geom.Matrix;

import kabam.rotmg.core.StaticInjectorContext;
import kabam.rotmg.game.model.AddSpeechBalloonVO;
import kabam.rotmg.game.signals.AddSpeechBalloonSignal;
import kabam.rotmg.language.model.StringMap;
import kabam.rotmg.text.view.stringBuilder.LineBuilder;

public class Merchant extends SellableObject implements IInteractiveObject {

    private static const NONE_MESSAGE:int = 0;

    private static const NEW_MESSAGE:int = 1;

    private static const MINS_LEFT_MESSAGE:int = 2;

    private static const ITEMS_LEFT_MESSAGE:int = 3;

    private static const DISCOUNT_MESSAGE:int = 4;

    private static const T:Number = 1;

    private static const DOSE_MATRIX:Matrix = function ():Matrix {
        var _local1:* = new Matrix();
        _local1.translate(10, 5);
        return _local1;
    }();

    public function Merchant(_arg_1:XML) {
        ct_ = new ColorTransform(1, 1, 1, 1);
        addSpeechBalloon = StaticInjectorContext.getInjector().getInstance(AddSpeechBalloonSignal);
        stringMap = StaticInjectorContext.getInjector().getInstance(StringMap);
        super(_arg_1);
        isInteractive_ = true;
    }
    public var merchandiseType_:int = -1;
    public var count_:int = -1;
    public var minsLeft_:int = -1;
    public var discount_:int = 0;
    public var merchandiseTexture_:BitmapData = null;
    public var untilNextMessage_:int = 0;
    public var alpha_:Number = 1;
    private var firstUpdate_:Boolean = true;
    private var messageIndex_:int = 0;
    private var ct_:ColorTransform;
    private var addSpeechBalloon:AddSpeechBalloonSignal;
    private var stringMap:StringMap;

    override public function setPrice(_arg_1:int):void {
        super.setPrice(_arg_1);
        this.untilNextMessage_ = 0;
    }

    override public function setRankReq(_arg_1:int):void {
        super.setRankReq(_arg_1);
        this.untilNextMessage_ = 0;
    }

    override public function addTo(_arg_1:Map, _arg_2:Number, _arg_3:Number):Boolean {
        if (!super.addTo(_arg_1, _arg_2, _arg_3)) {
            return false;
        }
        _arg_1.merchLookup_[new IntPoint(x_, y_)] = this;
        return true;
    }

    override public function removeFromMap():void {
        var _local1:IntPoint = new IntPoint(x_, y_);
        if (map_.merchLookup_[_local1] == this) {
            map_.merchLookup_[_local1] = null;
        }
        super.removeFromMap();
    }

    override public function update(_arg_1:int, _arg_2:int):Boolean {
        var _local3:* = null;
        super.update(_arg_1, _arg_2);
        if (this.firstUpdate_) {
            if (this.minsLeft_ == 0x7fffffff) {
                _local3 = new GTween(this, 0.5, {"size_": 150}, {"ease": Sine.easeOut});
                _local3.nextTween = new GTween(this, 0.5, {"size_": 100}, {"ease": Sine.easeIn});
                _local3.nextTween.paused = true;
            }
            this.firstUpdate_ = false;
        }
        this.untilNextMessage_ = this.untilNextMessage_ - _arg_2;
        if (this.untilNextMessage_ > 0) {
            return true;
        }
        this.untilNextMessage_ = 5000;
        var _local5:Vector.<int> = new Vector.<int>();
        if (this.minsLeft_ == 0x7fffffff) {
            _local5.push(1);
        } else if (this.minsLeft_ >= 0 && this.minsLeft_ <= 5) {
            _local5.push(2);
        }
        if (this.count_ >= 1 && this.count_ <= 2) {
            _local5.push(3);
        }
        if (this.discount_ > 0) {
            _local5.push(4);
        }
        if (_local5.length == 0) {
            return true;
        }
        var _local6:* = this.messageIndex_ + 1;
        this.messageIndex_++;
        this.messageIndex_ = _local6 % _local5.length;
        var _local4:int = _local5[this.messageIndex_];
        this.addSpeechBalloon.dispatch(this.getSpeechBalloon(_local4));
        return true;
    }

    override public function soldObjectName():String {
        return ObjectLibrary.typeToDisplayId_[this.merchandiseType_];
    }

    override public function soldObjectInternalName():String {
        var _local1:XML = ObjectLibrary.xmlLibrary_[this.merchandiseType_];
        return _local1.@id.toString();
    }

    override public function getTooltip():ToolTip {
        return new EquipmentToolTip(this.merchandiseType_, map_.player_, -1, "NPC");
    }

    override public function getSellableType():int {
        return this.merchandiseType_;
    }

    override public function getIcon():BitmapData {
        var _local1:* = null;
        var _local3:* = null;
        var _local4:BitmapData = ObjectLibrary.getRedrawnTextureFromType(this.merchandiseType_, 80, true);
        var _local2:XML = ObjectLibrary.xmlLibrary_[this.merchandiseType_];
        if (_local2.hasOwnProperty("Doses")) {
            _local4 = _local4.clone();
            _local1 = new BaseSimpleText(12, 0xffffff, false, 0, 0);
            _local1.text = _local2.Doses;
            _local1.updateMetrics();
            _local4.draw(_local1, DOSE_MATRIX);
        }
        if (_local2.hasOwnProperty("Quantity")) {
            _local4 = _local4.clone();
            _local3 = new BaseSimpleText(12, 0xffffff, false, 0, 0);
            _local3.text = _local2.Quantity;
            _local3.updateMetrics();
            _local4.draw(_local3, DOSE_MATRIX);
        }
        return _local4;
    }

    override protected function getTexture(_arg_1:Camera, _arg_2:int):BitmapData {
        if (this.alpha_ == 1 && size_ == 100) {
            return this.merchandiseTexture_;
        }
        var _local3:BitmapData = ObjectLibrary.getRedrawnTextureFromType(this.merchandiseType_, size_, false, false);
        if (this.alpha_ != 1) {
            this.ct_.alphaMultiplier = this.alpha_;
            _local3.colorTransform(_local3.rect, this.ct_);
        }
        return _local3;
    }

    public function getSpeechBalloon(_arg_1:int):AddSpeechBalloonVO {
        var _local2:* = null;
        var _local5:int = 0;
        var _local4:int = 0;
        var _local3:int = 0;
        switch (int(_arg_1) - 1) {
            case 0:
                _local2 = new LineBuilder().setParams("Merchant.new");
                _local5 = 0xe6e6e6;
                _local4 = 0xffffff;
                _local3 = 5931045;
                break;
            case 1:
                if (this.minsLeft_ == 0) {
                    _local2 = new LineBuilder().setParams("Merchant.goingSoon");
                } else if (this.minsLeft_ == 1) {
                    _local2 = new LineBuilder().setParams("Merchant.goingInOneMinute");
                } else {
                    _local2 = new LineBuilder().setParams("Merchant.goingInNMinutes", {"minutes": this.minsLeft_});
                }
                _local5 = 5973542;
                _local4 = 16549442;
                _local3 = 16549442;
                break;
            case 2:
                _local2 = new LineBuilder().setParams("Merchant.limitedStock", {"count": this.count_});
                _local5 = 5973542;
                _local4 = 16549442;
                _local3 = 16549442;
                break;
            case 3:
                _local2 = new LineBuilder().setParams("Merchant.discount", {"discount": this.discount_});
                _local5 = 6324275;
                _local4 = 0xffff8f;
                _local3 = 0xffff8f;
        }
        _local2.setStringMap(this.stringMap);
        return new AddSpeechBalloonVO(this, _local2.getString(), "", false, false, _local5, 1, _local4, 1, _local3, 6, true, false);
    }

    public function getTex1Id(_arg_1:int):int {
        var _local2:XML = ObjectLibrary.xmlLibrary_[this.merchandiseType_];
        if (_local2 == null) {
            return _arg_1;
        }
        if (_local2.Activate == "Dye" && "Tex1" in _local2) {
            return _local2.Tex1;
        }
        return _arg_1;
    }

    public function getTex2Id(_arg_1:int):int {
        var _local2:XML = ObjectLibrary.xmlLibrary_[this.merchandiseType_];
        if (_local2 == null) {
            return _arg_1;
        }
        if (_local2.Activate == "Dye" && "Tex2" in _local2) {
            return _local2.Tex2;
        }
        return _arg_1;
    }

    public function setMerchandiseType(_arg_1:int):void {
        this.merchandiseType_ = _arg_1;
        this.merchandiseTexture_ = ObjectLibrary.getRedrawnTextureFromType(this.merchandiseType_, 100, false);
    }
}
}
