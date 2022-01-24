package com.company.assembleegameclient.ui.panels.itemgrids.itemtiles {
import com.company.assembleegameclient.ui.panels.itemgrids.ItemGrid;

import flash.display.DisplayObject;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.geom.Point;
import flash.utils.Timer;

public class InteractiveItemTile extends ItemTile {

    private static const DOUBLE_CLICK_PAUSE:uint = 250;

    private static const DRAG_DIST:int = 3;

    public function InteractiveItemTile(_arg_1:int, _arg_2:ItemGrid, _arg_3:Boolean) {
        super(_arg_1, _arg_2);
        mouseChildren = false;
        this.doubleClickTimer = new Timer(250, 1);
        this.doubleClickTimer.addEventListener("timerComplete", this.onDoubleClickTimerComplete);
        this.setInteractive(_arg_3);
    }
    private var doubleClickTimer:Timer;
    private var dragStart:Point;
    private var pendingSecondClick:Boolean;
    private var isDragging:Boolean;

    override public function setItem(_arg_1:int):Boolean {
        var _local2:Boolean = super.setItem(_arg_1);
        if (_local2) {
            this.stopDragging();
        }
        return _local2;
    }

    public function setInteractive(_arg_1:Boolean):void {
        if (_arg_1) {
            addEventListener("mouseDown", this.onMouseDown);
            addEventListener("mouseUp", this.onMouseUp);
            addEventListener("mouseOut", this.onMouseOut);
            addEventListener("removedFromStage", this.onRemovedFromStage);
        } else {
            removeEventListener("mouseDown", this.onMouseDown);
            removeEventListener("mouseUp", this.onMouseUp);
            removeEventListener("mouseOut", this.onMouseOut);
        }
    }

    public function getDropTarget():DisplayObject {
        return itemSprite.dropTarget;
    }

    protected function beginDragCallback():void {
    }

    protected function endDragCallback():void {
    }

    private function setPendingDoubleClick(_arg_1:Boolean):void {
        this.pendingSecondClick = _arg_1;
        if (this.pendingSecondClick) {
            this.doubleClickTimer.reset();
            this.doubleClickTimer.start();
        } else {
            this.doubleClickTimer.stop();
        }
    }

    private function stopDragging():void {
        if (this.isDragging) {
            itemSprite.stopDrag();
            if (stage.contains(itemSprite)) {
                stage.removeChild(itemSprite);
            }
            this.isDragging = false;
        }
    }

    private function onMouseOut(_arg_1:MouseEvent):void {
        this.setPendingDoubleClick(false);
    }

    private function onMouseUp(_arg_1:MouseEvent):void {
        if (this.isDragging) {
            return;
        }
        if (_arg_1.shiftKey) {
            this.setPendingDoubleClick(false);
            dispatchEvent(new ItemTileEvent("ITEM_SHIFT_CLICK", this));
        } else if (_arg_1.ctrlKey) {
            this.setPendingDoubleClick(false);
            dispatchEvent(new ItemTileEvent("ITEM_CTRL_CLICK", this));
        } else if (!this.pendingSecondClick) {
            this.setPendingDoubleClick(true);
        } else {
            this.setPendingDoubleClick(false);
            dispatchEvent(new ItemTileEvent("ITEM_DOUBLE_CLICK", this));
        }
    }

    private function onMouseDown(_arg_1:MouseEvent):void {
        if (getItemId() == -1) {
            return;
        }
        this.beginDragCheck(_arg_1);
    }

    private function beginDragCheck(_arg_1:MouseEvent):void {
        this.dragStart = new Point(_arg_1.stageX, _arg_1.stageY);
        addEventListener("mouseMove", this.onMouseMoveCheckDrag);
        addEventListener("mouseOut", this.cancelDragCheck);
        addEventListener("mouseUp", this.cancelDragCheck);
    }

    private function cancelDragCheck(_arg_1:MouseEvent):void {
        removeEventListener("mouseMove", this.onMouseMoveCheckDrag);
        removeEventListener("mouseOut", this.cancelDragCheck);
        removeEventListener("mouseUp", this.cancelDragCheck);
    }

    private function onMouseMoveCheckDrag(_arg_1:MouseEvent):void {
        var _local2:Number = _arg_1.stageX - this.dragStart.x;
        var _local4:Number = _arg_1.stageY - this.dragStart.y;
        var _local3:Number = Math.sqrt(_local2 * _local2 + _local4 * _local4);
        if (_local3 > 3) {
            this.cancelDragCheck(null);
            this.setPendingDoubleClick(false);
            this.beginDrag(_arg_1);
        }
    }

    private function onDoubleClickTimerComplete(_arg_1:TimerEvent):void {
        this.setPendingDoubleClick(false);
        dispatchEvent(new ItemTileEvent("ITEM_CLICK", this));
    }

    private function beginDrag(_arg_1:MouseEvent):void {
        this.isDragging = true;
        toggleDragState(false);
        stage.addChild(itemSprite);
        itemSprite.startDrag(true);
        itemSprite.x = _arg_1.stageX;
        itemSprite.y = _arg_1.stageY;
        itemSprite.addEventListener("mouseUp", this.endDrag);
        this.beginDragCallback();
    }

    private function endDrag(_arg_1:MouseEvent):void {
        this.isDragging = false;
        toggleDragState(true);
        itemSprite.stopDrag();
        itemSprite.removeEventListener("mouseUp", this.endDrag);
        dispatchEvent(new ItemTileEvent("ITEM_MOVE", this));
        this.endDragCallback();
    }

    private function onRemovedFromStage(_arg_1:Event):void {
        this.setPendingDoubleClick(false);
        this.cancelDragCheck(null);
        this.stopDragging();
    }
}
}
