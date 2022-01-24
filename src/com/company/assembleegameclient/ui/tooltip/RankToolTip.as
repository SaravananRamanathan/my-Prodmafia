package com.company.assembleegameclient.ui.tooltip {
import com.company.assembleegameclient.objects.ObjectLibrary;
import com.company.assembleegameclient.ui.LineBreakDesign;
import com.company.assembleegameclient.util.FameUtil;
import com.company.rotmg.graphics.StarGraphic;

import flash.filters.DropShadowFilter;
import flash.geom.ColorTransform;
import flash.geom.Rectangle;

import kabam.rotmg.text.view.TextFieldDisplayConcrete;
import kabam.rotmg.text.view.stringBuilder.LineBuilder;
import kabam.rotmg.ui.view.SignalWaiter;

public class RankToolTip extends ToolTip {

    private static const PADDING_LEFT:int = 6;

    private static const ct:ColorTransform = new ColorTransform(0.701960784313725, 0.701960784313725, 0.701960784313725);

    public function RankToolTip(_arg_1:int) {
        lineBreak_ = new LineBreakDesign(100, 0x1c1c1c);
        super(0x363636, 1, 0xffffff, 1);
        this.earnedText_ = new TextFieldDisplayConcrete().setSize(13).setColor(0xb3b3b3).setBold(true);
        this.earnedText_.setVerticalAlign("bottom");
        this.earnedText_.setStringBuilder(new LineBuilder().setParams("RankToolTip.earned", {"numStars": _arg_1}));
        this.earnedText_.filters = [new DropShadowFilter(0, 0, 0)];
        this.earnedText_.x = 6;
        addChild(this.earnedText_);
        this.howToText_ = new TextFieldDisplayConcrete().setSize(13).setColor(0xb3b3b3);
        this.howToText_.setTextWidth(174);
        this.howToText_.setMultiLine(true).setWordWrap(true);
        this.howToText_.setStringBuilder(new LineBuilder().setParams(_arg_1 >= 80 ? "RankToolTip.completed_all_class_quests" : "RankToolTip.completing_class_quests"));
        this.howToText_.filters = [new DropShadowFilter(0, 0, 0)];
        this.howToText_.x = 6;
        this.howToText_.y = 30;
        addChild(this.howToText_);
        var _local2:SignalWaiter = new SignalWaiter().push(this.earnedText_.textChanged).push(this.howToText_.textChanged);
        _local2.complete.addOnce(this.textAdded);
    }
    private var earnedText_:TextFieldDisplayConcrete;
    private var star_:StarGraphic;
    private var howToText_:TextFieldDisplayConcrete;
    private var lineBreak_:LineBreakDesign;

    override public function draw():void {
        this.lineBreak_.setWidthColor(width - 10, 0x1c1c1c);
        super.draw();
    }

    private function textAdded():void {
        var _local2:* = null;
        var _local4:int = 0;
        this.earnedText_.y = this.earnedText_.height + 2;
        this.star_ = new StarGraphic();
        this.star_.transform.colorTransform = ct;
        var _local1:Rectangle = this.earnedText_.getBounds(this);
        this.star_.x = _local1.right + 7;
        this.star_.y = this.earnedText_.y - this.star_.height;
        addChild(this.star_);
        this.lineBreak_.x = 6;
        this.lineBreak_.y = height + 10;
        addChild(this.lineBreak_);
        var _local3:int = this.lineBreak_.y + 4;
        while (_local4 < FameUtil.COLORS.length) {
            _local2 = new LegendLine(_local4 * ObjectLibrary.playerChars_.length, (_local4 + 1) * ObjectLibrary.playerChars_.length - 1, FameUtil.COLORS[_local4]);
            _local2.x = 6;
            _local2.y = _local3;
            addChild(_local2);
            _local3 = _local3 + _local2.height;
            _local4++;
        }
        _local4 = FameUtil.maxStars();
        _local2 = new LegendLine(_local4, _local4, new ColorTransform());
        _local2.x = 6;
        _local2.y = _local3;
        addChild(_local2);
        this.draw();
    }
}
}

import com.company.rotmg.graphics.StarGraphic;

import flash.display.Sprite;
import flash.filters.DropShadowFilter;
import flash.geom.ColorTransform;

import kabam.rotmg.text.view.TextFieldDisplayConcrete;
import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;

class LegendLine extends Sprite {

    private static const ct:ColorTransform = new ColorTransform(0.701960784313725, 0.701960784313725, 0.701960784313725);

    private static const EMPTY_DROPSHADOW_FILTER:DropShadowFilter = new DropShadowFilter(0, 0, 0);

    function LegendLine(_arg_1:int, _arg_2:int, _arg_3:ColorTransform) {
        super();
        this.addColoredStar(_arg_3);
        this.addRangeText(_arg_1, _arg_2);
        this.addGreyStar();
    }
    private var coloredStar_:StarGraphic;
    private var star_:StarGraphic;
    private var rangeText_:TextFieldDisplayConcrete;

    public function addGreyStar():void {
        this.star_ = new StarGraphic();
        this.star_.transform.colorTransform = ct;
        addChild(this.star_);
    }

    public function addRangeText(_arg_1:int, _arg_2:int):void {
        this.rangeText_ = new TextFieldDisplayConcrete().setSize(13).setColor(0xb3b3b3);
        this.rangeText_.setVerticalAlign("bottom");
        this.rangeText_.setStringBuilder(new StaticStringBuilder(": " + (_arg_1 == _arg_2 ? _arg_1.toString() : _arg_1 + " - " + _arg_2)));
        this.rangeText_.setBold(true);
        filters = [EMPTY_DROPSHADOW_FILTER];
        this.rangeText_.x = this.coloredStar_.width;
        this.rangeText_.y = this.coloredStar_.getBounds(this).bottom;
        this.rangeText_.textChanged.addOnce(this.positionGreyStar);
        addChild(this.rangeText_);
    }

    public function addColoredStar(_arg_1:ColorTransform):void {
        this.coloredStar_ = new StarGraphic();
        this.coloredStar_.transform.colorTransform = _arg_1;
        this.coloredStar_.y = 4;
        addChild(this.coloredStar_);
    }

    private function positionGreyStar():void {
        this.star_.x = this.rangeText_.getBounds(this).right + 2;
        this.star_.y = 4;
    }
}
