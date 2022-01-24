package kabam.rotmg.ui.view {
import com.company.assembleegameclient.ui.dialogs.Dialog;

import flash.display.Sprite;
import flash.events.Event;

import org.osflash.signals.Signal;

public class CharacterSlotNeedGoldDialog extends Sprite {

    private static const ANALYTICS_PAGE:String = "/charSlotNeedGold";


    public const buyGold:Signal = new Signal();

    public const cancel:Signal = new Signal();

    public function CharacterSlotNeedGoldDialog() {
        super();
    }
    private var dialog:Dialog;
    private var price:int;

    public function setPrice(_arg_1:int):void {
        this.price = _arg_1;
        this.dialog && contains(this.dialog) && removeChild(this.dialog);
        this.makeDialog();
        this.dialog.addEventListener("dialogLeftButton", this.onCancel);
        this.dialog.addEventListener("dialogRightButton", this.onBuyGold);
    }

    private function makeDialog():void {
        this.dialog = new Dialog("Gold.NotEnough", "", "Frame.cancel", "Gold.Buy", "/charSlotNeedGold");
        this.dialog.setTextParams("CharacterSlotNeedGoldDialog.price", {"price": this.price});
        addChild(this.dialog);
    }

    public function onCancel(_arg_1:Event):void {
        this.cancel.dispatch();
    }

    public function onBuyGold(_arg_1:Event):void {
        this.buyGold.dispatch();
    }
}
}
