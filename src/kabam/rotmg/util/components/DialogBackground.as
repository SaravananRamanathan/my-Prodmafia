package kabam.rotmg.util.components {
import flash.display.Sprite;

import kabam.rotmg.util.graphics.BevelRect;
import kabam.rotmg.util.graphics.GraphicsHelper;

public class DialogBackground extends Sprite {

    private static const BEVEL:int = 4;


    public function DialogBackground() {
        super();
    }

    public function draw(_arg_1:int, _arg_2:int):void {
        var _local4:BevelRect = new BevelRect(_arg_1, _arg_2, 4);
        var _local3:GraphicsHelper = new GraphicsHelper();
        graphics.lineStyle(1, 0xffffff, 1, false, "normal", "none", "round", 3);
        graphics.beginFill(0x363636);
        _local3.drawBevelRect(0, 0, _local4, graphics);
        graphics.endFill();
    }
}
}
