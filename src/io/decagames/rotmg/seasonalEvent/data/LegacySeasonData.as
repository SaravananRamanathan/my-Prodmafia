package io.decagames.rotmg.seasonalEvent.data {
    public class LegacySeasonData {
        
        
        public function LegacySeasonData() {
            super();
        }
        
        private var _seasonId: String;
        
        public function get seasonId(): String {
            return this._seasonId;
        }
        
        public function set seasonId(_arg_1: String): void {
            this._seasonId = _arg_1;
        }
        
        private var _title: String;
        
        public function get title(): String {
            return this._title;
        }
        
        public function set title(_arg_1: String): void {
            this._title = _arg_1;
        }
        
        private var _active: Boolean;
        
        public function get active(): Boolean {
            return this._active;
        }
        
        public function set active(_arg_1: Boolean): void {
            this._active = _arg_1;
        }
        
        private var _timeValid: Boolean;
        
        public function get timeValid(): Boolean {
            return this._timeValid;
        }
        
        public function set timeValid(_arg_1: Boolean): void {
            this._timeValid = _arg_1;
        }
        
        private var _hasLeaderBoard: Boolean;
        
        public function get hasLeaderBoard(): Boolean {
            return this._hasLeaderBoard;
        }
        
        public function set hasLeaderBoard(_arg_1: Boolean): void {
            this._hasLeaderBoard = _arg_1;
        }
        
        private var _startTime: Date;
        
        public function get startTime(): Date {
            return this._startTime;
        }
        
        public function set startTime(_arg_1: Date): void {
            this._startTime = _arg_1;
        }
        
        private var _endTime: Date;
        
        public function get endTime(): Date {
            return this._endTime;
        }
        
        public function set endTime(_arg_1: Date): void {
            this._endTime = _arg_1;
        }
    }
}
