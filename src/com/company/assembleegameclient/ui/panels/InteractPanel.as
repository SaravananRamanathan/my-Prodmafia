package com.company.assembleegameclient.ui.panels {
import com.company.assembleegameclient.game.GameSprite;
import com.company.assembleegameclient.objects.IInteractiveObject;
import com.company.assembleegameclient.objects.Player;
import com.company.assembleegameclient.ui.panels.itemgrids.ItemGrid;

import flash.display.Sprite;
import flash.events.Event;

public class InteractPanel extends Sprite {

    public static const MAX_DIST:Number = 1;

    public function InteractPanel(_arg_1:GameSprite, _arg_2:Player, _arg_3:int, _arg_4:int) {
        super();
        this.gs_ = _arg_1;
        this.player_ = _arg_2;
        this.w_ = _arg_3;
        this.h_ = _arg_4;
        this.partyPanel_ = new PartyPanel(_arg_1);
    }
    public var gs_:GameSprite;
    public var player_:Player;
    public var w_:int;
    public var h_:int;
    public var currentPanel:Panel = null;
    public var currObj_:IInteractiveObject = null;
    public var partyPanel_:PartyPanel;
    public var requestInteractive:Function;
    private var overridePanel_:Panel;

    public function dispose():void {
        this.gs_ = null;
        this.player_ = null;
        this.currObj_ = null;
        this.partyPanel_.dispose();
        this.partyPanel_ = null;
        this.overridePanel_ = null;
    }

    public function setOverride(_arg_1:Panel):void {
        if (this.overridePanel_ != null) {
            this.overridePanel_.removeEventListener("complete", this.onComplete);
        }
        this.overridePanel_ = _arg_1;
        this.overridePanel_.addEventListener("complete", this.onComplete);
    }

    public function redraw():void {
        this.currentPanel.draw();
    }

    public function draw():void {
        var _local2:* = null;
        var _local1:* = null;
        if (this.overridePanel_) {
            this.setPanel(this.overridePanel_);
            this.currentPanel.draw();
            return;
        }
        _local1 = this.requestInteractive();
        if (this.currentPanel == null || _local1 != this.currObj_) {
            this.currObj_ = _local1;
            this.partyPanel_ = new PartyPanel(this.gs_);
            if (this.currObj_) {
                _local2 = this.currObj_.getPanel(this.gs_);
            } else {
                _local2 = this.partyPanel_;
            }
            this.setPanel(_local2);
        }
        if (this.currentPanel) {
            this.currentPanel.draw();
        }
    }

    public function setPanel(_arg_1:Panel):void {
        if (_arg_1 != this.currentPanel) {
            this.currentPanel && removeChild(this.currentPanel);
            this.currentPanel = _arg_1;
            this.currentPanel && this.positionPanelAndAdd();
        }
    }

    private function positionPanelAndAdd():void {
        if (this.currentPanel is ItemGrid) {
            this.currentPanel.x = (this.w_ - this.currentPanel.width) * 0.5;
            this.currentPanel.y = 8;
        } else {
            this.currentPanel.x = 6;
            this.currentPanel.y = 8;
        }
        addChild(this.currentPanel);
    }

    private function onComplete(_arg_1:Event):void {
        if (this.overridePanel_) {
            this.overridePanel_.removeEventListener("complete", this.onComplete);
            this.overridePanel_ = null;
        }
        this.setPanel(null);
        this.draw();
    }
}
}
