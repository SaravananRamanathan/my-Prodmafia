package kabam.rotmg.game.view.components {
import flash.display.Sprite;

public class TabBackground extends Sprite {


    public function TabBackground(_arg_1:Number = 28, _arg_2:Number = 35) {
        super();
        graphics.beginFill(7039594);
        graphics.drawRoundRect(0, 0, _arg_1, _arg_2, 9, 9);
        graphics.endFill();
    }
}
}
