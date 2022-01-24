package kabam.rotmg.account.web.view {
import com.company.assembleegameclient.account.ui.Frame;
import com.company.assembleegameclient.account.ui.TextInputField;
import com.company.assembleegameclient.ui.DeprecatedClickableText;

import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;

import kabam.rotmg.account.web.model.AccountData;
import kabam.rotmg.text.view.TextFieldDisplayConcrete;
import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;

import org.osflash.signals.Signal;
import org.osflash.signals.natives.NativeMappedSignal;

public class WebLoginDialogForced extends Frame {


    public function WebLoginDialogForced(_arg_1:Boolean = false) {
        super("WebLoginDialog.title", "", "WebLoginDialog.rightButton", "/signIn");
        this.makeUI();
        if (_arg_1) {
            addChild(this.getText("Attention!", -165, -85).setColor(0xff0000));
            addChild(this.getText("A new password was sent to your Sign In Email Address.", -165, -65));
            addChild(this.getText("Please use the new password to Sign In.", -165, -45));
        }
        this.forgot = new NativeMappedSignal(this.forgotText, "click");
        this.register = new NativeMappedSignal(this.registerText, "click");
        this.signInForced = new Signal(AccountData);
    }
    public var signInForced:Signal;
    public var forgot:Signal;
    public var register:Signal;
    public var email:TextInputField;
    private var password:TextInputField;
    private var forgotText:DeprecatedClickableText;
    private var registerText:DeprecatedClickableText;

    public function setError(_arg_1:String):void {
        this.password.setError(_arg_1);
    }

    public function getText(_arg_1:String, _arg_2:int, _arg_3:int):TextFieldDisplayConcrete {
        var _local4:TextFieldDisplayConcrete = new TextFieldDisplayConcrete().setSize(16).setColor(0xffffff).setTextWidth(10 * 60);
        _local4.setBold(true);
        _local4.setStringBuilder(new StaticStringBuilder(_arg_1));
        _local4.setSize(16).setColor(0xffffff);
        _local4.setWordWrap(true);
        _local4.setMultiLine(true);
        _local4.setAutoSize("center");
        _local4.setHorizontalAlign("center");
        _local4.filters = [new DropShadowFilter(0, 0, 0)];
        _local4.x = _arg_2;
        _local4.y = _arg_3;
        return _local4;
    }

    private function makeUI():void {
        this.email = new TextInputField("WebLoginDialog.email", false);
        addTextInputField(this.email);
        this.password = new TextInputField("WebLoginDialog.password", true);
        addTextInputField(this.password);
        this.forgotText = new DeprecatedClickableText(12, false, "WebLoginDialog.forgot");
        addNavigationText(this.forgotText);
        this.registerText = new DeprecatedClickableText(12, false, "WebLoginDialog.register");
        addNavigationText(this.registerText);
        rightButton_.addEventListener("click", this.onSignIn);
        addEventListener("keyDown", this.onKeyDown);
        addEventListener("removedFromStage", this.onRemovedFromStage);
    }

    private function onSignInSub():void {
        var _local1:* = null;
        if (this.isEmailValid() && this.isPasswordValid()) {
            _local1 = new AccountData();
            _local1.username = this.email.text();
            _local1.password = this.password.text();
            this.signInForced.dispatch(_local1);
        }
    }

    private function isPasswordValid():Boolean {
        var _local1:* = this.password.text() != "";
        if (!_local1) {
            this.password.setError("WebLoginDialog.passwordError");
        }
        return _local1;
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
