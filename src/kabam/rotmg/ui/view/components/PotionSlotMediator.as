package kabam.rotmg.ui.view.components {
import com.company.assembleegameclient.map.Map;
import com.company.assembleegameclient.objects.Player;
import com.company.assembleegameclient.ui.panels.itemgrids.itemtiles.InteractiveItemTile;
import com.company.assembleegameclient.util.DisplayHierarchy;

import flash.display.DisplayObject;

import kabam.rotmg.game.model.PotionInventoryModel;
import kabam.rotmg.game.model.UseBuyPotionVO;
import kabam.rotmg.game.signals.UseBuyPotionSignal;
import kabam.rotmg.messaging.impl.GameServerConnection;
import kabam.rotmg.ui.model.HUDModel;
import kabam.rotmg.ui.model.PotionModel;
import kabam.rotmg.ui.signals.UpdateHUDSignal;

import robotlegs.bender.bundles.mvcs.Mediator;

public class PotionSlotMediator extends Mediator {


    public function PotionSlotMediator() {
        super();
    }
    [Inject]
    public var view:PotionSlotView;
    [Inject]
    public var hudModel:HUDModel;
    [Inject]
    public var updateHUD:UpdateHUDSignal;
    [Inject]
    public var potionInventoryModel:PotionInventoryModel;
    [Inject]
    public var useBuyPotionSignal:UseBuyPotionSignal;
    private var blockingUpdate:Boolean = false;
    private var prevCount:int = -1;

    override public function initialize():void {
        this.updateHUD.addOnce(this.initializeData);
        this.view.drop.add(this.onDrop);
        this.view.buyUse.add(this.onBuyUse);
        this.updateHUD.add(this.update);
    }

    override public function destroy():void {
        this.view.drop.remove(this.onDrop);
        this.view.buyUse.remove(this.onBuyUse);
        this.updateHUD.remove(this.update);
    }

    private function initializeData(_arg_1:Player):void {
        var _local2:PotionModel = this.potionInventoryModel.potionModels[this.view.position];
        var _local3:int = _arg_1.getPotionCount(_local2.objectId);
        this.view.setData(_local3, _local2.currentCost(_local3), _local2.available, _local2.objectId);
    }

    private function update(_arg_1:Player) : void {
        var _local2:int = 0;
        var _local3:* = null;
        if((this.view.objectType == 2594 || this.view.objectType == 2595) && !this.blockingUpdate) {
            _local3 = this.potionInventoryModel.getPotionModel(this.view.objectType);
            _local2 = _arg_1.getPotionCount(_local3.objectId);
            if(_local2 != this.prevCount) {
                this.view.setData(_local2,_local3.currentCost(_local2),_local3.available);
                this.prevCount = _local2;
            }
        }
    }

    private function onDrop(_arg_1:DisplayObject):void {
        var _local3:* = null;
        var _local2:Player = this.hudModel.gameSprite.map.player_;
        var _local4:* = DisplayHierarchy.getParentWithTypeArray(_arg_1, InteractiveItemTile, Map);
        if (_local4 is Map || _local4 == null) {
            GameServerConnection.instance.invDrop(_local2, PotionInventoryModel.getPotionSlot(this.view.objectType), this.view.objectType);
        } else if (_local4 is InteractiveItemTile) {
            _local3 = _local4 as InteractiveItemTile;
            if (_local3.getItemId() == -1 && _local3.ownerGrid.owner != _local2) {
                GameServerConnection.instance.invSwapPotion(_local2, _local2, PotionInventoryModel.getPotionSlot(this.view.objectType), this.view.objectType, _local3.ownerGrid.owner, _local3.tileId, -1);
            }
        }
    }

    private function onBuyUse():void {
        var _local2:* = null;
        var _local1:PotionModel = this.potionInventoryModel.potionModels[this.view.position];
        if (_local1.available) {
            _local2 = new UseBuyPotionVO(_local1.objectId, UseBuyPotionVO.SHIFTCLICK);
            this.useBuyPotionSignal.dispatch(_local2);
        }
    }
}
}
