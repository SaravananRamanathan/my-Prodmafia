package kabam.rotmg.servers.model {
import com.company.assembleegameclient.appengine.SavedCharacter;
import com.company.assembleegameclient.parameters.Parameters;

import io.decagames.rotmg.seasonalEvent.data.SeasonalEventModel;

import kabam.rotmg.core.model.PlayerModel;
import kabam.rotmg.servers.api.LatLong;
import kabam.rotmg.servers.api.Server;
import kabam.rotmg.servers.api.ServerModel;

public class LiveServerModel implements ServerModel {


    private const servers:Vector.<Server> = new Vector.<Server>(0);

    public function LiveServerModel() {
        super();
    }
    [Inject]
    public var model:PlayerModel;
    [Inject]
    public var seasonalEventModel:SeasonalEventModel;
    private var _descendingFlag:Boolean;
    private var availableServers:Vector.<Server>;

    public function setServers(_arg_1:Vector.<Server>):void {
        var _local2:* = null;
        this.servers.length = 0;
        var _local4:int = 0;
        var _local3:* = _arg_1;
        for each(_local2 in _arg_1) {
            this.servers.push(_local2);
        }
        this._descendingFlag = false;
        this.servers.sort(this.compareServerName);
    }

    public function getServers():Vector.<Server> {
        return this.servers;
    }

    public function getServer():Server {
        var _local4:* = null;
        var _local1:int = 0;
        var _local6:Number = NaN;
        var _local12:* = null;
        var _local11:* = false;
        var _local2:Boolean = this.model.isAdmin();
        var _local3:LatLong = this.model.getMyPos();
        var _local10:* = Infinity;
        var _local9:* = 0x7fffffff;
        var _local8:SavedCharacter = this.model.getCharacterById(this.model.currentCharId);
        if (_local8) {
            _local11 = _local8.charXML_.IsChallenger == 1;
        } else {
            _local11 = this.seasonalEventModel.isChallenger == 1;
        }
        var _local5:int = !!_local11 ? 1 : 0;
        var _local7:String = !!_local11 ? Parameters.data.preferredChallengerServer : Parameters.data.preferredServer;
        this.setAvailableServers(_local5);
        var _local14:int = 0;
        var _local13:* = this.availableServers;
        for each(_local4 in this.availableServers) {
            if (_local4.name == _local7) {
                return _local4;
            }
            _local1 = _local4.priority();
            _local6 = LatLong.distance(_local3, _local4.latLong);
            if (_local1 < _local9 || _local1 == _local9 && _local6 < _local10) {
                _local12 = _local4;
                _local10 = _local6;
                _local9 = _local1;
                if (_local11) {
                    Parameters.data.bestChallengerServer = _local12.name;
                } else {
                    Parameters.data.bestServer = _local12.name;
                }
                Parameters.save();
            }
        }
        return _local12;
    }

    public function getServerNameByAddress(_arg_1:String):String {
        var _local2:* = null;
        var _local4:int = 0;
        var _local3:* = this.servers;
        for each(_local2 in this.servers) {
            if (_local2.address == _arg_1) {
                return _local2.name;
            }
        }
        return "";
    }

    public function isServerAvailable():Boolean {
        return this.servers.length > 0;
    }

    public function setAvailableServers(_arg_1:int):void {
        var _local2:* = null;
        var _local3:* = null;
        if (!this.availableServers) {
            this.availableServers = new Vector.<Server>(0);
        } else {
            this.availableServers.length = 0;
        }
        if (_arg_1 != 0) {
            var _local5:int = 0;
            var _local4:* = this.servers;
            for each(_local2 in this.servers) {
                if (_local2.name.charAt(0) == "C") {
                    this.availableServers.push(_local2);
                }
            }
        } else {
            var _local7:int = 0;
            var _local6:* = this.servers;
            for each(_local3 in this.servers) {
                if (_local3.name.charAt(0) != "C") {
                    this.availableServers.push(_local3);
                }
            }
        }
    }

    public function getAvailableServers():Vector.<Server> {
        return this.availableServers;
    }

    private function compareServerName(_arg_1:Server, _arg_2:Server):int {
        if (_arg_1.name < _arg_2.name) {
            return !this._descendingFlag ? 1 : -1;
        }
        if (_arg_1.name > _arg_2.name) {
            return !this._descendingFlag ? -1 : 1;
        }
        return 0;
    }
}
}
