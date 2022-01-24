package kabam.rotmg.protip.view {
import com.gskinner.motion.GTween;

import flash.display.Sprite;
import flash.filters.GlowFilter;

public class ProTipView extends Sprite {


    public function ProTipView() {
        super();
        this.text = new ProTipText();
        this.text.x = 5 * 60;
        this.text.y = 125;
        addChild(this.text);
        filters = [new GlowFilter(0, 1, 3, 3, 2, 1)];
        mouseEnabled = false;
        mouseChildren = false;
    }
    private var text:ProTipText;

    public function setTip(_arg_1:String):void {
        this.text.setTip(_arg_1);
        var _local2:GTween = new GTween(this, 5, {"alpha": 0});
        _local2.delay = 5;
        _local2.onComplete = this.removeSelf;
    }

    private function removeSelf(_arg_1:GTween):void {
    }
}
}
