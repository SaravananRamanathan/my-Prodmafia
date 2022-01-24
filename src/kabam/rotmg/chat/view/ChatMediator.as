package kabam.rotmg.chat.view {
import com.company.assembleegameclient.parameters.Parameters;

import flash.display.Sprite;
import flash.display.Stage;
import flash.events.Event;
import flash.events.KeyboardEvent;

import kabam.rotmg.account.core.Account;
import kabam.rotmg.account.core.signals.RegisterSignal;
import kabam.rotmg.account.core.view.RegisterPromptDialog;
import kabam.rotmg.account.web.model.AccountData;
import kabam.rotmg.chat.control.ScrollListSignal;
import kabam.rotmg.chat.control.ShowChatInputSignal;
import kabam.rotmg.chat.model.ChatModel;
import kabam.rotmg.chat.model.ChatShortcutModel;
import kabam.rotmg.chat.model.TellModel;
import kabam.rotmg.dialogs.control.CloseDialogsSignal;
import kabam.rotmg.dialogs.control.OpenDialogSignal;
import kabam.rotmg.ui.model.HUDModel;

import robotlegs.bender.bundles.mvcs.Mediator;

public class ChatMediator extends Mediator {

    private static var SCROLL_BUFFER_SIZE:int = 5;

    public function ChatMediator() {
        super();
    }
    [Inject]
    public var view:Chat;
    [Inject]
    public var model:ChatModel;
    [Inject]
    public var account:Account;
    [Inject]
    public var shortcuts:ChatShortcutModel;
    [Inject]
    public var showChatInput:ShowChatInputSignal;
    [Inject]
    public var scrollList:ScrollListSignal;
    [Inject]
    public var tellModel:TellModel;
    [Inject]
    public var hudModel:HUDModel;
    [Inject]
    public var openDialog:OpenDialogSignal;
    [Inject]
    public var closeDialog:CloseDialogsSignal;
    [Inject]
    public var register:RegisterSignal;
    private var stage:Stage;
    private var scrollDirection:int;
    private var scrollBuffer:int;
    private var listenersAdded:Boolean = false;

    override public function initialize():void {
        this.view.x = this.model.bounds.left;
        this.view.y = this.model.bounds.top;
        this.view.setup(this.model, this.account.isRegistered());
        this.stage = this.view.stage;
        this.addListeners();
        this.showChatInput.add(this.onShowChatInput);
        this.openDialog.add(this.onOpenDialog);
        this.closeDialog.add(this.onCloseDialog);
        this.register.add(this.onRegister);
    }

    override public function destroy():void {
        this.removeListeners();
        this.showChatInput.remove(this.onShowChatInput);
        this.openDialog.remove(this.onOpenDialog);
        this.closeDialog.remove(this.onCloseDialog);
        this.register.remove(this.onRegister);
        this.stage = null;
    }

    private function onOpenDialog(_arg_1:Sprite):void {
        this.removeListeners();
    }

    private function onCloseDialog():void {
        this.addListeners();
    }

    private function onShowChatInput(_arg_1:Boolean, _arg_2:String):void {
        if (_arg_1) {
            this.listenersAdded = false;
        } else {
            this.addListeners();
        }
    }

    private function onRegister(_arg_1:AccountData):void {
        if (_arg_1.error == null) {
            this.view.removeRegisterBlock();
        }
    }

    private function addListeners():void {
        if (!this.listenersAdded) {
            this.stage.addEventListener("keyDown", this.onKeyDown);
            this.stage.addEventListener("keyUp", this.onKeyUp);
            this.listenersAdded = true;
        }
    }

    private function removeListeners():void {
        if (this.listenersAdded) {
            this.stage.removeEventListener("keyDown", this.onKeyDown);
            this.stage.removeEventListener("keyUp", this.onKeyUp);
            this.stage.removeEventListener("enterFrame", this.iterate);
            this.listenersAdded = false;
        }
    }

    private function setupScroll(_arg_1:int):void {
        this.scrollDirection = _arg_1;
        this.scrollList.dispatch(_arg_1);
        this.scrollBuffer = 0;
        this.view.addEventListener("enterFrame", this.iterate);
    }

    private function checkForInputTrigger(_arg_1:uint):void {
        if (this.stage.focus == null || _arg_1 == this.shortcuts.getTellShortcut()) {
            if (_arg_1 == this.shortcuts.getCommandShortcut()) {
                this.triggerOrPromptRegistration("/");
            } else if (_arg_1 == this.shortcuts.getChatShortcut()) {
                this.triggerOrPromptRegistration("");
            } else if (_arg_1 == this.shortcuts.getGuildShortcut()) {
                this.triggerOrPromptRegistration("/g ");
            } else if (_arg_1 == this.shortcuts.getTellShortcut()) {
                this.triggerOrPromptRegistration(("/tell ") + this.tellModel.getNext() + " ");
            }
        }
    }

    private function triggerOrPromptRegistration(_arg_1:String):void {
        if (this.account.isRegistered()) {
            this.showChatInput.dispatch(true, _arg_1);
        } else if (this.hudModel.gameSprite != null && this.hudModel.gameSprite.isSafeMap) {
            this.openDialog.dispatch(new RegisterPromptDialog("chat.registertoChat"));
        }
    }

    private function onKeyDown(_arg_1:KeyboardEvent):void {
        if (_arg_1.keyCode == this.shortcuts.getScrollUp()) {
            this.setupScroll(-1);
        } else if (_arg_1.keyCode == this.shortcuts.getScrollDown()) {
            this.setupScroll(1);
        }
    }

    private function iterate(_arg_1:Event):void {
        var _local2:Number = this.scrollBuffer;
        this.scrollBuffer++;
        if (_local2 >= SCROLL_BUFFER_SIZE) {
            this.scrollList.dispatch(this.scrollDirection);
        }
    }

    private function onKeyUp(_arg_1:KeyboardEvent):void {
        if (this.listenersAdded) {
            this.checkForInputTrigger(_arg_1.keyCode);
        }
        if (_arg_1.keyCode == this.shortcuts.getScrollUp() || _arg_1.keyCode == this.shortcuts.getScrollDown()) {
            this.view.removeEventListener("enterFrame", this.iterate);
        }
    }
}
}
