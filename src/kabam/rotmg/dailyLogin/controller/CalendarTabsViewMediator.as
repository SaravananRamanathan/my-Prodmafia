package kabam.rotmg.dailyLogin.controller {
import flash.events.MouseEvent;

import kabam.rotmg.dailyLogin.config.CalendarSettings;
import kabam.rotmg.dailyLogin.model.DailyLoginModel;
import kabam.rotmg.dailyLogin.view.CalendarTabButton;
import kabam.rotmg.dailyLogin.view.CalendarTabsView;

import robotlegs.bender.bundles.mvcs.Mediator;

public class CalendarTabsViewMediator extends Mediator {


    public function CalendarTabsViewMediator() {
        super();
    }
    [Inject]
    public var view:CalendarTabsView;
    [Inject]
    public var model:DailyLoginModel;
    private var tabs:Vector.<CalendarTabButton>;

    override public function initialize():void {
        var _local2:* = null;
        this.tabs = new Vector.<CalendarTabButton>();
        this.view.init(CalendarSettings.getTabsRectangle(this.model.overallMaxDays));
        var _local1:String = "";
        if (this.model.hasCalendar("nonconsecutive")) {
            _local1 = "nonconsecutive";
            this.tabs.push(this.view.addCalendar("Login Calendar", "nonconsecutive", "Unlock rewards the more days you login. Logins do not need to be in consecutive days. You must claim all rewards before the end of the event."));
        }
        if (this.model.hasCalendar("consecutive")) {
            if (_local1 == "") {
                _local1 = "consecutive";
            }
            this.tabs.push(this.view.addCalendar("Login Streak", "consecutive", "Login on consecutive days to keep your streak alive. The more consecutive days you login, the more rewards you can unlock. If you miss a day, you start over. All rewards must be claimed by the end of the event."));
        }
        var _local4:int = 0;
        var _local3:* = this.tabs;
        for each(_local2 in this.tabs) {
            _local2.addEventListener("click", this.onTabChange);
        }
        this.view.drawTabs();
        if (_local1 != "") {
            this.model.currentDisplayedCaledar = _local1;
            this.view.selectTab(_local1);
        }
    }

    override public function destroy():void {
        var _local1:* = null;
        var _local3:int = 0;
        var _local2:* = this.tabs;
        for each(_local1 in this.tabs) {
            _local1.removeEventListener("click", this.onTabChange);
        }
        this.tabs = new Vector.<CalendarTabButton>();
        super.destroy();
    }

    private function onTabChange(_arg_1:MouseEvent):void {
        _arg_1.stopImmediatePropagation();
        _arg_1.stopPropagation();
        var _local2:CalendarTabButton = _arg_1.currentTarget as CalendarTabButton;
        if (_local2 != null) {
            this.model.currentDisplayedCaledar = _local2.calendarType;
            this.view.selectTab(_local2.calendarType);
        }
    }
}
}
