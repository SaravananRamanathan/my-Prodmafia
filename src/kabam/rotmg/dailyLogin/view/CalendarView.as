package kabam.rotmg.dailyLogin.view {
import flash.display.Sprite;

import kabam.rotmg.dailyLogin.model.CalendarDayModel;

public class CalendarView extends Sprite {


    public function CalendarView() {
        super();
    }

    public function init(_arg_1:Vector.<CalendarDayModel>, _arg_2:int, _arg_3:int):void {
        var _local8:int = 0;
        var _local4:int = 0;
        var _local9:int = 0;
        var _local6:int = 0;
        var _local5:* = null;
        var _local7:* = null;
        var _local11:int = 0;
        var _local10:* = _arg_1;
        for each(_local5 in _arg_1) {
            _local7 = new CalendarDayBox(_local5, _arg_2, _local4 + 1 == _arg_3);
            addChild(_local7);
            _local7.x = _local9 * 70;
            if (_local9 > 0) {
                _local7.x = _local7.x + _local9 * 10;
            }
            _local7.y = _local6 * 70;
            if (_local6 > 0) {
                _local7.y = _local7.y + _local6 * 10;
            }
            _local9++;
            _local4++;
            if (_local4 % 7 == 0) {
                _local9 = 0;
                _local6++;
            }
        }
        _local8 = 550;
        this.x = (this.parent.width - _local8) / 2;
        this.y = 40;
    }
}
}
