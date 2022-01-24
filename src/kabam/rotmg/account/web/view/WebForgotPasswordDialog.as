package kabam.rotmg.account.web.view {
import com.company.assembleegameclient.account.ui.Frame;
import com.company.assembleegameclient.account.ui.TextInputField;
import com.company.assembleegameclient.ui.DeprecatedClickableText;

import flash.events.MouseEvent;

import org.osflash.signals.Signal;
import org.osflash.signals.natives.NativeMappedSignal;

public class WebForgotPasswordDialog extends Frame {


    public function WebForgotPasswordDialog() {
        super("WebForgotPasswordDialog.title", "WebForgotPasswordDialog.leftButton", "WebForgotPasswordDialog.rightButton", "/forgotPassword");
        this.emailInput = new TextInputField("WebForgotPasswordDialog.email", false);
        addTextInputField(this.emailInput);
        this.registerText = new DeprecatedClickableText(12, false, "WebForgotPasswordDialog.register");
        addNavigationText(this.registerText);
        rightButton_.addEventListener("click", this.onSubmit);
        this.cancel = new NativeMappedSignal(leftButton_, "click");
        this.register = new NativeMappedSignal(this.registerText, "click");
        this.submit = new Signal(String);
    }
    public var cancel:Signal;
    public var submit:Signal;
    public var register:Signal;
    private var emailInput:TextInputField;
    private var registerText:DeprecatedClickableText;

    public function showError(_arg_1:String):void {
        this.emailInput.setError(_arg_1);
    }

    private function isEmailValid():Boolean {
        var _local1:* = this.emailInput.text() != "";
        if (!_local1) {
            this.emailInput.setError("Not a valid email address");
        }
        return _local1;
    }

    private function onSubmit(_arg_1:MouseEvent):void {
        if (this.isEmailValid()) {
            disable();
            this.submit.dispatch(this.emailInput.text());
        }
    }
}
}
