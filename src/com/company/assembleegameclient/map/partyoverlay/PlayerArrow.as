package com.company.assembleegameclient.map.partyoverlay {
import com.company.assembleegameclient.objects.Player;
import com.company.assembleegameclient.ui.menu.Menu;
import com.company.assembleegameclient.ui.menu.PlayerGroupMenu;
import com.company.assembleegameclient.ui.tooltip.PlayerGroupToolTip;

import flash.events.MouseEvent;

public class PlayerArrow extends GameObjectArrow {


    public function PlayerArrow() {
        super(0xffffff, 4179794, false);
    }

    protected function getMenu():Menu {
        var _local1:Player = go_ as Player;
        if (_local1 == null || _local1.map_ == null) {
            return null;
        }
        var _local2:Player = _local1.map_.player_;
        if (_local2 == null) {
            return null;
        }
        return new PlayerGroupMenu(_local1.map_, this.getFullPlayerVec());
    }

    private function getFullPlayerVec():Vector.<Player> {
        var _local2:* = null;
        var _local1:Vector.<Player> = new <Player>[go_ as Player];
        var _local4:int = 0;
        var _local3:* = extraGOs_;
        for each(_local2 in extraGOs_) {
            _local1.push(_local2 as Player);
        }
        return _local1;
    }

    override protected function onMouseOver(_arg_1:MouseEvent):void {
        super.onMouseOver(_arg_1);
        setToolTip(new PlayerGroupToolTip(this.getFullPlayerVec(), false));
    }

    override protected function onMouseOut(_arg_1:MouseEvent):void {
        super.onMouseOut(_arg_1);
        setToolTip(null);
    }

    override protected function onMouseDown(_arg_1:MouseEvent):void {
        super.onMouseDown(_arg_1);
        removeMenu();
        setMenu(this.getMenu());
    }
}
}
