package com.company.assembleegameclient.account.ui {
import com.company.assembleegameclient.ui.DeprecatedClickableText;
import com.company.util.GraphicsUtil;

import flash.display.DisplayObject;
import flash.display.GraphicsPath;
import flash.display.GraphicsSolidFill;
import flash.display.GraphicsStroke;
import flash.display.IGraphicsData;
import flash.display.Sprite;
import flash.events.Event;
import flash.filters.DropShadowFilter;

import kabam.rotmg.account.web.view.LabeledField;
import kabam.rotmg.core.StaticInjectorContext;
import kabam.rotmg.core.service.GoogleAnalytics;
import kabam.rotmg.text.view.TextFieldDisplayConcrete;
import kabam.rotmg.text.view.stringBuilder.LineBuilder;

public class Frame extends Sprite {

    private static const INDENT:Number = 17;
    private var graphicsData_:Vector.<IGraphicsData>;

    public function Frame(_arg_1:String, _arg_2:String, _arg_3:String, _arg_4:String = "", _arg_5:int = 288) {
        textInputFields_ = new Vector.<TextInputField>();
        navigationLinks_ = new Vector.<DeprecatedClickableText>();
        titleFill_ = new GraphicsSolidFill(0x4d4d4d, 1);
        backgroundFill_ = new GraphicsSolidFill(0x363636, 1);
        outlineFill_ = new GraphicsSolidFill(0xffffff, 1);
        lineStyle_ = new GraphicsStroke(1, false, "normal", "none", "round", 3, outlineFill_);
        path1_ = new GraphicsPath(new Vector.<int>(), new Vector.<Number>());
        path2_ = new GraphicsPath(new Vector.<int>(), new Vector.<Number>());
        this.graphicsData_ = new <IGraphicsData>[backgroundFill_, path2_, GraphicsUtil.END_FILL, titleFill_, path1_, GraphicsUtil.END_FILL, lineStyle_, path2_, GraphicsUtil.END_STROKE];
        super();
        this.w_ = _arg_5;
        this.googleAnalytics = StaticInjectorContext.getInjector().getInstance(GoogleAnalytics);
        this.titleText_ = new TextFieldDisplayConcrete().setSize(13).setColor(0xb3b3b3);
        this.titleText_.setStringBuilder(new LineBuilder().setParams(_arg_1));
        this.titleText_.filters = [new DropShadowFilter(0, 0, 0)];
        this.titleText_.x = 5;
        this.titleText_.y = 3;
        this.titleText_.filters = [new DropShadowFilter(0, 0, 0, 0.5, 12, 12)];
        addChild(this.titleText_);
        this.makeAndAddLeftButton(_arg_2);
        this.makeAndAddRightButton(_arg_3);
        this.analyticsPageName_ = _arg_4;
        filters = [new DropShadowFilter(0, 0, 0, 0.5, 12, 12)];
        addEventListener("addedToStage", this.onAddedToStage);
    }
    public var titleText_:TextFieldDisplayConcrete;
    public var leftButton_:DeprecatedClickableText;
    public var rightButton_:DeprecatedClickableText;
    public var analyticsPageName_:String;
    public var w_:int = 288;
    public var h_:int = 100;
    public var textInputFields_:Vector.<TextInputField>;
    public var navigationLinks_:Vector.<DeprecatedClickableText>;
    private var googleAnalytics:GoogleAnalytics;
    private var titleFill_:GraphicsSolidFill;
    private var backgroundFill_:GraphicsSolidFill;
    private var outlineFill_:GraphicsSolidFill;
    private var lineStyle_:GraphicsStroke;
    private var path1_:GraphicsPath;
    private var path2_:GraphicsPath;

    public function addLabeledField(_arg_1:LabeledField):void {
        addChild(_arg_1);
        _arg_1.y = this.h_ - 60;
        _arg_1.x = 17;
        this.h_ = this.h_ + _arg_1.getHeight();
    }

    public function addTextInputField(_arg_1:TextInputField):void {
        this.textInputFields_.push(_arg_1);
        addChild(_arg_1);
        _arg_1.y = this.h_ - 60;
        _arg_1.x = 17;
        this.h_ = this.h_ + _arg_1.height;
    }

    public function addNavigationText(_arg_1:DeprecatedClickableText):void {
        this.navigationLinks_.push(_arg_1);
        _arg_1.x = 17;
        addChild(_arg_1);
        this.positionText(_arg_1);
    }

    public function addComponent(_arg_1:DisplayObject, _arg_2:int = 8):void {
        addChild(_arg_1);
        _arg_1.y = this.h_ - 66;
        _arg_1.x = _arg_2;
        this.h_ = this.h_ + _arg_1.height;
    }

    public function addPlainText(plainText:String, tokens:Object = null):void {
        plainText = plainText;
        tokens = tokens;
        var position:Function = function ():void {
            positionText(text);
            draw();
        };
        var text:TextFieldDisplayConcrete = new TextFieldDisplayConcrete().setSize(12).setColor(0xffffff);
        text.setStringBuilder(new LineBuilder().setParams(plainText, tokens));
        text.filters = [new DropShadowFilter(0, 0, 0)];
        text.textChanged.add(position);
        addChild(text);
    }

    public function addTitle(_arg_1:String):void {
        var _local2:TextFieldDisplayConcrete = new TextFieldDisplayConcrete().setSize(20).setColor(0xb2b2b2).setBold(true);
        _local2.setStringBuilder(new LineBuilder().setParams(_arg_1));
        _local2.filters = [new DropShadowFilter(0, 0, 0, 0.5, 12, 12)];
        addChild(_local2);
        _local2.y = this.h_ - 60;
        _local2.x = 15;
        this.h_ = this.h_ + 40;
    }

    public function addCheckBox(_arg_1:CheckBoxField):void {
        addChild(_arg_1);
        _arg_1.y = this.h_ - 66;
        _arg_1.x = 17;
        this.h_ = this.h_ + 44;
    }

    public function addRadioBox(_arg_1:PaymentMethodRadioButtons):void {
        addChild(_arg_1);
        _arg_1.y = this.h_ - 66;
        _arg_1.x = 18;
        this.h_ = this.h_ + _arg_1.height;
    }

    public function addSpace(_arg_1:int):void {
        this.h_ = this.h_ + _arg_1;
    }

    public function disable():void {
        var _local1:* = null;
        mouseEnabled = false;
        mouseChildren = false;
        var _local3:int = 0;
        var _local2:* = this.navigationLinks_;
        for each(_local1 in this.navigationLinks_) {
            _local1.setDefaultColor(0xb3b3b3);
        }
        this.leftButton_.setDefaultColor(0xb3b3b3);
        this.rightButton_.setDefaultColor(0xb3b3b3);
    }

    public function enable():void {
        var _local1:* = null;
        mouseEnabled = true;
        mouseChildren = true;
        var _local3:int = 0;
        var _local2:* = this.navigationLinks_;
        for each(_local1 in this.navigationLinks_) {
            _local1.setDefaultColor(0xffffff);
        }
        this.leftButton_.setDefaultColor(0xffffff);
        this.rightButton_.setDefaultColor(0xffffff);
    }

    protected function positionText(_arg_1:DisplayObject):void {
        _arg_1.y = this.h_ - 66;
        _arg_1.x = 17;
        this.h_ = this.h_ + 20;
    }

    protected function draw():void {
        graphics.clear();
        GraphicsUtil.clearPath(this.path1_);
        GraphicsUtil.drawCutEdgeRect(-6, -6, this.w_, 32, 4, [1, 1, 0, 0], this.path1_);
        GraphicsUtil.clearPath(this.path2_);
        GraphicsUtil.drawCutEdgeRect(-6, -6, this.w_, this.h_, 4, [1, 1, 1, 1], this.path2_);
        this.leftButton_.y = this.h_ - 52;
        this.rightButton_.y = this.h_ - 52;
        graphics.drawGraphicsData(this.graphicsData_);
    }

    private function makeAndAddLeftButton(_arg_1:String):void {
        this.leftButton_ = new DeprecatedClickableText(18, true, _arg_1);
        if (_arg_1 != "") {
            this.leftButton_.buttonMode = true;
            this.leftButton_.x = 109;
            addChild(this.leftButton_);
        }
    }

    private function makeAndAddRightButton(_arg_1:String):void {
        this.rightButton_ = new DeprecatedClickableText(18, true, _arg_1);
        if (_arg_1 != "") {
            this.rightButton_.buttonMode = true;
            this.rightButton_.x = this.w_ - this.rightButton_.width - 26;
            this.rightButton_.setAutoSize("right");
            addChild(this.rightButton_);
        }
    }

    protected function onAddedToStage(_arg_1:Event):void {
        this.draw();
        x = stage.stageWidth / 2 - (this.w_ - 6) / 2;
        y = stage.stageHeight / 2 - height / 2;
        if (this.textInputFields_.length > 0) {
            stage.focus = this.textInputFields_[0].inputText_;
        }
        if (this.analyticsPageName_ && this.googleAnalytics) {
            this.googleAnalytics.trackPageView(this.analyticsPageName_);
        }
    }
}
}
