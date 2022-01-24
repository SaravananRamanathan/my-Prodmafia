package kabam.rotmg.account.securityQuestions.view {
import com.company.assembleegameclient.account.ui.Frame;
import com.company.assembleegameclient.account.ui.TextInputField;

import kabam.rotmg.text.view.stringBuilder.LineBuilder;

public class SecurityQuestionsDialog extends Frame {


    private const minQuestionLength:int = 3;

    private const maxQuestionLength:int = 50;

    public function SecurityQuestionsDialog(_arg_1:Array, _arg_2:Array) {
        errors = [];
        this.questionsList = _arg_1;
        super("SecurityQuestionsDialog.title", "Cancel", "SecurityQuestionsDialog.save");
        this.createAssets();
        if (_arg_1.length == _arg_2.length) {
            this.updateAnswers(_arg_2);
        }
    }
    private var errors:Array;
    private var fields:Array;
    private var questionsList:Array;

    override public function disable():void {
        super.disable();
        titleText_.setStringBuilder(new LineBuilder().setParams("SecurityQuestionsDialog.savingInProgress"));
    }

    public function updateAnswers(_arg_1:Array):void {
        var _local3:* = null;
        var _local2:int = 1;
        var _local5:int = 0;
        var _local4:* = this.fields;
        for each(_local3 in this.fields) {
            _local3.inputText_.text = _arg_1[_local2 - 1];
            _local2++;
        }
    }

    public function clearErrors():void {
        var _local1:* = null;
        titleText_.setStringBuilder(new LineBuilder().setParams("SecurityQuestionsDialog.title"));
        titleText_.setColor(0xb3b3b3);
        this.errors = [];
        var _local3:int = 0;
        var _local2:* = this.fields;
        for each(_local1 in this.fields) {
            _local1.setErrorHighlight(false);
        }
    }

    public function areQuestionsValid():Boolean {
        var _local1:* = null;
        var _local3:int = 0;
        var _local2:* = this.fields;
        for each(_local1 in this.fields) {
            if (_local1.inputText_.length < 3) {
                this.errors.push("SecurityQuestionsDialog.tooShort");
                _local1.setErrorHighlight(true);
                return false;
            }
            if (_local1.inputText_.length > 50) {
                this.errors.push("SecurityQuestionsDialog.tooLong");
                _local1.setErrorHighlight(true);
                return false;
            }
        }
        return true;
    }

    public function displayErrorText():void {
        var _local1:String = this.errors.length == 1 ? this.errors[0] : "WebRegister.multiple_errors_message";
        this.setError(_local1);
    }

    public function dispose():void {
        this.errors = null;
        this.fields = null;
        this.questionsList = null;
    }

    public function getAnswers():Array {
        var _local2:* = null;
        var _local1:* = [];
        var _local4:int = 0;
        var _local3:* = this.fields;
        for each(_local2 in this.fields) {
            _local1.push(_local2.inputText_.text);
        }
        return _local1;
    }

    public function setError(_arg_1:String):void {
        titleText_.setStringBuilder(new LineBuilder().setParams(_arg_1, {"min": 3}));
        titleText_.setColor(16549442);
    }

    private function createAssets():void {
        var _local2:* = null;
        var _local1:* = null;
        var _local3:int = 1;
        this.fields = [];
        var _local5:int = 0;
        var _local4:* = this.questionsList;
        for each(_local2 in this.questionsList) {
            _local1 = new TextInputField(_local2, false, 4 * 60);
            _local1.nameText_.setTextWidth(4 * 60);
            _local1.nameText_.setSize(12);
            _local1.nameText_.setWordWrap(true);
            _local1.nameText_.setMultiLine(true);
            addTextInputField(_local1);
            _local1.inputText_.tabEnabled = true;
            _local1.inputText_.tabIndex = _local3;
            _local1.inputText_.maxChars = 50;
            _local3++;
            this.fields.push(_local1);
        }
        rightButton_.tabIndex = _local3 + 1;
        rightButton_.tabEnabled = true;
    }
}
}
