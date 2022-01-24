package kabam.rotmg.ui.model {
import flash.events.TimerEvent;
import flash.utils.Timer;

import org.osflash.signals.Signal;
import org.osflash.signals.natives.NativeSignal;

public class PotionModel {


    public function PotionModel() {
        super();
        this.update = new Signal(int);
        this.available = true;
    }
    public var objectId:uint;
    public var maxPotionCount:int;
    public var position:int;
    public var available:Boolean;
    public var update:Signal;
    private var costIndex:int;
    private var costCoolDownTimer:Timer;
    private var costTimerSignal:NativeSignal;
    private var purchaseCoolDownTimer:Timer;
    private var purchaseTimerSignal:NativeSignal;

    private var _costs:Array;

    public function get costs():Array {
        return this._costs;
    }

    public function set costs(_arg_1:Array):void {
        this._costs = _arg_1;
        if (_arg_1 != null && _arg_1.length > 0) {
            this.costIndex = 0;
        }
    }

    private var _priceCooldownMillis:uint;

    public function set priceCooldownMillis(_arg_1:uint):void {
        this._priceCooldownMillis = _arg_1;
        this.costCoolDownTimer = new Timer(_arg_1, 0);
        this.costTimerSignal = new NativeSignal(this.costCoolDownTimer, "timer", TimerEvent);
        this.costTimerSignal.add(this.coolDownPrice);
    }

    public var _purchaseCooldownMillis:uint;

    public function set purchaseCooldownMillis(_arg_1:uint):void {
        this._purchaseCooldownMillis = _arg_1;
        this.purchaseCoolDownTimer = new Timer(_arg_1, 0);
        this.purchaseTimerSignal = new NativeSignal(this.purchaseCoolDownTimer, "timer", TimerEvent);
        this.purchaseTimerSignal.add(this.coolDownPurchase);
    }

    public function purchasedPot():void {
        if (this.available) {
            this.costCoolDownTimer.reset();
            this.costCoolDownTimer.start();
            this.purchaseCoolDownTimer.reset();
            this.purchaseCoolDownTimer.start();
            this.available = false;
            if (this.costIndex < this.costs.length - 1) {
                this.costIndex++;
            }
            this.update.dispatch(this.position);
        }
    }

    public function currentCost(_arg_1:int):int {
        var _local2:int = 0;
        if (_arg_1 <= 0) {
            _local2 = this.costs[this.costIndex];
        }
        return _local2;
    }

    private function coolDownPurchase(_arg_1:TimerEvent):void {
        if (this.costIndex == 0) {
            this.purchaseCoolDownTimer.stop();
        }
        this.available = true;
        this.update.dispatch(this.position);
    }

    private function coolDownPrice(_arg_1:TimerEvent):void {
        this.costIndex--;
        if (this.costIndex == 0) {
            this.costCoolDownTimer.stop();
        }
        this.update.dispatch(this.position);
    }
}
}
