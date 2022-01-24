package kabam.rotmg.game.focus.view {
import com.company.assembleegameclient.game.GameSprite;
import com.company.assembleegameclient.objects.GameObject;

import flash.utils.Dictionary;

import kabam.rotmg.game.focus.control.SetGameFocusSignal;

import robotlegs.bender.bundles.mvcs.Mediator;

public class GameFocusMediator extends Mediator {


    public function GameFocusMediator() {
        super();
    }
    [Inject]
    public var signal:SetGameFocusSignal;
    [Inject]
    public var view:GameSprite;

    override public function initialize():void {
        this.signal.add(this.onSetGameFocus);
    }

    override public function destroy():void {
        this.signal.remove(this.onSetGameFocus);
    }

    private function onSetGameFocus(_arg_1:String = ""):void {
        this.view.setFocus(this.getFocusById(_arg_1));
    }

    private function getFocusById(_arg_1:String):GameObject {
        var _local3:* = null;
        if (_arg_1 == "") {
            return this.view.map.player_;
        }
        var _local2:Dictionary = this.view.map.goDict_;
        var _local5:int = 0;
        var _local4:* = _local2;
        for each(_local3 in _local2) {
            if (_local3.name_ == _arg_1) {
                return _local3;
            }
        }
        return this.view.map.player_;
    }
}
}
