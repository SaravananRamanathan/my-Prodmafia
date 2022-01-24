package com.company.assembleegameclient.ui.panels {
import com.company.assembleegameclient.game.AGameSprite;
import com.company.assembleegameclient.ui.DeprecatedTextButton;

import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.filters.DropShadowFilter;
import flash.utils.Timer;

import kabam.rotmg.text.view.TextFieldDisplayConcrete;
import kabam.rotmg.text.view.stringBuilder.LineBuilder;
import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;
import kabam.rotmg.ui.view.SignalWaiter;

public class GuildInvitePanel extends Panel {


    private const waiter:SignalWaiter = new SignalWaiter();

    public function GuildInvitePanel(_arg_1:AGameSprite, _arg_2:String, _arg_3:String) {
        super(_arg_1);
        this.name_ = _arg_2;
        this.guildName_ = _arg_3;
        this.title_ = new TextFieldDisplayConcrete().setSize(16).setColor(0xffffff).setTextWidth(188).setBold(true).setAutoSize("center").setHTML(true);
        this.title_.setStringBuilder(new LineBuilder().setParams("Guild.invitation", {"playerName": _arg_2}).setPrefix("<p align=\"center\">").setPostfix("</p>"));
        this.title_.filters = [new DropShadowFilter(0, 0, 0)];
        this.title_.y = 0;
        addChild(this.title_);
        this.guildNameText_ = new TextFieldDisplayConcrete().setSize(16).setColor(0xffffff).setTextWidth(188).setAutoSize("center").setBold(true).setHTML(true);
        this.guildNameText_.setStringBuilder(new StaticStringBuilder("<p align=\"center\">" + this.guildName_ + "</p>"));
        this.guildNameText_.filters = [new DropShadowFilter(0, 0, 0)];
        this.guildNameText_.y = 20;
        addChild(this.guildNameText_);
        this.rejectButton_ = new DeprecatedTextButton(16, "Guild.rejection");
        this.rejectButton_.addEventListener("click", this.onRejectClick);
        this.waiter.push(this.rejectButton_.textChanged);
        addChild(this.rejectButton_);
        this.acceptButton_ = new DeprecatedTextButton(16, "Guild.accept");
        this.acceptButton_.addEventListener("click", this.onAcceptClick);
        this.waiter.push(this.acceptButton_.textChanged);
        addChild(this.acceptButton_);
        this.timer_ = new Timer(20000, 1);
        this.timer_.start();
        this.timer_.addEventListener("timer", this.onTimer);
        this.waiter.complete.addOnce(this.alignUI);
    }
    public var name_:String;
    private var title_:TextFieldDisplayConcrete;
    private var guildName_:String;
    private var guildNameText_:TextFieldDisplayConcrete;
    private var rejectButton_:DeprecatedTextButton;
    private var acceptButton_:DeprecatedTextButton;
    private var timer_:Timer;

    private function alignUI():void {
        this.rejectButton_.x = 47 - this.rejectButton_.width / 2;
        this.rejectButton_.y = 84 - this.rejectButton_.height - 4;
        this.acceptButton_.x = 141 - this.acceptButton_.width / 2;
        this.acceptButton_.y = 84 - this.acceptButton_.height - 4;
    }

    private function onTimer(_arg_1:TimerEvent):void {
        dispatchEvent(new Event("complete"));
    }

    private function onRejectClick(_arg_1:MouseEvent):void {
        dispatchEvent(new Event("complete"));
    }

    private function onAcceptClick(_arg_1:MouseEvent):void {
        gs_.gsc_.joinGuild(this.guildName_);
        dispatchEvent(new Event("complete"));
    }
}
}
