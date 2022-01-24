package com.company.assembleegameclient.ui.panels {
import com.company.assembleegameclient.game.GameSprite;
import com.company.assembleegameclient.objects.Player;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.ui.board.GuildBoardWindow;

import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;

public class GuildBoardPanel extends ButtonPanel {


    public function GuildBoardPanel(_arg_1:GameSprite) {
        super(_arg_1, "GuildBoardPanel.title", "Panel.viewButton");
        addEventListener("addedToStage", this.onAddedToStage);
        addEventListener("removedFromStage", this.onRemovedFromStage);
    }

    private function openWindow():void {
        var _local1:Player = gs_.map.player_;
        if (_local1 == null) {
            return;
        }
        gs_.addChild(new GuildBoardWindow(_local1.guildRank_ >= 20));
    }

    override protected function onButtonClick(_arg_1:MouseEvent):void {
        this.openWindow();
    }

    private function onAddedToStage(_arg_1:Event):void {
        stage.addEventListener("keyDown", this.onKeyDown);
    }

    private function onRemovedFromStage(_arg_1:Event):void {
        stage.removeEventListener("keyDown", this.onKeyDown);
    }

    private function onKeyDown(_arg_1:KeyboardEvent):void {
        if (_arg_1.keyCode == Parameters.data.interact && stage.focus == null) {
            this.openWindow();
        }
    }
}
}
