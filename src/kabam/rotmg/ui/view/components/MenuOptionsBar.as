package kabam.rotmg.ui.view.components {
import com.company.assembleegameclient.screens.TitleMenuOption;
import com.company.rotmg.graphics.ScreenGraphic;

import flash.display.Sprite;
import flash.geom.Rectangle;

public class MenuOptionsBar extends Sprite {

    private static const Y_POSITION:Number = 550;

    private static const SPACING:int = 20;

    public static const CENTER:String = "CENTER";

    public static const RIGHT:String = "RIGHT";

    public static const LEFT:String = "LEFT";


    private const leftObjects:Array = [];

    private const rightObjects:Array = [];

    public function MenuOptionsBar() {
        super();
        this.makeScreenGraphic();
    }
    private var screenGraphic:ScreenGraphic;

    public function addButton(_arg_1:TitleMenuOption, _arg_2:String):void {
        var _local3:* = undefined;
        this.screenGraphic.addChild(_arg_1);
        var _local4:* = _arg_2;
        switch (_local4) {
            case "CENTER":
                _local3 = _arg_1;
                this.rightObjects[0] = _local3;
                this.leftObjects[0] = _local3;
                _arg_1.x = this.screenGraphic.width / 2;
                _arg_1.y = 550;
                return;
            case "LEFT":
                this.layoutToLeftOf(this.leftObjects[this.leftObjects.length - 1], _arg_1);
                this.leftObjects.push(_arg_1);
                _arg_1.changed.add(this.layoutLeftButtons);
                return;
            case "RIGHT":
                this.layoutToRightOf(this.rightObjects[this.rightObjects.length - 1], _arg_1);
                this.rightObjects.push(_arg_1);
                _arg_1.changed.add(this.layoutRightButtons);
                return;
            default:
                return;
        }
    }

    private function makeScreenGraphic():void {
        this.screenGraphic = new ScreenGraphic();
        addChild(this.screenGraphic);
    }

    private function layoutLeftButtons():void {
        var _local1:int = 1;
        while (_local1 < this.leftObjects.length) {
            this.layoutToLeftOf(this.leftObjects[_local1 - 1], this.leftObjects[_local1]);
            _local1++;
        }
    }

    private function layoutToLeftOf(_arg_1:TitleMenuOption, _arg_2:TitleMenuOption):void {
        var _local4:Rectangle = _arg_1.getBounds(_arg_1);
        var _local3:Rectangle = _arg_2.getBounds(_arg_2);
        _arg_2.x = _arg_1.x + _local4.left - _local3.right - 20;
        _arg_2.y = 550;
    }

    private function layoutRightButtons():void {
        var _local1:int = 1;
        while (_local1 < this.rightObjects.length) {
            this.layoutToRightOf(this.rightObjects[_local1 - 1], this.rightObjects[_local1]);
            _local1++;
        }
    }

    private function layoutToRightOf(_arg_1:TitleMenuOption, _arg_2:TitleMenuOption):void {
        var _local4:Rectangle = _arg_1.getBounds(_arg_1);
        var _local3:Rectangle = _arg_2.getBounds(_arg_2);
        _arg_2.x = _arg_1.x + _local4.right - _local3.left + 20;
        _arg_2.y = 550;
    }
}
}
