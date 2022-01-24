package com.company.assembleegameclient.ui {
import com.company.util.GraphicsUtil;

import flash.display.GraphicsPath;
import flash.display.GraphicsSolidFill;
import flash.display.IGraphicsData;
import flash.display.Sprite;

import kabam.rotmg.text.view.TextFieldDisplayConcrete;

public class BackgroundFilledText extends Sprite {

    protected static const MARGIN:int = 4;

    public function BackgroundFilledText(_arg_1:int) {
        enabledFill_ = new GraphicsSolidFill(0xffffff, 1);
        disabledFill_ = new GraphicsSolidFill(0x7f7f7f, 1);
        path_ = new GraphicsPath(new Vector.<int>(), new Vector.<Number>());
        graphicsData_ = new <IGraphicsData>[enabledFill_, path_, GraphicsUtil.END_FILL];
        super();
        this.bWidth = _arg_1;
    }
    public var bWidth:int = 0;
    protected var text_:TextFieldDisplayConcrete;
    protected var w_:int;
    protected var enabledFill_:GraphicsSolidFill;
    protected var disabledFill_:GraphicsSolidFill;
    protected var path_:GraphicsPath;
    protected var graphicsData_:Vector.<IGraphicsData>;

    public function addText(_arg_1:int):void {
        this.text_ = this.makeText().setSize(_arg_1).setColor(0x363636);
        this.text_.setBold(true);
        this.text_.setAutoSize("center");
        this.text_.y = 4;
        addChild(this.text_);
    }

    protected function centerTextAndDrawButton():void {
        this.w_ = this.bWidth != 0 ? this.bWidth : this.text_.width + 12;
        this.text_.x = this.w_ / 2;
        GraphicsUtil.clearPath(this.path_);
        GraphicsUtil.drawCutEdgeRect(0, 0, this.w_, this.text_.height + 8, 4, [1, 1, 1, 1], this.path_);
    }

    protected function makeText():TextFieldDisplayConcrete {
        return new TextFieldDisplayConcrete();
    }
}
}
