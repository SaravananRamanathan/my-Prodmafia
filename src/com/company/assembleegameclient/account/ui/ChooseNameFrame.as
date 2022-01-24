package com.company.assembleegameclient.account.ui {
import com.company.assembleegameclient.game.AGameSprite;

import flash.events.MouseEvent;

import org.osflash.signals.Signal;

public class ChooseNameFrame extends Frame {


    public const cancel:Signal = new Signal();

    public const choose:Signal = new Signal(String);

    public function ChooseNameFrame(_arg_1:AGameSprite, _arg_2:Boolean) {
        super("NewChooseNameFrame.title", "Frame.cancel", "NewChooseNameFrame.rightButton", "/chooseName");
        this.gameSprite = _arg_1;
        this.isPurchase = _arg_2;
        this.nameInput = new TextInputField("NewChooseNameFrame.name", false);
        this.nameInput.inputText_.restrict = "A-Za-z";
        this.nameInput.inputText_.maxChars = 10;
        addTextInputField(this.nameInput);
        addPlainText("Frame.maxChar", {"maxChars": 10});
        addPlainText("Frame.restrictChar");
        addPlainText("NewChooseNameFrame.warning");
        leftButton_.addEventListener("click", this.onCancel);
        rightButton_.addEventListener("click", this.onChoose);
    }
    public var gameSprite:AGameSprite;
    public var isPurchase:Boolean;
    private var nameInput:TextInputField;

    public function setError(_arg_1:String):void {
        this.nameInput.setError(_arg_1);
    }

    private function onCancel(_arg_1:MouseEvent):void {
        this.cancel.dispatch();
    }

    private function onChoose(_arg_1:MouseEvent):void {
        this.choose.dispatch(this.nameInput.text());
        disable();
    }
}
}
