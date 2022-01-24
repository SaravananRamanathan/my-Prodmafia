package com.company.assembleegameclient.ui.guild {
import com.company.assembleegameclient.ui.Scrollbar;
import com.company.assembleegameclient.util.GuildUtil;
import com.company.ui.BaseSimpleText;
import com.company.util.MoreObjectUtil;

import flash.display.Bitmap;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.filters.DropShadowFilter;

import kabam.rotmg.account.core.Account;
import kabam.rotmg.appengine.api.AppEngineClient;
import kabam.rotmg.core.StaticInjectorContext;
import kabam.rotmg.text.view.TextFieldDisplayConcrete;
import kabam.rotmg.text.view.stringBuilder.LineBuilder;

public class GuildPlayerList extends Sprite {


    public function GuildPlayerList(_arg_1:int, _arg_2:int, _arg_3:String = "", _arg_4:int = 0) {
        super();
        this.num_ = _arg_1;
        this.offset_ = _arg_2;
        this.myName_ = _arg_3;
        this.myRank_ = _arg_4;
        this.loadingText_ = new TextFieldDisplayConcrete().setSize(22).setColor(0xb3b3b3);
        this.loadingText_.setBold(true);
        this.loadingText_.setStringBuilder(new LineBuilder().setParams("Loading.text"));
        this.loadingText_.filters = [new DropShadowFilter(0, 0, 0, 1, 8, 8)];
        this.loadingText_.setAutoSize("center").setVerticalAlign("middle");
        this.loadingText_.x = 400;
        this.loadingText_.y = 550;
        addChild(this.loadingText_);
        var _local5:Account = StaticInjectorContext.getInjector().getInstance(Account);
        var _local6:Object = {
            "num": _arg_1,
            "offset": _arg_2
        };
        MoreObjectUtil.addToObject(_local6, _local5.getCredentials());
        this.listClient_ = StaticInjectorContext.getInjector().getInstance(AppEngineClient);
        this.listClient_.setMaxRetries(2);
        this.listClient_.complete.addOnce(this.onComplete);
        this.listClient_.sendRequest("/guild/listMembers", _local6);
    }
    private var num_:int;
    private var offset_:int;
    private var myName_:String;
    private var myRank_:int;
    private var listClient_:AppEngineClient;
    private var loadingText_:TextFieldDisplayConcrete;
    private var titleText_:BaseSimpleText;
    private var guildFameText_:BaseSimpleText;
    private var guildFameIcon_:Bitmap;
    private var lines_:Shape;
    private var mainSprite_:Sprite;
    private var listSprite_:Sprite;
    private var openSlotsText_:TextFieldDisplayConcrete;
    private var scrollBar_:Scrollbar;

    private function onComplete(_arg_1:Boolean, _arg_2:*):void {
        if (_arg_1) {
            this.onGenericData(_arg_2);
        } else {
            this.onTextError(_arg_2);
        }
    }

    private function onGenericData(_arg_1:String):void {
        this.build(XML(_arg_1));
    }

    private function onTextError(_arg_1:String):void {
    }

    private function build(_arg_1:XML):void {
        var _local5:int = 0;
        var _local4:* = false;
        var _local9:int = 0;
        var _local7:int = 0;
        var _local2:* = null;
        var _local3:* = null;
        var _local8:* = null;
        removeChild(this.loadingText_);
        this.titleText_ = new BaseSimpleText(32, 0xb3b3b3, false, 0, 0);
        this.titleText_.setBold(true);
        this.titleText_.text = _arg_1.@name;
        this.titleText_.useTextDimensions();
        this.titleText_.filters = [new DropShadowFilter(0, 0, 0, 1, 8, 8)];
        this.titleText_.y = 24;
        this.titleText_.x = 400 - this.titleText_.width * 0.5;
        addChild(this.titleText_);
        this.guildFameText_ = new BaseSimpleText(22, 0xffffff, false, 0, 0);
        this.guildFameText_.text = _arg_1.CurrentFame;
        this.guildFameText_.useTextDimensions();
        this.guildFameText_.filters = [new DropShadowFilter(0, 0, 0, 1, 8, 8)];
        this.guildFameText_.x = 768 - this.guildFameText_.width;
        this.guildFameText_.y = 16 - this.guildFameText_.height * 0.5;
        addChild(this.guildFameText_);
        this.guildFameIcon_ = new Bitmap(GuildUtil.guildFameIcon(40));
        this.guildFameIcon_.x = 760;
        this.guildFameIcon_.y = 16 - this.guildFameIcon_.height * 0.5;
        addChild(this.guildFameIcon_);
        this.lines_ = new Shape();
        _local2 = this.lines_.graphics;
        _local2.clear();
        _local2.lineStyle(2, 0x545454);
        _local2.moveTo(0, 100);
        _local2.lineTo(stage.stageWidth, 100);
        _local2.lineStyle();
        addChild(this.lines_);
        this.mainSprite_ = new Sprite();
        this.mainSprite_.x = 10;
        this.mainSprite_.y = 110;
        var _local6:Shape = new Shape();
        _local2 = _local6.graphics;
        _local2.beginFill(0);
        _local2.drawRect(0, 0, 756, 430);
        _local2.endFill();
        this.mainSprite_.addChild(_local6);
        this.mainSprite_.mask = _local6;
        addChild(this.mainSprite_);
        this.listSprite_ = new Sprite();
        var _local11:int = 0;
        var _local10:* = _arg_1.Member;
        for each(_local3 in _arg_1.Member) {
            _local4 = this.myName_ == _local3.Name;
            _local9 = _local3.Rank;
            _local8 = new MemberListLine(this.offset_ + _local7 + 1, _local3.Name, _local3.Rank, _local3.Fame, _local4, this.myRank_);
            _local8.y = _local7 * 32;
            this.listSprite_.addChild(_local8);
            _local7++;
        }
        _local5 = 50 - (this.offset_ + _local7);
        this.openSlotsText_ = new TextFieldDisplayConcrete().setSize(22).setColor(0xb3b3b3);
        this.openSlotsText_.setStringBuilder(new LineBuilder().setParams("GuildPlayerList.openSlots", {"openSlots": _local5}));
        this.openSlotsText_.filters = [new DropShadowFilter(0, 0, 0, 1, 8, 8)];
        this.openSlotsText_.setAutoSize("center");
        this.openSlotsText_.x = 378;
        this.openSlotsText_.y = _local7 * 32;
        this.listSprite_.addChild(this.openSlotsText_);
        this.mainSprite_.addChild(this.listSprite_);
        if (this.listSprite_.height > 400) {
            this.scrollBar_ = new Scrollbar(16, 400);
            this.scrollBar_.x = 800 - this.scrollBar_.width - 4;
            this.scrollBar_.y = 104;
            this.scrollBar_.setIndicatorSize(400, this.listSprite_.height);
            this.scrollBar_.addEventListener("change", this.onScrollBarChange, false, 0, true);
            addChild(this.scrollBar_);
        }
    }

    private function onScrollBarChange(_arg_1:Event):void {
        this.listSprite_.y = -this.scrollBar_.pos() * (this.listSprite_.height - 400);
    }
}
}
