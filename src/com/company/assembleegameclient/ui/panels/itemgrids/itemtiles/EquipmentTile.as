package com.company.assembleegameclient.ui.panels.itemgrids.itemtiles {
import com.company.assembleegameclient.objects.ObjectLibrary;
import com.company.assembleegameclient.objects.Player;
import com.company.assembleegameclient.ui.panels.itemgrids.ItemGrid;
import com.company.assembleegameclient.util.EquipmentUtil;
import com.company.assembleegameclient.util.FilterUtil;
import com.company.util.MoreColorUtil;

import flash.display.Bitmap;
import flash.filters.ColorMatrixFilter;

public class EquipmentTile extends InteractiveItemTile {

    private static const greyColorFilter:ColorMatrixFilter = new ColorMatrixFilter(MoreColorUtil.singleColorFilterMatrix(0x363636));

    public function EquipmentTile(_arg_1:int, _arg_2:ItemGrid, _arg_3:Boolean) {
        super(_arg_1, _arg_2, _arg_3);
    }
    public var backgroundDetail:Bitmap;
    public var itemType:int;
    private var minManaUsage:int;

    override public function canHoldItem(_arg_1:int):Boolean {
        return _arg_1 <= 0 || this.itemType == ObjectLibrary.getSlotTypeFromType(_arg_1);
    }

    override public function setItem(_arg_1:int):Boolean {
        var _local2:Boolean = super.setItem(_arg_1);
        if (_local2) {
            this.backgroundDetail.visible = itemSprite.itemId <= 0;
            this.updateMinMana();
        }
        return _local2;
    }

    override protected function beginDragCallback():void {
        this.backgroundDetail.visible = true;
    }

    override protected function endDragCallback():void {
        this.backgroundDetail.visible = itemSprite.itemId <= 0;
    }

    override protected function getBackgroundColor():int {
        return 0x454545;
    }

    public function setType(_arg_1:int):void {
        this.backgroundDetail = EquipmentUtil.getEquipmentBackground(_arg_1, 4);
        if (this.backgroundDetail) {
            this.backgroundDetail.x = 4;
            this.backgroundDetail.y = 4;
            this.backgroundDetail.filters = FilterUtil.getGreyColorFilter();
            addChildAt(this.backgroundDetail, 0);
        }
        this.itemType = _arg_1;
    }

    public function updateDim(_arg_1:Player):void {
        itemSprite.setDim(_arg_1 && (_arg_1.mp_ < this.minManaUsage || this.minManaUsage && _arg_1.isSilenced));
    }

    private function updateMinMana():void {
        var _local1:* = null;
        this.minManaUsage = 0;
        if (itemSprite.itemId > 0) {
            _local1 = ObjectLibrary.xmlLibrary_[itemSprite.itemId];
            if (_local1 && "Usable" in _local1) {
                if ("MultiPhase" in _local1) {
                    this.minManaUsage = _local1.MpEndCost;
                } else {
                    this.minManaUsage = _local1.MpCost;
                }
            }
        }
    }
}
}
