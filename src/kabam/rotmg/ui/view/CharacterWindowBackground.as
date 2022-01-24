package kabam.rotmg.ui.view {
import flash.display.Sprite;

public class CharacterWindowBackground extends Sprite {


    public function CharacterWindowBackground() {
        super();
        var _local1:Sprite = new Sprite();
        _local1.graphics.beginFill(0x363636);
        _local1.graphics.drawRect(0, 0, 200, 10 * 60);
        addChild(_local1);
    }
}
}
