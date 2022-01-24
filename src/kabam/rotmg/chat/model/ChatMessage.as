package kabam.rotmg.chat.model {
public class ChatMessage {


    public static function make(_arg_1:String, _arg_2:String, _arg_3:int = -1, _arg_4:int = -1, _arg_5:String = "", _arg_6:Boolean = false, _arg_7:Object = null, _arg_8:Boolean = false, _arg_9:Boolean = false, _arg_10:int = 0):ChatMessage {
        var _local11:ChatMessage = new ChatMessage();
        _local11.name = _arg_1;
        _local11.text = _arg_2;
        _local11.objectId = _arg_3;
        _local11.numStars = _arg_4;
        _local11.recipient = _arg_5;
        _local11.isToMe = _arg_6;
        _local11.isWhisper = _arg_8;
        _local11.isFromSupporter = _arg_9;
        _local11.tokens = _arg_7 == null ? {} : _arg_7;
        _local11.starBg = _arg_10;
        return _local11;
    }

    public function ChatMessage() {
        super();
    }
    public var name:String;
    public var text:String;
    public var objectId:int = -1;
    public var numStars:int = -1;
    public var recipient:String = "";
    public var isToMe:Boolean;
    public var isWhisper:Boolean;
    public var tokens:Object;
    public var isFromSupporter:Boolean;
    public var starBg:int;
}
}
