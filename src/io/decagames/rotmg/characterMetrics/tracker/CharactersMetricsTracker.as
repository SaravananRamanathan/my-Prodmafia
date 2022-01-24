package io.decagames.rotmg.characterMetrics.tracker {
import com.hurlant.util.Base64;

import flash.utils.Dictionary;
import flash.utils.IDataInput;

import io.decagames.rotmg.characterMetrics.data.CharacterMetricsData;

public class CharactersMetricsTracker {

    public static const STATS_SIZE:int = 5;

    public function CharactersMetricsTracker() {
        super();
    }
    private var charactersStats:Dictionary;

    private var _lastUpdate:Date;

    public function get lastUpdate():Date {
        return this._lastUpdate;
    }

    public function setBinaryStringData(_arg_1:int, _arg_2:String):void {
        var _local5:RegExp = /-/g;
        var _local4:RegExp = /_/g;
        var _local3:int = 4 - _arg_2.length % 4;
        while (true) {
            _local3--;
            if (!_local3) {
                break;
            }
            _arg_2 = _arg_2 + "=";
        }
        _arg_2 = _arg_2.replace(_local5, "+").replace(_local4, "/");
        this.setBinaryData(_arg_1, Base64.decodeToByteArray(_arg_2));
    }

    public function setBinaryData(_arg_1:int, _arg_2:IDataInput):void {
        var _local4:int = 0;
        var _local3:int = 0;
        if (!this.charactersStats) {
            this.charactersStats = new Dictionary();
        }
        if (!this.charactersStats[_arg_1]) {
            this.charactersStats[_arg_1] = new CharacterMetricsData();
        }
        while (_arg_2.bytesAvailable >= 5) {
            _local4 = _arg_2.readByte();
            _local3 = _arg_2.readInt();
            this.charactersStats[_arg_1].setStat(_local4, _local3);
        }
        this._lastUpdate = new Date();
    }

    public function getCharacterStat(_arg_1:int, _arg_2:int):int {
        if (!this.charactersStats) {
            this.charactersStats = new Dictionary();
        }
        if (!this.charactersStats[_arg_1]) {
            return 0;
        }
        return this.charactersStats[_arg_1].getStat(_arg_2);
    }

    public function parseCharListData(_arg_1:XML):void {
        var _local2:* = null;
        var _local4:int = 0;
        var _local3:* = _arg_1.Char;
        for each(_local2 in _arg_1.Char) {
            this.setBinaryStringData(int(_local2.@id), _local2.PCStats);
        }
    }
}
}
