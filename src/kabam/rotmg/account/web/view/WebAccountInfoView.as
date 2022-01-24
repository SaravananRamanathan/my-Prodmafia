package kabam.rotmg.account.web.view {
import com.company.assembleegameclient.screens.TitleMenuOption;

import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.filters.DropShadowFilter;

import kabam.rotmg.account.core.view.AccountInfoView;
import kabam.rotmg.text.view.TextFieldDisplayConcrete;
import kabam.rotmg.text.view.stringBuilder.LineBuilder;
import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;

import org.osflash.signals.Signal;
import org.osflash.signals.natives.NativeMappedSignal;

public class WebAccountInfoView extends Sprite implements AccountInfoView {

    private static const FONT_SIZE:int = 18;

    public function WebAccountInfoView() {
        super();
        this.makeUIElements();
        this.makeSignals();
    }
    private var userName:String = "";
    private var isRegistered:Boolean;
    private var accountText:TextFieldDisplayConcrete;
    private var registerButton:TitleMenuOption;
    private var loginButton:TitleMenuOption;
    private var resetButton:TitleMenuOption;

    private var _login:Signal;

    public function get login():Signal {
        return this._login;
    }

    private var _register:Signal;

    public function get register():Signal {
        return this._register;
    }

    private var _reset:Signal;

    public function get reset():Signal {
        return this._reset;
    }

    public function setInfo(_arg_1:String, _arg_2:Boolean):void {
        this.userName = _arg_1;
        this.isRegistered = _arg_2;
        this.updateUI();
    }

    private function makeUIElements():void {
        this.makeAccountText();
        this.makeLoginButton();
        this.makeRegisterButton();
        this.makeResetButton();
    }

    private function makeSignals():void {
        this._login = new NativeMappedSignal(this.loginButton, "click");
        this._register = new NativeMappedSignal(this.registerButton, "click");
        this._reset = new NativeMappedSignal(this.resetButton, "click");
    }

    private function makeAccountText():void {
        this.accountText = this.makeTextFieldConcrete();
    }

    private function makeTextFieldConcrete():TextFieldDisplayConcrete {
        var _local1:* = null;
        _local1 = new TextFieldDisplayConcrete();
        _local1.setAutoSize("right");
        _local1.setSize(18).setColor(0xb3b3b3);
        _local1.filters = [new DropShadowFilter(0, 0, 0, 1, 4, 4)];
        return _local1;
    }

    private function makeLoginButton():void {
        this.loginButton = new TitleMenuOption("AccountInfo.log_in", 18, false);
        this.loginButton.setAutoSize("right");
    }

    private function makeResetButton():void {
        this.resetButton = new TitleMenuOption("reset", 18, false);
        this.resetButton.setAutoSize("right");
    }

    private function makeRegisterButton():void {
        this.registerButton = new TitleMenuOption("AccountInfo.register", 18, false);
        this.registerButton.setAutoSize("right");
    }

    private function makeDividerText():DisplayObject {
        var _local1:TextFieldDisplayConcrete = new TextFieldDisplayConcrete();
        _local1.setColor(0xb3b3b3).setAutoSize("right").setSize(18);
        _local1.filters = [new DropShadowFilter(0, 0, 0, 1, 4, 4)];
        _local1.setStringBuilder(new StaticStringBuilder(" - "));
        return _local1;
    }

    private function updateUI():void {
        this.removeUIElements();
        if (this.isRegistered) {
            this.showUIForRegisteredAccount();
        } else {
            this.showUIForGuestAccount();
        }
    }

    private function removeUIElements():void {
        while (numChildren) {
            removeChildAt(0);
        }
    }

    private function showUIForRegisteredAccount():void {
        this.accountText.setStringBuilder(new LineBuilder().setParams("AccountInfo.loggedIn", {"userName": this.userName}));
        this.loginButton.setTextKey("AccountInfo.log_out");
        this.addAndAlignHorizontally(this.accountText, this.loginButton);
    }

    private function showUIForGuestAccount():void {
        this.loginButton.setTextKey("AccountInfo.log_in");
        this.addAndAlignHorizontally(this.registerButton, this.makeDividerText(), this.loginButton);
    }

    private function addAndAlignHorizontally(..._args):void {
        var _local2:DisplayObject;
        var _local3:int;
        var _local4:int;
        var _local5:DisplayObject;
        for each (_local2 in _args) {
            addChild(_local2);
        }
        _local3 = 0;
        _local4 = _args.length;
        while (_local4--) {
            _local5 = _args[_local4];
            _local5.x = _local3;
            _local3 = (_local3 - _local5.width);
        }
    }
}
}
