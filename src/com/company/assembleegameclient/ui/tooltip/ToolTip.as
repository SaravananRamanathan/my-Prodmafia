package com.company.assembleegameclient.ui.tooltip {
import com.company.assembleegameclient.map.partyoverlay.PlayerArrow;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.ui.options.Options;
import com.company.util.GraphicsUtil;

import flash.display.DisplayObject;
import flash.display.GraphicsPath;
import flash.display.GraphicsSolidFill;
import flash.display.GraphicsStroke;
import flash.display.IGraphicsData;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;

import kabam.rotmg.tooltips.view.TooltipsView;
import kabam.rotmg.ui.view.SignalWaiter;

public class ToolTip extends Sprite {


    protected const waiter:SignalWaiter = new SignalWaiter();

    public function ToolTip(_arg_1:uint, _arg_2:Number, _arg_3:uint, _arg_4:Number, _arg_5:Boolean = true) {
        backgroundFill_ = new GraphicsSolidFill(0, 1);
        outlineFill_ = new GraphicsSolidFill(0xffffff, 1);
        lineStyle_ = new GraphicsStroke(1, false, "normal", "none", "round", 3, outlineFill_);
        path_ = new GraphicsPath(new Vector.<int>(), new Vector.<Number>());
        graphicsData_ = new <IGraphicsData>[lineStyle_, backgroundFill_, path_, GraphicsUtil.END_FILL, GraphicsUtil.END_STROKE];
        super();
        this.background_ = _arg_1;
        this.backgroundAlpha_ = _arg_2;
        this.outline_ = _arg_3;
        this.outlineAlpha_ = _arg_4;
        this._followMouse = _arg_5;
        mouseEnabled = false;
        mouseChildren = false;
        filters = [new DropShadowFilter(0, 0, 0, 1, 16, 16)];
        addEventListener("addedToStage", this.onAddedToStage);
        addEventListener("removedFromStage", this.onRemovedFromStage);
        this.waiter.complete.add(this.alignUIAndDraw);
    }
    public var contentWidth_:int;
    public var contentHeight_:int;
    private var background_:uint;
    private var backgroundAlpha_:Number;
    private var outline_:uint;
    private var outlineAlpha_:Number;
    private var _followMouse:Boolean;
    private var forcePositionLeft_:Boolean = false;
    private var forcePositionRight_:Boolean = false;
    private var targetObj:DisplayObject;
    private var backgroundFill_:GraphicsSolidFill;
    private var outlineFill_:GraphicsSolidFill;
    private var lineStyle_:GraphicsStroke;
    private var path_:GraphicsPath;
    private var graphicsData_:Vector.<IGraphicsData>;

    public function attachToTarget(_arg_1:DisplayObject):void {
        if (_arg_1) {
            this.targetObj = _arg_1;
            this.targetObj.addEventListener("rollOut", this.onLeaveTarget);
        }
    }

    public function detachFromTarget():void {
        if (this.targetObj) {
            this.targetObj.removeEventListener("rollOut", this.onLeaveTarget);
            if (parent) {
                parent.removeChild(this);
            }
            this.targetObj = null;
        }
    }

    public function forcePostionLeft():void {
        this.forcePositionLeft_ = true;
        this.forcePositionRight_ = false;
    }

    public function forcePostionRight():void {
        this.forcePositionRight_ = true;
        this.forcePositionLeft_ = false;
    }

    public function draw():void {
        this.backgroundFill_.color = this.background_;
        this.backgroundFill_.alpha = this.backgroundAlpha_;
        this.outlineFill_.color = this.outline_;
        this.outlineFill_.alpha = this.outlineAlpha_;
        graphics.clear();
        this.contentWidth_ = width;
        this.contentHeight_ = height;
        GraphicsUtil.clearPath(this.path_);
        GraphicsUtil.drawCutEdgeRect(-6, -6, this.contentWidth_ + 12, this.contentHeight_ + 12, 4, [1, 1, 1, 1], this.path_);
        graphics.drawGraphicsData(this.graphicsData_);
    }

    protected function alignUI():void {
    }

    protected function position():void {
        var _local4:Number = NaN;
        var _local2:Number = NaN;
        var _local1:Number = 800 / stage.stageWidth;
        var _local3:Number = 600 / stage.stageHeight;
        if (this.parent is Options) {
            _local4 = (stage.mouseX + stage.stageWidth / 2 - 400) / stage.stageWidth * 800;
            _local2 = (stage.mouseY + stage.stageHeight / 2 - 300) / stage.stageHeight * 600;
        } else {
            _local4 = (stage.stageWidth - 800) / 2 + stage.mouseX;
            _local2 = (stage.stageHeight - 600) / 2 + stage.mouseY;
            if (this.parent is TooltipsView || this is PlayerGroupToolTip && !(this.parent is PlayerArrow)) {
                if (Parameters.data.uiscale) {
                    this.parent.scaleX = _local1 / _local3;
                    this.parent.scaleY = 1;
                    _local4 = _local4 * _local3;
                    _local2 = _local2 * _local3;
                } else {
                    this.parent.scaleX = _local1;
                    this.parent.scaleY = _local3;
                }
            }
        }
        if (stage == null) {
            return;
        }
        if (stage.mouseX + 0.5 * stage.stageWidth - 400 < stage.stageWidth / 2) {
            x = _local4 + 12;
        } else {
            x = _local4 - width - 1;
        }
        if (x < 12) {
            x = 12;
        }
        if (stage.mouseY + 0.5 * stage.stageHeight - 300 < stage.stageHeight / 3) {
            y = _local2 + 12;
        } else {
            y = _local2 - height - 1;
        }
        if (y < 12) {
            y = 12;
        }
    }

    private function alignUIAndDraw():void {
        this.alignUI();
        this.draw();
        this.position();
    }

    private function onLeaveTarget(_arg_1:MouseEvent):void {
        this.detachFromTarget();
    }

    private function onAddedToStage(_arg_1:Event):void {
        if (this.waiter.isEmpty()) {
            this.draw();
        }
        if (this._followMouse) {
            this.position();
            addEventListener("enterFrame", this.onEnterFrame);
        }
    }

    private function onRemovedFromStage(_arg_1:Event):void {
        var _local2:* = null;
        if (this is EquipmentToolTip) {
            _local2 = (this as EquipmentToolTip).player;
            if (_local2 && (_local2.fakeTex1 != -1 || _local2.fakeTex2 != -1)) {
                _local2.fakeTex1 = -1;
                _local2.fakeTex2 = -1;
                _local2.clearTextureCache();
            }
        }
        if (this._followMouse) {
            removeEventListener("enterFrame", this.onEnterFrame);
        }
    }

    private function onEnterFrame(_arg_1:Event):void {
        this.position();
    }
}
}
