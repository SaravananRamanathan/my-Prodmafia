package kabam.rotmg.dailyLogin.controller {
import flash.events.MouseEvent;

import kabam.lib.net.api.MessageProvider;
import kabam.lib.net.impl.SocketServer;
import kabam.rotmg.core.model.MapModel;
import kabam.rotmg.dailyLogin.message.ClaimDailyRewardMessage;
import kabam.rotmg.dailyLogin.model.DailyLoginModel;
import kabam.rotmg.dailyLogin.view.CalendarDayBox;
import kabam.rotmg.ui.model.HUDModel;

import robotlegs.bender.bundles.mvcs.Mediator;

public class CalendarDayBoxMediator extends Mediator {


    public function CalendarDayBoxMediator() {
        super();
    }
    [Inject]
    public var view:CalendarDayBox;
    [Inject]
    public var socketServer:SocketServer;
    [Inject]
    public var messages:MessageProvider;
    [Inject]
    public var mapModel:MapModel;
    [Inject]
    public var hudModel:HUDModel;
    [Inject]
    public var model:DailyLoginModel;

    override public function initialize():void {
        this.view.addEventListener("click", this.onClickHandler);
    }

    override public function destroy():void {
        this.view.removeEventListener("click", this.onClickHandler);
        super.destroy();
    }

    private function onClickHandler(_arg_1:MouseEvent):void {
        var _local2:* = null;
        this.view.removeEventListener("click", this.onClickHandler);
        if (this.hudModel.gameSprite.map.name_ == "Daily Quest Room" && this.view.day.claimKey != "" && !this.view.day.isClaimed) {
            _local2 = this.messages.require(3) as ClaimDailyRewardMessage;
            _local2.claimKey = this.view.day.claimKey;
            _local2.type_ = this.view.getDay().calendarType;
            this.socketServer.sendMessage(_local2);
            this.view.markAsClaimed();
            this.model.markAsClaimed(this.view.getDay().dayNumber, this.view.getDay().calendarType);
        }
    }
}
}
