package kabam.rotmg.arena.view {
import flash.display.DisplayObject;
import flash.display.Sprite;

import kabam.lib.ui.api.Size;
import kabam.rotmg.arena.model.ArenaLeaderboardEntry;
import kabam.rotmg.util.components.VerticalScrollingList;

public class ArenaLeaderboardList extends Sprite {


    private const MAX_SIZE:int = 20;

    public function ArenaLeaderboardList() {
        var _local1:int = 0;
        listItemPool = new Vector.<DisplayObject>(20);
        scrollList = new VerticalScrollingList();
        super();
        while (_local1 < 20) {
            this.listItemPool[_local1] = new ArenaLeaderboardListItem();
            _local1++;
        }
        this.scrollList.setSize(new Size(786, 400));
        addChild(this.scrollList);
    }
    private var listItemPool:Vector.<DisplayObject>;
    private var scrollList:VerticalScrollingList;

    public function setItems(_arg_1:Vector.<ArenaLeaderboardEntry>, _arg_2:Boolean):void {
        var _local4:* = null;
        var _local3:* = null;
        var _local5:int = 0;
        while (_local5 < this.listItemPool.length) {
            _local4 = _local5 < _arg_1.length ? _arg_1[_local5] : null;
            _local3 = this.listItemPool[_local5] as ArenaLeaderboardListItem;
            _local3.apply(_local4, _arg_2);
            _local5++;
        }
        this.scrollList.setItems(this.listItemPool);
    }
}
}
