package kabam.rotmg.text.model {
import flash.display.BitmapData;
import flash.geom.Rectangle;
import flash.text.TextField;
import flash.text.TextFormat;

public class FontInfo {

    private static const renderingFontSize:Number = 200;

    private static const GUTTER:Number = 2;

    public function FontInfo() {
        super();
    }
    protected var name:String;
    private var textColor:uint = 0;
    private var xHeightRatio:Number;
    private var verticalSpaceRatio:Number;

    public function setName(_arg_1:String):void {
        this.name = _arg_1;
        this.computeRatiosByRendering();
    }

    public function getName():String {
        return this.name;
    }

    public function getXHeight(_arg_1:Number):Number {
        return this.xHeightRatio * _arg_1;
    }

    public function getVerticalSpace(_arg_1:Number):Number {
        return this.verticalSpaceRatio * _arg_1;
    }

    private function computeRatiosByRendering():void {
        var _local4:TextField = this.makeTextField();
        var _local2:BitmapData = new BitmapData(_local4.width, _local4.height, true, 0);
        _local2.draw(_local4);
        var _local3:Rectangle = _local2.getColorBoundsRect(0xffffff, this.textColor, true);
        this.xHeightRatio = this.deNormalize(_local3.height);
        this.verticalSpaceRatio = this.deNormalize(_local4.height - _local3.bottom - 2);
    }

    private function makeTextField():TextField {
        var _local1:TextField = new TextField();
        _local1.autoSize = "left";
        _local1.text = "x";
        _local1.textColor = this.textColor;
        _local1.setTextFormat(new TextFormat(this.name, 200));
        return _local1;
    }

    private function deNormalize(_arg_1:Number):Number {
        return _arg_1 / 200;
    }
}
}
