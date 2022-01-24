package com.company.assembleegameclient.ui.dropdown {
import com.company.ui.BaseSimpleText;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;

public class DropDown extends Sprite {


    public function DropDown(_arg_1:Vector.<String>, _arg_2:int, _arg_3:int, _arg_4:String = null, _arg_5:Number = 0, _arg_6:int = 17) {
        all_ = new Sprite();
        super();
        this.strings_ = _arg_1;
        this.w_ = _arg_2;
        this.h_ = _arg_3;
        this.maxItems_ = _arg_6;
        if (_arg_4 != null) {
            this.labelText_ = new BaseSimpleText(14, 0xffffff, false, 0, 0);
            this.labelText_.setBold(true);
            this.labelText_.text = _arg_4 + ":";
            this.labelText_.updateMetrics();
            addChild(this.labelText_);
            this.xOffset_ = this.labelText_.width + 5;
        }
        this.setIndex(_arg_5);
    }
    protected var strings_:Vector.<String>;
    protected var w_:int;
    protected var h_:int;
    protected var maxItems_:int;
    protected var labelText_:BaseSimpleText;
    protected var xOffset_:int = 0;
    protected var selected_:DropDownItem;
    protected var all_:Sprite;

    public function getValue():String {
        return this.selected_.getValue();
    }

    public function setListItems(_arg_1:Vector.<String>):void {
        this.strings_ = _arg_1;
    }

    public function setValue(_arg_1:String):Boolean {
        var _local2:int = 0;
        while (_local2 < this.strings_.length) {
            if (_arg_1 == this.strings_[_local2]) {
                this.setIndex(_local2);
                return true;
            }
            _local2++;
        }
        return false;
    }

    public function setIndex(_arg_1:int):void {
        if (_arg_1 >= this.strings_.length) {
            _arg_1 = 0;
        }
        this.setSelected(this.strings_[_arg_1]);
    }

    public function getIndex():int {
        var _local1:int = 0;
        while (_local1 < this.strings_.length) {
            if (this.selected_.getValue() == this.strings_[_local1]) {
                return _local1;
            }
            _local1++;
        }
        return -1;
    }

    private function setSelected(_arg_1:String):void {
        var _local2:String = this.selected_ != null ? this.selected_.getValue() : null;
        this.selected_ = new DropDownItem(_arg_1, this.w_, this.h_);
        this.selected_.x = this.xOffset_;
        this.selected_.y = 0;
        addChild(this.selected_);
        this.selected_.addEventListener("click", this.onClick);
        if (_arg_1 != _local2) {
            dispatchEvent(new Event("change"));
        }
    }

    private function showAll():void {
        var _local1:int = 0;
        var _local4:int = 0;
        var _local3:int = 0;
        var _local5:int = 0;
        var _local6:Point = parent.localToGlobal(new Point(x, y));
        this.all_.x = _local6.x;
        this.all_.y = _local6.y;
        var _local2:int = Math.ceil(this.strings_.length / this.maxItems_);
        while (_local5 < _local2) {
            _local1 = _local5 * this.maxItems_;
            _local4 = Math.min(_local1 + this.maxItems_, this.strings_.length);
            _local3 = this.xOffset_ - this.w_ * _local5;
            this.listItems(_local1, _local4, _local3);
            _local5++;
        }
        this.all_.addEventListener("rollOut", this.onOut);
        stage.addChild(this.all_);
    }

    private function listItems(_arg_1:int, _arg_2:int, _arg_3:int):void {
        var _local5:int = 0;
        var _local4:* = null;
        _local5 = 0;
        var _local6:* = _arg_1;
        while (_local6 < _arg_2) {
            _local4 = new DropDownItem(this.strings_[_local6], this.w_, this.h_);
            _local4.addEventListener("click", this.onSelect);
            _local4.x = _arg_3;
            _local4.y = _local5;
            this.all_.addChild(_local4);
            _local5 = _local5 + _local4.h_;
            _local6++;
        }
    }

    private function hideAll():void {
        this.all_.removeEventListener("rollOut", this.onOut);
        stage.removeChild(this.all_);
    }

    private function onClick(_arg_1:MouseEvent):void {
        _arg_1.stopImmediatePropagation();
        this.selected_.removeEventListener("click", this.onClick);
        if (contains(this.selected_)) {
            removeChild(this.selected_);
        }
        this.showAll();
    }

    private function onSelect(_arg_1:MouseEvent):void {
        _arg_1.stopImmediatePropagation();
        this.hideAll();
        var _local2:DropDownItem = _arg_1.target as DropDownItem;
        this.setSelected(_local2.getValue());
    }

    private function onOut(_arg_1:MouseEvent):void {
        this.hideAll();
        this.setSelected(this.selected_.getValue());
    }
}
}
