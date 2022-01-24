package com.company.assembleegameclient.ui.panels.itemgrids {
import com.company.assembleegameclient.objects.Container;
import com.company.assembleegameclient.objects.GameObject;
import com.company.assembleegameclient.objects.Player;
import com.company.assembleegameclient.ui.panels.Panel;
import com.company.assembleegameclient.ui.panels.itemgrids.itemtiles.EquipmentTile;
import com.company.assembleegameclient.ui.panels.itemgrids.itemtiles.ItemTile;
import com.company.assembleegameclient.ui.tooltip.EquipmentToolTip;
import com.company.assembleegameclient.ui.tooltip.TextToolTip;
import com.company.assembleegameclient.ui.tooltip.ToolTip;

import flash.events.MouseEvent;

import kabam.rotmg.constants.ItemConstants;
import kabam.rotmg.text.model.TextKey;

import org.osflash.signals.Signal;

public class ItemGrid extends Panel {

    private static const NO_CUT:Array = [0, 0, 0, 0];

    private static const CutsByNum:Object = {
        "1": [[1, 0, 0, 1], NO_CUT, NO_CUT, [0, 1, 1, 0]],
        "2": [[1, 0, 0, 0], NO_CUT, NO_CUT, [0, 1, 0, 0], [0, 0, 0, 1], NO_CUT, NO_CUT, [0, 0, 1, 0]],
        "3": [[1, 0, 0, 1], NO_CUT, NO_CUT, [0, 1, 1, 0], [1, 0, 0, 0], NO_CUT, NO_CUT, [0, 1, 0, 0], [0, 0, 0, 1], NO_CUT, NO_CUT, [0, 0, 1, 0]]
    };


    private const padding:uint = 4;

    private const rowLength:uint = 4;

    public const addToolTip:Signal = new Signal(ToolTip);

    public function ItemGrid(_arg_1:GameObject, _arg_2:Player, _arg_3:int) {
        super(null);
        this.owner = _arg_1;
        this.curPlayer = _arg_2;
        this.indexOffset = _arg_3;
        var _local4:Container = _arg_1 as Container;
        if (_arg_1 == _arg_2 || _local4) {
            this.interactive = true;
        }
    }
    public var owner:GameObject;
    public var curPlayer:Player;
    public var interactive:Boolean;
    protected var indexOffset:int;
    private var tooltip:ToolTip;
    private var tooltipFocusTile:ItemTile;
    private var prevEquips:Vector.<int>;

    override public function draw():void {
        this.setItems(this.owner.equipment_, this.indexOffset);
    }

    public function hideTooltip():void {
        if (this.tooltip) {
            this.tooltip.detachFromTarget();
            this.tooltip = null;
            this.tooltipFocusTile = null;
        }
    }

    public function refreshTooltip():void {
        if (!stage || !this.tooltip || !this.tooltip.stage) {
            return;
        }
        if (this.tooltipFocusTile) {
            this.tooltip.detachFromTarget();
            this.tooltip = null;
            this.addToolTipToTile(this.tooltipFocusTile);
        }
    }

    public function setItems(_arg_1:Vector.<int>, _arg_2:int = 0):void {
    }

    public function enableInteraction(_arg_1:Boolean):void {
        mouseEnabled = _arg_1;
    }

    protected function addToGrid(_arg_1:ItemTile, _arg_2:uint, _arg_3:uint):void {
        _arg_1.drawBackground(CutsByNum[_arg_2][_arg_3]);
        _arg_1.addEventListener("rollOver", this.onTileHover);
        _arg_1.x = _arg_3 % 4 * 44;
        _arg_1.y = int(_arg_3 / 4) * 44;
        addChild(_arg_1);
    }

    private function addToolTipToTile(_arg_1:ItemTile):void {
        var _local2:* = null;
        if (_arg_1.itemSprite.itemId > 0) {
            this.tooltip = new EquipmentToolTip(_arg_1.itemSprite.itemId, this.curPlayer, !!this.owner ? this.owner.objectType_ : -1, this.getCharacterType());
        } else {
            if (_arg_1 is EquipmentTile) {
                _local2 = ItemConstants.itemTypeToName((_arg_1 as EquipmentTile).itemType);
            } else {
                _local2 = "item.toolTip";
            }
            this.tooltip = new TextToolTip(0x363636, 0x9b9b9b, null, "item.emptySlot", 200, {"itemType": TextKey.wrapForTokenResolution(_local2)});
        }
        this.tooltip.attachToTarget(_arg_1);
        this.addToolTip.dispatch(this.tooltip);
    }

    private function getCharacterType():String {
        if (this.owner == this.curPlayer) {
            return "CURRENT_PLAYER";
        }
        if (this.owner is Player) {
            return "OTHER_PLAYER";
        }
        return "NPC";
    }

    private function onTileHover(_arg_1:MouseEvent):void {
        if (!stage) {
            return;
        }
        var _local2:ItemTile = _arg_1.currentTarget as ItemTile;
        this.addToolTipToTile(_local2);
        this.tooltipFocusTile = _local2;
    }
}
}
