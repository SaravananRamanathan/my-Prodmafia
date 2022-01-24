package kabam.rotmg.account.core.view {
import com.company.assembleegameclient.ui.dialogs.Dialog;

public class PurchaseConfirmationDialog extends Dialog {


    public function PurchaseConfirmationDialog(_arg_1:Function) {
        super("Purchase confirmation", "Continue with purchase?", "Yes", "No", null);
        this.confirmedHandler = _arg_1;
    }
    public var confirmedHandler:Function;
}
}
