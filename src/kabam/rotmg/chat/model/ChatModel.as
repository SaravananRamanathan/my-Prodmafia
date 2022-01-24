package kabam.rotmg.chat.model {
import com.company.assembleegameclient.parameters.Parameters;

import flash.geom.Rectangle;

public class ChatModel {


    public function ChatModel() {
        chatMessages = new Vector.<ChatMessage>();
        super();
        this.bounds = new Rectangle(0, 0, 10 * 60, 5 * 60);
        this.lineHeight = 20;
        this.setVisibleItemCount();
        this.storedItemCount = 150;
    }
    public var bounds:Rectangle;
    public var lineHeight:int;
    public var visibleItemCount:int;
    public var storedItemCount:int;
    public var chatMessages:Vector.<ChatMessage>;

    public function pushMessage(_arg_1:ChatMessage):void {
        this.chatMessages.push(_arg_1);
        if (this.chatMessages.length > this.storedItemCount) {
            this.chatMessages.shift();
        }
    }

    public function setVisibleItemCount():void {
        this.visibleItemCount = Parameters.data.chatLength;
    }
}
}
