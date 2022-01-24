package kabam.rotmg.classes.model {
import org.osflash.signals.Signal;

public class ClassesModel {

    public static const WIZARD_ID:int = 782;


    public const selected:Signal = new Signal(CharacterClass);

    private const map:Object = {};

    private const classes:Vector.<CharacterClass> = new Vector.<CharacterClass>(0);

    public function ClassesModel() {
        super();
    }
    private var count:uint = 0;
    private var selectedChar:CharacterClass;

    public function resetCharacterSkinsSelection():void {
        var _local1:* = null;
        var _local3:int = 0;
        var _local2:* = this.classes;
        for each(_local1 in this.classes) {
            _local1.resetSkin();
        }
    }

    public function getCount():uint {
        return this.count;
    }

    public function getClassAtIndex(_arg_1:int):CharacterClass {
        return this.classes[_arg_1];
    }

    public function getCharacterClass(_arg_1:int):CharacterClass {
        var _local2:* = this.map[_arg_1] || this.makeCharacterClass();
        this.map[_arg_1] = _local2;
        return _local2;
    }

    public function getSelected():CharacterClass {
        return this.selectedChar || this.getCharacterClass(782);
    }

    public function getCharacterSkin(_arg_1:int):CharacterSkin {
        var _local2:* = null;
        var _local3:* = null;
        var _local5:int = 0;
        var _local4:* = this.classes;
        for each(_local3 in this.classes) {
            _local2 = _local3.skins.getSkin(_arg_1);
            if (_local2 == _local3.skins.getDefaultSkin()) {
                continue;
            }
            break;
        }
        return _local2;
    }

    private function makeCharacterClass():CharacterClass {
        var _local1:CharacterClass = new CharacterClass();
        _local1.selected.add(this.onClassSelected);
        this.count = this.classes.push(_local1);
        return _local1;
    }

    private function onClassSelected(_arg_1:CharacterClass):void {
        if (this.selectedChar != _arg_1) {
            this.selectedChar && this.selectedChar.setIsSelected(false);
            this.selectedChar = _arg_1;
            this.selected.dispatch(_arg_1);
        }
    }
}
}
