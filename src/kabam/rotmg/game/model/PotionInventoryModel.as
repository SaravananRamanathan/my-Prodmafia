package kabam.rotmg.game.model {
import flash.utils.Dictionary;

import kabam.rotmg.ui.model.PotionModel;

import org.osflash.signals.Signal;

public class PotionInventoryModel {

    public static const HEALTH_POTION_ID:int = 2594;

    public static const HEALTH_POTION_SLOT:int = 254;

    public static const MAGIC_POTION_ID:int = 2595;

    public static const MAGIC_POTION_SLOT:int = 255;

    public static function getPotionSlot(_arg_1:int):int {
        switch (int(_arg_1) - 2594) {
            case 0:
                return 254;
            case 1:
                return 255;
        }

        return -1;
    }

    public function PotionInventoryModel() {
        super();
        this.potionModels = new Dictionary();
        this.updatePosition = new Signal(int);
    }
    public var potionModels:Dictionary;
    public var updatePosition:Signal;

    public function initializePotionModels(_arg_1:XML):void {
        var _local5:int = 0;
        var _local4:* = null;
        var _local2:int = _arg_1.PotionPurchaseCooldown;
        var _local6:int = _arg_1.PotionPurchaseCostCooldown;
        var _local3:int = _arg_1.MaxStackablePotions;
        var _local7:* = [];
        var _local9:int = 0;
        var _local8:* = _arg_1.PotionPurchaseCosts.cost;
        for each(_local5 in _arg_1.PotionPurchaseCosts.cost) {
            _local7.push(_local5);
        }
        _local4 = new PotionModel();
        _local4.purchaseCooldownMillis = _local2;
        _local4.priceCooldownMillis = _local6;
        _local4.maxPotionCount = _local3;
        _local4.objectId = 2594;
        _local4.position = 0;
        _local4.costs = _local7;
        this.potionModels[_local4.position] = _local4;
        _local4.update.add(this.update);
        _local4 = new PotionModel();
        _local4.purchaseCooldownMillis = _local2;
        _local4.priceCooldownMillis = _local6;
        _local4.maxPotionCount = _local3;
        _local4.objectId = 2595;
        _local4.position = 1;
        _local4.costs = _local7;
        this.potionModels[_local4.position] = _local4;
        _local4.update.add(this.update);
    }

    public function getPotionModel(_arg_1:uint):PotionModel {
        var _local2:* = undefined;
        var _local4:int = 0;
        var _local3:* = this.potionModels;
        for (_local2 in this.potionModels) {
            if (this.potionModels[_local2].objectId == _arg_1) {
                return this.potionModels[_local2];
            }
        }
        return null;
    }

    private function update(_arg_1:int):void {
        this.updatePosition.dispatch(_arg_1);
    }
}
}
