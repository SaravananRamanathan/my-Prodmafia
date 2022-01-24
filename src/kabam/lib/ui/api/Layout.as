package kabam.lib.ui.api {
import flash.display.DisplayObject;

public interface Layout {

    function getPadding():int;

    function setPadding(amount: int):void;

    function layout(elements: Vector.<DisplayObject>, offset: int = 0):void;
}
}
