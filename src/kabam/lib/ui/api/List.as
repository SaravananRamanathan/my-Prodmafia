package kabam.lib.ui.api {
import flash.display.DisplayObject;

public interface List {

    function addItem(element:DisplayObject):void;

    function setItems(elements:Vector.<DisplayObject>):void;

    function getItemAt(index:int):DisplayObject;

    function getItemCount():int;
}
}
