package kabam.rotmg.chat.model {
public class TellModel {


    public function TellModel() {
        pastRecipients = new Vector.<String>();
        super();
    }
    private var pastRecipients:Vector.<String>;
    private var index:int = 0;

    public function push(_arg_1:String):void {
        var _local2:int = this.pastRecipients.indexOf(_arg_1);
        if (_local2 != -1) {
            this.pastRecipients.splice(_local2, 1);
        }
        this.pastRecipients.unshift(_arg_1);
    }

    public function getNext():String {
        if (this.pastRecipients.length > 0) {
            this.index = (this.index + 1) % this.pastRecipients.length;
            return this.pastRecipients[this.index];
        }
        return "";
    }

    public function resetRecipients():void {
        this.index = -1;
    }

    public function clearRecipients():void {
        this.pastRecipients = new Vector.<String>();
        this.index = 0;
    }
}
}
