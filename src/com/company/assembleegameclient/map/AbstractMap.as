package com.company.assembleegameclient.map {
import com.company.assembleegameclient.background.Background;
import com.company.assembleegameclient.game.AGameSprite;
import com.company.assembleegameclient.map.mapoverlay.MapOverlay;
import com.company.assembleegameclient.map.partyoverlay.PartyOverlay;
import com.company.assembleegameclient.objects.BasicObject;
import com.company.assembleegameclient.objects.GameObject;
import com.company.assembleegameclient.objects.Party;
import com.company.assembleegameclient.objects.Player;

import flash.display.Sprite;
import flash.geom.Point;
import flash.utils.Dictionary;

import org.osflash.signals.Signal;

public class AbstractMap extends Sprite {


    public function AbstractMap() {
        vulnPlayerDict_ = new Vector.<GameObject>();
        vulnEnemyDict_ = new Vector.<GameObject>();
        goDict_ = new Dictionary();
        map_ = new Sprite();
        squares = new Vector.<Square>();
        boDict_ = new Dictionary();
        merchLookup_ = {};
        signalRenderSwitch = new Signal(Boolean);
        super();
    }
    public var playerDict_:Dictionary;
    public var gs_:AGameSprite;
    public var name_:String;
    public var player_:Player = null;
    public var showDisplays_:Boolean;
    public var mapWidth:int;
    public var mapHeight:int;
    public var back_:int;
    public var background_:Background = null;
    public var mapHitArea:Sprite;
    public var mapOverlay_:MapOverlay = null;
    public var partyOverlay_:PartyOverlay = null;
    public var party_:Party = null;
    public var quest_:Quest = null;
    public var isPetYard:Boolean = false;
    public var isTrench:Boolean = false;
    public var isNexus:Boolean = false;
    public var isRealm:Boolean = false;
    public var isVault:Boolean = false;
    public var isQuestRoom:Boolean = false;
    public var vulnPlayerDict_:Vector.<GameObject>;
    public var vulnEnemyDict_:Vector.<GameObject>;
    public var goDict_:Dictionary;
    public var map_:Sprite;
    public var squares:Vector.<Square>;
    public var boDict_:Dictionary;
    public var merchLookup_:Object;
    public var signalRenderSwitch:Signal;
    protected var allowPlayerTeleport_:Boolean;

    public function setProps(_arg_1:int, _arg_2:int, _arg_3:String, _arg_4:int, _arg_5:Boolean, _arg_6:Boolean):void {
    }

    public function setHitAreaProps(_arg_1:int, _arg_2:int):void {
    }

    public function addObj(_arg_1:BasicObject, _arg_2:Number, _arg_3:Number):void {
    }

    public function setGroundTile(_arg_1:int, _arg_2:int, _arg_3:uint):void {
    }

    public function initialize():void {
    }

    public function dispose():void {
    }

    public function resetOverlays():void {
    }

    public function update(_arg_1:int, _arg_2:int):void {
    }

    public function pSTopW(_arg_1:Number, _arg_2:Number):Point {
        return null;
    }

    public function removeObj(_arg_1:int):void {
    }

    public function calcVulnerables():void {
    }

    public function draw(_arg_1:Camera, _arg_2:int):void {
    }

    public function allowPlayerTeleport():Boolean {
        return this.name_ != "Nexus" && this.allowPlayerTeleport_;
    }

    public function saveMap(_arg_1:Boolean):void {
    }

    public function findPlayer(_arg_1:String):Player {
        return null;
    }

    public function findObject(_arg_1:int):GameObject {
        return null;
    }

    public function needsMapHack(_arg_1:String):int {
        return 0;
    }

    public function saveJson():void {
    }

    public function startSaveMap():void {
    }

    public function printOffsetPosition() : void {
    }
}
}
