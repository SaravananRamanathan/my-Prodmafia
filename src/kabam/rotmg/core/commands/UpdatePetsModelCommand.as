package kabam.rotmg.core.commands {
import com.company.assembleegameclient.objects.ObjectLibrary;

import io.decagames.rotmg.pets.data.PetsModel;
import io.decagames.rotmg.pets.data.vo.PetVO;
import io.decagames.rotmg.pets.data.yard.PetYardEnum;

import robotlegs.bender.bundles.mvcs.Command;

public class UpdatePetsModelCommand extends Command {


    public function UpdatePetsModelCommand() {
        super();
    }
    [Inject]
    public var model:PetsModel;
    [Inject]
    public var data:XML;

    override public function execute():void {
        if ("PetYardType" in this.data.Account) {
            this.model.setPetYardType(this.parseYardFromXML());
        }
        if ("Pet" in this.data) {
            this.model.setActivePet(this.parsePetFromXML());
        }
    }

    private function parseYardFromXML():int {
        var _local1:* = null;
        var _local2:* = null;
        if (!(this.data.Account.PetYardType <= 5 && this.data.Account.PetYardType >= 0)) {
            _local1 = PetYardEnum.selectByOrdinal(1).value;
        } else {
            _local1 = PetYardEnum.selectByOrdinal(this.data.Account.PetYardType).value;
        }
        _local2 = ObjectLibrary.getXMLfromId(_local1);
        return _local2.@type;
    }

    private function parsePetFromXML():PetVO {
        var _local1:XMLList = this.data.Pet;
        var _local2:PetVO = this.model.getPetVO(_local1.@instanceId);
        _local2.apply(_local1[0]);
        return _local2;
    }
}
}
