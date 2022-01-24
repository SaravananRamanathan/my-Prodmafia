package io.decagames.rotmg.seasonalEvent.tasks {
    import io.decagames.rotmg.seasonalEvent.SeasonalLeaderBoard.SeasonalItemDataFactory;
    import io.decagames.rotmg.seasonalEvent.SeasonalLeaderBoard.SeasonalLeaderBoardItemData;
    import io.decagames.rotmg.seasonalEvent.data.SeasonalEventModel;
    import io.decagames.rotmg.seasonalEvent.signals.SeasonalLeaderBoardErrorSignal;

    import kabam.lib.tasks.BaseTask;
    import kabam.rotmg.account.core.Account;
    import kabam.rotmg.appengine.api.AppEngineClient;
    import kabam.rotmg.core.model.PlayerModel;
    import kabam.rotmg.legends.model.LegendFactory;
    import kabam.rotmg.legends.model.LegendsModel;
    import kabam.rotmg.legends.model.Timespan;

    public class GetChallengerListTask extends BaseTask {

        public static const REFRESH_INTERVAL_IN_MILLISECONDS: Number = 300000;

        public function GetChallengerListTask() {
            super();
        }

        [Inject]
        public var account: Account;
        [Inject]
        public var client: AppEngineClient;
        [Inject]
        public var player: PlayerModel;
        [Inject]
        public var model: LegendsModel;
        [Inject]
        public var seasonalEventModel: SeasonalEventModel;
        [Inject]
        public var factory: LegendFactory;
        [Inject]
        public var seasonalItemDataFactory: SeasonalItemDataFactory;
        [Inject]
        public var timespan: Timespan;
        [Inject]
        public var listType: String;
        [Inject]
        public var seasonalLeaderBoardErrorSignal: SeasonalLeaderBoardErrorSignal;
        public var charId: int;

        override protected function startTask(): void {
            this.client.complete.addOnce(this.onComplete);
            if (this.listType == "Top 20") {
                this.client.sendRequest("/fame/challengerLeaderboard", this.makeRequestObject());
            } else if (this.listType == "Your Position") {
                this.client.sendRequest("/fame/challengerAccountLeaderboard?account=" + this.account.getUserName(), this.makeRequestObject());
            }
        }

        private function onComplete(_arg_1: Boolean, _arg_2: *): void {
            if (_arg_1) {
                this.updateFameListData(_arg_2);
            } else {
                this.onFameListError(_arg_2);
            }
        }

        private function onFameListError(_arg_1: String): void {
            this.seasonalLeaderBoardErrorSignal.dispatch(_arg_1);
            completeTask(true);
        }

        private function updateFameListData(_arg_1: String): void {
            var _local2: XML = XML(_arg_1);
            var _local6: Date = new Date(_local2.GeneratedOn * 1000);
            var _local4: Number = _local6.getTimezoneOffset() * 60 * 1000;
            _local6.setTime(_local6.getTime() - _local4);
            var _local3: Date = new Date();
            _local3.setTime(_local3.getTime() + 5 * 60 * 1000);
            var _local5: Vector.<SeasonalLeaderBoardItemData> = this.seasonalItemDataFactory.createSeasonalLeaderBoardItemDatas(XML(_arg_1));
            if (this.listType == "Top 20") {
                this.seasonalEventModel.leaderboardTop20ItemDatas = _local5;
                this.seasonalEventModel.leaderboardTop20RefreshTime = _local3;
                this.seasonalEventModel.leaderboardTop20CreateTime = _local6;
            } else if (this.listType == "Your Position") {
                _local5.sort(this.fameSort);
                this.seasonalEventModel.leaderboardPlayerItemDatas = _local5;
                this.seasonalEventModel.leaderboardPlayerRefreshTime = _local3;
                this.seasonalEventModel.leaderboardPlayerCreateTime = _local6;
            }
            completeTask(true);
        }

        private function fameSort(_arg_1: SeasonalLeaderBoardItemData, _arg_2: SeasonalLeaderBoardItemData): int {
            if (_arg_1.totalFame > _arg_2.totalFame) {
                return -1;
            }
            if (_arg_1.totalFame < _arg_2.totalFame) {
                return 1;
            }
            return 0;
        }

        private function makeRequestObject(): Object {
            var _local1: * = {};
            _local1.timespan = this.timespan.getId();
            _local1.accountId = this.player.getAccountId();
            _local1.charId = this.charId;
            return _local1;
        }
    }
}
