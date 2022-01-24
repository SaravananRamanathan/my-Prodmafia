package kabam.rotmg.util.components {
import com.company.util.GraphicsUtil;

import flash.display.Graphics;
import flash.display.GraphicsPath;
import flash.display.GraphicsSolidFill;
import flash.display.GraphicsStroke;
import flash.display.IGraphicsData;
import flash.display.Shape;
import flash.display.Sprite;

import org.osflash.signals.Signal;

public class RadioButton extends Sprite {


    public const changed:Signal = new Signal(Boolean);

    private const WIDTH:int = 28;

    private const HEIGHT:int = 28;

    public function RadioButton() {
        super();
        var _local1:* = this.makeUnselected();
        this.unselected = _local1;
        addChild(_local1);
        _local1 = this.makeSelected();
        this.selected = _local1;
        addChild(_local1);
        this.setSelected(false);
    }
    private var unselected:Shape;
    private var selected:Shape;

    public function setSelected(_arg_1:Boolean):void {
        this.unselected.visible = !_arg_1;
        this.selected.visible = _arg_1;
        this.changed.dispatch(_arg_1);
    }

    private function makeUnselected():Shape {
        var _local1:Shape = new Shape();
        this.drawOutline(_local1.graphics);
        return _local1;
    }

    private function makeSelected():Shape {
        var _local1:Shape = new Shape();
        this.drawOutline(_local1.graphics);
        this.drawFill(_local1.graphics);
        return _local1;
    }

    private function drawOutline(_arg_1:Graphics):void {
        var _local2:GraphicsSolidFill = new GraphicsSolidFill(0, 0.01);
        var _local6:GraphicsSolidFill = new GraphicsSolidFill(0xffffff, 1);
        var _local4:GraphicsStroke = new GraphicsStroke(2, false, "normal", "none", "round", 3, _local6);
        var _local3:GraphicsPath = new GraphicsPath();
        GraphicsUtil.drawCutEdgeRect(0, 0, 28, 28, 4, GraphicsUtil.ALL_CUTS, _local3);
        var _local5:Vector.<IGraphicsData> = new <IGraphicsData>[_local4, _local2, _local3, GraphicsUtil.END_FILL, GraphicsUtil.END_STROKE];
        _arg_1.drawGraphicsData(_local5);
    }

    private function drawFill(_arg_1:Graphics):void {
        var _local2:GraphicsSolidFill = new GraphicsSolidFill(0xffffff, 1);
        var _local4:GraphicsPath = new GraphicsPath();
        GraphicsUtil.drawCutEdgeRect(4, 4, 20, 20, 2, GraphicsUtil.ALL_CUTS, _local4);
        var _local3:Vector.<IGraphicsData> = new <IGraphicsData>[_local2, _local4, GraphicsUtil.END_FILL];
        _arg_1.drawGraphicsData(_local3);
    }
}
}
