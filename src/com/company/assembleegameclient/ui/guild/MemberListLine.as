package com.company.assembleegameclient.ui.guild {
import com.company.assembleegameclient.ui.dialogs.Dialog;
import com.company.assembleegameclient.util.GuildUtil;
import com.company.rotmg.graphics.DeleteXGraphic;
import com.company.util.MoreColorUtil;

import flash.display.Bitmap;
import flash.display.Graphics;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;
import flash.geom.ColorTransform;

import kabam.rotmg.core.StaticInjectorContext;
import kabam.rotmg.dialogs.control.CloseDialogsSignal;
import kabam.rotmg.dialogs.control.OpenDialogSignal;
import kabam.rotmg.text.view.TextFieldDisplayConcrete;
import kabam.rotmg.text.view.stringBuilder.LineBuilder;
import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;

internal class MemberListLine extends Sprite {

    public static const WIDTH:int = 756;

    public static const HEIGHT:int = 32;

    protected static const mouseOverCT:ColorTransform = new ColorTransform(1, 0.862745098039216, 0.52156862745098);

    function MemberListLine(_arg_1:int, _arg_2:String, _arg_3:int, _arg_4:int, _arg_5:Boolean, _arg_6:int) {
        var _local7:int = 0;
        super();
        this.name_ = _arg_2;
        this.rank_ = _arg_3;
        _local7 = 0xb3b3b3;
        if (_arg_5) {
            _local7 = 16564761;
        }
        this.placeText_ = new TextFieldDisplayConcrete().setSize(22).setColor(_local7);
        this.placeText_.setStringBuilder(new StaticStringBuilder(_arg_1.toString() + "."));
        this.placeText_.filters = [new DropShadowFilter(0, 0, 0, 1, 8, 8)];
        this.placeText_.x = 60 - this.placeText_.width;
        this.placeText_.y = 4;
        addChild(this.placeText_);
        this.nameText_ = new TextFieldDisplayConcrete().setSize(22).setColor(_local7);
        this.nameText_.setStringBuilder(new StaticStringBuilder(_arg_2));
        this.nameText_.filters = [new DropShadowFilter(0, 0, 0, 1, 8, 8)];
        this.nameText_.x = 100;
        this.nameText_.y = 4;
        addChild(this.nameText_);
        this.guildFameText_ = new TextFieldDisplayConcrete().setSize(22).setColor(_local7);
        this.guildFameText_.setAutoSize("right");
        this.guildFameText_.setStringBuilder(new StaticStringBuilder(_arg_4.toString()));
        this.guildFameText_.filters = [new DropShadowFilter(0, 0, 0, 1, 8, 8)];
        this.guildFameText_.x = 408;
        this.guildFameText_.y = 4;
        addChild(this.guildFameText_);
        this.guildFameIcon_ = new Bitmap(GuildUtil.guildFameIcon(40));
        this.guildFameIcon_.x = 400;
        this.guildFameIcon_.y = 16 - this.guildFameIcon_.height / 2;
        addChild(this.guildFameIcon_);
        this.rankIcon_ = new Bitmap(GuildUtil.rankToIcon(_arg_3, 20));
        this.rankIcon_.x = 548;
        this.rankIcon_.y = 16 - this.rankIcon_.height / 2;
        addChild(this.rankIcon_);
        this.rankText_ = new TextFieldDisplayConcrete().setSize(22).setColor(_local7);
        this.rankText_.setStringBuilder(new LineBuilder().setParams(GuildUtil.rankToString(_arg_3)));
        this.rankText_.filters = [new DropShadowFilter(0, 0, 0, 1, 8, 8)];
        this.rankText_.setVerticalAlign("middle");
        this.rankText_.x = 580;
        this.rankText_.y = 16;
        addChild(this.rankText_);
        if (GuildUtil.canPromote(_arg_6, _arg_3)) {
            this.promoteButton_ = this.createArrow(true);
            this.addHighlighting(this.promoteButton_);
            this.promoteButton_.addEventListener("click", this.onPromote, false, 0, true);
            this.promoteButton_.x = 676;
            this.promoteButton_.y = 16;
            addChild(this.promoteButton_);
        }
        if (GuildUtil.canDemote(_arg_6, _arg_3)) {
            this.demoteButton_ = this.createArrow(false);
            this.addHighlighting(this.demoteButton_);
            this.demoteButton_.addEventListener("click", this.onDemote, false, 0, true);
            this.demoteButton_.x = 706;
            this.demoteButton_.y = 16;
            addChild(this.demoteButton_);
        }
        if (GuildUtil.canRemove(_arg_6, _arg_3)) {
            this.removeButton_ = new DeleteXGraphic();
            this.addHighlighting(this.removeButton_);
            this.removeButton_.addEventListener("click", this.onRemove, false, 0, true);
            this.removeButton_.x = 730;
            this.removeButton_.y = 16 - this.removeButton_.height / 2;
            addChild(this.removeButton_);
        }
    }
    private var name_:String;
    private var rank_:int;
    private var placeText_:TextFieldDisplayConcrete;
    private var nameText_:TextFieldDisplayConcrete;
    private var guildFameText_:TextFieldDisplayConcrete;
    private var guildFameIcon_:Bitmap;
    private var rankIcon_:Bitmap;
    private var rankText_:TextFieldDisplayConcrete;
    private var promoteButton_:Sprite;
    private var demoteButton_:Sprite;
    private var removeButton_:Sprite;

    private function createArrow(_arg_1:Boolean):Sprite {
        var _local2:Sprite = new Sprite();
        var _local3:Graphics = _local2.graphics;
        _local3.beginFill(0xffffff);
        _local3.moveTo(-8, -6);
        _local3.lineTo(8, -6);
        _local3.lineTo(0, 6);
        _local3.lineTo(-8, -6);
        if (_arg_1) {
            _local2.rotation = 3 * 60;
        }
        return _local2;
    }

    private function addHighlighting(_arg_1:Sprite):void {
        _arg_1.addEventListener("mouseOver", this.onHighlightOver, false, 0, true);
        _arg_1.addEventListener("rollOut", this.onHighlightOut, false, 0, true);
    }

    private function onHighlightOver(_arg_1:MouseEvent):void {
        var _local2:Sprite = _arg_1.currentTarget as Sprite;
        _local2.transform.colorTransform = mouseOverCT;
    }

    private function onHighlightOut(_arg_1:MouseEvent):void {
        var _local2:Sprite = _arg_1.currentTarget as Sprite;
        _local2.transform.colorTransform = MoreColorUtil.identity;
    }

    private function onPromote(_arg_1:MouseEvent):void {
        var _local2:String = GuildUtil.rankToString(GuildUtil.promotedRank(this.rank_));
        var _local3:Dialog = new Dialog("", "", "Guild.PromoteLeftButton", "Guild.PromoteRightButton", "/promote");
        _local3.setTextParams("Guild.PromoteText", {
            "name": this.name_,
            "rank": _local2
        });
        _local3.setTitleStringBuilder(new LineBuilder().setParams("Guild.PromoteTitle", {"name": this.name_}));
        _local3.addEventListener("dialogLeftButton", this.onCancelDialog, false, 0, true);
        _local3.addEventListener("dialogRightButton", this.onVerifiedPromote, false, 0, true);
        StaticInjectorContext.getInjector().getInstance(OpenDialogSignal).dispatch(_local3);
    }

    private function onVerifiedPromote(_arg_1:Event):void {
        dispatchEvent(new GuildPlayerListEvent("SET_RANK", this.name_, GuildUtil.promotedRank(this.rank_)));
        StaticInjectorContext.getInjector().getInstance(CloseDialogsSignal).dispatch();
    }

    private function onDemote(_arg_1:MouseEvent):void {
        var _local2:String = GuildUtil.rankToString(GuildUtil.demotedRank(this.rank_));
        var _local3:Dialog = new Dialog("", "", "Guild.DemoteLeft", "Guild.DemoteRight", "/demote");
        _local3.setTextParams("Guild.DemoteText", {
            "name": this.name_,
            "rank": _local2
        });
        _local3.setTitleStringBuilder(new LineBuilder().setParams("Guild.DemoteTitle", {"name": this.name_}));
        _local3.addEventListener("dialogLeftButton", this.onCancelDialog, false, 0, true);
        _local3.addEventListener("dialogRightButton", this.onVerifiedDemote, false, 0, true);
        StaticInjectorContext.getInjector().getInstance(OpenDialogSignal).dispatch(_local3);
    }

    private function onVerifiedDemote(_arg_1:Event):void {
        dispatchEvent(new GuildPlayerListEvent("SET_RANK", this.name_, GuildUtil.demotedRank(this.rank_)));
        StaticInjectorContext.getInjector().getInstance(CloseDialogsSignal).dispatch();
    }

    private function onRemove(_arg_1:MouseEvent):void {
        var _local2:Dialog = new Dialog("", "", "Guild.RemoveLeft", "Guild.RemoveRight", "/removeFromGuild");
        _local2.setTextParams("Guild.RemoveText", {"name": this.name_});
        _local2.setTitleStringBuilder(new LineBuilder().setParams("Guild.RemoveTitle", {"name": this.name_}));
        _local2.addEventListener("dialogLeftButton", this.onCancelDialog, false, 0, true);
        _local2.addEventListener("dialogRightButton", this.onVerifiedRemove, false, 0, true);
        StaticInjectorContext.getInjector().getInstance(OpenDialogSignal).dispatch(_local2);
    }

    private function onVerifiedRemove(_arg_1:Event):void {
        StaticInjectorContext.getInjector().getInstance(CloseDialogsSignal).dispatch();
        dispatchEvent(new GuildPlayerListEvent("REMOVE_MEMBER", this.name_));
    }

    private function onCancelDialog(_arg_1:Event):void {
        StaticInjectorContext.getInjector().getInstance(CloseDialogsSignal).dispatch();
    }
}
}
