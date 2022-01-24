package kabam.rotmg.characters.deletion.view {
import com.company.assembleegameclient.ui.dialogs.Dialog;

import flash.display.Sprite;
import flash.events.Event;

import io.decagames.rotmg.seasonalEvent.data.SeasonalEventModel;

import kabam.rotmg.core.StaticInjectorContext;

import org.osflash.signals.Signal;

public class ConfirmDeleteCharacterDialog extends Sprite {


    private const CANCEL_EVENT:String = "dialogLeftButton";

    private const DELETE_EVENT:String = "dialogRightButton";

    public function ConfirmDeleteCharacterDialog() {
        super();
        this.deleteCharacter = new Signal();
        this.cancel = new Signal();
    }
    public var deleteCharacter:Signal;
    public var cancel:Signal;

    public function setText(_arg_1:String, _arg_2:String):void {
        var _local5:Boolean = StaticInjectorContext.getInjector().getInstance(SeasonalEventModel).isChallenger;
        var _local4:String = !_local5 ? "ConfirmDeleteCharacterDialog" : "It will cost you a character life to delete {name} the {displayID} - Are you really sure you want to?";
        var _local3:Dialog = new Dialog("ConfirmDelete.verifyDeletion", "", "ConfirmDelete.cancel", "ConfirmDelete.delete", "/deleteDialog");
        _local3.setTextParams(_local4, {
            "name": _arg_1,
            "displayID": _arg_2
        });
        _local3.addEventListener("dialogLeftButton", this.onCancel);
        _local3.addEventListener("dialogRightButton", this.onDelete);
        addChild(_local3);
    }

    private function onCancel(_arg_1:Event):void {
        this.cancel.dispatch();
    }

    private function onDelete(_arg_1:Event):void {
        this.deleteCharacter.dispatch();
    }
}
}
