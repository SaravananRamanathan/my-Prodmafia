package kabam.rotmg.account.securityQuestions.mediators {
import com.company.assembleegameclient.parameters.Parameters;
import com.hurlant.util.Base64;

import flash.events.MouseEvent;

import kabam.lib.tasks.Task;
import kabam.rotmg.account.securityQuestions.data.SecurityQuestionsData;
import kabam.rotmg.account.securityQuestions.data.SecurityQuestionsModel;
import kabam.rotmg.account.securityQuestions.signals.SaveSecurityQuestionsSignal;
import kabam.rotmg.account.securityQuestions.view.SecurityQuestionsConfirmDialog;
import kabam.rotmg.account.securityQuestions.view.SecurityQuestionsDialog;
import kabam.rotmg.account.securityQuestions.view.SecurityQuestionsInfoDialog;
import kabam.rotmg.core.signals.TaskErrorSignal;
import kabam.rotmg.dialogs.control.CloseDialogsSignal;
import kabam.rotmg.dialogs.control.OpenDialogSignal;

import robotlegs.bender.bundles.mvcs.Mediator;

public class SecurityQuestionsMediator extends Mediator {


    public function SecurityQuestionsMediator() {
        super();
    }
    [Inject]
    public var view:SecurityQuestionsDialog;
    [Inject]
    public var infoView:SecurityQuestionsInfoDialog;
    [Inject]
    public var confirmationView:SecurityQuestionsConfirmDialog;
    [Inject]
    public var saveQuestions:SaveSecurityQuestionsSignal;
    [Inject]
    public var taskError:TaskErrorSignal;
    [Inject]
    public var openDialog:OpenDialogSignal;
    [Inject]
    public var closeDialogs:CloseDialogsSignal;
    [Inject]
    public var securityQuestionsModel:SecurityQuestionsModel;

    override public function initialize():void {
        this.view.leftButton_.addEventListener("click", this.onCloseClick);
        this.view.rightButton_.addEventListener("click", this.onShowConfirmationClick);
        this.infoView.leftButton_.addEventListener("click", this.onCloseClick);
        this.infoView.rightButton_.addEventListener("click", this.onContinueClick);
        this.confirmationView.leftButton_.addEventListener("click", this.onBackClick);
        this.confirmationView.rightButton_.addEventListener("click", this.onSaveQuestions);
        this.taskError.add(this.onTaskError);
    }

    override public function destroy():void {
        this.taskError.remove(this.onTaskError);
        this.view.rightButton_.removeEventListener("click", this.onShowConfirmationClick);
        this.infoView.leftButton_.removeEventListener("click", this.onCloseClick);
        this.infoView.rightButton_.removeEventListener("click", this.onContinueClick);
        this.confirmationView.leftButton_.removeEventListener("click", this.onBackClick);
        this.confirmationView.rightButton_.removeEventListener("click", this.onSaveQuestions);
        this.view.dispose();
        this.infoView.dispose();
        this.confirmationView.dispose();
    }

    private function onTaskError(_arg_1:Task):void {
        this.confirmationView.enable();
        this.confirmationView.setError(_arg_1.error);
    }

    private function onCloseClick(_arg_1:MouseEvent):void {
        securityQuestionsModel.showSecurityQuestionsOnStartup = false;
        Parameters.ignoringSecurityQuestions = true;
        this.closeDialogs.dispatch();
    }

    private function onShowConfirmationClick(_arg_1:MouseEvent):void {
        this.view.clearErrors();
        if (!this.view.areQuestionsValid()) {
            this.view.displayErrorText();
        } else {
            this.securityQuestionsModel.securityQuestionsAnswers = this.view.getAnswers();
            this.closeDialogs.dispatch();
            this.openDialog.dispatch(new SecurityQuestionsConfirmDialog(this.securityQuestionsModel.securityQuestionsList, this.securityQuestionsModel.securityQuestionsAnswers));
        }
    }

    private function onBackClick(_arg_1:MouseEvent):void {
        this.closeDialogs.dispatch();
        this.openDialog.dispatch(new SecurityQuestionsDialog(this.securityQuestionsModel.securityQuestionsList, this.securityQuestionsModel.securityQuestionsAnswers));
    }

    private function onContinueClick(_arg_1:MouseEvent):void {
        this.closeDialogs.dispatch();
        this.openDialog.dispatch(new SecurityQuestionsDialog(this.securityQuestionsModel.securityQuestionsList, []));
    }

    private function onSaveQuestions(_arg_1:MouseEvent):void {
        var _local3:* = null;
        this.confirmationView.disable();
        this.confirmationView.setInProgressMessage();
        var _local2:SecurityQuestionsData = new SecurityQuestionsData();
        _local2.answers = [];
        var _local5:int = 0;
        var _local4:* = this.securityQuestionsModel.securityQuestionsAnswers;
        for each(_local3 in this.securityQuestionsModel.securityQuestionsAnswers) {
            _local2.answers.push(Base64.encode(_local3));
        }
        this.saveQuestions.dispatch(_local2);
    }
}
}
