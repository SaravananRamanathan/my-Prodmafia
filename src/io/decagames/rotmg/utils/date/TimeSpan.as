package io.decagames.rotmg.utils.date {
    import mx.utils.StringUtil;
    
    public class TimeSpan {
        
        public static const MILLISECONDS_IN_DAY: Number = 86400000;
        
        public static const MILLISECONDS_IN_HOUR: Number = 3600000;
        
        public static const MILLISECONDS_IN_MINUTE: Number = 60000;
        
        public static const MILLISECONDS_IN_SECOND: Number = 1000;
        
        public static function distanceOfTimeInWords(_arg_1: Date, _arg_2: Date, _arg_3: Boolean = false): String {
            var _local4: TimeSpan = TimeSpan.fromDates(_arg_1, _arg_2);
            if (_local4.totalMinutes < 1) {
                if (_arg_3) {
                    if (_local4.totalSeconds == 0 || _local4.totalSeconds == 1) {
                        return "now";
                    }
                    return StringUtil.substitute("{0} seconds ago", [Math.round(_local4.totalSeconds)]);
                }
                return "minute ago";
            }
            if (_local4.totalMinutes >= 1 && _local4.totalMinutes < 2) {
                return "1 minute ago";
            }
            if (_local4.totalMinutes < 60) {
                return StringUtil.substitute("{0} minutes ago", [Math.round(_local4.totalMinutes)]);
            }
            if (_local4.totalHours >= 1 && _local4.totalHours < 2) {
                return "1 hour ago";
            }
            return StringUtil.substitute("{0} hours ago", [Math.round(_local4.totalHours)]);
        }
        
        public static function fromDates(_arg_1: Date, _arg_2: Date): TimeSpan {
            return new TimeSpan(_arg_2.time - _arg_1.time);
        }
        
        public static function fromMilliseconds(_arg_1: Number): TimeSpan {
            return new TimeSpan(_arg_1);
        }
        
        public static function fromSeconds(_arg_1: Number): TimeSpan {
            return new TimeSpan(_arg_1 * 1000);
        }
        
        public static function fromMinutes(_arg_1: Number): TimeSpan {
            return new TimeSpan(_arg_1 * 60000);
        }
        
        public static function fromHours(_arg_1: Number): TimeSpan {
            return new TimeSpan(_arg_1 * 3600000);
        }
        
        public static function fromDays(_arg_1: Number): TimeSpan {
            return new TimeSpan(_arg_1 * 86400000);
        }
        
        public function TimeSpan(_arg_1: Number) {
            super();
            this._totalMilliseconds = Math.floor(_arg_1);
        }
        
        private var _totalMilliseconds: Number;
        
        public function get totalMilliseconds(): Number {
            return this._totalMilliseconds;
        }
        
        public function get days(): int {
            return int(this._totalMilliseconds / 86400000);
        }
        
        public function get hours(): int {
            return int(this._totalMilliseconds / 3600000) % 24;
        }
        
        public function get minutes(): int {
            return int(this._totalMilliseconds / 60000) % 60;
        }
        
        public function get seconds(): int {
            return int(this._totalMilliseconds / 1000) % 60;
        }
        
        public function get milliseconds(): int {
            return this._totalMilliseconds % 1000;
        }
        
        public function get totalDays(): Number {
            return this._totalMilliseconds / 86400000;
        }
        
        public function get totalHours(): Number {
            return this._totalMilliseconds / 3600000;
        }
        
        public function get totalMinutes(): Number {
            return this._totalMilliseconds / 60000;
        }
        
        public function get totalSeconds(): Number {
            return this._totalMilliseconds / 1000;
        }
        
        public function add(_arg_1: Date): Date {
            var _local2: Date = new Date(_arg_1.time);
            _local2.milliseconds = _local2.milliseconds + this.totalMilliseconds;
            return _local2;
        }
    }
}
