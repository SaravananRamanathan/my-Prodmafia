package kabam.rotmg.util.graphics {
import flash.display.DisplayObject;
import flash.geom.Rectangle;

public class ButtonLayoutHelper {


    public function ButtonLayoutHelper() {
        super();
    }

    public function layout(_arg_1:int, ...rest):void {
        var _local3:int = rest.length;
        switch (int(_local3) - 1) {
            case 0:
                this.centerButton(_arg_1, rest[0]);
                return;
            case 1:
                this.twoButtons(_arg_1, rest[0], rest[1]);
                return;
        }
    }

    private function centerButton(_arg_1:int, _arg_2:DisplayObject):void {
        var _local3:Rectangle = _arg_2.getRect(_arg_2);
        _arg_2.x = (_arg_1 - _local3.width) * 0.5 - _local3.left;
    }

    private function twoButtons(_arg_1:int, _arg_2:DisplayObject, _arg_3:DisplayObject):void {
        var _local4:* = null;
        var _local5:Rectangle = _arg_2.getRect(_arg_2);
        _local4 = _arg_3.getRect(_arg_3);
        _arg_2.x = (_arg_1 - 2 * _arg_2.width) * 0.25 - _local5.left;
        _arg_3.x = (3 * _arg_1 - 2 * _arg_3.width) * 0.25 - _local4.left;
    }
}
}
