package io.decagames.rotmg.seasonalEvent.data {
    import com.company.assembleegameclient.screens.LeagueData;
    
    import io.decagames.rotmg.seasonalEvent.SeasonalLeaderBoard.SeasonalLeaderBoardItemData;
    import io.decagames.rotmg.seasonalEvent.config.SeasonalConfig;
    
    import robotlegs.bender.framework.api.IContext;
    
    public class SeasonalEventModel {
        
        
        public function SeasonalEventModel() {
            super();
        }
        
        [Inject]
        public var context: IContext;
        private var _startTime: Date;
        private var _endTime: Date;
        
        private var _isSeasonalMode: Boolean;
        
        public function get isSeasonalMode(): Boolean {
            return this._isSeasonalMode;
        }
        
        public function set isSeasonalMode(_arg_1: Boolean): void {
            this._isSeasonalMode = _arg_1;
        }
        
        private var _leagueDatas: Vector.<LeagueData>;
        
        public function get leagueDatas(): Vector.<LeagueData> {
            return this._leagueDatas;
        }
        
        private var _seasonTitle: String;
        
        public function get seasonTitle(): String {
            return this._seasonTitle;
        }
        
        private var _isChallenger: int = 0;
        
        public function get isChallenger(): int {
            return this._isChallenger;
        }
        
        public function set isChallenger(_arg_1: int): void {
            this._isChallenger = _arg_1;
        }
        
        private var _rulesAndDescription: String;
        
        public function get rulesAndDescription(): String {
            return this._rulesAndDescription;
        }
        
        private var _scheduledSeasonalEvent: Date;
        
        public function get scheduledSeasonalEvent(): Date {
            return this._scheduledSeasonalEvent;
        }
        
        private var _accountCreatedBefore: Date;
        
        public function get accountCreatedBefore(): Date {
            return this._accountCreatedBefore;
        }
        
        private var _maxCharacters: int;
        
        public function get maxCharacters(): int {
            return this._maxCharacters;
        }
        
        private var _maxPetYardLevel: int;
        
        public function get maxPetYardLevel(): int {
            return this._maxPetYardLevel;
        }
        
        private var _remainingCharacters: int;
        
        public function get remainingCharacters(): int {
            return this._remainingCharacters;
        }
        
        public function set remainingCharacters(_arg_1: int): void {
            this._remainingCharacters = _arg_1;
        }
        
        private var _leaderboardTop20RefreshTime: Date;
        
        public function get leaderboardTop20RefreshTime(): Date {
            return this._leaderboardTop20RefreshTime;
        }
        
        public function set leaderboardTop20RefreshTime(_arg_1: Date): void {
            this._leaderboardTop20RefreshTime = _arg_1;
        }
        
        private var _leaderboardTop20CreateTime: Date;
        
        public function get leaderboardTop20CreateTime(): Date {
            return this._leaderboardTop20CreateTime;
        }
        
        public function set leaderboardTop20CreateTime(_arg_1: Date): void {
            this._leaderboardTop20CreateTime = _arg_1;
        }
        
        private var _leaderboardPlayerRefreshTime: Date;
        
        public function get leaderboardPlayerRefreshTime(): Date {
            return this._leaderboardPlayerRefreshTime;
        }
        
        public function set leaderboardPlayerRefreshTime(_arg_1: Date): void {
            this._leaderboardPlayerRefreshTime = _arg_1;
        }
        
        private var _leaderboardPlayerCreateTime: Date;
        
        public function get leaderboardPlayerCreateTime(): Date {
            return this._leaderboardPlayerCreateTime;
        }
        
        public function set leaderboardPlayerCreateTime(_arg_1: Date): void {
            this._leaderboardPlayerCreateTime = _arg_1;
        }
        
        private var _leaderboardTop20ItemDatas: Vector.<SeasonalLeaderBoardItemData>;
        
        public function get leaderboardTop20ItemDatas(): Vector.<SeasonalLeaderBoardItemData> {
            return this._leaderboardTop20ItemDatas;
        }
        
        public function set leaderboardTop20ItemDatas(_arg_1: Vector.<SeasonalLeaderBoardItemData>): void {
            this._leaderboardTop20ItemDatas = _arg_1;
        }
        
        private var _leaderboardLegacyTop20ItemDatas: Vector.<SeasonalLeaderBoardItemData>;
        
        public function get leaderboardLegacyTop20ItemDatas(): Vector.<SeasonalLeaderBoardItemData> {
            return this._leaderboardLegacyTop20ItemDatas;
        }
        
        public function set leaderboardLegacyTop20ItemDatas(_arg_1: Vector.<SeasonalLeaderBoardItemData>): void {
            this._leaderboardLegacyTop20ItemDatas = _arg_1;
        }
        
        private var _leaderboardPlayerItemDatas: Vector.<SeasonalLeaderBoardItemData>;
        
        public function get leaderboardPlayerItemDatas(): Vector.<SeasonalLeaderBoardItemData> {
            return this._leaderboardPlayerItemDatas;
        }
        
        public function set leaderboardPlayerItemDatas(_arg_1: Vector.<SeasonalLeaderBoardItemData>): void {
            this._leaderboardPlayerItemDatas = _arg_1;
        }
        
        private var _leaderboardLegacyPlayerItemDatas: Vector.<SeasonalLeaderBoardItemData>;
        
        public function get leaderboardLegacyPlayerItemDatas(): Vector.<SeasonalLeaderBoardItemData> {
            return this._leaderboardLegacyPlayerItemDatas;
        }
        
        public function set leaderboardLegacyPlayerItemDatas(_arg_1: Vector.<SeasonalLeaderBoardItemData>): void {
            this._leaderboardLegacyPlayerItemDatas = _arg_1;
        }
        
        private var _legacySeasons: Vector.<LegacySeasonData>;
        
        public function get legacySeasons(): Vector.<LegacySeasonData> {
            return this._legacySeasons;
        }
        
        public function parseConfigData(_arg_1: XML): void {
            var _local5: * = null;
            var _local4: * = null;
            var _local3: * = undefined;
            var _local2: XMLList = _arg_1.Season;
            if (_local2.length() > 0) {
                this._leagueDatas = new Vector.<LeagueData>(0);
                var _local7: int = 0;
                var _local6: * = _local2;
                for each(_local5 in _local2) {
                    this._startTime = new Date(_local5.Start * 1000);
                    this._endTime = new Date(_local5.End * 1000);
                    this._maxCharacters = _local5.MaxLives;
                    this._maxPetYardLevel = _local5.MaxPetYardLevel;
                    this._accountCreatedBefore = new Date(_local5.AccountCreatedBefore * 1000);
                    if (this.getSecondsToStart(this._startTime) <= 0 && !this.hasSeasonEnded(this._endTime)) {
                        this._rulesAndDescription = _local5.Information;
                        _local4 = new LeagueData();
                        _local4.maxCharacters = this._maxCharacters;
                        _local4.leagueType = 1;
                        _local3 = _local5.@title;
                        this._seasonTitle = _local3;
                        _local4.title = _local3;
                        _local4.endDate = this._endTime;
                        _local4.description = _local5.Description;
                        _local4.quote = "";
                        _local4.panelBackgroundId = "game_mode_challenger_panel";
                        _local4.characterId = "game_mode_challenger_character";
                        this._leagueDatas.push(_local4);
                        this._isSeasonalMode = true;
                    } else if (this.getSecondsToStart(this._startTime) > 0) {
                        this._isSeasonalMode = false;
                        this.setScheduledStartTime(this._startTime);
                    } else {
                        this._isSeasonalMode = false;
                    }
                }
                if (this._leagueDatas.length > 0) {
                    this._leagueDatas.unshift(this.addLegacyLeagueData());
                }
            }
            if (this._isSeasonalMode) {
                this.context.configure(SeasonalConfig);
            }
        }
        
        public function parseLegacySeasonsData(_arg_1: XML): void {
            var _local4: * = null;
            var _local3: * = null;
            var _local2: XMLList = _arg_1.Season;
            if (_local2.length() > 0) {
                this._legacySeasons = new Vector.<LegacySeasonData>(0);
                var _local6: int = 0;
                var _local5: * = _local2;
                for each(_local4 in _local2) {
                    _local3 = new LegacySeasonData();
                    _local3.seasonId = _local4.@id;
                    _local3.title = _local4.Title;
                    _local3.active = _local4.hasOwnProperty("Active");
                    _local3.timeValid = _local4.hasOwnProperty("TimeValid");
                    _local3.hasLeaderBoard = _local4.hasOwnProperty("HasLeaderboard");
                    _local3.startTime = new Date(_local4.StartTime * 1000);
                    _local3.endTime = new Date(_local4.EndTime * 1000);
                    this._legacySeasons.push(_local3);
                }
            }
        }
        
        public function getSeasonIdByTitle(_arg_1: String): String {
            var _local3: * = null;
            var _local4: int = 0;
            var _local2: String = "";
            var _local5: int = this._legacySeasons.length;
            while (_local4 < _local5) {
                _local3 = this._legacySeasons[_local4];
                if (_local3.title == _arg_1) {
                    _local2 = _local3.seasonId;
                    break;
                }
                _local4++;
            }
            return _local2;
        }
        
        private function setScheduledStartTime(_arg_1: Date): void {
            this._scheduledSeasonalEvent = _arg_1;
        }
        
        private function getSecondsToStart(_arg_1: Date): Number {
            var _local2: Date = new Date();
            return (_arg_1.time - _local2.time) / 1000;
        }
        
        private function hasSeasonEnded(_arg_1: Date): Boolean {
            var _local2: Date = new Date();
            return (_arg_1.time - _local2.time) / 1000 <= 0;
        }
        
        private function addLegacyLeagueData(): LeagueData {
            var _local1: LeagueData = new LeagueData();
            _local1.maxCharacters = -1;
            _local1.leagueType = 0;
            _local1.title = "Original";
            _local1.description = "The original Realm of the Mad God. This is a gathering place for every Hero in the Realm of the Mad God.";
            _local1.quote = "The experience you have come to know, all your previous progress and achievements.";
            _local1.panelBackgroundId = "game_mode_legacy_panel";
            _local1.characterId = "game_mode_legacy_character";
            return _local1;
        }
    }
}
