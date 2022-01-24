package com.company.assembleegameclient.ui.options {
import com.company.util.GraphicsUtil;

import flash.display.Graphics;
import flash.display.GraphicsPath;
import flash.display.GraphicsSolidFill;
import flash.display.GraphicsStroke;
import flash.display.IGraphicsData;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;

import kabam.rotmg.text.view.TextFieldDisplayConcrete;
import kabam.rotmg.text.view.stringBuilder.StringBuilder;

public class ChoiceBox extends Sprite {

    public static const WIDTH:int = 80;

    public static const HEIGHT:int = 32;

    public function ChoiceBox(_arg_1:Vector.<StringBuilder>, _arg_2:Array, _arg_3:Object, _arg_4:Number = 16777215) {
        internalFill_ = new GraphicsSolidFill(0x333333, 1);
        overLineFill_ = new GraphicsSolidFill(0xb3b3b3, 1);
        normalLineFill_ = new GraphicsSolidFill(0x444444, 1);
        path_ = new GraphicsPath(new Vector.<int>(), new Vector.<Number>());
        lineStyle_ = new GraphicsStroke(2, false, "normal", "none", "round", 3, normalLineFill_);
        graphicsData_ = new <IGraphicsData>[internalFill_, lineStyle_, path_, GraphicsUtil.END_STROKE, GraphicsUtil.END_FILL];
        super();
        this.color = _arg_4;
        this.labels_ = _arg_1;
        this.values_ = _arg_2;
        this.labelText_ = new TextFieldDisplayConcrete().setSize(16).setColor(_arg_4);
        this.labelText_.x = 40;
        this.labelText_.y = 16;
        this.labelText_.setAutoSize("center").setVerticalAlign("middle");
        this.labelText_.setBold(true);
        this.labelText_.filters = [new DropShadowFilter(0, 0, 0, 1, 4, 4, 2)];
        addChild(this.labelText_);
        this.setValue(_arg_3);
        addEventListener("mouseOver", this.onMouseOver);
        addEventListener("rollOut", this.onRollOut);
        addEventListener("click", this.onClick);
        addEventListener("rightClick", this.onRightClick);
    }
    public var labels_:Vector.<StringBuilder>;
    public var values_:Array;
    public var selectedIndex_:int = -1;
    public var labelText_:TextFieldDisplayConcrete;
    private var over_:Boolean = false;
    private var color:Number = 16777215;
    private var internalFill_:GraphicsSolidFill;
    private var overLineFill_:GraphicsSolidFill;
    private var normalLineFill_:GraphicsSolidFill;
    private var path_:GraphicsPath;
    private var lineStyle_:GraphicsStroke;
    private var graphicsData_:Vector.<IGraphicsData>;

    public function setValue(_arg_1:*, _arg_2:Boolean = true):void {
        var _local3:int = 0;
        while (_local3 < this.values_.length) {
            if (_arg_1 == this.values_[_local3]) {
                if (_local3 == this.selectedIndex_) {
                    return;
                }
                this.selectedIndex_ = _local3;
                break;
            }
            _local3++;
        }
        this.setSelected(this.selectedIndex_);
        if (_arg_2) {
            dispatchEvent(new Event("change"));
        }
    }

    public function value():* {
        return this.values_[this.selectedIndex_];
    }

    private function drawBackground():void {
        GraphicsUtil.clearPath(this.path_);
        GraphicsUtil.drawCutEdgeRect(0, 0, 80, 32, 4, [1, 1, 1, 1], this.path_);
        this.lineStyle_.fill = !!this.over_ ? this.overLineFill_ : this.normalLineFill_;
        graphics.drawGraphicsData(this.graphicsData_);
        var _local1:Graphics = graphics;
        _local1.clear();
        _local1.drawGraphicsData(this.graphicsData_);
    }

    private function setSelected(_arg_1:int):void {
        this.selectedIndex_ = _arg_1;
        if (this.selectedIndex_ < 0 || this.selectedIndex_ >= this.labels_.length) {
            this.selectedIndex_ = 0;
        }
        this.setText(this.labels_[this.selectedIndex_]);
    }

    private function setText(_arg_1:StringBuilder):void {
        this.labelText_.setStringBuilder(_arg_1);
        this.drawBackground();
    }

    private function onMouseOver(_arg_1:MouseEvent):void {
        this.over_ = true;
        this.drawBackground();
    }

    private function onRollOut(_arg_1:MouseEvent):void {
        this.over_ = false;
        this.drawBackground();
    }

    private function onClick(_arg_1:MouseEvent):void {
        this.setSelected((this.selectedIndex_ + 1) % this.values_.length);
        dispatchEvent(new Event("change"));
    }

    private function onRightClick(_arg_1:MouseEvent):void {
        this.setSelected(this.selectedIndex_ - 1 < 0 ? this.values_.length - 1 : Number(this.selectedIndex_ - 1));
        dispatchEvent(new Event("change"));
    }
}
}
