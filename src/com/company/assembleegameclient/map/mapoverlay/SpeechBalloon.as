package com.company.assembleegameclient.map.mapoverlay {
import com.company.assembleegameclient.map.Camera;
import com.company.assembleegameclient.objects.GameObject;
import com.company.assembleegameclient.objects.Player;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.util.GraphicsUtil;

import flash.display.GraphicsPath;
import flash.display.GraphicsSolidFill;
import flash.display.GraphicsStroke;
import flash.display.IGraphicsData;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;
import flash.geom.Point;
import flash.text.TextField;
import flash.text.TextFormat;

import kabam.rotmg.core.StaticInjectorContext;
import kabam.rotmg.ui.model.HUDModel;

public class SpeechBalloon extends Sprite implements IMapOverlayElement {


    public function SpeechBalloon(_arg_1:GameObject, _arg_2:String, _arg_3:String, _arg_4:Boolean, _arg_5:Boolean, _arg_6:uint, _arg_7:Number, _arg_8:uint, _arg_9:Number, _arg_10:uint, _arg_11:int, _arg_12:Boolean, _arg_13:Boolean) {
        offset_ = new Point();
        backgroundFill_ = new GraphicsSolidFill(0, 1);
        outlineFill_ = new GraphicsSolidFill(0xffffff, 1);
        lineStyle_ = new GraphicsStroke(2, false, "normal", "none", "round", 3, outlineFill_);
        path_ = new GraphicsPath(new Vector.<int>(), new Vector.<Number>());
        graphicsData_ = new <IGraphicsData>[lineStyle_, backgroundFill_, path_, GraphicsUtil.END_FILL, GraphicsUtil.END_STROKE];
        super();
        this.go_ = _arg_1;
        this.senderName = _arg_3;
        this.isTrade = _arg_4;
        this.isGuild = _arg_5;
        this.lifetime_ = _arg_11 * 1000;
        this.hideable_ = _arg_13;
        this.text_ = new TextField();
        this.text_.autoSize = "left";
        this.text_.embedFonts = true;
        this.text_.width = 150;
        var _local16:TextFormat = new TextFormat();
        _local16.font = "Myriad Pro";
        _local16.size = 14;
        _local16.bold = _arg_12;
        _local16.color = _arg_10;
        this.text_.defaultTextFormat = _local16;
        this.text_.selectable = false;
        this.text_.mouseEnabled = false;
        this.text_.multiline = true;
        this.text_.wordWrap = true;
        this.text_.text = _arg_2;
        addChild(this.text_);
        var _local14:int = this.text_.textWidth + 4;
        var _local17:int = _local14 * 0.5;
        this.offset_.x = _local14 * -0.5;
        this.backgroundFill_.color = _arg_6;
        this.backgroundFill_.alpha = _arg_7;
        this.outlineFill_.color = _arg_8;
        this.outlineFill_.alpha = _arg_9;
        graphics.clear();
        GraphicsUtil.clearPath(this.path_);
        GraphicsUtil.drawCutEdgeRect(-6, -6, _local14 + 12, height + 12, 4, [1, 1, 1, 1], this.path_);
        this.path_.commands.splice(6, 0, 2, 2, 2);
        var _local15:int = height;
        this.path_.data.splice(12, 0, _local17 + 8, _local15 + 6, _local17, _local15 + 18, _local17 - 8, _local15 + 6);
        graphics.drawGraphicsData(this.graphicsData_);
        filters = [new DropShadowFilter(0, 0, 0, 1, 16, 16)];
        this.offset_.y = -height - this.go_.texture.height * (_arg_1.size_ * 0.01) * 5 - 2;
        visible = false;
        addEventListener("rightClick", this.onSpeechBalloonRightClicked);
    }
    public var go_:GameObject;
    public var lifetime_:int;
    public var hideable_:Boolean;
    public var offset_:Point;
    public var text_:TextField;
    private var backgroundFill_:GraphicsSolidFill;
    private var outlineFill_:GraphicsSolidFill;
    private var lineStyle_:GraphicsStroke;
    private var path_:GraphicsPath;
    private var graphicsData_:Vector.<IGraphicsData>;
    private var senderName:String;
    private var isTrade:Boolean;
    private var isGuild:Boolean;
    private var startTime_:int = 0;

    public function draw(_arg_1:Camera, _arg_2:int):Boolean {
        if (this.startTime_ == 0) {
            this.startTime_ = _arg_2;
        }
        var _local3:int = _arg_2 - this.startTime_;
        if (_local3 > this.lifetime_ || this.go_ != null && this.go_.map_ == null) {
            return false;
        }
        if (this.go_ == null || !this.go_.drawn_) {
            visible = false;
            return true;
        }
        if (this.hideable_ && !Parameters.data.textBubbles) {
            visible = false;
            return true;
        }
        visible = true;
        x = this.go_.posS_[0] + this.offset_.x;
        y = this.go_.posS_[1] + this.offset_.y;
        return true;
    }

    public function getGameObject():GameObject {
        return this.go_;
    }

    public function dispose():void {
        parent.removeChild(this);
    }

    private function onSpeechBalloonRightClicked(_arg_1:MouseEvent):void {
        var _local2:int = 0;
        var _local4:* = null;
        var _local3:* = null;
        try {
            _local2 = this.go_.objectId_;
            _local4 = StaticInjectorContext.getInjector().getInstance(HUDModel);
            if (_local4.gameSprite.map.goDict_[_local2] != null && _local4.gameSprite.map.goDict_[_local2] is Player && _local4.gameSprite.map.player_.objectId_ != _local2) {
                _local3 = _local4.gameSprite.map.goDict_[_local2] as Player;
                _local4.gameSprite.addChatPlayerMenu(_local3, _arg_1.stageX, _arg_1.stageY);
            } else if (!this.isTrade && this.senderName != null && this.senderName != "" && _local4.gameSprite.map.player_.name_ != this.senderName) {
                _local4.gameSprite.addChatPlayerMenu(null, _arg_1.stageX, _arg_1.stageY, this.senderName, this.isGuild);
            } else if (this.isTrade && this.senderName != null && this.senderName != "" && _local4.gameSprite.map.player_.name_ != this.senderName) {
                _local4.gameSprite.addChatPlayerMenu(null, _arg_1.stageX, _arg_1.stageY, this.senderName, false, true);
            }

        } catch (e:Error) {

        }
    }
}
}
