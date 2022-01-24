package kabam.rotmg.ui.view.components {
import flash.display.Shape;

public class DarkLayer extends Shape {


    public function DarkLayer(_arg_1:int = 2829099) {
        super();
        graphics.beginFill(_arg_1, 0.7);
        graphics.drawRect(0, 0, 800, 10 * 60);
        graphics.endFill();
    }
}
}
