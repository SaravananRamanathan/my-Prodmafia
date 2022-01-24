package com.company.assembleegameclient.ui.menu {
import com.company.assembleegameclient.map.AbstractMap;
import com.company.assembleegameclient.objects.Player;
import com.company.assembleegameclient.ui.GameObjectListItem;
import com.company.assembleegameclient.ui.LineBreakDesign;

import flash.events.Event;

import org.osflash.signals.Signal;

public class PlayerGroupMenu extends Menu {


    public function PlayerGroupMenu(_arg_1:AbstractMap, _arg_2:Vector.<Player>) {
        unableToTeleport = new Signal();
        playerPanels_ = new Vector.<GameObjectListItem>();
        super(0x363636, 0xffffff);
        this.map_ = _arg_1;
        this.players_ = _arg_2.concat();
        this.createHeader();
        this.createPlayerList();
    }
    public var map_:AbstractMap;
    public var players_:Vector.<Player>;
    public var teleportOption_:MenuOption;
    public var lineBreakDesign_:LineBreakDesign;
    public var unableToTeleport:Signal;
    private var playerPanels_:Vector.<GameObjectListItem>;
    private var posY:uint = 4;

    private function createPlayerList():void {
        var _local1:* = null;
        var _local2:* = null;
        var _local4:int = 0;
        var _local3:* = this.players_;
        for each(_local1 in this.players_) {
            _local2 = new GameObjectListItem(0xb3b3b3, true, _local1);
            _local2.x = 0;
            _local2.y = this.posY;
            addChild(_local2);
            this.playerPanels_.push(_local2);
            _local2.textReady.addOnce(this.onTextChanged);
            this.posY = this.posY + 32;
        }
    }

    private function onTextChanged():void {
        var _local1:* = null;
        draw();
        var _local3:int = 0;
        var _local2:* = this.playerPanels_;
        for each(_local1 in this.playerPanels_) {
            _local1.textReady.remove(this.onTextChanged);
        }
    }

    private function createHeader():void {
        if (this.map_.allowPlayerTeleport()) {
            this.teleportOption_ = new TeleportMenuOption(this.map_.player_);
            this.teleportOption_.x = 8;
            this.teleportOption_.y = 8;
            this.teleportOption_.addEventListener("click", this.onTeleport, false, 0, true);
            addChild(this.teleportOption_);
            this.lineBreakDesign_ = new LineBreakDesign(150, 0x1c1c1c);
            this.lineBreakDesign_.x = 6;
            this.lineBreakDesign_.y = 40;
            addChild(this.lineBreakDesign_);
            this.posY = 52;
        }
    }

    private function onTeleport(_arg_1:Event):void {
        var _local4:* = null;
        var _local3:* = null;
        var _local2:Player = this.map_.player_;
        var _local6:int = 0;
        var _local5:* = this.players_;
        for each(_local3 in this.players_) {
            if (_local2.isTeleportEligible(_local3)) {
                _local4 = _local3;
                if (_local2.msUtilTeleport() > 10000) {
                    if (!_local3.isFellowGuild_) {
                        continue;
                    }
                    break;
                }
                break;
            }
        }
        if (_local4 != null) {
            _local2.teleportTo(_local4);
        } else {
            this.unableToTeleport.dispatch();
        }
        remove();
    }
}
}
