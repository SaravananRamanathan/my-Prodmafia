package com.company.assembleegameclient.ui.dialogs {
import com.company.assembleegameclient.ui.DeprecatedTextButton;
import com.company.assembleegameclient.util.StageProxy;
import com.company.util.GraphicsUtil;

import flash.display.Graphics;
import flash.display.GraphicsPath;
import flash.display.GraphicsSolidFill;
import flash.display.GraphicsStroke;
import flash.display.IGraphicsData;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;

import kabam.rotmg.text.view.TextFieldDisplayConcrete;
import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;
import kabam.rotmg.ui.view.SignalWaiter;

import org.osflash.signals.Signal;
import org.osflash.signals.natives.NativeMappedSignal;

public class ErrorDialog extends Sprite {

    public static const GREY:int = 11776947;

    protected static const WIDTH:int = 300;

    public function ErrorDialog(_arg_1:String) {
        box_ = new Sprite();
        rect_ = new Shape();
        path_ = new GraphicsPath(new Vector.<int>(), new Vector.<Number>());
        uiWaiter = new SignalWaiter();
        graphicsData_ = new <IGraphicsData>[lineStyle_, backgroundFill_, path_, GraphicsUtil.END_FILL, GraphicsUtil.END_STROKE];
        outlineFill_ = new GraphicsSolidFill(0xffffff, 1);
        lineStyle_ = new GraphicsStroke(1, false, "normal", "none", "round", 3, outlineFill_);
        backgroundFill_ = new GraphicsSolidFill(0x363636, 1);
        super();
        var _local2:String = ["An error has occured:", _arg_1].join("\n");
        this.stageProxy = new StageProxy(this);
        this.analyticsPageName_ = "/error";
        this._makeUIAndAdd(_local2, "D\'oh, this isn\'t good", "ErrorWindow.buttonOK", null);
        this.makeUIAndAdd();
        this.uiWaiter.complete.addOnce(this.onComplete);
        addChild(this.box_);
        this.ok = new NativeMappedSignal(this, "dialogLeftButton");
    }
    public var ok:Signal;
    public var textText_:TextFieldDisplayConcrete;
    public var titleText_:TextFieldDisplayConcrete = null;
    public var button1_:DeprecatedTextButton = null;
    public var button2_:DeprecatedTextButton = null;
    public var analyticsPageName_:String = null;
    public var offsetX:Number = 0;
    public var offsetY:Number = 0;
    public var stageProxy:StageProxy;
    public var box_:Sprite;
    public var rect_:Shape;
    protected var path_:GraphicsPath;
    protected var uiWaiter:SignalWaiter;
    protected var graphicsData_:Vector.<IGraphicsData>;
    private var outlineFill_:GraphicsSolidFill;
    private var lineStyle_:GraphicsStroke;
    private var backgroundFill_:GraphicsSolidFill;

    public function setBaseAlpha(_arg_1:Number):void {
        this.rect_.alpha = _arg_1 > 1 ? 1 : Number(_arg_1 < 0 ? 0 : Number(_arg_1));
    }

    protected function makeUIAndAdd():void {
    }

    protected function initText(_arg_1:String):void {
        this.textText_ = new TextFieldDisplayConcrete().setSize(14).setColor(0xb3b3b3);
        this.textText_.setTextWidth(260);
        this.textText_.x = 20;
        this.textText_.setMultiLine(true).setWordWrap(true).setAutoSize("center");
        this.textText_.setStringBuilder(new StaticStringBuilder(_arg_1));
        this.textText_.mouseEnabled = true;
        this.textText_.filters = [new DropShadowFilter(0, 0, 0, 1, 6, 6, 1)];
    }

    protected function drawAdditionalUI():void {
    }

    protected function drawButtonsAndBackground():void {
        if (this.box_.contains(this.rect_)) {
            this.box_.removeChild(this.rect_);
        }
        this.removeButtonsIfAlreadyAdded();
        this.addButtonsAndLayout();
        this.drawBackground();
        this.box_.addChildAt(this.rect_, 0);
        this.box_.filters = [new DropShadowFilter(0, 0, 0, 1, 16, 16, 1)];
    }

    protected function getBoxHeight():Number {
        return this.box_.height;
    }

    private function _makeUIAndAdd(_arg_1:String, _arg_2:String, _arg_3:String, _arg_4:String):void {
        this.initText(_arg_1);
        this.addTextFieldDisplay(this.textText_);
        this.initNonNullTitleAndAdd(_arg_2);
        this.makeNonNullButtons(_arg_3, _arg_4);
    }

    private function addTextFieldDisplay(_arg_1:TextFieldDisplayConcrete):void {
        this.box_.addChild(_arg_1);
        this.uiWaiter.push(_arg_1.textChanged);
    }

    private function initNonNullTitleAndAdd(_arg_1:String):void {
        if (_arg_1 != null) {
            this.titleText_ = new TextFieldDisplayConcrete().setSize(18).setColor(5746018);
            this.titleText_.setTextWidth(5 * 60);
            this.titleText_.setBold(true);
            this.titleText_.setAutoSize("center");
            this.titleText_.filters = [new DropShadowFilter(0, 0, 0, 1, 8, 8, 1)];
            this.titleText_.setStringBuilder(new StaticStringBuilder(_arg_1));
            this.addTextFieldDisplay(this.titleText_);
        }
    }

    private function makeNonNullButtons(_arg_1:String, _arg_2:String):void {
        if (_arg_1 != null) {
            this.button1_ = new DeprecatedTextButton(16, _arg_1, 2 * 60);
            this.button1_.addEventListener("click", this.onButton1Click);
        }
        if (_arg_2 != null) {
            this.button2_ = new DeprecatedTextButton(16, _arg_2, 2 * 60);
            this.button2_.addEventListener("click", this.onButton2Click);
        }
    }

    private function onComplete():void {
        this.draw();
        this.positionDialog();
    }

    private function positionDialog():void {
        this.box_.x = this.offsetX + this.stageProxy.getStageWidth() / 2 - this.box_.width / 2;
        this.box_.y = this.offsetY + this.stageProxy.getStageHeight() / 2 - this.getBoxHeight() / 2;
    }

    private function draw():void {
        this.drawTitleAndText();
        this.drawAdditionalUI();
        this.drawButtonsAndBackground();
    }

    private function drawBackground():void {
        GraphicsUtil.clearPath(this.path_);
        GraphicsUtil.drawCutEdgeRect(0, 0, 5 * 60, this.getBoxHeight() + 10, 4, [1, 1, 1, 1], this.path_);
        var _local1:Graphics = this.rect_.graphics;
        _local1.clear();
        _local1.drawGraphicsData(this.graphicsData_);
    }

    private function addButtonsAndLayout():void {
        var _local1:int = 0;
        if (this.button1_ != null) {
            _local1 = this.box_.height + 16;
            this.box_.addChild(this.button1_);
            this.button1_.y = _local1;
            if (this.button2_ == null) {
                this.button1_.x = 150 - this.button1_.width / 2;
            } else {
                this.button1_.x = 75 - this.button1_.width / 2;
                this.box_.addChild(this.button2_);
                this.button2_.x = 225 - this.button2_.width / 2;
                this.button2_.y = _local1;
            }
        }
    }

    private function removeButtonsIfAlreadyAdded():void {
        if (this.button1_ && this.box_.contains(this.button1_)) {
            this.box_.removeChild(this.button1_);
        }
        if (this.button2_ && this.box_.contains(this.button2_)) {
            this.box_.removeChild(this.button2_);
        }
    }

    private function drawTitleAndText():void {
        if (this.titleText_ != null) {
            this.titleText_.y = 2;
            this.textText_.y = this.titleText_.height + 8;
        } else {
            this.textText_.y = 4;
        }
    }

    private function onButton1Click(_arg_1:MouseEvent):void {
        dispatchEvent(new Event("dialogLeftButton"));
    }

    private function onButton2Click(_arg_1:Event):void {
        dispatchEvent(new Event("dialogRightButton"));
    }
}
}
