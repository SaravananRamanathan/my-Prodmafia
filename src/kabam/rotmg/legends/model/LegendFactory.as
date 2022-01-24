package kabam.rotmg.legends.model {
import com.company.util.ConversionUtil;

import kabam.rotmg.assets.services.CharacterFactory;
import kabam.rotmg.classes.model.CharacterClass;
import kabam.rotmg.classes.model.CharacterSkin;
import kabam.rotmg.classes.model.ClassesModel;
import kabam.rotmg.core.model.PlayerModel;

public class LegendFactory {


    public function LegendFactory() {
        super();
    }
    [Inject]
    public var playerModel:PlayerModel;
    [Inject]
    public var classesModel:ClassesModel;
    [Inject]
    public var factory:CharacterFactory;
    private var ownAccountId:String;
    private var legends:Vector.<Legend>;

    public function makeLegends(_arg_1:XML):Vector.<Legend> {
        this.ownAccountId = this.playerModel.getAccountId();
        this.legends = new Vector.<Legend>(0);
        this.makeLegendsFromList(_arg_1.FameListElem, false);
        this.makeLegendsFromList(_arg_1.MyFameListElem, true);
        return this.legends;
    }

    public function makeLegend(_arg_1:XML):Legend {
        var _local2:int = _arg_1.ObjectType;
        var _local6:int = _arg_1.Texture;
        var _local3:CharacterClass = this.classesModel.getCharacterClass(_local2);
        var _local9:CharacterSkin = _local3.skins.getSkin(_local6);
        var _local5:int = "Tex1" in _arg_1 ? _arg_1.Tex1 : 0;
        var _local4:int = "Tex2" in _arg_1 ? _arg_1.Tex2 : 0;
        var _local8:int = !!_local9.is16x16 ? 50 : 100;
        var _local7:Legend = new Legend();
        _local7.place = this.legends.length + 1;
        _local7.accountId = _arg_1.@accountId;
        _local7.charId = _arg_1.@charId;
        _local7.name = _arg_1.Name;
        _local7.totalFame = _arg_1.TotalFame;
        _local7.character = this.factory.makeIcon(_local9.template, _local8, _local5, _local4, _local7.place <= 10);
        _local7.equipmentSlots = _local3.slotTypes;
        _local7.equipment = ConversionUtil.toIntVector(_arg_1.Equipment);
        return _local7;
    }

    private function makeLegendsFromList(_arg_1:XMLList, _arg_2:Boolean):void {
        var _local3:* = null;
        var _local4:* = null;
        var _local6:int = 0;
        var _local5:* = _arg_1;
        for each(_local4 in _arg_1) {
            if (!this.legendsContains(_local4)) {
                _local3 = this.makeLegend(_local4);
                _local3.isOwnLegend = _local4.@accountId == this.ownAccountId;
                _local3.isFocus = _arg_2;
                this.legends.push(_local3);
            }
        }
    }

    private function legendsContains(_arg_1:XML):Boolean {
        var _local2:* = null;
        var _local4:int = 0;
        var _local3:* = this.legends;
        for each(_local2 in this.legends) {
            if (_local2.accountId == _arg_1.@accountId && _local2.charId == _arg_1.@charId) {
                return true;
            }
        }
        return false;
    }
}
}
