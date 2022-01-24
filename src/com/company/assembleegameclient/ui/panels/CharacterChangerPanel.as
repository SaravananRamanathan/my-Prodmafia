package com.company.assembleegameclient.ui.panels {
import com.company.assembleegameclient.game.GameSprite;
import com.company.assembleegameclient.parameters.Parameters;

import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;

public class CharacterChangerPanel extends ButtonPanel {


    public function CharacterChangerPanel(_arg_1:GameSprite) {
        super(_arg_1, "CharacterChangerPanel.title", "CharacterChangerPanel.button");
        addEventListener("addedToStage", this.onAddedToStage);
        addEventListener("removedFromStage", this.onRemovedFromStage);
    }

    override protected function onButtonClick(_arg_1:MouseEvent):void {
        gs_.closed.dispatch();
    }

    private function onAddedToStage(_arg_1:Event):void {
        stage.addEventListener("keyDown", this.onKeyDown);
    }

    private function onRemovedFromStage(_arg_1:Event):void {
        stage.removeEventListener("keyDown", this.onKeyDown);
    }

    private function onKeyDown(_arg_1:KeyboardEvent):void {
        if (_arg_1.keyCode == Parameters.data.interact && stage.focus == null) {
            gs_.closed.dispatch();
        }
    }
}
}
