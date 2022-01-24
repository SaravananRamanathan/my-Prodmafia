package kabam.rotmg.dailyLogin.message {
import flash.utils.IDataInput;

import kabam.rotmg.messaging.impl.incoming.IncomingMessage;

public class ClaimDailyRewardResponse extends IncomingMessage {


    public function ClaimDailyRewardResponse(_arg_1:uint, _arg_2:Function) {
        super(_arg_1, _arg_2);
    }
    public var itemId:int;
    public var quantity:int;
    public var gold:int;

    override public function parseFromInput(_arg_1:IDataInput):void {
        this.itemId = _arg_1.readInt();
        this.quantity = _arg_1.readInt();
        this.gold = _arg_1.readInt();
    }

    override public function toString():String {
        return formatToString("CLAIMDAILYREWARDRESPONSE", "itemId", "quantity", "gold");
    }
}
}
