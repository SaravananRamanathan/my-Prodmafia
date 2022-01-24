package com.company.assembleegameclient.ui.menu {
import com.company.assembleegameclient.game.GameSprite;
import com.company.assembleegameclient.objects.Player;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.util.GraphicsUtil;
import com.company.util.RectangleUtil;

import flash.display.GraphicsPath;
import flash.display.GraphicsSolidFill;
import flash.display.GraphicsStroke;
import flash.display.IGraphicsData;
import flash.display.Sprite;
import flash.events.Event;
import flash.filters.DropShadowFilter;

import kabam.rotmg.ui.view.UnFocusAble;

public class Menu extends Sprite implements UnFocusAble {


    public function Menu(_arg_1:uint, _arg_2:uint) {
        backgroundFill_ = new GraphicsSolidFill(0, 1);
        outlineFill_ = new GraphicsSolidFill(0, 1);
        lineStyle_ = new GraphicsStroke(1, false, "normal", "none", "round", 3, outlineFill_);
        path_ = new GraphicsPath(new Vector.<int>(), new Vector.<Number>());
        graphicsData_ = new <IGraphicsData>[lineStyle_, backgroundFill_, path_, GraphicsUtil.END_FILL, GraphicsUtil.END_STROKE];
        super();
        this.background_ = _arg_1;
        this.outline_ = _arg_2;
        this.yOffset = 40;
        filters = [new DropShadowFilter(0, 0, 0, 1, 16, 16)];
        addEventListener("addedToStage", this.onAddedToStage, false, 0, true);
        addEventListener("removedFromStage", this.onRemovedFromStage, false, 0, true);
    }
    protected var yOffset:int;
    private var backgroundFill_:GraphicsSolidFill;
    private var outlineFill_:GraphicsSolidFill;
    private var lineStyle_:GraphicsStroke;
    private var path_:GraphicsPath;
    private var graphicsData_:Vector.<IGraphicsData>;
    private var background_:uint;
    private var outline_:uint;

    public function scaleParent(_arg_1:Boolean):void {
        var _local2:* = null;
        if (this.parent is GameSprite) {
            _local2 = this;
        } else {
            _local2 = this.parent;
        }
        var _local4:Number = 800 / stage.stageWidth;
        var _local3:Number = 600 / stage.stageHeight;
        if (_arg_1 == true) {
            _local2.scaleX = _local4 / _local3;
            _local2.scaleY = 1;
        } else {
            _local2.scaleX = _local4;
            _local2.scaleY = _local3;
        }
    }

    public function positionFixed():void {
        var _local4:Boolean = Parameters.data.uiscale;
        var _local2:Number = (stage.stageWidth - 800) * 0.5 + stage.mouseX;
        var _local1:Number = (stage.stageHeight - 600) * 0.5 + stage.mouseY;
        var _local3:Number = 600 / stage.stageHeight;
        this.scaleParent(_local4);
        if (_local4) {
            _local2 = _local2 * _local3;
            _local1 = _local1 * _local3;
        }
        if (stage == null) {
            return;
        }
        if (stage.mouseX + 0.5 * stage.stageWidth - 400 < stage.stageWidth * 0.5) {
            x = _local2 + 12;
        } else {
            x = _local2 - width - 1;
        }
        if (x < 12) {
            x = 12;
        }
        if (stage.mouseY + 0.5 * stage.stageHeight - 300 < stage.stageHeight * 0.333333333333333) {
            y = _local1 + 12;
        } else {
            y = _local1 - height - 1;
        }
        if (y < 12) {
            y = 12;
        }
    }

    public function remove():void {
        if (parent != null) {
            parent.removeChild(this);
        }
    }

    protected function addOption(_arg_1:MenuOption):void {
        _arg_1.x = 8;
        _arg_1.y = this.yOffset;
        addChild(_arg_1);
        this.yOffset = this.yOffset + 28;
    }

    protected function draw():void {
        this.backgroundFill_.color = this.background_;
        this.outlineFill_.color = this.outline_;
        graphics.clear();
        GraphicsUtil.clearPath(this.path_);
        GraphicsUtil.drawCutEdgeRect(-6, -6, Math.max(Player.isAdmin || Player.isMod ? 175 : Number(154), width + 12), height + 12, 4, [1, 1, 1, 1], this.path_);
        graphics.drawGraphicsData(this.graphicsData_);
    }

    private function position():void {
        if (stage == null) {
            return;
        }
        this.positionFixed();
    }

    protected function onAddedToStage(_arg_1:Event):void {
        this.draw();
        this.position();
        addEventListener("enterFrame", this.onEnterFrame, false, 0, true);
        addEventListener("rollOut", this.onRollOut, false, 0, true);
    }

    protected function onRemovedFromStage(_arg_1:Event):void {
        this.parent.scaleX = 1;
        this.parent.scaleY = 1;
        removeEventListener("enterFrame", this.onEnterFrame);
        removeEventListener("rollOut", this.onRollOut);
    }

    protected function onEnterFrame(_arg_1:Event):void {
        if (stage == null) {
            return;
        }
        this.scaleParent(Parameters.data.uiscale);
        if (RectangleUtil.pointDistSquared(getRect(stage), stage.mouseX, stage.mouseY) > 1600) {
            this.remove();
        }
    }

    protected function onRollOut(_arg_1:Event):void {
        this.remove();
    }
}
}
