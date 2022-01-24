package com.company.assembleegameclient.ui.panels {
import com.company.assembleegameclient.game.GameSprite;
import com.company.assembleegameclient.objects.Portal;
import com.company.assembleegameclient.objects.PortalNameParser;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.ui.DeprecatedTextButton;

import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;

import kabam.rotmg.text.view.TextFieldDisplayConcrete;
import kabam.rotmg.text.view.stringBuilder.LineBuilder;
import kabam.rotmg.text.view.stringBuilder.StringBuilder;
import kabam.rotmg.ui.view.SignalWaiter;

import org.osflash.signals.Signal;

public class PortalPanel extends Panel {


    public const exitGameSignal:Signal = new Signal();

    private const waiter:SignalWaiter = new SignalWaiter();

    private const LOCKED:String = "Locked ";

    private const TEXT_PATTERN:RegExp = /\{"text":"(.+)"}/;

    public function PortalPanel(_arg_1:GameSprite, _arg_2:Portal) {
        super(_arg_1);
        this.owner_ = _arg_2;
        this.nameText_ = new TextFieldDisplayConcrete().setSize(18).setColor(0xffffff).setBold(true).setTextWidth(188).setWordWrap(true).setHorizontalAlign("center");
        this.nameText_.filters = [new DropShadowFilter(0, 0, 0)];
        addChild(this.nameText_);
        this.waiter.push(this.nameText_.textChanged);
        this._enterButton_ = new DeprecatedTextButton(16, "Panel.enter");
        addChild(this._enterButton_);
        this.waiter.push(this._enterButton_.textChanged);
        this.fullText_ = new TextFieldDisplayConcrete().setSize(18).setColor(0xff0000).setHTML(true).setBold(true).setAutoSize("center");
        var _local3:String = !!this.owner_.lockedPortal_ ? "PortalPanel.locked" : "PortalPanel.full";
        this.fullText_.setStringBuilder(new LineBuilder().setParams(_local3).setPrefix("<p align=\"center\">").setPostfix("</p>"));
        this.fullText_.filters = [new DropShadowFilter(0, 0, 0)];
        this.fullText_.textChanged.addOnce(this.alignUI);
        addEventListener("addedToStage", this.onAddedToStage);
        addEventListener("removedFromStage", this.onRemovedFromStage);
        this.waiter.complete.addOnce(this.alignUI);
    }
    public var owner_:Portal;
    private var nameText_:TextFieldDisplayConcrete;
    private var fullText_:TextFieldDisplayConcrete;
    private var warned:Boolean = false;

    private var _enterButton_:DeprecatedTextButton;

    public function get enterButton_():DeprecatedTextButton {
        return this._enterButton_;
    }

    override public function draw():void {
        this.updateNameText();
        if (!this.owner_.lockedPortal_ && this.owner_.active_ && contains(this.fullText_)) {
            removeChild(this.fullText_);
            addChild(this._enterButton_);
        } else if ((this.owner_.lockedPortal_ || !this.owner_.active_) && contains(this._enterButton_)) {
            removeChild(this._enterButton_);
            addChild(this.fullText_);
        }
    }

    private function alignUI():void {
        this.nameText_.y = 6;
        this._enterButton_.x = 94 - this._enterButton_.width / 2;
        this._enterButton_.y = 84 - this._enterButton_.height - 4;
        this.fullText_.y = 54;
        this.fullText_.x = 94;
    }

    private function enterPortal():void {
        if (Parameters.data.fameBlockTP && this.owner_.objectType_ == 3873 && !this.warned) {
            this.gs_.map.player_.textNotification("MGM forces you to teleport and ruins Boots on the Ground, BE WARNED!", 14835456);
            this.warned = true;
            return;
        }
        gs_.gsc_.usePortal(this.owner_.objectId_);
        this.exitGameSignal.dispatch();
    }

    private function updateNameText():void {
        var _local1:String = this.getName();
        var _local2:StringBuilder = new PortalNameParser().makeBuilder(_local1);
        this.nameText_.setStringBuilder(_local2);
        this.nameText_.x = (188 - this.nameText_.width) * 0.5;
        this.nameText_.y = this.nameText_.height > 30 ? 0 : 6;
    }

    private function getName():String {
        var _local1:String = this.owner_.getName();
        if (this.owner_.lockedPortal_ && _local1.indexOf("Locked ") == 0) {
            return _local1.substr(7);
        }
        return this.parseJson(_local1);
    }

    private function parseJson(_arg_1:String):String {
        var _local2:Array = _arg_1.match(this.TEXT_PATTERN);
        return !!_local2 ? _local2[1] : _arg_1;
    }

    public function onEnterSpriteClick(_arg_1:MouseEvent):void {
        this.enterPortal();
    }

    private function onAddedToStage(_arg_1:Event):void {
        stage.addEventListener("keyDown", this.onKeyDown);
    }

    private function onRemovedFromStage(_arg_1:Event):void {
        this._enterButton_.removeEventListener("click", this.onEnterSpriteClick);
        stage.removeEventListener("keyDown", this.onKeyDown);
    }

    private function onKeyDown(_arg_1:KeyboardEvent):void {
        if (_arg_1.keyCode == Parameters.data.interact && stage.focus == null && !this.owner_.lockedPortal_) {
            this.enterPortal();
        }
    }
}
}
