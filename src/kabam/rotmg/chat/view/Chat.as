package kabam.rotmg.chat.view {
import flash.display.Sprite;
import flash.events.Event;

import kabam.rotmg.chat.model.ChatModel;

public class Chat extends Sprite {


    public function Chat() {
        super();
        mouseEnabled = true;
        mouseChildren = true;
        tabEnabled = false;
        this.list = new ChatList();
        addChild(this.list);
    }
    public var list:ChatList;
    public var model:ChatModel;
    public var input:ChatInput;
    private var notAllowed:ChatInputNotAllowed;

    public function setup(_arg_1:ChatModel, _arg_2:Boolean):void {
        this.model = _arg_1;
        this.y = 600 - _arg_1.bounds.height;
        this.list.y = _arg_1.bounds.height;
        if (_arg_2) {
            this.addChatInput();
        } else {
            this.addInputNotAllowed();
        }
        stage.dispatchEvent(new Event("resize"));
    }

    public function removeRegisterBlock():void {
        if (this.notAllowed != null && contains(this.notAllowed)) {
            removeChild(this.notAllowed);
        }
        if (this.input == null || !contains(this.input)) {
            this.addChatInput();
        }
    }

    private function addChatInput():void {
        this.input = new ChatInput();
        addChild(this.input);
    }

    private function addInputNotAllowed():void {
        this.notAllowed = new ChatInputNotAllowed();
        addChild(this.notAllowed);
        this.list.y = this.model.bounds.height - this.model.lineHeight;
    }
}
}
