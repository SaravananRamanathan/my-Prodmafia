package kabam.rotmg.arena.component {
import flash.display.Shape;
import flash.display.Sprite;

import kabam.rotmg.text.view.TextFieldDisplayConcrete;
import kabam.rotmg.text.view.stringBuilder.LineBuilder;
import kabam.rotmg.util.graphics.BevelRect;
import kabam.rotmg.util.graphics.GraphicsHelper;

public class HostQueryDetailBubble extends Sprite {


    private const WIDTH:int = 235;

    private const HEIGHT:int = 252;

    private const BEVEL:int = 4;

    private const POINT:int = 6;

    private const POINT_CENTER:int = 25;

    private const PADDING:int = 8;

    private const bubble:Shape = new Shape();

    private const textfield:TextFieldDisplayConcrete = makeText();

    public function HostQueryDetailBubble() {
        super();
        addChild(this.bubble);
        addChild(this.textfield);
    }

    public function setText(_arg_1:String):void {
        this.textfield.setStringBuilder(new LineBuilder().setParams(_arg_1));
        this.textfield.textChanged.add(this.onTextUpdated);
    }

    private function makeText():TextFieldDisplayConcrete {
        return new TextFieldDisplayConcrete().setSize(16).setLeading(3).setAutoSize("left").setVerticalAlign("top").setMultiLine(true).setWordWrap(true).setPosition(8, 8).setTextWidth(219).setTextHeight(236);
    }

    private function onTextUpdated():void {
        this.makeBubble();
    }

    private function makeBubble():void {
        var _local1:GraphicsHelper = new GraphicsHelper();
        var _local2:BevelRect = new BevelRect(235, this.textfield.height + 16, 4);
        this.bubble.graphics.beginFill(0xe0e0e0);
        _local1.drawBevelRect(0, 0, _local2, this.bubble.graphics);
        this.bubble.graphics.endFill();
        this.bubble.graphics.beginFill(0xe0e0e0);
        this.bubble.graphics.moveTo(19, 0);
        this.bubble.graphics.lineTo(25, -6);
        this.bubble.graphics.lineTo(31, 0);
        this.bubble.graphics.endFill();
    }
}
}
