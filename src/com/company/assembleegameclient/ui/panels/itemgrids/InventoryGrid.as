package com.company.assembleegameclient.ui.panels.itemgrids {
import com.company.assembleegameclient.objects.GameObject;
import com.company.assembleegameclient.objects.Player;
import com.company.assembleegameclient.ui.panels.itemgrids.itemtiles.InventoryTile;

public class InventoryGrid extends ItemGrid {


    private const NUM_SLOTS:uint = 8;

    public function InventoryGrid(_arg_1:GameObject, _arg_2:Player, _arg_3:int = 0, _arg_4:Boolean = false) {
        var _local6:* = null;
        var _local5:int = 0;
        super(_arg_1, _arg_2, _arg_3);
        this._tiles = new Vector.<InventoryTile>(8);
        this.isBackpack = _arg_4;
        while (_local5 < 8) {
            _local6 = new InventoryTile(_local5 + indexOffset, this, interactive);
            _local6.addTileNumber(_local5 + 1);
            addToGrid(_local6, 2, _local5);
            this._tiles[_local5] = _local6;
            _local5++;
        }
    }
    private var isBackpack:Boolean;

    private var _tiles:Vector.<InventoryTile>;

    public function get tiles():Vector.<InventoryTile> {
        return this._tiles.concat();
    }

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
                    if (this._tiles[_local3].setItem(_arg_1[_local3 + indexOffset])) {
                        _local5 = true;
                    }
                } else if (this._tiles[_local3].setItem(-1)) {
                    _local5 = true;
                }
                _local3++;
            }
            if (_local5) {
                refreshTooltip();
            }
        }
    }

    public function getItemById(_arg_1:int):InventoryTile {
        var _local2:* = null;
        var _local4:int = 0;
        var _local3:* = this._tiles;
        for each(_local2 in this._tiles) {
            if (_local2.getItemId() == _arg_1) {
                return _local2;
            }
        }
        return null;
    }

    public function toggleTierTags(_arg_1:Boolean):void {
        for each(var _local2:InventoryTile in this._tiles) {
            _local2.toggleTierTag(_arg_1);
        }
    }
}
}
