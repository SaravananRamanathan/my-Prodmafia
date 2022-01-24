package kabam.rotmg.mysterybox.services {
import kabam.rotmg.mysterybox.model.MysteryBoxInfo;

import org.osflash.signals.Signal;

public class MysteryBoxModel {


    public const updateSignal:Signal = new Signal();

    public function MysteryBoxModel() {
        super();
    }
    private var models:Object;
    private var initialized:Boolean = false;
    private var maxSlots:int = 18;

    private var _isNew:Boolean = false;

    public function get isNew():Boolean {
        return this._isNew;
    }

    public function set isNew(_arg_1:Boolean):void {
        this._isNew = _arg_1;
    }

    public function getBoxesOrderByWeight():Object {
        return this.models;
    }

    public function getBoxesForGrid():Vector.<MysteryBoxInfo> {
        var _local2:* = null;
        var _local1:Vector.<MysteryBoxInfo> = new Vector.<MysteryBoxInfo>(this.maxSlots);
        var _local4:int = 0;
        var _local3:* = this.models;
        for each(_local2 in this.models) {
            if (_local2.slot != 0 && this.isBoxValid(_local2)) {
                _local1[_local2.slot - 1] = _local2;
            }
        }
        return _local1;
    }

    public function getBoxById(_arg_1:String):MysteryBoxInfo {
        var _local2:* = null;
        var _local4:int = 0;
        var _local3:* = this.models;
        for each(_local2 in this.models) {
            if (_local2.id == _arg_1) {
                return _local2;
            }
        }
        return null;
    }

    public function setMysetryBoxes(_arg_1:Array):void {
        var _local2:* = null;
        this.models = {};
        var _local4:int = 0;
        var _local3:* = _arg_1;
        for each(_local2 in _arg_1) {
            this.models[_local2.id] = _local2;
        }
        this.updateSignal.dispatch();
        this.initialized = true;
    }

    public function isInitialized():Boolean {
        return this.initialized;
    }

    public function setInitialized(_arg_1:Boolean):void {
        this.initialized = _arg_1;
    }

    private function isBoxValid(_arg_1:MysteryBoxInfo):Boolean {
        return (_arg_1.unitsLeft == -1 || _arg_1.unitsLeft > 0) && (_arg_1.maxPurchase == -1 || _arg_1.purchaseLeft > 0);
    }
}
}
