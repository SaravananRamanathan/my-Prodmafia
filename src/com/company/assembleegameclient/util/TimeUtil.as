package com.company.assembleegameclient.util 
{
    import flash.utils.getTimer;
    import com.company.assembleegameclient.parameters.Parameters;

    public class TimeUtil 
    {
        public static const DAY_IN_MS:int = 86400000;
        public static const DAY_IN_S:int = 86400;
        public static const HOUR_IN_S:int = 3600;
        public static const MIN_IN_S:int = 60;
        public static var moddedTime:int = -1;
        public static var prevTrueTime:int = -1;

        public function TimeUtil()
        {
            super();
        }

        public static function getTrueTime() : int
        {
            return getTimer();
        }

        public static function getModdedTime() : int
        {
            var currentTime:int = getTimer();
            var timeScale:Number = Parameters.data.timeScale;
            if(moddedTime == -1)
            {
                moddedTime = int(currentTime * timeScale);
            }
            moddedTime = moddedTime + (prevTrueTime == -1?0:int((currentTime - prevTrueTime) * timeScale));
            prevTrueTime = currentTime;
            return moddedTime;
        }

        public static function secondsToDays(seconds: Number) : Number {
            return seconds / 86400;
        }

        public static function secondsToHours(seconds: Number) : Number {
            return seconds / 3600;
        }

        public static function secondsToMins(seconds: Number) : Number {
            return seconds / 60;
        }

        public static function parseUTCDate(_arg_1:String) : Date {
            var _local2:Array = _arg_1.match(/(\d\d\d\d)-(\d\d)-(\d\d) (\d\d):(\d\d):(\d\d)/);
            var _local3:Date = new Date();
            _local3.setUTCFullYear(_local2[1], _local2[2] - 1, _local2[3]);
            _local3.setUTCHours(_local2[4], _local2[5], _local2[6], 0);
            return _local3;
        }

        public static function humanReadableTime(_arg_1:int) : String {
            var _local6:int = 0;
            var _local4:int = 0;
            var _local3:int = 0;
            var _local5:int = 0;
            _local5 = _arg_1 >= 0 ? _arg_1 : 0;
            _local6 = _local5 / 86400;
            _local5 = _local5 % 86400;
            _local4 = _local5 / 3600;
            _local5 = _local5 % 3600;
            _local3 = _local5 / 60;
            return _getReadableTime(_arg_1, _local6, _local4, _local3);
        }

        private static function _getReadableTime(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:int) : String {
            var _local5:* = null;
            if (_arg_1 >= 24 * 60 * 60) {
                if (_arg_3 == 0 && _arg_4 == 0) {
                    _local5 = _arg_2.toString() + (_arg_2 > 1 ? "days" : "day");
                    return _local5;
                }
                if (_arg_4 == 0) {
                    _local5 = _arg_2.toString() + (_arg_2 > 1 ? " days" : " day");
                    _local5 = _local5 + (", " + _arg_3.toString() + (_arg_3 > 1 ? " hours" : " hour"));
                    return _local5;
                }
                _local5 = _arg_2.toString() + (_arg_2 > 1 ? " days" : " day");
                _local5 = _local5 + (", " + _arg_3.toString() + (_arg_3 > 1 ? " hours" : " hour"));
                _local5 = _local5 + (" and " + _arg_4.toString() + (_arg_4 > 1 ? " minutes" : " minute"));
                return _local5;
            }
            if (_arg_1 >= 60 * 60) {
                if (_arg_4 == 0) {
                    _local5 = _arg_3.toString() + (_arg_3 > 1 ? " hours" : " hour");
                    return _local5;
                }
                _local5 = _arg_3.toString() + (_arg_3 > 1 ? " hours" : " hour");
                _local5 = _local5 + (" and " + _arg_4.toString() + (_arg_4 > 1 ? " minutes" : " minute"));
                return _local5;
            }
            _local5 = _arg_4.toString() + (_arg_4 > 1 ? " minutes" : " minute");
            return _local5;
        }
    }
}
