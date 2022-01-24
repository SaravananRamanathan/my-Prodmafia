package com.company.assembleegameclient.ui.panels.itemgrids {
import com.company.assembleegameclient.objects.GameObject;
import com.company.assembleegameclient.objects.Player;
import com.company.assembleegameclient.ui.panels.itemgrids.itemtiles.EquipmentTile;
import com.company.util.ArrayIterator;
import com.company.util.IIterator;

import kabam.lib.util.VectorAS3Util;

public class EquippedGrid extends ItemGrid {


    public function EquippedGrid(_arg_1:GameObject, _arg_2:Vector.<int>, _arg_3:Player, _arg_4:int = 0) {
        super(_arg_1, _arg_3, _arg_4);
        this._invTypes = _arg_2;
        this.init();
    }
    private var tiles:Vector.<EquipmentTile>;
    private var _invTypes:Vector.<int>;

    override public function setItems(_arg_1:Vector.<int>, _arg_2:int = 0):void {
        var _local3:int = 0;
        if (!_arg_1) {
            return;
        }
        var _local4:int = _arg_1.length;
        while (_local3 < this.tiles.length) {
            if (_local3 + _arg_2 < _local4) {
                this.tiles[_local3].setItem(_arg_1[_local3 + _arg_2]);
            } else {
                this.tiles[_local3].setItem(-1);
            }
            this.tiles[_local3].updateDim(curPlayer);
            _local3++;
        }
    }

    public function dispose():void {
        tiles.length = 0;
    }

    public function createInteractiveItemTileIterator():IIterator {
        return new ArrayIterator(VectorAS3Util.toArray(this.tiles));
    }

    public function toggleTierTags(_arg_1:Boolean):void {
        for each(var _local2:EquipmentTile in this.tiles) {
            _local2.toggleTierTag(_arg_1);
        }
    }

    private function init():void {
        var _local1:* = null;
        var _local2:int = 0;
        this.tiles = new Vector.<EquipmentTile>(4);
        while (_local2 < 4) {
            _local1 = new EquipmentTile(_local2, this, interactive);
            addToGrid(_local1, 1, _local2);
            _local1.setType(this._invTypes[_local2]);
            this.tiles[_local2] = _local1;
            _local2++;
        }
    }
}
}
