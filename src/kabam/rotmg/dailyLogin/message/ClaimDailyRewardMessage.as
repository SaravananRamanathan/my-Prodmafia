package kabam.rotmg.dailyLogin.message {
import flash.utils.IDataOutput;

import kabam.rotmg.messaging.impl.outgoing.OutgoingMessage;

public class ClaimDailyRewardMessage extends OutgoingMessage {


    public function ClaimDailyRewardMessage(_arg_1:uint, _arg_2:Function) {
        super(_arg_1, _arg_2);
    }
    public var claimKey:String;
    public var type_:String;

    override public function writeToOutput(_arg_1:IDataOutput):void {
        _arg_1.writeUTF(this.claimKey);
        _arg_1.writeUTF(this.type_);
    }

    override public function toString():String {
        return formatToString("CLAIMDAILYREWARD", "claimKey", "type_");
    }
}
}
