package com.company.assembleegameclient.ui.panels {
import com.company.assembleegameclient.game.AGameSprite;
import com.company.assembleegameclient.objects.ArenaPortal;
import com.company.assembleegameclient.objects.Player;

import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;

import kabam.rotmg.text.view.StaticTextDisplay;
import kabam.rotmg.text.view.TextFieldDisplayConcrete;
import kabam.rotmg.text.view.stringBuilder.LineBuilder;
import kabam.rotmg.util.components.LegacyBuyButton;

import org.osflash.signals.Signal;

public class ArenaPortalPanel extends Panel {


    public const purchase:Signal = new Signal(int);

    public function ArenaPortalPanel(_arg_1:AGameSprite, _arg_2:ArenaPortal) {
        openContainer = new Sprite();
        closeContainer = new Sprite();
        super(_arg_1);
        this.owner_ = _arg_2;
        addChild(this.openContainer);
        addChild(this.closeContainer);
        if (gs_.map == null || gs_.map.player_ == null) {
            return;
        }
        var _local3:Player = gs_.map.player_;
        this.nameText_ = this.makeTitle();
        this.openContainer.addChild(this.nameText_);
        this.goldButton = new LegacyBuyButton("", 20, 51, 0);
        this.goldButton.addEventListener("click", this.onGoldClick, false, 0, true);
        this.openContainer.addChild(this.goldButton);
        this.fameButton = new LegacyBuyButton("", 20, 250, 1);
        if (_local3.fame_ < 250) {
            this.fameButton.setEnabled(false);
        } else {
            this.fameButton.addEventListener("click", this.onFameClick, false, 0, true);
        }
        this.openContainer.addChild(this.fameButton);
        this.fameButton.readyForPlacement.addOnce(this.alignUI);
        this.closedText = new StaticTextDisplay();
        this.closedText.setSize(18).setColor(0xff0000).setTextWidth(188).setWordWrap(true).setMultiLine(true).setAutoSize("center").setBold(true).setHTML(true);
        this.closedText.setStringBuilder(new LineBuilder().setParams("PortalPanel.full").setPrefix("<p align=\"center\">").setPostfix("</p>"));
        this.closedText.filters = [new DropShadowFilter(0, 0, 0)];
        this.closedText.y = 39;
        this.closeContainer.addChild(this.closedText);
        this.closeNameText = this.makeTitle();
        this.closeContainer.addChild(this.closeNameText);
    }
    private var owner_:ArenaPortal;
    private var openContainer:Sprite;
    private var nameText_:StaticTextDisplay;
    private var goldButton:LegacyBuyButton;
    private var fameButton:LegacyBuyButton;
    private var closeContainer:Sprite;
    private var closeNameText:TextFieldDisplayConcrete;
    private var closedText:StaticTextDisplay;

    override public function draw():void {
        this.openContainer.visible = this.owner_.active_;
        this.closeContainer.visible = !this.owner_.active_;
    }

    private function alignUI():void {
        this.goldButton.x = 47 - this.goldButton.width / 2;
        this.goldButton.y = 84 - this.goldButton.height - 4;
        this.fameButton.x = 141 - this.fameButton.width / 2;
        this.fameButton.y = 84 - this.fameButton.height - 4;
    }

    private function makeTitle():StaticTextDisplay {
        var _local1:* = null;
        _local1 = new StaticTextDisplay();
        _local1.setSize(18).setColor(0xffffff).setTextWidth(188).setWordWrap(true).setMultiLine(true).setAutoSize("center").setBold(true).setHTML(true);
        _local1.setStringBuilder(new LineBuilder().setParams("ArenaPortalPanel.title").setPrefix("<p align=\"center\">").setPostfix("</p>"));
        _local1.filters = [new DropShadowFilter(0, 0, 0)];
        _local1.y = 6;
        return _local1;
    }

    private function onGoldClick(_arg_1:MouseEvent):void {
        this.purchase.dispatch(0);
    }

    private function onFameClick(_arg_1:MouseEvent):void {
        this.purchase.dispatch(1);
    }
}
}
