package kabam.rotmg.ui.view {
import com.company.assembleegameclient.ui.dialogs.Dialog;

import flash.events.Event;
import flash.filters.DropShadowFilter;

import kabam.rotmg.account.ui.components.DateField;
import kabam.rotmg.text.view.TextFieldDisplayConcrete;
import kabam.rotmg.text.view.stringBuilder.LineBuilder;

import org.osflash.signals.Signal;

public class AgeVerificationDialog extends Dialog {

    private static const WIDTH:int = 300;


    private const DEFAULT_FILTER_0:DropShadowFilter = new DropShadowFilter(0, 0, 0, 1, 6, 6, 1);

    private const DEFAULT_FILTER_1:DropShadowFilter = new DropShadowFilter(0, 0, 0, 0.5, 12, 12);

    private const BIRTH_DATE_BELOW_MINIMUM_ERROR:String = "AgeVerificationDialog.tooYoung";

    private const BIRTH_DATE_INVALID_ERROR:String = "AgeVerificationDialog.invalidBirthDate";

    private const MINIMUM_AGE:uint = 16;

    public const response:Signal = new Signal(Boolean);

    public function AgeVerificationDialog() {
        super("AgeVerificationDialog.title", "", "AgeVerificationDialog.left", "AgeVerificationDialog.right", "/ageVerificationDialog");
        addEventListener("dialogLeftButton", this.onCancel);
        addEventListener("dialogRightButton", this.onVerify);
    }
    private var ageVerificationField:DateField;
    private var errorLabel:TextFieldDisplayConcrete;

    override protected function makeUIAndAdd():void {
        this.makeAgeVerificationAndErrorLabel();
        this.addChildren();
    }

    override protected function initText(_arg_1:String):void {
        textText_ = new TextFieldDisplayConcrete().setSize(14).setColor(0xb3b3b3);
        textText_.setTextWidth(260);
        textText_.x = 20;
        textText_.setMultiLine(true).setWordWrap(true).setHTML(true);
        textText_.setAutoSize("left");
        textText_.mouseEnabled = true;
        textText_.filters = [DEFAULT_FILTER_0];
        this.setText();
    }

    override protected function drawAdditionalUI():void {
        this.ageVerificationField.y = textText_.getBounds(box_).bottom + 8;
        this.ageVerificationField.x = 20;
        this.errorLabel.y = this.ageVerificationField.y + this.ageVerificationField.height + 8;
        this.errorLabel.x = 20;
    }

    private function makeAgeVerificationAndErrorLabel():void {
        this.makeAgeVerificationField();
        this.makeErrorLabel();
    }

    private function addChildren():void {
        uiWaiter.pushArgs(this.ageVerificationField.getTextChanged());
        box_.addChild(this.ageVerificationField);
        box_.addChild(this.errorLabel);
    }

    private function setText():void {
        textText_.setStringBuilder(new LineBuilder().setParams("AgeVerificationDialog.text", {
            "tou": "<font color=\"#7777EE\"><a href=\"http://legal.decagames.com/tos/\" target=\"_blank\">",
            "_tou": "</a></font>",
            "policy": "<font color=\"#7777EE\"><a href=\"http://legal.decagames.com/privacy/\" target=\"_blank\">",
            "_policy": "</a></font>"
        }));
    }

    private function makeAgeVerificationField():void {
        this.ageVerificationField = new DateField();
        this.ageVerificationField.setTitle("WebRegister.birthday");
    }

    private function makeErrorLabel():void {
        this.errorLabel = new TextFieldDisplayConcrete().setSize(12).setColor(16549442);
        this.errorLabel.setMultiLine(true);
        this.errorLabel.filters = [DEFAULT_FILTER_1];
    }

    private function getPlayerAge():uint {
        var _local3:Date = new Date(this.getBirthDate());
        var _local2:Date = new Date();
        var _local1:uint = _local2.fullYear - _local3.fullYear;
        if (_local3.month > _local2.month || _local3.month == _local2.month && _local3.date > _local2.date) {
            _local1--;
        }
        return _local1;
    }

    private function getBirthDate():Number {
        return Date.parse(this.ageVerificationField.getDate());
    }

    private function onCancel(_arg_1:Event):void {
        this.response.dispatch(false);
    }

    private function onVerify(_arg_1:Event):void {
        var _local4:Boolean = false;
        var _local2:uint = this.getPlayerAge();
        var _local3:String = "";
        if (!this.ageVerificationField.isValidDate()) {
            _local3 = "AgeVerificationDialog.invalidBirthDate";
            _local4 = true;
        } else if (_local2 < 16 && !_local4) {
            _local3 = "AgeVerificationDialog.tooYoung";
            _local4 = true;
        } else {
            _local3 = "";
            _local4 = false;
            this.response.dispatch(true);
        }
        this.errorLabel.setStringBuilder(new LineBuilder().setParams(_local3));
        this.ageVerificationField.setErrorHighlight(_local4);
        drawButtonsAndBackground();
    }
}
}
