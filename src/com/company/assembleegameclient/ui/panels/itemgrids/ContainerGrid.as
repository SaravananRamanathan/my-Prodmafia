package com.company.assembleegameclient.ui.panels.itemgrids {
import com.company.assembleegameclient.objects.GameObject;
import com.company.assembleegameclient.objects.Player;
import com.company.assembleegameclient.ui.panels.itemgrids.itemtiles.InteractiveItemTile;

public class ContainerGrid extends ItemGrid {


    private const NUM_SLOTS:uint = 8;

    public function ContainerGrid(_arg_1:GameObject, _arg_2:Player) {
        var _local3:* = null;
        var _local4:int = 0;
        super(_arg_1, _arg_2, 0);
        this.tiles = new Vector.<InteractiveItemTile>(8);
        while (_local4 < 8) {
            _local3 = new InteractiveItemTile(_local4 + indexOffset, this, interactive);
            addToGrid(_local3, 2, _local4);
            this.tiles[_local4] = _local3;
            _local4++;
        }
    }
    private var tiles:Vector.<InteractiveItemTile>;

    override public function setItems(_arg_1:Vector.<int>, _arg_2:int = 0):void {
        var _local5:Boolean = false;
        var _local4:int = 0;
        var _local3:int = 0;
        if (_arg_1) {
            _local5 = false;
            _local4 = _arg_1.length;
            _local3 = 0;
            while (_local3 < 8) {
                if (_local3 + indexOffset < _local4) {
                    if (this.tiles[_local3].setItem(_arg_1[_local3 + indexOffset])) {
                        _local5 = true;
                    }
                } else if (this.tiles[_local3].setItem(-1)) {
                    _local5 = true;
                }
                _local3++;
            }
            if (_local5) {
                refreshTooltip();
            }
        }
    }
}
}
