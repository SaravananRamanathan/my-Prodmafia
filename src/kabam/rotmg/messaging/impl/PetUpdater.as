package kabam.rotmg.messaging.impl {
import com.company.assembleegameclient.game.AGameSprite;
import com.company.assembleegameclient.objects.Pet;

import io.decagames.rotmg.pets.data.PetsModel;
import io.decagames.rotmg.pets.data.vo.PetVO;

import kabam.rotmg.messaging.impl.data.StatData;

public class PetUpdater {


    public function PetUpdater() {
        super();
    }
    [Inject]
    public var petsModel:PetsModel;
    [Inject]
    public var gameSprite:AGameSprite;

    public function updatePetVOs(_arg_1:Pet, _arg_2:Vector.<StatData>, _arg_3:Boolean = true):void {
        var _local4:int = 0;
        var _local6:* = 0;
        var _local5:* = null;
        var _local7:* = null;
        if (!_arg_3) {
            return;
        }
        var _local8:PetVO = _arg_1.vo || this.createPetVO(_arg_1, _arg_2);
        if (_local8 == null) {
            return;
        }
        var _local10:int = 0;
        var _local9:* = _arg_2;
        for each(_local7 in _arg_2) {
            _local4 = _local7.statValue_;
            _local6 = uint(_local7.statType_);
            if (_local6 == 80) {
                _local8.setSkin(_local4);
            } else if (_local6 == 81) {
                _local8.setID(_local4);
            } else if (_local6 == 82) {
                _local8.setName(_local7.strStatValue_);
            } else if (_local6 == 83) {
                _local8.setType(_local4);
            } else if (_local6 == 84) {
                _local8.setRarity(_local4);
            } else if (_local6 == 85) {
                _local8.setMaxAbilityPower(_local4);
            } else if (_local6 == 87) {
                _local5 = _local8.abilityList[0];
                _local5.points = _local4;
            } else if (_local6 == 88) {
                _local5 = _local8.abilityList[1];
                _local5.points = _local4;
            } else if (_local6 == 89) {
                _local5 = _local8.abilityList[2];
                _local5.points = _local4;
            } else if (_local6 == 90) {
                _local5 = _local8.abilityList[0];
                _local5.level = _local4;
            } else if (_local6 == 91) {
                _local5 = _local8.abilityList[1];
                _local5.level = _local4;
            } else if (_local6 == 92) {
                _local5 = _local8.abilityList[2];
                _local5.level = _local4;
            } else if (_local6 == 93) {
                _local5 = _local8.abilityList[0];
                _local5.type = _local4;
            } else if (_local6 == 94) {
                _local5 = _local8.abilityList[1];
                _local5.type = _local4;
            } else if (_local6 == 95) {
                _local5 = _local8.abilityList[2];
                _local5.type = _local4;
            }
            if (_local5) {
                _local5.updated.dispatch(_local5);
            }
        }
    }

    public function updatePet(_arg_1:Pet, _arg_2:Vector.<StatData>):void {
        var _local3:int = 0;
        var _local4:StatData = null;
        for each(_local4 in _arg_2) {
            _local3 = _local4.statValue_;
            if (_local4.statType_ == 80) {
                _arg_1.setSkin(_local3, false);
            }
            if (_local4.statType_ == 2) {
                _arg_1.size_ = _local3;
            }
            if (_local4.statType_ == 29) {
                _arg_1.condition_[0] = _local3;
            }
        }
    }

    private function createPetVO(_arg_1:Pet, _arg_2:Vector.<StatData>):PetVO {
        var _local3:* = null;
        var _local4:* = null;
        var _local6:int = 0;
        var _local5:* = _arg_2;
        for each(_local4 in _arg_2) {
            if (_local4.statType_ == 81) {
                _local3 = this.petsModel.getCachedVOOnly(_local4.statValue_);
                _arg_1.vo = !!_local3 ? _local3 : !!this.gameSprite.map.isPetYard ? this.petsModel.getPetVO(_local4.statValue_) : new PetVO(_local4.statValue_);
                return _arg_1.vo;
            }
        }
        return null;
    }
}
}
