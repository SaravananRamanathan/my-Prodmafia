package kabam.rotmg.chat.view {
import com.company.assembleegameclient.parameters.Parameters;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.filters.GlowFilter;
import flash.text.TextField;

import kabam.rotmg.chat.model.ChatModel;

import org.osflash.signals.Signal;

public class ChatInput extends Sprite {


    public const message:Signal = new Signal(String);

    public const close:Signal = new Signal();

    public function ChatInput() {
        super();
        visible = false;
        tabEnabled = false;
        this.enteredText = false;
    }
    public var input:TextField;
    private var enteredText:Boolean;
    private var lastInput:String = "";

    public function setup(_arg_1:ChatModel, _arg_2:TextField):void {
        var _local3:* = _arg_2;
        this.input = _local3;
        addChild(_local3);
        _arg_2.width = _arg_1.bounds.width - 2;
        _arg_2.height = _arg_1.lineHeight;
        _arg_2.y = _arg_1.bounds.height - _arg_1.lineHeight;
    }

    public function activate(_arg_1:String, _arg_2:Boolean):void {
        this.enteredText = false;
        if (_arg_1 != null) {
            this.input.text = _arg_1;
        }
        var _local3:int = !!_arg_1 ? _arg_1.length : 0;
        this.input.setSelection(_local3, _local3);
        if (_arg_2) {
            this.activateEnabled();
        } else {
            this.activateDisabled();
        }
        visible = true;
    }

    public function deactivate():void {
        this.enteredText = false;
        removeEventListener("keyUp", this.onKeyUp);
        stage.removeEventListener("keyUp", this.onTextChange);
        visible = false;
    }

    public function hasEnteredText():Boolean {
        return this.enteredText;
    }

    private function activateEnabled():void {
        this.input.type = "input";
        this.input.border = true;
        this.input.selectable = true;
        this.input.maxChars = 128;
        this.input.borderColor = 0xffffff;
        this.input.height = 18;
        this.input.filters = [new GlowFilter(0, 1, 3, 3, 2, 1)];
        addEventListener("keyUp", this.onKeyUp);
        stage.addEventListener("keyUp", this.onTextChange);
    }

    private function activateDisabled():void {
        this.input.type = "dynamic";
        this.input.border = false;
        this.input.selectable = false;
        this.input.filters = [new GlowFilter(0, 1, 3, 3, 2, 1)];
        this.input.height = 18;
        removeEventListener("keyUp", this.onKeyUp);
        stage.removeEventListener("keyUp", this.onTextChange);
    }

    private function onTextChange(_arg_1:Event):void {
        this.enteredText = true;
    }

    private function onKeyUp(_arg_1:KeyboardEvent):void {
        var _local2:int = 0;
        if (_arg_1.keyCode == Parameters.data.chat) {
            if (this.input.text != "") {
                this.message.dispatch(this.input.text);
            } else {
                this.close.dispatch();
            }
            this.lastInput = this.input.text;
            _arg_1.stopImmediatePropagation();
        }
        if (_arg_1.keyCode == Parameters.data.chatCommand) {
            if (this.input.text != "")
                return;
            this.input.text = this.lastInput;
            _local2 = this.lastInput.length;
            this.input.setSelection(_local2, _local2);
            _arg_1.stopImmediatePropagation();
        }
    }
}
}
