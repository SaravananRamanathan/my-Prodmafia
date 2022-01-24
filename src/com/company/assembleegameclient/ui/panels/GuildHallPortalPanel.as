package com.company.assembleegameclient.ui.panels {
import com.company.assembleegameclient.game.AGameSprite;
import com.company.assembleegameclient.objects.GuildHallPortal;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.ui.DeprecatedTextButton;
import com.company.assembleegameclient.util.StageProxy;

import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;

import kabam.rotmg.text.view.TextFieldDisplayConcrete;
import kabam.rotmg.text.view.stringBuilder.LineBuilder;
import kabam.rotmg.ui.view.SignalWaiter;

public class GuildHallPortalPanel extends Panel {


    private const waiter:SignalWaiter = new SignalWaiter();

    public function GuildHallPortalPanel(_arg_1:AGameSprite, _arg_2:GuildHallPortal) {
        var _local3:* = null;
        super(_arg_1);
        this.stageProxy = new StageProxy(this);
        this.owner_ = _arg_2;
        if (gs_.map == null || gs_.map.player_ == null) {
            return;
        }
        _local3 = gs_.map.player_;
        this.nameText_ = new TextFieldDisplayConcrete().setSize(18).setColor(0xffffff).setTextWidth(188).setWordWrap(true).setMultiLine(true).setAutoSize("center").setBold(true).setHTML(true);
        this.nameText_.setStringBuilder(new LineBuilder().setParams("GuildHallPortalPanel.title").setPrefix("<p align=\"center\">").setPostfix("</p>"));
        this.nameText_.filters = [new DropShadowFilter(0, 0, 0)];
        this.nameText_.y = 6;
        addChild(this.nameText_);
        if (_local3.guildName_ != null && _local3.guildName_.length > 0) {
            this.enterButton_ = new DeprecatedTextButton(16, "Panel.enter");
            this.enterButton_.addEventListener("click", this.onEnterSpriteClick);
            addChild(this.enterButton_);
            this.waiter.push(this.enterButton_.textChanged);
            addEventListener("addedToStage", this.onAdded);
        } else {
            this.noGuildText_ = new TextFieldDisplayConcrete().setSize(18).setColor(0xff0000).setTextWidth(188).setAutoSize("center").setHTML(true).setBold(true);
            this.noGuildText_.setStringBuilder(new LineBuilder().setParams("GuildHallPortalPanel.noGuild").setPrefix("<p align=\"center\">").setPostfix("</p>"));
            this.noGuildText_.filters = [new DropShadowFilter(0, 0, 0)];
            this.waiter.push(this.noGuildText_.textChanged);
            addChild(this.noGuildText_);
        }
        this.waiter.complete.addOnce(this.alignUI);
    }
    public var stageProxy:StageProxy;
    private var owner_:GuildHallPortal;
    private var nameText_:TextFieldDisplayConcrete;
    private var enterButton_:DeprecatedTextButton;
    private var noGuildText_:TextFieldDisplayConcrete;

    private function alignUI():void {
        if (this.noGuildText_) {
            this.noGuildText_.y = 84 - this.noGuildText_.height - 12;
        }
        if (this.enterButton_) {
            this.enterButton_.x = 94 - this.enterButton_.width / 2;
            this.enterButton_.y = 84 - this.enterButton_.height - 4;
        }
    }

    private function enterPortal():void {
        gs_.gsc_.usePortal(this.owner_.objectId_);
    }

    private function onAdded(_arg_1:Event):void {
        this.stageProxy.addEventListener("keyDown", this.onKeyDown);
        addEventListener("removedFromStage", this.onRemoved);
    }

    private function onRemoved(_arg_1:Event):void {
        this.stageProxy.removeEventListener("keyDown", this.onKeyDown);
    }

    private function onEnterSpriteClick(_arg_1:MouseEvent):void {
        this.enterPortal();
    }

    private function onKeyDown(_arg_1:KeyboardEvent):void {
        if (_arg_1.keyCode == Parameters.data.interact && stage.focus == null) {
            this.enterPortal();
        }
    }
}
}
