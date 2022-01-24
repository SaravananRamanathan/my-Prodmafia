package kabam.rotmg.account.core.view {
import com.company.assembleegameclient.ui.dialogs.Dialog;

import org.osflash.signals.Signal;
import org.osflash.signals.natives.NativeMappedSignal;

public class RegisterPromptDialog extends Dialog {


    public function RegisterPromptDialog(_arg_1:String, _arg_2:Object = null) {
        super("RegisterPrompt.notRegistered", _arg_1, "RegisterPrompt.left", "RegisterPrompt.right", "/needRegister", _arg_2);
        this.cancel = new NativeMappedSignal(this, "dialogLeftButton");
        this.register = new NativeMappedSignal(this, "dialogRightButton");
    }
    public var cancel:Signal;
    public var register:Signal;
}
}
