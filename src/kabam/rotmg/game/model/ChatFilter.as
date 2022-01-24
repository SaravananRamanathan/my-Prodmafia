package kabam.rotmg.game.model {
public class ChatFilter {


    public function ChatFilter() {
        super();
    }

    public function guestChatFilter(_arg_1:String):Boolean {
        var _local2:Boolean = false;
        if (_arg_1 == null) {
            return true;
        }
        if (_arg_1 == "" || _arg_1 == "*Help*" || _arg_1 == "*Error*" || _arg_1 == "*Client*") {
            _local2 = true;
        }
        if (_arg_1.charAt(0) == "#") {
            _local2 = true;
        }
        if (_arg_1.charAt(0) == "@") {
            _local2 = true;
        }
        return _local2;
    }
}
}
