package kabam.rotmg.packages.services {
import kabam.rotmg.packages.model.PackageInfo;

import org.osflash.signals.Signal;

public class PackageModel {

    public static const TARGETING_BOX_SLOT:int = 100;


    public const updateSignal:Signal = new Signal();

    public function PackageModel() {
        models = {};
        super();
    }
    public var numSpammed:int = 0;
    private var models:Object;
    private var initialized:Boolean;
    private var maxSlots:int = 18;

    public function getBoxesForGrid():Vector.<PackageInfo> {
        var _local2:* = null;
        var _local1:Vector.<PackageInfo> = new Vector.<PackageInfo>(this.maxSlots);
        var _local4:int = 0;
        var _local3:* = this.models;
        for each(_local2 in this.models) {
            if (_local2.slot != 0 && _local2.slot != 100 && this.isPackageValid(_local2)) {
                _local1[_local2.slot - 1] = _local2;
            }
        }
        return _local1;
    }

    public function getTargetingBoxesForGrid():Vector.<PackageInfo> {
        var _local2:* = null;
        var _local1:Vector.<PackageInfo> = new Vector.<PackageInfo>(this.maxSlots);
        var _local4:int = 0;
        var _local3:* = this.models;
        for each(_local2 in this.models) {
            if (_local2.slot == 100 && this.isPackageValid(_local2)) {
                _local1.push(_local2);
            }
        }
        return _local1;
    }

    public function startupPackage():PackageInfo {
        var _local2:* = null;
        var _local1:* = null;
        var _local4:int = 0;
        var _local3:* = this.models;
        for each(_local2 in this.models) {
            if (_local2.slot == 100) {
                return _local2;
            }
            if (this.isPackageValid(_local2) && _local2.showOnLogin && _local2.popupImage != "") {
                if (_local1 != null) {
                    if (_local2.unitsLeft != -1 || _local2.maxPurchase != -1) {
                        _local1 = _local2;
                    }
                } else {
                    _local1 = _local2;
                }
            }
        }
        return _local1;
    }

    public function getInitialized():Boolean {
        return this.initialized;
    }

    public function getPackageById(_arg_1:int):PackageInfo {
        return this.models[_arg_1];
    }

    public function hasPackage(_arg_1:int):Boolean {
        return _arg_1 in this.models;
    }

    public function setPackages(_arg_1:Array):void {
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

    public function canPurchasePackage(_arg_1:int):Boolean {
        return this.models[_arg_1] != null;
    }

    public function getPriorityPackage():PackageInfo {
        return null;
    }

    public function setInitialized(_arg_1:Boolean):void {
        this.initialized = _arg_1;
    }

    public function hasPackages():Boolean {
        var _local1:* = null;
        var _local3:int = 0;
        var _local2:* = this.models;
        for each(_local1 in this.models) {
            return true;
        }
        return false;
    }

    private function isPackageValid(_arg_1:PackageInfo):Boolean {
        return (_arg_1.unitsLeft == -1 || _arg_1.unitsLeft > 0) && (_arg_1.maxPurchase == -1 || _arg_1.purchaseLeft > 0);
    }
}
}
