package kabam.rotmg.game.view.components {
import flash.display.Bitmap;
import flash.display.Sprite;
import flash.geom.ColorTransform;

public class TabIconView extends TabView {


    public function TabIconView(_arg_1:int, _arg_2:Sprite, _arg_3:Bitmap) {
        super(_arg_1);
        this.initBackground(_arg_2);
        if (_arg_3) {
            this.initIcon(_arg_3);
        }
    }
    private var background:Sprite;
    private var icon:Bitmap;

    override public function setSelected(_arg_1:Boolean):void {
        var _local2:ColorTransform = this.background.transform.colorTransform;
        _local2.color = !!_arg_1 ? 2368034 : 7039594;
        this.background.transform.colorTransform = _local2;
    }

    private function initBackground(_arg_1:Sprite):void {
        this.background = _arg_1;
        addChild(_arg_1);
    }

    private function initIcon(_arg_1:Bitmap):void {
        this.icon = _arg_1;
        _arg_1.x = _arg_1.x - 5;
        _arg_1.y = _arg_1.y - 11;
        addChild(_arg_1);
    }
}
}
