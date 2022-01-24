package kabam.rotmg.account.web.view {
import com.company.assembleegameclient.account.ui.Frame;
import com.company.assembleegameclient.account.ui.TextInputField;

import org.osflash.signals.Signal;
import org.osflash.signals.natives.NativeMappedSignal;

public class WebChangePasswordDialogForced extends Frame {


    public function WebChangePasswordDialogForced() {
        super("WebChangePasswordDialog.title", "", "WebChangePasswordDialog.rightButton", "/changePassword");
        this.password_ = new TextInputField("WebChangePasswordDialog.password", true);
        addTextInputField(this.password_);
        this.newPassword_ = new TextInputField("WebChangePasswordDialog.newPassword", true);
        addTextInputField(this.newPassword_);
        this.retypeNewPassword_ = new TextInputField("WebChangePasswordDialog.retypePassword", true);
        addTextInputField(this.retypeNewPassword_);
        this.change = new NativeMappedSignal(rightButton_, "click");
    }
    public var cancel:Signal;
    public var change:Signal;
    public var password_:TextInputField;
    public var newPassword_:TextInputField;
    public var retypeNewPassword_:TextInputField;

    public function setError(_arg_1:String):void {
        this.password_.setError(_arg_1);
    }

    public function clearError():void {
        this.password_.clearError();
        this.retypeNewPassword_.clearError();
        this.newPassword_.clearError();
    }

    private function isCurrentPasswordValid():Boolean {
        var _local1:* = this.password_.text().length >= 5;
        if (!_local1) {
            this.password_.setError("WebChangePasswordDialog.Incorrect");
        }
        return _local1;
    }

    private function isNewPasswordValid():Boolean {
        var _local2:* = null;
        var _local1:int = 0;
        var _local3:* = this.newPassword_.text().length >= 10;
        if (!_local3) {
            this.newPassword_.setError("LinkWebAccountDialog.shortError");
        } else {
            _local2 = this.newPassword_.text();
            _local1 = 0;
            while (_local1 < _local2.length - 2) {
                if (_local2.charAt(_local1) == _local2.charAt(_local1 + 1) && _local2.charAt(_local1 + 1) == _local2.charAt(_local1 + 2)) {
                    this.newPassword_.setError("LinkWebAccountDialog.shortError");
                    _local3 = false;
                }
                _local1++;
            }
        }
        return _local3;
    }

    private function isNewPasswordVerified():Boolean {
        var _local1:* = this.newPassword_.text() == this.retypeNewPassword_.text();
        if (!_local1) {
            this.retypeNewPassword_.setError("LinkWebAccountDialog.matchError");
        }
        return _local1;
    }
}
}
