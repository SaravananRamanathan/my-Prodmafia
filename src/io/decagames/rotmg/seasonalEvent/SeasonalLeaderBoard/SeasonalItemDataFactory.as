package io.decagames.rotmg.seasonalEvent.SeasonalLeaderBoard {
import com.company.util.ConversionUtil;

import kabam.rotmg.assets.services.CharacterFactory;
import kabam.rotmg.classes.model.CharacterClass;
import kabam.rotmg.classes.model.CharacterSkin;
import kabam.rotmg.classes.model.ClassesModel;
import kabam.rotmg.core.model.PlayerModel;

public class SeasonalItemDataFactory {


    public function SeasonalItemDataFactory() {
        super();
    }
    [Inject]
    public var playerModel:PlayerModel;
    [Inject]
    public var classesModel:ClassesModel;
    [Inject]
    public var factory:CharacterFactory;
    private var seasonalLeaderBoardItemDatas:Vector.<SeasonalLeaderBoardItemData>;

    public function createSeasonalLeaderBoardItemDatas(_arg_1:XML):Vector.<SeasonalLeaderBoardItemData> {
        this.seasonalLeaderBoardItemDatas = new Vector.<SeasonalLeaderBoardItemData>(0);
        this.createItemsFromList(_arg_1.FameListElem);
        return this.seasonalLeaderBoardItemDatas;
    }

    public function createSeasonalLeaderBoardItemData(_arg_1:XML):SeasonalLeaderBoardItemData {
        var _local2:int = _arg_1.ObjectType;
        var _local6:int = _arg_1.Texture;
        var _local3:CharacterClass = this.classesModel.getCharacterClass(_local2);
        var _local9:CharacterSkin = _local3.skins.getSkin(_local6);
        var _local5:int = !_arg_1.hasOwnProperty("Tex1") ? 0 : _arg_1.Tex1;
        var _local4:int = !_arg_1.hasOwnProperty("Tex2") ? 0 : _arg_1.Tex2;
        var _local8:int = !_local9.is16x16 ? 100 : 50;
        var _local7:SeasonalLeaderBoardItemData = new SeasonalLeaderBoardItemData();
        _local7.rank = _arg_1.Rank;
        _local7.accountId = _arg_1.@accountId;
        _local7.charId = _arg_1.@charId;
        _local7.name = _arg_1.Name;
        _local7.totalFame = _arg_1.TotalFame;
        _local7.character = this.factory.makeIcon(_local9.template, _local8, _local5, _local4, _local7.rank <= 10);
        _local7.equipmentSlots = _local3.slotTypes;
        _local7.equipment = ConversionUtil.toIntVector(_arg_1.Equipment);
        return _local7;
    }

    private function createItemsFromList(_arg_1:XMLList):void {
        var _local2:* = null;
        var _local3:* = null;
        var _local5:int = 0;
        var _local4:* = _arg_1;
        for each(_local2 in _arg_1) {
            if (!this.seasonalLeaderBoardItemDatasContains(_local2)) {
                _local3 = this.createSeasonalLeaderBoardItemData(_local2);
                _local3.isOwn = _local2.Name == this.playerModel.getName();
                this.seasonalLeaderBoardItemDatas.push(_local3);
            }
        }
    }

    private function seasonalLeaderBoardItemDatasContains(_arg_1:XML):Boolean {
        var _local2:* = null;
        var _local4:int = 0;
        var _local3:* = this.seasonalLeaderBoardItemDatas;
        for each(_local2 in this.seasonalLeaderBoardItemDatas) {
            if (_local2.accountId == _arg_1.@accountId && _local2.charId == _arg_1.@charId) {
                return true;
            }
        }
        return false;
    }
}
}
