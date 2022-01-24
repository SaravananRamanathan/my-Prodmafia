package io.decagames.rotmg.utils.date {
    public class TimeLeft {
        
        
        public static function parse(_arg_1: int, _arg_2: String): String {
            var _local5: int = 0;
            var _local4: int = 0;
            var _local3: int = 0;
            if (_arg_2.indexOf("%d") >= 0) {
                _local5 = Math.floor(_arg_1 / 86400);
                _arg_1 = _arg_1 - _local5 * 86400;
                _arg_2 = _arg_2.replace("%d", _local5);
            }
            if (_arg_2.indexOf("%h") >= 0) {
                _local4 = Math.floor(_arg_1 / 3600);
                _arg_1 = _arg_1 - _local4 * 3600;
                _arg_2 = _arg_2.replace("%h", _local4);
            }
            if (_arg_2.indexOf("%m") >= 0) {
                _local3 = Math.floor(_arg_1 / 60);
                _arg_1 = _arg_1 - _local3 * 60;
                _arg_2 = _arg_2.replace("%m", _local3);
            }
            return _arg_2.replace("%s", _arg_1);
        }
        
        public static function getStartTimeString(_arg_1: Date): String {
            var _local2: String = "";
            var _local4: Date = new Date();
            var _local3: Number = (_arg_1.time - _local4.time) / 1000;
            if (_local3 <= 0) {
                return "";
            }
            if (_local3 > 24 * 60 * 60) {
                _local2 = _local2 + TimeLeft.parse(_local3, "%dd %hh");
            } else if (_local3 > 60 * 60) {
                _local2 = _local2 + TimeLeft.parse(_local3, "%hh %mm");
            } else if (_local3 > 60) {
                _local2 = _local2 + TimeLeft.parse(_local3, "%mm %ss");
            } else {
                _local2 = _local2 + TimeLeft.parse(_local3, "%ss");
            }
            return _local2;
        }
        
        public function TimeLeft() {
            super();
        }
    }
}
