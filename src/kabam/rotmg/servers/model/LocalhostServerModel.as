package kabam.rotmg.servers.model {
import com.company.assembleegameclient.appengine.SavedCharacter;
import com.company.assembleegameclient.parameters.Parameters;

import io.decagames.rotmg.seasonalEvent.data.SeasonalEventModel;

import kabam.rotmg.core.model.PlayerModel;
import kabam.rotmg.servers.api.Server;
import kabam.rotmg.servers.api.ServerModel;

public class LocalhostServerModel implements ServerModel {


    public function LocalhostServerModel() {
        var _local2:* = null;
        var _local1:* = null;
        var _local3:int = 0;
        super();
        this.servers = new Vector.<Server>(0);
        while (_local3 < 40) {
            _local2 = _local3 % 2 == 0 ? "localhost" : "C_localhost" + _local3;
            _local1 = new Server().setName(_local2).setAddress("localhost").setPort(2050);
            this.servers.push(_local1);
            _local3++;
        }
    }
    [Inject]
    public var playerModel:PlayerModel;
    [Inject]
    public var seasonalEventModel:SeasonalEventModel;
    private var localhost:Server;
    private var servers:Vector.<Server>;
    private var availableServers:Vector.<Server>;

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

    public function getServer():Server {
        var _local2:* = false;
        var _local5:* = null;
        var _local4:* = null;
        var _local7:* = null;
        var _local6:Boolean = this.playerModel.isAdmin();
        var _local1:SavedCharacter = this.playerModel.getCharacterById(this.playerModel.currentCharId);
        if (_local1) {
            _local2 = _local1.charXML_.IsChallenger == 1;
        } else {
            _local2 = this.seasonalEventModel.isChallenger == 1;
        }
        var _local3:int = !_local2 ? 0 : 1;
        this.setAvailableServers(_local3);
        var _local9:int = 0;
        var _local8:* = this.availableServers;
        for each(_local5 in this.availableServers) {
            if (!(_local5.isFull() && !_local6)) {
                _local4 = !_local2 ? Parameters.data.preferredServer : Parameters.data.preferredChallengerServer;
                if (_local5.name == _local4) {
                    return _local5;
                }
                _local7 = this.availableServers[0];
                if (_local2) {
                    Parameters.data.bestChallengerServer = _local7.name;
                } else {
                    Parameters.data.bestServer = _local7.name;
                }
                Parameters.save();
            }
        }
        return _local7;
    }

    public function isServerAvailable():Boolean {
        return true;
    }

    public function setServers(_arg_1:Vector.<Server>):void {
    }

    public function getServers():Vector.<Server> {
        return this.servers;
    }
}
}
