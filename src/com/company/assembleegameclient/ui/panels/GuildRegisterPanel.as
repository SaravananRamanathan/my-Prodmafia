package com.company.assembleegameclient.ui.panels {
import com.company.assembleegameclient.game.GameSprite;
import com.company.assembleegameclient.ui.DeprecatedTextButton;
import com.company.assembleegameclient.util.GuildUtil;

import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;

import kabam.rotmg.text.view.TextFieldDisplayConcrete;
import kabam.rotmg.text.view.stringBuilder.LineBuilder;
import kabam.rotmg.ui.view.SignalWaiter;
import kabam.rotmg.util.components.LegacyBuyButton;

import org.osflash.signals.Signal;

public class GuildRegisterPanel extends Panel {


    public const openCreateGuildFrame:Signal = new Signal();

    public const waiter:SignalWaiter = new SignalWaiter();

    public const renounce:Signal = new Signal();

    public function GuildRegisterPanel(_arg_1:GameSprite) {
        var _local4:* = null;
        var _local3:* = null;
        var _local2:* = null;
        super(_arg_1);
        if (gs_.map == null || gs_.map.player_ == null) {
            return;
        }
        _local2 = gs_.map.player_;
        this.title_ = new TextFieldDisplayConcrete().setSize(18).setColor(0xffffff).setTextWidth(188).setWordWrap(true).setMultiLine(true).setAutoSize("center").setHTML(true);
        this.title_.filters = [new DropShadowFilter(0, 0, 0)];
        if (_local2.guildName_ != null && _local2.guildName_.length > 0) {
            _local4 = GuildUtil.rankToString(_local2.guildRank_);
            this.title_.setStringBuilder(new LineBuilder().setParams("GuildRegisterPanel.rankOfGuild", {
                "rank": _local4,
                "guildName": _local2.guildName_
            }).setPrefix("<p align=\"center\">").setPostfix("</p>"));
            this.title_.y = 0;
            addChild(this.title_);
            this.button_ = new DeprecatedTextButton(16, "GuildRegisterPanel.renounce");
            this.button_.addEventListener("click", this.onRenounceClick);
            this.waiter.push(DeprecatedTextButton(this.button_).textChanged);
            addChild(this.button_);
        } else {
            this.title_.setStringBuilder(new LineBuilder().setParams("GuildRegisterPanel.createAGuild").setPrefix("<p align=\"center\">").setPostfix("</p>"));
            this.title_.y = 0;
            addChild(this.title_);
            _local3 = new LegacyBuyButton("GuildRegisterPanel.buyButton", 16, 1000, 1);
            _local3.addEventListener("click", this.onCreateClick);
            this.waiter.push(_local3.readyForPlacement);
            addChild(_local3);
            this.button_ = _local3;
        }
        this.waiter.complete.addOnce(this.alignUI);
    }
    private var title_:TextFieldDisplayConcrete;
    private var button_:Sprite;

    private function alignUI():void {
        this.button_.x = 94 - this.button_.width / 2;
        this.button_.y = this.button_ is LegacyBuyButton ? 84 - this.button_.height / 2 - 31 : Number(84 - this.button_.height - 4);
    }

    public function onCreateClick(_arg_1:MouseEvent):void {
        visible = false;
        this.openCreateGuildFrame.dispatch();
    }

    private function onRenounceClick(_arg_1:MouseEvent):void {
        this.renounce.dispatch();
    }
}
}
