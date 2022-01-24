package kabam.rotmg.arena.model {
public class ArenaLeaderboardModel {

    public static const FILTERS:Vector.<ArenaLeaderboardFilter> = Vector.<ArenaLeaderboardFilter>([new ArenaLeaderboardFilter("ArenaLeaderboard.allTime", "alltime"), new ArenaLeaderboardFilter("ArenaLeaderboard.weekly", "weekly"), new ArenaLeaderboardFilter("ArenaLeaderbaord.yourRank", "personal")]);


    public function ArenaLeaderboardModel() {
        super();
    }

    public function clearFilters():void {
        var _local1:* = null;
        var _local3:int = 0;
        var _local2:* = FILTERS;
        for each(_local1 in FILTERS) {
            _local1.clearEntries();
        }
    }
}
}
