package com.company.assembleegameclient.ui {
import com.company.assembleegameclient.parameters.Parameters;
import com.company.util.GraphicsUtil;

import flash.display.GraphicsSolidFill;
import flash.display.GraphicsStroke;
import flash.display.IGraphicsData;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.utils.getTimer;

import kabam.rotmg.text.view.StaticTextDisplay;
import kabam.rotmg.text.view.stringBuilder.LineBuilder;

public class TradeButton extends BackgroundFilledText {

    private static const WAIT_TIME:int = 2999;

    private static const COUNTDOWN_STATE:int = 0;

    private static const NORMAL_STATE:int = 1;

    private static const WAITING_STATE:int = 2;

    private static const DISABLED_STATE:int = 3;

    public function TradeButton(_arg_1:int, _arg_2:int = 0) {
        super(_arg_2);
        this.makeGraphics();
        this.lastResetTime_ = getTimer();
        this.myText = new StaticTextDisplay();
        this.myText.setAutoSize("center").setVerticalAlign("middle");
        this.myText.setSize(_arg_1).setColor(0x363636).setBold(true);
        this.myText.setStringBuilder(new LineBuilder().setParams("PlayerMenu.Trade"));
        w_ = _arg_2 != 0 ? _arg_2 : this.myText.width + 12;
        this.h_ = this.myText.height + 8;
        this.myText.x = w_ * 0.5;
        this.myText.y = this.h_ * 0.5;
        GraphicsUtil.clearPath(path_);
        GraphicsUtil.drawCutEdgeRect(0, 0, w_, this.myText.height + 8, 4, [1, 1, 1, 1], path_);
        this.statusBar_ = this.newStatusBar();
        addChild(this.statusBar_);
        addChild(this.myText);
        this.draw();
        addEventListener("addedToStage", this.onAddedToStage, false, 0, true);
        addEventListener("removedFromStage", this.onRemovedFromStage, false, 0, true);
        addEventListener("mouseOver", this.onMouseOver, false, 0, true);
        addEventListener("rollOut", this.onRollOut, false, 0, true);
        addEventListener("click", this.onClick, false, 0, true);
    }
    public var statusBar_:Sprite;
    public var barMask_:Shape;
    public var myText:StaticTextDisplay;
    public var h_:int;
    private var state_:int;
    private var lastResetTime_:int;
    private var barGraphicsData_:Vector.<IGraphicsData>;
    private var outlineGraphicsData_:Vector.<IGraphicsData>;

    public function reset():void {
        this.lastResetTime_ = getTimer();
        this.state_ = 0;
        this.setEnabled(false);
        this.setText("PlayerMenu.Trade");
    }

    public function disable():void {
        this.state_ = 3;
        this.setEnabled(false);
        this.setText("PlayerMenu.Trade");
    }

    private function makeGraphics():void {
        var _local3:GraphicsSolidFill = new GraphicsSolidFill(0xbfbfbf, 1);
        this.barGraphicsData_ = new <IGraphicsData>[_local3, path_, GraphicsUtil.END_FILL];
        var _local2:GraphicsSolidFill = new GraphicsSolidFill(0xffffff, 1);
        var _local1:GraphicsStroke = new GraphicsStroke(2, false, "normal", "none", "round", 3, _local2);
        this.outlineGraphicsData_ = new <IGraphicsData>[_local1, path_, GraphicsUtil.END_STROKE];
    }

    private function setText(_arg_1:String):void {
        this.myText.setStringBuilder(new LineBuilder().setParams(_arg_1));
    }

    private function setEnabled(_arg_1:Boolean):void {
        if (Parameters.data.TradeDelay) {
            _arg_1 = true;
        }
        if (_arg_1 == mouseEnabled) {
            return;
        }
        mouseEnabled = _arg_1;
        mouseChildren = _arg_1;
        graphicsData_[0] = !!_arg_1 ? enabledFill_ : disabledFill_;
        this.draw();
    }

    private function newStatusBar():Sprite {
        var _local4:Sprite = new Sprite();
        var _local2:Sprite = new Sprite();
        var _local1:Shape = new Shape();
        _local1.graphics.clear();
        _local1.graphics.drawGraphicsData(this.barGraphicsData_);
        _local2.addChild(_local1);
        this.barMask_ = new Shape();
        _local2.addChild(this.barMask_);
        _local2.mask = this.barMask_;
        _local4.addChild(_local2);
        var _local3:Shape = new Shape();
        _local3.graphics.clear();
        _local3.graphics.drawGraphicsData(this.outlineGraphicsData_);
        _local4.addChild(_local3);
        return _local4;
    }

    private function drawCountDown(_arg_1:Number):void {
        this.barMask_.graphics.clear();
        this.barMask_.graphics.beginFill(0xbfbfbf);
        this.barMask_.graphics.drawRect(0, 0, w_ * _arg_1, this.h_);
        this.barMask_.graphics.endFill();
    }

    private function draw():void {
        var _local1:int = 0;
        var _local2:Number = NaN;
        _local1 = getTimer();
        if (this.state_ == 0) {
            if (_local1 - this.lastResetTime_ >= 2999) {
                this.state_ = 1;
                this.setEnabled(true);
            }
        }
        switch (int(this.state_)) {
            case 0:
                this.statusBar_.visible = true;
                _local2 = (_local1 - this.lastResetTime_) / 2999;
                this.drawCountDown(_local2);
                break;
            case 1:
            case 2:
            case 3:
                this.statusBar_.visible = false;
        }
        graphics.clear();
        graphics.drawGraphicsData(graphicsData_);
    }

    private function onAddedToStage(_arg_1:Event):void {
        addEventListener("enterFrame", this.onEnterFrame, false, 0, true);
        this.reset();
        this.draw();
    }

    private function onRemovedFromStage(_arg_1:Event):void {
        removeEventListener("enterFrame", this.onEnterFrame);
        removeEventListener("addedToStage", this.onAddedToStage);
        removeEventListener("removedFromStage", this.onRemovedFromStage);
        removeEventListener("mouseOver", this.onMouseOver);
        removeEventListener("rollOut", this.onRollOut);
        removeEventListener("click", this.onClick);
    }

    private function onEnterFrame(_arg_1:Event):void {
        this.draw();
    }

    private function onMouseOver(_arg_1:MouseEvent):void {
        enabledFill_.color = 16768133;
        this.draw();
    }

    private function onRollOut(_arg_1:MouseEvent):void {
        enabledFill_.color = 0xffffff;
        this.draw();
    }

    private function onClick(_arg_1:MouseEvent):void {
        this.state_ = 2;
        this.setEnabled(false);
        this.setText("PlayerMenu.Waiting");
    }
}
}
