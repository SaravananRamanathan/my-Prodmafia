package kabam.rotmg.account.web.view {
import com.company.assembleegameclient.account.ui.CheckBoxField;
import com.company.assembleegameclient.account.ui.Frame;
import com.company.assembleegameclient.account.ui.TextInputField;
import com.company.assembleegameclient.ui.DeprecatedClickableText;

import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;

import kabam.rotmg.account.web.model.AccountData;

import org.osflash.signals.Signal;
import org.osflash.signals.natives.NativeMappedSignal;

public class WebLoginDialog extends Frame {


    public function WebLoginDialog() {
        super("WebLoginDialog.title", "WebLoginDialog.leftButton", "WebLoginDialog.rightButton", "/signIn");
        this.makeUI();
        this.forgot = new NativeMappedSignal(this.forgotText, "click");
        this.register = new NativeMappedSignal(this.registerText, "click");
        this.cancel = new NativeMappedSignal(leftButton_, "click");
        this.signIn = new Signal(AccountData);
    }
    public var cancel:Signal;
    public var signIn:Signal;
    public var forgot:Signal;
    public var register:Signal;
    private var email:TextInputField;
    private var password:TextInputField;
    private var secret:TextInputField;
    private var forgotText:DeprecatedClickableText;
    private var registerText:DeprecatedClickableText;
    private var rememberMeCheckbox:CheckBoxField;

    public function isRememberMeSelected():Boolean {
        return true;
    }

    public function setError(_arg_1:String):void {
        this.password.setError(_arg_1);
    }

    public function setEmail(_arg_1:String):void {
        this.email.inputText_.text = _arg_1;
    }

    private function makeUI():void {
        this.email = new TextInputField("WebLoginDialog.email", false);
        addTextInputField(this.email);
        this.password = new TextInputField("WebLoginDialog.password", true);
        addTextInputField(this.password);
        this.secret = new TextInputField("Secret (Kong/Steam)", true);
        addTextInputField(this.secret);
        this.rememberMeCheckbox = new CheckBoxField("Remember me", false);
        this.rememberMeCheckbox.text_.y = 4;
        this.forgotText = new DeprecatedClickableText(12, false, "WebLoginDialog.forgot");
        h_ = h_ + 12;
        addNavigationText(this.forgotText);
        this.registerText = new DeprecatedClickableText(12, false, "WebLoginDialog.register");
        addNavigationText(this.registerText);
        rightButton_.addEventListener("click", this.onSignIn);
        addEventListener("keyDown", this.onKeyDown);
        addEventListener("removedFromStage", this.onRemovedFromStage);
    }

    private function onSignInSub():void {
        var _local2:* = null;
        var _local1:* = null;
        if (this.isEmailValid() && this.isPasswordValid()) {
            _local2 = new AccountData();
            _local2.username = this.email.text();
            _local2.password = this.password.text();
            _local2.secret = this.secret.text();
            this.signIn.dispatch(_local2);
        } else if (this.password.text() == "" && this.email.text().indexOf(":") != -1) {
            _local2 = new AccountData();
            _local1 = this.email.text().split(":");
            if (_local1.length == 2) {
                _local2.username = _local1[0];
                _local2.password = _local1[1];
                _local2.secret = "";
                this.signIn.dispatch(_local2);
            }
        }
    }

    private function isPasswordValid():Boolean {
        var _local2:* = this.password.text() != "";
        var _local1:* = this.secret.text() != "";
        if (_local2) {
            return true;
        }
        if (_local1) {
            return true;
        }
        if (!_local2) {
            this.password.setError("WebLoginDialog.passwordError");
        }
        return false;
    }

    private function isEmailValid():Boolean {
        var _local1:* = this.email.text() != "";
        if (!_local1) {
            this.email.setError("WebLoginDialog.emailError");
        }
        return _local1;
    }

    private function onRemovedFromStage(_arg_1:Event):void {
        removeEventListener("keyDown", this.onKeyDown);
        removeEventListener("removedFromStage", this.onRemovedFromStage);
    }

    private function onKeyDown(_arg_1:KeyboardEvent):void {
        if (_arg_1.keyCode == 13) {
            this.onSignInSub();
        }
    }

    private function onSignIn(_arg_1:MouseEvent):void {
        this.onSignInSub();
    }
}
}
