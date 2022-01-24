package kabam.rotmg.game.commands {
import com.company.assembleegameclient.appengine.SavedCharacter;
import com.company.assembleegameclient.game.GameSprite;
import com.company.assembleegameclient.parameters.Parameters;

import flash.utils.ByteArray;

import io.decagames.rotmg.pets.data.PetsModel;
import io.decagames.rotmg.seasonalEvent.data.SeasonalEventModel;

import kabam.lib.net.impl.SocketServerModel;
import kabam.lib.tasks.TaskMonitor;
import kabam.rotmg.core.model.PlayerModel;
import kabam.rotmg.core.signals.SetScreenSignal;
import kabam.rotmg.game.model.GameInitData;
import kabam.rotmg.servers.api.Server;
import kabam.rotmg.servers.api.ServerModel;

public class PlayGameCommand {

    public static const RECONNECT_DELAY:int = 250;

    public function PlayGameCommand() {
        super();
    }
    [Inject]
    public var setScreen:SetScreenSignal;
    [Inject]
    public var data:GameInitData;
    [Inject]
    public var model:PlayerModel;
    [Inject]
    public var petsModel:PetsModel;
    [Inject]
    public var serverModel:ServerModel;
    [Inject]
    public var seasonalEventModel:SeasonalEventModel;
    [Inject]
    public var monitor:TaskMonitor;
    [Inject]
    public var socketServerModel:SocketServerModel;

    public function execute():void {
        if (!this.data.isNewGame) {
            this.socketServerModel.connectDelayMS = Parameters.data.reconnectDelay;
        }
        this.recordCharacterUseInSharedObject();
        this.makeGameView();
        this.updatePet();
    }

    private function updatePet():void {
        var _local1:SavedCharacter = this.model.getCharacterById(this.model.currentCharId);
        if (_local1) {
            this.petsModel.setActivePet(_local1.getPetVO());
        } else {
            if (this.model.currentCharId && this.petsModel.getActivePet() && !this.data.isNewGame) {
                return;
            }
            this.petsModel.setActivePet(null);
        }
    }

    private function recordCharacterUseInSharedObject():void {
        Parameters.data.charIdUseMap[this.data.charId] = new Date().getTime();
        Parameters.save();
    }

    private function makeGameView() : void {
        var _local3:Boolean = false;
        var _local6:SavedCharacter = this.model.getCharacterById(this.data.charId);
        if(_local6) {
            _local3 = int(_local6.charXML_.IsChallenger);
        } else {
            _local3 = this.seasonalEventModel.isChallenger;
        }
        var _local4:int = !!_local3?1:0;
        this.serverModel.setAvailableServers(_local4);
        var _local2:Server = this.data.server || this.serverModel.getServer();
        var _local1:int = !!this.data.isNewGame?int(this.getInitialGameId()):int(this.data.gameId);
        var _local8:Boolean = this.data.createCharacter;
        var _local5:int = this.data.charId;
        var _local7:int = !!this.data.isNewGame?-1:int(this.data.keyTime);
        var _local9:ByteArray = this.data.key;
        this.model.currentCharId = _local5;
        this.setScreen.dispatch(new GameSprite(_local2,_local1,_local8,_local5,_local7,_local9,this.model,null,this.data.isFromArena));
    }

    private function getInitialGameId():int {
        var _local1:int = 0;
        if (Parameters.data.needsTutorial) {
            _local1 = -1;
        } else {
            _local1 = -2;
        }
        return _local1;
    }
}
}
