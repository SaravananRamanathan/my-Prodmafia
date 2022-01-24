package kabam.rotmg.arena.service {
import com.company.util.ConversionUtil;

import io.decagames.rotmg.pets.data.vo.PetVO;

import kabam.rotmg.arena.model.ArenaLeaderboardEntry;
import kabam.rotmg.arena.model.CurrentArenaRunModel;
import kabam.rotmg.assets.services.CharacterFactory;
import kabam.rotmg.classes.model.CharacterClass;
import kabam.rotmg.classes.model.CharacterSkin;
import kabam.rotmg.classes.model.ClassesModel;

public class ArenaLeaderboardFactory {


    public function ArenaLeaderboardFactory() {
        super();
    }
    [Inject]
    public var classesModel:ClassesModel;
    [Inject]
    public var factory:CharacterFactory;
    [Inject]
    public var currentRunModel:CurrentArenaRunModel;

    public function makeEntries(_arg_1:XMLList):Vector.<ArenaLeaderboardEntry> {
        var _local3:* = null;
        var _local2:Vector.<ArenaLeaderboardEntry> = new Vector.<ArenaLeaderboardEntry>();
        var _local4:int = 1;
        var _local6:int = 0;
        var _local5:* = _arg_1;
        for each(_local3 in _arg_1) {
            _local2.push(this.makeArenaEntry(_local3, _local4));
            _local4++;
        }
        _local2 = this.removeDuplicateUser(_local2);
        return this.addCurrentRun(_local2);
    }

    private function addCurrentRun(_arg_1:Vector.<ArenaLeaderboardEntry>):Vector.<ArenaLeaderboardEntry> {
        var _local5:Boolean = false;
        var _local4:Boolean = false;
        var _local3:* = null;
        var _local2:Vector.<ArenaLeaderboardEntry> = new Vector.<ArenaLeaderboardEntry>();
        if (this.currentRunModel.hasEntry()) {
            _local5 = false;
            _local4 = false;
            var _local7:int = 0;
            var _local6:* = _arg_1;
            for each(_local3 in _arg_1) {
                if (!_local5 && this.currentRunModel.entry.isBetterThan(_local3)) {
                    this.currentRunModel.entry.rank = _local3.rank;
                    _local2.push(this.currentRunModel.entry);
                    _local5 = true;
                }
                if (_local3.isPersonalRecord) {
                    _local4 = true;
                }
                if (_local5) {
                    _local3.rank++;
                }
                _local2.push(_local3);
            }
            if (_local2.length < 20 && !_local5 && !_local4) {
                this.currentRunModel.entry.rank = _local2.length + 1;
                _local2.push(this.currentRunModel.entry);
            }
        }
        return _local2.length > 0 ? _local2 : _arg_1;
    }

    private function removeDuplicateUser(_arg_1:Vector.<ArenaLeaderboardEntry>):Vector.<ArenaLeaderboardEntry> {
        var _local5:Boolean = false;
        var _local4:* = null;
        var _local3:* = null;
        var _local2:int = -1;
        if (this.currentRunModel.hasEntry()) {
            _local5 = false;
            _local4 = this.currentRunModel.entry;
            var _local7:int = 0;
            var _local6:* = _arg_1;
            for each(_local3 in _arg_1) {
                if (_local3.isPersonalRecord && _local4.isBetterThan(_local3)) {
                    _local2 = _local3.rank - 1;
                    _local5 = true;
                } else if (_local5) {
                    _local3.rank--;
                }
            }
        }
        if (_local2 != -1) {
            _arg_1.splice(_local2, 1);
        }
        return _arg_1;
    }

    private function makeArenaEntry(_arg_1:XML, _arg_2:int):ArenaLeaderboardEntry {
        var _local9:* = null;
        var _local6:* = null;
        var _local8:ArenaLeaderboardEntry = new ArenaLeaderboardEntry();
        _local8.isPersonalRecord = "IsPersonalRecord" in _arg_1;
        _local8.runtime = _arg_1.Time;
        _local8.name = _arg_1.PlayData.CharacterData.Name;
        _local8.rank = "Rank" in _arg_1 ? _arg_1.Rank : _arg_2;
        var _local11:int = _arg_1.PlayData.CharacterData.Texture;
        var _local10:int = _arg_1.PlayData.CharacterData.Class;
        var _local7:CharacterClass = this.classesModel.getCharacterClass(_local10);
        var _local5:CharacterSkin = _local7.skins.getSkin(_local11);
        var _local4:int = "Tex1" in _arg_1.PlayData.CharacterData ? _arg_1.PlayData.CharacterData.Tex1 : 0;
        var _local3:int = "Tex2" in _arg_1.PlayData.CharacterData ? _arg_1.PlayData.CharacterData.Tex2 : 0;
        _local8.playerBitmap = this.factory.makeIcon(_local5.template, !!_local5.is16x16 ? 50 : 100, _local4, _local3);
        _local8.equipment = ConversionUtil.toIntVector(_arg_1.PlayData.CharacterData.Inventory);
        _local8.slotTypes = _local7.slotTypes;
        _local8.guildName = _arg_1.PlayData.CharacterData.GuildName;
        _local8.guildRank = _arg_1.PlayData.CharacterData.GuildRank;
        _local8.currentWave = _arg_1.WaveNumber;
        if ("Pet" in _arg_1.PlayData) {
            _local9 = new PetVO();
            _local6 = new XML(_arg_1.PlayData.Pet);
            _local9.apply(_local6);
            _local8.pet = _local9;
        }
        return _local8;
    }
}
}
