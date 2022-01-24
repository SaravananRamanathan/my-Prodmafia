package kabam.rotmg.account.web.view {
import kabam.lib.tasks.Task;
import kabam.rotmg.account.web.model.ChangePasswordData;
import kabam.rotmg.account.web.signals.WebChangePasswordSignal;
import kabam.rotmg.core.signals.TaskErrorSignal;
import kabam.rotmg.dialogs.control.OpenDialogSignal;

import robotlegs.bender.bundles.mvcs.Mediator;

public class WebChangePasswordMediator extends Mediator {


    public function WebChangePasswordMediator() {
        super();
    }
    [Inject]
    public var view:WebChangePasswordDialog;
    [Inject]
    public var change:WebChangePasswordSignal;
    [Inject]
    public var openDialog:OpenDialogSignal;
    [Inject]
    public var loginError:TaskErrorSignal;

    override public function initialize():void {
        this.view.change.add(this.onChange);
        this.view.cancel.add(this.onCancel);
        this.loginError.add(this.onError);
    }

    override public function destroy():void {
        this.view.change.remove(this.onChange);
        this.view.cancel.remove(this.onCancel);
        this.loginError.remove(this.onError);
    }

    private function onCancel():void {
        this.openDialog.dispatch(new WebAccountDetailDialog());
    }

    private function onChange():void {
        var _local1:* = null;
        if (this.isCurrentPasswordValid() && this.isNewPasswordValid() && this.isNewPasswordVerified()) {
            this.view.disable();
            this.view.clearError();
            _local1 = new ChangePasswordData();
            _local1.currentPassword = this.view.password_.text();
            _local1.newPassword = this.view.newPassword_.text();
            this.change.dispatch(_local1);
        }
    }

    private function isCurrentPasswordValid():Boolean {
        var _local1:* = this.view.password_.text().length >= 5;
        if (!_local1) {
            this.view.password_.setError("WebChangePasswordDialog.Incorrect");
        }
        return _local1;
    }

    private function isNewPasswordValid():Boolean {
        var _local1:* = this.view.newPassword_.text().length >= 10;
        if (!_local1) {
            this.view.newPassword_.setError("RegisterWebAccountDialog.shortError");
        }
        return _local1;
    }

    private function isNewPasswordVerified():Boolean {
        var _local1:* = this.view.newPassword_.text() == this.view.retypeNewPassword_.text();
        if (!_local1) {
            this.view.retypeNewPassword_.setError("RegisterWebAccountDialog.matchError");
        }
        return _local1;
    }

    private function onError(_arg_1:Task):void {
        this.view.setError(_arg_1.error);
        this.view.enable();
    }
}
}
