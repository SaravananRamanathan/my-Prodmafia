package kabam.rotmg.game.view {
import com.company.assembleegameclient.game.GameSprite;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.ui.panels.ButtonPanel;

import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;

import org.osflash.signals.Signal;

public class MoneyChangerPanel extends ButtonPanel {


    public function MoneyChangerPanel(_arg_1:GameSprite) {
        super(_arg_1, "MoneyChangerPanel.title", "MoneyChangerPanel.button");
        this.triggered = new Signal();
        addEventListener("addedToStage", this.onAddedToStage);
        addEventListener("removedFromStage", this.onRemovedFromStage);
    }
    public var triggered:Signal;

    override protected function onButtonClick(_arg_1:MouseEvent):void {
        this.triggered.dispatch();
    }

    private function onAddedToStage(_arg_1:Event):void {
        stage.addEventListener("keyDown", this.onKeyDown);
    }

    private function onRemovedFromStage(_arg_1:Event):void {
        stage.removeEventListener("keyDown", this.onKeyDown);
    }

    private function onKeyDown(_arg_1:KeyboardEvent):void {
        if (_arg_1.keyCode == Parameters.data.interact && stage.focus == null) {
            this.triggered.dispatch();
        }
    }
}
}
