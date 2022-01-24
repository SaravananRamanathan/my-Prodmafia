package com.company.assembleegameclient.ui {
import com.company.util.GraphicsUtil;

import flash.display.GraphicsPath;
import flash.display.GraphicsSolidFill;
import flash.display.IGraphicsData;
import flash.display.Shape;

public class LineBreakDesign extends Shape {


    public function LineBreakDesign(_arg_1:int, _arg_2:uint) {
        designFill_ = new GraphicsSolidFill(0xffffff, 1);
        designPath_ = new GraphicsPath(new Vector.<int>(), new Vector.<Number>(), "nonZero");
        designGraphicsData_ = new <IGraphicsData>[designFill_, designPath_, GraphicsUtil.END_FILL];
        super();
        this.setWidthColor(_arg_1, _arg_2);
    }
    private var designFill_:GraphicsSolidFill;
    private var designPath_:GraphicsPath;
    private var designGraphicsData_:Vector.<IGraphicsData>;

    public function setWidthColor(_arg_1:int, _arg_2:uint):void {
        graphics.clear();
        this.designFill_.color = _arg_2;
        GraphicsUtil.clearPath(this.designPath_);
        GraphicsUtil.drawDiamond(0, 0, 4, this.designPath_);
        GraphicsUtil.drawDiamond(_arg_1, 0, 4, this.designPath_);
        GraphicsUtil.drawRect(0, -1, _arg_1, 2, this.designPath_);
        graphics.drawGraphicsData(this.designGraphicsData_);
    }
}
}
