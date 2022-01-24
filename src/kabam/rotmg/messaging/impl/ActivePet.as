package kabam.rotmg.messaging.impl {
import flash.utils.IDataInput;

import kabam.rotmg.messaging.impl.incoming.IncomingMessage;

public class ActivePet extends IncomingMessage {


    public function ActivePet(_arg_1:uint, _arg_2:Function) {
        super(_arg_1, _arg_2);
    }
    public var instanceID:int;

    override public function parseFromInput(_arg_1:IDataInput):void {
        this.instanceID = _arg_1.readInt();
    }
}
}
