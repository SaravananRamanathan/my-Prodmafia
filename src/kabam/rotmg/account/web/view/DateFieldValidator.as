package kabam.rotmg.account.web.view {
import kabam.rotmg.account.ui.components.DateField;

public class DateFieldValidator {


    public static function getPlayerAge(_arg_1:DateField):uint {
        var _local2:Date = new Date(getBirthDate(_arg_1));
        var _local4:Date = new Date();
        var _local3:uint = _local4.fullYear - _local2.fullYear;
        if (_local2.month > _local4.month || _local2.month == _local4.month && _local2.date > _local4.date) {
            _local3--;
        }
        return _local3;
    }

    public static function getBirthDate(_arg_1:DateField):Number {
        var _local2:String = _arg_1.months.text + "/" + _arg_1.days.text + "/" + _arg_1.years.text;
        return Date.parse(_local2);
    }

    public function DateFieldValidator() {
        super();
    }
}
}
