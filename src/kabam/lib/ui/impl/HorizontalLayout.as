package kabam.lib.ui.impl {
import flash.display.DisplayObject;

import kabam.lib.ui.api.Layout;

public class HorizontalLayout implements Layout {

    public function HorizontalLayout() {
        super();
    }

    private var padding:int = 0;

    public function getPadding():int {
        return this.padding;
    }

    public function setPadding(padding: int):void {
        this.padding = padding;
    }

    public function layout(elements: Vector.<DisplayObject>, offset: int = 0):void {
        var box: * = null;
        var counter: int = 0;
        var boxSize: * = offset;
        var boxCount: int = elements.length;
        while (counter < boxCount) {
            box = elements[counter];
            box.x = boxSize;
            boxSize = boxSize + (box.width + this.padding);
            counter++;
        }
    }
}
}
