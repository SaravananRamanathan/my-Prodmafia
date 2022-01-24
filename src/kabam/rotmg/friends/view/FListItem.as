package kabam.rotmg.friends.view {
import flash.display.Sprite;

import io.decagames.rotmg.social.model.FriendVO;

import org.osflash.signals.Signal;

public class FListItem extends Sprite {


    public function FListItem() {
        actionSignal = new Signal(String, String);
        super();
    }
    public var actionSignal:Signal;

    public function update(_arg_1:FriendVO, _arg_2:String):void {
    }

    public function destroy():void {
    }

    protected function init(_arg_1:Number, _arg_2:Number):void {
    }
}
}
