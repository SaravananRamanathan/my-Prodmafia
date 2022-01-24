package kabam.rotmg.account.web.view {
import com.company.assembleegameclient.account.ui.Frame;
import com.company.assembleegameclient.ui.DeprecatedClickableText;

import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;

import kabam.rotmg.text.view.TextFieldDisplayConcrete;
import kabam.rotmg.text.view.stringBuilder.LineBuilder;
import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;

import org.osflash.signals.Signal;
import org.osflash.signals.natives.NativeMappedSignal;

public class WebAccountDetailDialog extends Frame {


    public function WebAccountDetailDialog(_arg_1:String = "WebAccountDetailDialog.title", _arg_2:String = "WebAccountDetailDialog.loginText") {
        super(_arg_1, "", "WebAccountDetailDialog.rightButton", "/currentLogin");
        this.headerText = _arg_2;
        this.makeLoginText();
        this.makeEmailText();
        h_ = h_ + 88;
        this.cancel = new NativeMappedSignal(rightButton_, "click");
        this.change = new Signal();
        this.logout = new Signal();
        this.verify = new Signal();
    }
    public var cancel:Signal;
    public var change:Signal;
    public var logout:Signal;
    public var verify:Signal;
    private var loginText:TextFieldDisplayConcrete;
    private var emailText:TextFieldDisplayConcrete;
    private var verifyTitle:TextFieldDisplayConcrete;
    private var verifyEmail:DeprecatedClickableText;
    private var changeText:DeprecatedClickableText;
    private var logoutText:DeprecatedClickableText;
    private var headerText:String;

    public function setUserInfo(_arg_1:String, _arg_2:Boolean):void {
        this.emailText.setStringBuilder(new StaticStringBuilder(_arg_1));
        if (_arg_2) {
            this.makeVerifyEmailText();
        }
        this.makeChangeText();
        this.makeLogoutText();
    }

    private function makeVerifyEmailText():void {
        if (this.verifyEmail != null) {
            removeChild(this.verifyTitle);
        }
        this.verifyTitle = new TextFieldDisplayConcrete().setSize(18).setColor(0xff00);
        this.verifyTitle.setBold(true);
        this.verifyTitle.setStringBuilder(new LineBuilder().setParams("Email verified!"));
        this.verifyTitle.filters = [new DropShadowFilter(0, 0, 0)];
        this.verifyTitle.y = h_ - 110;
        this.verifyTitle.x = 17;
        addChild(this.verifyTitle);
    }

    private function makeChangeText():void {
        if (this.changeText != null) {
            removeChild(this.changeText);
        }
        this.changeText = new DeprecatedClickableText(12, false, "Change password");
        this.changeText.addEventListener("click", this.onChange);
        addNavigationText(this.changeText);
    }

    private function makeLogoutText():void {
        if (this.logoutText != null) {
            removeChild(this.logoutText);
        }
        this.logoutText = new DeprecatedClickableText(12, false, "Not you? Log out");
        this.logoutText.addEventListener("click", this.onLogout);
        addNavigationText(this.logoutText);
    }

    private function makeLoginText():void {
        this.loginText = new TextFieldDisplayConcrete().setSize(12).setColor(0xb3b3b3);
        this.loginText.setStringBuilder(new LineBuilder().setParams(this.headerText));
        this.loginText.y = h_ - 65;
        this.loginText.x = 17;
        addChild(this.loginText);
    }

    private function makeEmailText():void {
        this.emailText = new TextFieldDisplayConcrete().setSize(16).setColor(0xffffff);
        this.emailText.y = h_ - 50;
        this.emailText.x = 17;
        addChild(this.emailText);
    }

    private function onChange(_arg_1:MouseEvent):void {
        this.change.dispatch();
    }

    private function onLogout(_arg_1:MouseEvent):void {
        this.logout.dispatch();
    }

    private function onVerifyEmail(_arg_1:MouseEvent):void {
        this.verify.dispatch();
        this.verifyEmail.makeStatic("WebAccountDetailDialog.sent");
    }
}
}
