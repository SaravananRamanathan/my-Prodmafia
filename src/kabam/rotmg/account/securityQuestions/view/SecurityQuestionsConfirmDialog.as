package kabam.rotmg.account.securityQuestions.view {
import com.company.assembleegameclient.account.ui.Frame;

import flash.filters.DropShadowFilter;

import kabam.rotmg.text.view.TextFieldDisplayConcrete;
import kabam.rotmg.text.view.stringBuilder.LineBuilder;

public class SecurityQuestionsConfirmDialog extends Frame {


    public function SecurityQuestionsConfirmDialog(_arg_1:Array, _arg_2:Array) {
        this.questionsList = _arg_1;
        this.answerList = _arg_2;
        super("SecurityQuestionsConfirmDialog.title", "SecurityQuestionsConfirmDialog.leftButton", "SecurityQuestionsConfirmDialog.rightButton");
        this.createAssets();
    }
    private var infoText:TextFieldDisplayConcrete;
    private var questionsList:Array;
    private var answerList:Array;

    public function dispose():void {
    }

    public function setInProgressMessage():void {
        titleText_.setStringBuilder(new LineBuilder().setParams("SecurityQuestionsDialog.savingInProgress"));
        titleText_.setColor(0xb3b3b3);
    }

    public function setError(_arg_1:String):void {
        titleText_.setStringBuilder(new LineBuilder().setParams(_arg_1));
        titleText_.setColor(16549442);
    }

    private function createAssets():void {
        var _local2:int = 0;
        var _local1:* = null;
        var _local3:String = "";
        var _local5:int = 0;
        var _local4:* = this.questionsList;
        for each(_local1 in this.questionsList) {
            _local3 = _local3 + ("<font color=\"#7777EE\">" + LineBuilder.getLocalizedStringFromKey(_local1) + "</font>\n");
            _local3 = _local3 + (this.answerList[_local2] + "\n\n");
            _local2++;
        }
        _local3 = _local3 + LineBuilder.getLocalizedStringFromKey("SecurityQuestionsConfirmDialog.text");
        this.infoText = new TextFieldDisplayConcrete();
        this.infoText.setStringBuilder(new LineBuilder().setParams(_local3));
        this.infoText.setSize(12).setColor(0xb3b3b3).setBold(true);
        this.infoText.setTextWidth(250);
        this.infoText.setMultiLine(true).setWordWrap(true).setHTML(true);
        this.infoText.filters = [new DropShadowFilter(0, 0, 0)];
        addChild(this.infoText);
        this.infoText.y = 40;
        this.infoText.x = 17;
        h_ = 280;
    }
}
}
