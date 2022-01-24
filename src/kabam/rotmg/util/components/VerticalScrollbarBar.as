package kabam.rotmg.util.components {
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;

import kabam.rotmg.util.graphics.BevelRect;
import kabam.rotmg.util.graphics.GraphicsHelper;

import org.osflash.signals.Signal;

internal final class VerticalScrollbarBar extends Sprite {

    public static const WIDTH:int = 20;

    public static const BEVEL:int = 4;

    public static const PADDING:int = 0;


    public const dragging:Signal = new Signal(int);

    public const scrolling:Signal = new Signal(Number);

    public const rect:BevelRect = new BevelRect(20, 0, 4);

    private const helper:GraphicsHelper = new GraphicsHelper();

    function VerticalScrollbarBar() {
        super();
    }
    private var downOffset:Number;
    private var isOver:Boolean;
    private var isDown:Boolean;

    public function redraw():void {
        var _local1:int = this.isOver || this.isDown ? 16767876 : 13421772;
        graphics.clear();
        graphics.beginFill(_local1);
        this.helper.drawBevelRect(0, 0, this.rect, graphics);
        graphics.endFill();
    }

    public function addMouseListeners():void {
        addEventListener("mouseDown", this.onMouseDown);
        addEventListener("mouseOver", this.onMouseOver);
        addEventListener("mouseOut", this.onMouseOut);
        if (parent && parent.parent) {
            parent.parent.addEventListener("mouseWheel", this.onMouseWheel);
        } else if (WebMain.STAGE) {
            WebMain.STAGE.addEventListener("mouseWheel", this.onMouseWheel);
        }
    }

    public function removeMouseListeners():void {
        removeEventListener("mouseOver", this.onMouseOver);
        removeEventListener("mouseOut", this.onMouseOut);
        removeEventListener("mouseDown", this.onMouseDown);
        if (parent && parent.parent) {
            parent.parent.removeEventListener("mouseWheel", this.onMouseWheel);
        } else if (WebMain.STAGE) {
            WebMain.STAGE.removeEventListener("mouseWheel", this.onMouseWheel);
        }
        this.onMouseUp();
    }

    protected function onMouseWheel(_arg_1:MouseEvent):void {
        if (_arg_1.delta > 0) {
            this.scrolling.dispatch(-0.25);
        } else if (_arg_1.delta < 0) {
            this.scrolling.dispatch(0.25);
        }
    }

    private function onMouseDown(_arg_1:MouseEvent = null):void {
        this.isDown = true;
        this.downOffset = parent.mouseY - y;
        if (stage != null) {
            stage.addEventListener("mouseUp", this.onMouseUp);
        }
        addEventListener("enterFrame", this.iterate);
        this.redraw();
    }

    private function onMouseUp(_arg_1:MouseEvent = null):void {
        this.isDown = false;
        if (stage != null) {
            stage.removeEventListener("mouseUp", this.onMouseUp);
        }
        removeEventListener("enterFrame", this.iterate);
        this.redraw();
    }

    private function onMouseOver(_arg_1:MouseEvent):void {
        this.isOver = true;
        this.redraw();
    }

    private function onMouseOut(_arg_1:MouseEvent):void {
        this.isOver = false;
        this.redraw();
    }

    private function iterate(_arg_1:Event):void {
        this.dragging.dispatch(parent.mouseY - this.downOffset);
    }
}
}
