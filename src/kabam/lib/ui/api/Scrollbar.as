package kabam.lib.ui.api {
import org.osflash.signals.Signal;

public interface Scrollbar {

    function get positionChanged():Signal;

    function setSize(barSize: int, visibleSize: int):void;

    function getBarSize():int;

    function getGrooveSize():int;

    function getPosition():Number;

    function setPosition(pos: Number):void;
}
}
