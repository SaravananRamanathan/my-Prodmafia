package com.company.assembleegameclient.ui.panels.mediators {
import com.company.assembleegameclient.map.Map;
import com.company.assembleegameclient.objects.Container;
import com.company.assembleegameclient.objects.GameObject;
import com.company.assembleegameclient.objects.ObjectLibrary;
import com.company.assembleegameclient.objects.OneWayContainer;
import com.company.assembleegameclient.objects.Player;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.ui.panels.itemgrids.ContainerGrid;
import com.company.assembleegameclient.ui.panels.itemgrids.InventoryGrid;
import com.company.assembleegameclient.ui.panels.itemgrids.ItemGrid;
import com.company.assembleegameclient.ui.panels.itemgrids.itemtiles.InteractiveItemTile;
import com.company.assembleegameclient.ui.panels.itemgrids.itemtiles.ItemTile;
import com.company.assembleegameclient.ui.panels.itemgrids.itemtiles.ItemTileEvent;
import com.company.assembleegameclient.ui.tooltip.ToolTip;
import com.company.assembleegameclient.util.DisplayHierarchy;

import io.decagames.rotmg.pets.data.PetsModel;

import kabam.rotmg.chat.model.ChatMessage;
import kabam.rotmg.core.model.MapModel;
import kabam.rotmg.core.model.PlayerModel;
import kabam.rotmg.core.signals.ShowTooltipSignal;
import kabam.rotmg.game.model.PotionInventoryModel;
import kabam.rotmg.game.signals.AddTextLineSignal;
import kabam.rotmg.game.view.components.TabStripView;
import kabam.rotmg.messaging.impl.GameServerConnection;
import kabam.rotmg.ui.model.HUDModel;
import kabam.rotmg.ui.model.TabStripModel;

import robotlegs.bender.bundles.mvcs.Mediator;

public class ItemGridMediator extends Mediator {


    public function ItemGridMediator() {
        super();
    }
    [Inject]
    public var view:ItemGrid;
    [Inject]
    public var mapModel:MapModel;
    [Inject]
    public var playerModel:PlayerModel;
    [Inject]
    public var potionInventoryModel:PotionInventoryModel;
    [Inject]
    public var hudModel:HUDModel;
    [Inject]
    public var tabStripModel:TabStripModel;
    [Inject]
    public var showToolTip:ShowTooltipSignal;
    [Inject]
    public var petsModel:PetsModel;
    [Inject]
    public var addTextLine:AddTextLineSignal;

    override public function initialize():void {
        this.view.addEventListener("ITEM_MOVE", this.onTileMove);
        this.view.addEventListener("ITEM_SHIFT_CLICK", this.onShiftClick);
        this.view.addEventListener("ITEM_DOUBLE_CLICK", this.onDoubleClick);
        this.view.addEventListener("ITEM_CTRL_CLICK", this.onCtrlClick);
        this.view.addToolTip.add(this.onAddToolTip);
    }

    override public function destroy():void {
        super.destroy();
    }

    private function onAddToolTip(_arg_1:ToolTip):void {
        this.showToolTip.dispatch(_arg_1);
    }

    private function addToPotionStack(_arg_1:InteractiveItemTile):void {
        if (!GameServerConnection.instance || !this.view.interactive || !_arg_1 || this.potionInventoryModel.getPotionModel(_arg_1.getItemId()).maxPotionCount <= this.hudModel.gameSprite.map.player_.getPotionCount(_arg_1.getItemId())) {
            return;
        }
        GameServerConnection.instance.invSwapPotion(this.view.curPlayer, this.view.owner, _arg_1.tileId, _arg_1.itemSprite.itemId, this.view.curPlayer, PotionInventoryModel.getPotionSlot(_arg_1.getItemId()), -1);
        _arg_1.setItem(-1);
        _arg_1.updateUseability(this.view.curPlayer);
    }

    private function canSwapItems(_arg_1:InteractiveItemTile, _arg_2:InteractiveItemTile):Boolean {
        if (!_arg_1.canHoldItem(_arg_2.getItemId())) {
            return false;
        }
        if (!_arg_2.canHoldItem(_arg_1.getItemId())) {
            return false;
        }
        if (ItemGrid(_arg_2.parent).owner is OneWayContainer) {
            return false;
        }
        if (_arg_1.blockingItemUpdates || _arg_2.blockingItemUpdates) {
            return false;
        }
        return true;
    }

    private function dropItem(_arg_1:InteractiveItemTile):void {
        var _local8:* = null;
        var _local5:* = undefined;
        var _local4:int = 0;
        var _local7:int = 0;
        var _local2:Boolean = ObjectLibrary.isSoulbound(_arg_1.itemSprite.itemId);
        var _local6:Boolean = ObjectLibrary.isDropTradable(_arg_1.itemSprite.itemId);
        var _local3:Container = this.view.owner as Container;
        if (this.view.owner == this.view.curPlayer || _local3 && _local3.ownerId_ == this.view.curPlayer.accountId_ && !_local2) {
            _local8 = this.mapModel.currentInteractiveTarget as Container;
            if (_local8 && !(!_local8.canHaveSoulbound_ && !_local6 || _local8.canHaveSoulbound_ && _local8.isLoot_ && _local6)) {
                _local5 = _local8.equipment_;
                _local4 = _local5.length;
                _local7 = 0;
                while (_local7 < _local4) {
                    if (_local5[_local7] >= 0) {
                        _local7++;
                        continue;
                    }
                    break;
                }
                if (_local7 < _local4) {
                    this.dropWithoutDestTile(_arg_1, _local8, _local7);
                } else {
                    GameServerConnection.instance.invDrop(this.view.owner, _arg_1.tileId, _arg_1.getItemId());
                }
            } else {
                GameServerConnection.instance.invDrop(this.view.owner, _arg_1.tileId, _arg_1.getItemId());
            }
        } else if (_local3.canHaveSoulbound_ && _local3.isLoot_ && _local6) {
            GameServerConnection.instance.invDrop(this.view.owner, _arg_1.tileId, _arg_1.getItemId());
        }
        _arg_1.setItem(-1);
    }

    private function swapItemTiles(_arg_1:ItemTile, _arg_2:ItemTile):Boolean {
        if (!GameServerConnection.instance || !this.view.interactive || !_arg_1 || !_arg_2) {
            return false;
        }
        GameServerConnection.instance.invSwap(this.view.curPlayer, this.view.owner, _arg_1.tileId, _arg_1.itemSprite.itemId, _arg_2.ownerGrid.owner, _arg_2.tileId, _arg_2.itemSprite.itemId);
        var _local3:int = _arg_1.getItemId();
        _arg_1.setItem(_arg_2.getItemId());
        _arg_2.setItem(_local3);
        _arg_1.updateUseability(this.view.curPlayer);
        _arg_2.updateUseability(this.view.curPlayer);
        return true;
    }

    private function dropWithoutDestTile(_arg_1:ItemTile, _arg_2:Container, _arg_3:int):void {
        if (!GameServerConnection.instance || !this.view.interactive || !_arg_1 || !_arg_2) {
            return;
        }
        GameServerConnection.instance.invSwap(this.view.curPlayer, this.view.owner, _arg_1.tileId, _arg_1.itemSprite.itemId, _arg_2, _arg_3, -1);
        _arg_1.setItem(-1);
    }

    private function isStackablePotion(_arg_1:InteractiveItemTile):Boolean {
        return _arg_1.getItemId() == 2594 || _arg_1.getItemId() == 2595;
    }

    private function pickUpItem(_arg_1:InteractiveItemTile):void {
        var _local2:int = this.view.curPlayer.nextAvailableInventorySlot();
        if (_local2 != -1) {
            GameServerConnection.instance.invSwap(this.view.curPlayer, this.view.owner, _arg_1.tileId, _arg_1.itemSprite.itemId, this.view.curPlayer, _local2, -1);
        }
    }

    private function equipOrUseContainer(_arg_1:InteractiveItemTile):void {
        var _local2:GameObject = _arg_1.ownerGrid.owner;
        var _local4:Player = this.view.curPlayer;
        var _local3:int = this.view.curPlayer.nextAvailableInventorySlot();
        if (_local3 != -1) {
            GameServerConnection.instance.invSwap(_local4, this.view.owner, _arg_1.tileId, _arg_1.itemSprite.itemId, this.view.curPlayer, _local3, -1);
        } else {
            GameServerConnection.instance.useItem_new(_local2, _arg_1.tileId);
        }
    }

    private function equipOrUseInventory(_arg_1:InteractiveItemTile):void {
        var _local2:GameObject = _arg_1.ownerGrid.owner;
        var _local4:Player = this.view.curPlayer;
        var _local3:int = ObjectLibrary.getMatchingSlotIndex(_arg_1.getItemId(), _local4);
        if (_local3 != -1) {
            GameServerConnection.instance.invSwap(_local4, _local2, _arg_1.tileId, _arg_1.getItemId(), _local4, _local3, _local4.equipment_[_local3]);
        } else {
            GameServerConnection.instance.useItem_new(_local2, _arg_1.tileId);
        }
    }

    private function onTileMove(_arg_1:ItemTileEvent):void {
        var _local4:* = null;
        var _local3:* = null;
        var _local5:int = 0;
        var _local2:InteractiveItemTile = _arg_1.tile;
        var _local6:* = DisplayHierarchy.getParentWithTypeArray(_local2.getDropTarget(), TabStripView, InteractiveItemTile, Map);
        if (_local2.getItemId() == 2594 || _local2.getItemId() == 2595) {
            this.onPotionMove(_arg_1);
            return;
        }
        if (_local6 is InteractiveItemTile) {
            _local4 = _local6 as InteractiveItemTile;
            if (this.view.curPlayer.lockedSlot[_local4.tileId] == 0) {
                if (this.canSwapItems(_local2, _local4)) {
                    this.swapItemTiles(_local2, _local4);
                }
            } else {
                this.addTextLine.dispatch(ChatMessage.make("*Error*", "You cannot put items into this slot right now."));
            }
        } else if (_local6 is TabStripView) {
            _local3 = _local6 as TabStripView;
            _local5 = _local2.ownerGrid.curPlayer.nextAvailableInventorySlot();
            if (_local5 != -1) {
                GameServerConnection.instance.invSwap(this.view.curPlayer, _local2.ownerGrid.owner, _local2.tileId, _local2.itemSprite.itemId, this.view.curPlayer, _local5, -1);
                _local2.setItem(-1);
                _local2.updateUseability(this.view.curPlayer);
            }
        } else if (_local6 is Map || this.hudModel.gameSprite.map.mouseX < 5 * 60) {
            this.dropItem(_local2);
        }
        _local2.resetItemPosition();
    }

    private function onPotionMove(_arg_1:ItemTileEvent):void {
        var _local2:InteractiveItemTile = _arg_1.tile;
        var _local3:* = DisplayHierarchy.getParentWithTypeArray(_local2.getDropTarget(), TabStripView, Map);
        if (_local3 is TabStripView) {
            this.addToPotionStack(_local2);
        } else if (_local3 is Map || this.hudModel.gameSprite.map.mouseX < 5 * 60) {
            this.dropItem(_local2);
        }
        _local2.resetItemPosition();
    }

    private function onShiftClick(_arg_1:ItemTileEvent):void {
        var _local2:InteractiveItemTile = _arg_1.tile;
        if (_local2.ownerGrid is InventoryGrid || _local2.ownerGrid is ContainerGrid) {
            GameServerConnection.instance.useItem_new(_local2.ownerGrid.owner, _local2.tileId);
        }
    }

    private function onCtrlClick(_arg_1:ItemTileEvent):void {
        var _local2:* = null;
        var _local3:int = 0;
        if (Parameters.data.inventorySwap) {
            _local2 = _arg_1.tile;
            if (_local2.ownerGrid is InventoryGrid) {
                _local3 = _local2.ownerGrid.curPlayer.swapInventoryIndex(this.tabStripModel.currentSelection);
                if (_local3 != -1) {
                    GameServerConnection.instance.invSwap(this.view.curPlayer, _local2.ownerGrid.owner, _local2.tileId, _local2.itemSprite.itemId, this.view.curPlayer, _local3, -1);
                    _local2.setItem(-1);
                    _local2.updateUseability(this.view.curPlayer);
                }
            }
        }
    }

    private function onDoubleClick(_arg_1:ItemTileEvent):void {
        var _local2:InteractiveItemTile = _arg_1.tile;
        if (this.isStackablePotion(_local2)) {
            this.addToPotionStack(_local2);
        } else if (_local2.ownerGrid is ContainerGrid) {
            this.equipOrUseContainer(_local2);
        } else {
            this.equipOrUseInventory(_local2);
        }
        this.view.refreshTooltip();
    }
}
}
