package kabam.rotmg.arena.view {
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;

import kabam.rotmg.arena.model.ArenaLeaderboardFilter;
import kabam.rotmg.text.view.StaticTextDisplay;
import kabam.rotmg.text.view.stringBuilder.LineBuilder;

import org.osflash.signals.Signal;

public class ArenaLeaderboardTab extends Sprite {

    private static const OVER_COLOR:int = 16567065;

    private static const DOWN_COLOR:int = 16777215;

    private static const OUT_COLOR:int = 11711154;


    public const selected:Signal = new Signal(ArenaLeaderboardTab);

    public function ArenaLeaderboardTab(_arg_1:ArenaLeaderboardFilter) {
        this.label = this.makeLabel();
        this.readyToAlign = label.textChanged;
        super();
        this.filter = _arg_1;
        this.label.setStringBuilder(new LineBuilder().setParams(_arg_1.getName()));
        addChild(this.label);
        this.addMouseListeners();
    }
    public var label:StaticTextDisplay;
    public var readyToAlign:Signal;
    private var filter:ArenaLeaderboardFilter;
    private var isOver:Boolean;
    private var isDown:Boolean;
    private var isSelected:Boolean = false;

    public function destroy():void {
        this.removeMouseListeners();
    }

    public function getFilter():ArenaLeaderboardFilter {
        return this.filter;
    }

    public function setSelected(_arg_1:Boolean):void {
        this.isSelected = _arg_1;
        this.redraw();
    }

    private function addMouseListeners():void {
        addEventListener("mouseOver", this.onMouseOver);
        addEventListener("mouseOut", this.onMouseOut);
        addEventListener("mouseDown", this.onMouseDown);
        addEventListener("mouseUp", this.onMouseUp);
        addEventListener("click", this.onClick);
    }

    private function removeMouseListeners():void {
        removeEventListener("mouseOver", this.onMouseOver);
        removeEventListener("mouseOut", this.onMouseOut);
        removeEventListener("mouseDown", this.onMouseDown);
        removeEventListener("mouseUp", this.onMouseUp);
        removeEventListener("click", this.onClick);
    }

    private function redraw():void {
        if (this.isOver) {
            this.label.setColor(16567065);
        } else if (this.isSelected || this.isDown) {
            this.label.setColor(0xffffff);
        } else {
            this.label.setColor(0xb2b2b2);
        }
    }

    private function makeLabel():StaticTextDisplay {
        var _local1:* = null;
        _local1 = new StaticTextDisplay();
        _local1.setBold(true).setColor(0xb3b3b3).setSize(20);
        _local1.filters = [new DropShadowFilter(0, 0, 0, 1, 8, 8)];
        return _local1;
    }

    private function onClick(_arg_1:MouseEvent):void {
        if (!this.isSelected) {
            this.selected.dispatch(this);
        }
    }

    private function onMouseUp(_arg_1:MouseEvent):void {
        this.isDown = false;
        this.redraw();
    }

    private function onMouseDown(_arg_1:MouseEvent):void {
        this.isDown = true;
        this.redraw();
    }

    private function onMouseOut(_arg_1:MouseEvent):void {
        this.isOver = false;
        this.isDown = false;
        this.redraw();
    }

    private function onMouseOver(_arg_1:MouseEvent):void {
        this.isOver = true;
        this.redraw();
    }
}
}
