package kabam.rotmg.classes.control {
import kabam.rotmg.classes.model.CharacterClass;
import kabam.rotmg.classes.model.CharacterSkin;
import kabam.rotmg.classes.model.CharacterSkinState;
import kabam.rotmg.classes.model.ClassesModel;

public class ResetClassDataCommand {


    public function ResetClassDataCommand() {
        super();
    }
    [Inject]
    public var classes:ClassesModel;

    public function execute():void {
        var _local2:int = 0;
        var _local1:int = this.classes.getCount();
        while (_local2 < _local1) {
            this.resetClass(this.classes.getClassAtIndex(_local2));
            _local2++;
        }
    }

    private function resetClass(_arg_1:CharacterClass):void {
        _arg_1.setIsSelected(_arg_1.id == 782);
        this.resetClassSkins(_arg_1);
    }

    private function resetClassSkins(_arg_1:CharacterClass):void {
        var _local3:* = null;
        var _local4:int = 0;
        var _local2:CharacterSkin = _arg_1.skins.getDefaultSkin();
        var _local5:int = _arg_1.skins.getCount();
        while (_local4 < _local5) {
            _local3 = _arg_1.skins.getSkinAt(_local4);
            if (_local3 != _local2) {
                this.resetSkin(_arg_1.skins.getSkinAt(_local4));
            }
            _local4++;
        }
    }

    private function resetSkin(_arg_1:CharacterSkin):void {
        _arg_1.setState(CharacterSkinState.LOCKED);
    }
}
}
