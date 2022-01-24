package kabam.rotmg.account.core.view {
import com.company.assembleegameclient.account.ui.Frame;
import com.company.assembleegameclient.account.ui.TextInputField;
import com.company.util.EmailValidator;
import com.company.util.MoreObjectUtil;

import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;

import kabam.rotmg.account.core.Account;
import kabam.rotmg.account.web.model.AccountData;
import kabam.rotmg.appengine.api.AppEngineClient;
import kabam.rotmg.core.StaticInjectorContext;
import kabam.rotmg.pets.view.components.DialogCloseButton;
import kabam.rotmg.text.view.TextFieldDisplayConcrete;
import kabam.rotmg.text.view.stringBuilder.LineBuilder;

import org.osflash.signals.Signal;

public class ConfirmEmailModal extends Frame {


    public function ConfirmEmailModal() {
        register = new Signal(AccountData);
        super("VerifyWebAccountDialog.title", "RegisterWebAccountDialog.leftButton", "VerifyWebAccountDialog.button");
        this.positionAndStuff();
        removeChild(leftButton_);
        this.account = StaticInjectorContext.getInjector().getInstance(Account);
        this.createAssets();
        this.enableForTabBehavior();
        this.addEventListeners();
    }
    public var register:Signal;
    public var cancel:Signal;
    private var emailInput:TextInputField;
    private var account:Account;
    private var closeButton:DialogCloseButton;
    private var isKabam:Boolean = false;

    private function addEventListeners():void {
        rightButton_.addEventListener("click", this.onVerify);
        this.closeButton.addEventListener("click", this.onCancel);
    }

    private function createAssets():void {
        this.emailInput = new TextInputField("RegisterWebAccountDialog.email", false);
        if (EmailValidator.isValidEmail(this.account.getUserId())) {
            this.emailInput.inputText_.setText(this.account.getUserId());
        } else {
            this.emailInput.inputText_.setText("");
            this.isKabam = true;
        }
        addTextInputField(this.emailInput);
        this.closeButton = new DialogCloseButton();
        this.closeButton.y = -2;
        this.closeButton.x = w_ - this.closeButton.width - 8;
        addChild(this.closeButton);
    }

    private function enableForTabBehavior():void {
        this.emailInput.tabIndex = 1;
        rightButton_.tabIndex = 2;
        this.emailInput.tabEnabled = true;
        rightButton_.tabEnabled = true;
    }

    private function close():void {
        if (parent && parent.contains(this)) {
            parent.removeChild(this);
        }
    }

    private function onComplete(_arg_1:Boolean, _arg_2:*):void {
        if (_arg_1) {
            this.onSent();
        } else {
            this.onError(_arg_2);
        }
        rightButton_.addEventListener("click", this.onVerify);
    }

    private function onSent():void {
        var _local1:Account = StaticInjectorContext.getInjector().getInstance(Account);
        if (!this.isKabam) {
            _local1.updateUser(this.emailInput.text(), _local1.getPassword(), _local1.getToken(), _local1.getSecret());
        }
        removeChild(titleText_);
        titleText_ = new TextFieldDisplayConcrete().setSize(12).setColor(0xb3b3b3);
        titleText_.setStringBuilder(new LineBuilder().setParams("WebAccountDetailDialog.sent"));
        titleText_.filters = [new DropShadowFilter(0, 0, 0)];
        titleText_.x = 5;
        titleText_.y = 3;
        titleText_.filters = [new DropShadowFilter(0, 0, 0, 0.5, 12, 12)];
        addChild(titleText_);
    }

    private function onError(_arg_1:String):void {
        removeChild(titleText_);
        titleText_ = new TextFieldDisplayConcrete().setSize(12).setColor(16549442);
        titleText_.setStringBuilder(new LineBuilder().setParams(_arg_1));
        titleText_.filters = [new DropShadowFilter(0, 0, 0)];
        titleText_.x = 5;
        titleText_.y = 3;
        titleText_.filters = [new DropShadowFilter(0, 0, 0, 0.5, 12, 12)];
        addChild(titleText_);
    }

    private function isEmailValid():Boolean {
        var _local1:Boolean = EmailValidator.isValidEmail(this.emailInput.text());
        if (!_local1) {
            this.emailInput.setError("WebRegister.invalid_email_address");
        }
        return _local1;
    }

    private function positionAndStuff():void {
        this.x = WebMain.STAGE.stageWidth / 2 - this.w_ / 2;
        this.y = WebMain.STAGE.stageHeight / 2 - this.h_ / 2;
    }

    private function onCancel(_arg_1:MouseEvent):void {
        this.close();
    }

    private function onVerify(_arg_1:MouseEvent):void {
        var _local2:* = null;
        var _local3:* = null;
        if (this.isEmailValid()) {
            _local2 = StaticInjectorContext.getInjector().getInstance(AppEngineClient);
            _local2.complete.addOnce(this.onComplete);
            _local3 = {"newGuid": this.emailInput.text()};
            MoreObjectUtil.addToObject(_local3, this.account.getCredentials());
            _local2.sendRequest("account/changeEmail", _local3);
            rightButton_.removeEventListener("click", this.onVerify);
        }
    }
}
}
