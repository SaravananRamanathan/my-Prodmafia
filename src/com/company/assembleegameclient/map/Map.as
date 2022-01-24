package com.company.assembleegameclient.map {
import com.company.assembleegameclient.game.AGameSprite;
import com.company.assembleegameclient.map.mapoverlay.MapOverlay;
import com.company.assembleegameclient.map.partyoverlay.PartyOverlay;
import com.company.assembleegameclient.objects.BasicObject;
import com.company.assembleegameclient.objects.Character;
import com.company.assembleegameclient.objects.GameObject;
import com.company.assembleegameclient.objects.Party;
import com.company.assembleegameclient.objects.particles.ParticleEffect;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.util.ConditionEffect;

import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.GraphicsBitmapFill;
import flash.display.Sprite;
import flash.filters.ColorMatrixFilter;
import flash.geom.ColorTransform;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.utils.Dictionary;

import kabam.rotmg.assets.EmbeddedAssets;
import kabam.rotmg.core.StaticInjectorContext;
import kabam.rotmg.game.model.GameModel;
import kabam.rotmg.stage3D.GraphicsFillExtra;
import kabam.rotmg.stage3D.Render3D;
import kabam.rotmg.stage3D.Renderer;
import kabam.rotmg.stage3D.graphic3D.Program3DFactory;
import kabam.rotmg.stage3D.graphic3D.TextureFactory;
import kabam.rotmg.ui.signals.RealmOryxSignal;

public class Map extends AbstractMap {

    public static const CLOTH_BAZAAR:String = "Cloth Bazaar";

    public static const NEXUS:String = "Nexus";

    public static const DAILY_QUEST_ROOM:String = "Daily Quest Room";

    public static const DAILY_LOGIN_ROOM:String = "Daily Login Room";

    public static const PET_YARD_1:String = "Pet Yard";

    public static const PET_YARD_2:String = "Pet Yard 2";

    public static const PET_YARD_3:String = "Pet Yard 3";

    public static const PET_YARD_4:String = "Pet Yard 4";

    public static const PET_YARD_5:String = "Pet Yard 5";

    public static const REALM:String = "Realm of the Mad God";

    public static const ORYX_CHAMBER:String = "Oryx\'s Chamber";

    public static const GUILD_HALL:String = "Guild Hall";

    public static const GUILD_HALL_2:String = "Guild Hall 2";

    public static const GUILD_HALL_3:String = "Guild Hall 3";

    public static const GUILD_HALL_4:String = "Guild Hall 4";

    public static const GUILD_HALL_5:String = "Guild Hall 5";

    public static const NEXUS_EXPLANATION:String = "Nexus_Explanation";

    public static const VAULT:String = "Vault";
    private static const VISIBLE_SORT_FIELDS:Array = ["sortVal_", "objectId_"];
    private static const VISIBLE_SORT_PARAMS:Array = [16, 16];
    protected static const BLIND_FILTER:ColorMatrixFilter = new ColorMatrixFilter([0.05, 0.05, 0.05, 0, 0, 0.05, 0.05, 0.05, 0, 0, 0.05, 0.05, 0.05, 0, 0, 0.05, 0.05, 0.05, 1, 0]);
    public static var forceSoftwareRender:Boolean = false;
    public static var texture:BitmapData;
    protected static var BREATH_CT:ColorTransform = new ColorTransform(1, 0.215686274509804, 0, 0);

    public function Map(_arg_1:AGameSprite) {
        objsToAdd_ = new Vector.<BasicObject>();
        idsToRemove_ = new Vector.<int>();
        forceSoftwareMap = new Dictionary();
        darkness = new EmbeddedAssets.DarknessBackground();
        bgCont = new Sprite();
        graphicsData_ = new Vector.<GraphicsBitmapFill>();
        visible_ = [];
        visibleUnder_ = [];
        visibleSquares_ = new Vector.<Square>();
        topSquares_ = new Vector.<Square>();
        super();
        gs_ = _arg_1;
        mapHitArea = new Sprite();
        mapOverlay_ = new MapOverlay();
        partyOverlay_ = new PartyOverlay(this);
        party_ = new Party(this);
        quest_ = new Quest(this);
        StaticInjectorContext.getInjector().getInstance(GameModel).gameObjects = goDict_;
    }
    public var visible_:Array;
    public var visibleUnder_:Array;
    public var visibleSquares_:Vector.<Square>;
    public var topSquares_:Vector.<Square>;
    private var inUpdate_:Boolean = false;
    private var objsToAdd_:Vector.<BasicObject>;
    private var idsToRemove_:Vector.<int>;
    private var forceSoftwareMap:Dictionary;
    private var darkness:DisplayObject;
    private var bgCont:Sprite;
    private var oryxObjectId:int;
    private var graphicsData_:Vector.<GraphicsBitmapFill>;

    override public function calcVulnerables():void {
        var _local1:GameObject = null;
        this.vulnEnemyDict_.length = 0;
        this.vulnPlayerDict_.length = 0;
        for each(_local1 in goDict_) {
            if (_local1.props_.isEnemy_) {
                if (!_local1.dead_ && !_local1.isInvincible) {
                    if (!(_local1.props_.isCube_ && Parameters.data.fameBlockCubes)) {
                        if (!(!_local1.props_.isGod_ && Parameters.data.fameBlockGodsOnly)) {
                            if ((_local1.condition_[0] & ConditionEffect.PROJ_NOHIT_BITMASK) == 0) {
                                vulnEnemyDict_.push(_local1);
                            }
                        }
                    }
                }
            } else if (_local1.props_.isPlayer_) {
                if (!_local1.isPaused && !_local1.isInvincible && !_local1.isStasis && !_local1.dead_) {
                    vulnPlayerDict_.push(_local1);
                }
            }
        }
    }

    override public function setProps(_arg_1:int, _arg_2:int, _arg_3:String, _arg_4:int, _arg_5:Boolean, _arg_6:Boolean):void {
        mapWidth = _arg_1;
        mapHeight = _arg_2;
        name_ = _arg_3;
        back_ = _arg_4;
        allowPlayerTeleport_ = _arg_5;
        showDisplays_ = _arg_6;
        this.forceSoftwareRenderCheck(name_);
    }

    override public function setHitAreaProps(_arg_1:int, _arg_2:int):void {
        mapHitArea.graphics.beginFill(0xff0000, 0);
        mapHitArea.graphics.drawRect(-_arg_1 / 2, -_arg_2 / 2 - 20, _arg_1, _arg_2);
    }

    override public function initialize():void {
        squares.length = mapWidth * mapHeight;
        addChild(map_);
        addChild(mapHitArea);
        addChild(mapOverlay_);
        addChild(partyOverlay_);
        isPetYard = name_.substr(0, 8) == "Pet Yard";
        isQuestRoom = name_.indexOf("Quest") != -1;
    }

    override public function dispose():void {
        var _local2:* = null;
        var _local1:* = null;
        var _local3:* = null;
        gs_ = null;
        background_ = null;
        map_ = null;
        mapHitArea.graphics.clear();
        mapHitArea = null;
        mapOverlay_ = null;
        partyOverlay_ = null;
        squares.length = 0;
        squares = null;
        for each(_local1 in goDict_) {
            _local1.dispose();
        }
        goDict_ = null;
        for each(_local3 in boDict_) {
            _local3.dispose();
        }
        boDict_ = null;
        merchLookup_ = null;
        player_ = null;
        party_ = null;
        quest_ = null;
        this.objsToAdd_ = null;
        this.idsToRemove_ = null;
        TextureFactory.disposeTextures();
        GraphicsFillExtra.dispose();
        Program3DFactory.getInstance().dispose();
    }

    override public function update(_arg1:int, _arg2:int):void {
        var _local3:BasicObject;
        var _local4:int;
        this.inUpdate_ = true;
        for each (_local3 in goDict_) {
            if (_local3 && this.idsToRemove_ != null
                    && this.idsToRemove_.indexOf(_local3.objectId_) == -1
                    && !_local3.update(_arg1, _arg2)) {
                this.idsToRemove_.push(_local3.objectId_);
            }
        }
        for each (_local3 in boDict_) {
            if (_local3 && this.idsToRemove_ != null
                    && this.idsToRemove_.indexOf(_local3.objectId_) == -1
                    && !_local3.update(_arg1, _arg2)) {
                this.idsToRemove_.push(_local3.objectId_);
            }
        }
        this.inUpdate_ = false;
        for each (_local3 in this.objsToAdd_) {
            this.internalAddObj(_local3);
        }
        this.objsToAdd_.length = 0;
        for each (_local4 in this.idsToRemove_) {
            this.internalRemoveObj(_local4);
        }
        this.idsToRemove_.length = 0;
        party_.update(_arg1, _arg2);
    }

    override public function pSTopW(_arg_1:Number, _arg_2:Number):Point {
        var _local3:* = null;
        var _local5:int = 0;
        var _local4:* = this.visibleSquares_;
        for each(_local3 in this.visibleSquares_) {
            if (_local3.faces_.length != 0 && _local3.faces_[0].face.contains(_arg_1, _arg_2)) {
                return new Point(_local3.centerX_, _local3.centerY_);
            }
        }
        return null;
    }

    override public function setGroundTile(_arg_1:int, _arg_2:int, _arg_3:uint):void {
        var _local9:int = 0;
        var _local8:int = 0;
        var _local4:Square = null;
        var _local7:Square = this.getSquare(_arg_1, _arg_2);
        _local7.setTileType(_arg_3);
        var _local6:int = _arg_1 < mapWidth - 1 ? _arg_1 + 1 : _arg_1;
        var _local5:int = _arg_2 < mapHeight - 1 ? _arg_2 + 1 : _arg_2;
        var _local10:int = _arg_1 > 0 ? _arg_1 - 1 : _arg_1;
        while (_local10 <= _local6) {
            _local9 = _arg_2 > 0 ? _arg_2 - 1 : _arg_2;
            while (_local9 <= _local5) {
                _local8 = _local10 + _local9 * mapWidth;
                _local4 = squares[_local8];
                if (_local4 != null && (_local4.props_.hasEdge_ || _local4.tileType != _arg_3)) {
                    _local4.faces_.length = 0;
                }
                _local9++;
            }
            _local10++;
        }
    }

    override public function addObj(_arg_1:BasicObject, _arg_2:Number, _arg_3:Number):void {
        _arg_1.x_ = _arg_2;
        _arg_1.y_ = _arg_3;
        if (_arg_1 is ParticleEffect) {
            (_arg_1 as ParticleEffect).reducedDrawEnabled = !Parameters.data.particleEffect;
        }
        if (this.inUpdate_) {
            this.objsToAdd_.push(_arg_1);
        } else {
            this.internalAddObj(_arg_1);
        }
    }

    override public function removeObj(_arg_1:int):void {
        if (this.inUpdate_) {
            this.idsToRemove_.push(_arg_1);
        } else {
            this.internalRemoveObj(_arg_1);
        }
    }

    override public function draw(camera:Camera, time:int):void {
        var screenRect:Rectangle = camera.clipRect_;
        x = -screenRect.x * 800 / WebMain.STAGE.stageWidth * Parameters.data.mscale;
        y = -screenRect.y * 600 / WebMain.STAGE.stageHeight * Parameters.data.mscale;

        WebMain.STAGE.stage3Ds[0].x = 400 - WebMain.STAGE.stageWidth / 2;
        WebMain.STAGE.stage3Ds[0].y = 300 - WebMain.STAGE.stageHeight / 2;

        var filter:uint = 0;
        var render3D:Render3D = null;
        var square:Square = null;
        var go:GameObject = null;
        var bo:BasicObject = null;
        var yi:int = 0;

        this.visible_.length = 0;
        this.visibleUnder_.length = 0;
        this.visibleSquares_.length = 0;
        this.topSquares_.length = 0;
        this.graphicsData_.length = 0;

        var len:int = Parameters.data.renderDistance - 1;
        for (var xi:int = -len; xi <= len; xi++)
            for (yi = -len; yi <= len; yi++)
                if (xi * xi + yi * yi <= len * len) {
                    square = this.lookupSquare(xi + this.player_.x_, yi + this.player_.y_);
                    if (square != null) {
                        square.lastVisible_ = time;
                        square.draw(this.graphicsData_, camera, time);
                        this.visibleSquares_.push(square);
                        if (square.topFace_ != null)
                            this.topSquares_.push(square);
                    }
                }

        for each (go in this.goDict_) {
            go.drawn_ = false;
            if (!go.dead_) {
                square = go.square;
                if (!(square == null || square.lastVisible_ != time)) {
                    go.drawn_ = true;
                    go.computeSortVal(camera); // gets computed regardless for posS_
                    if (go.objectId_ == player_.objectId_)
                        go.sortVal_ = 9999;
                    if (go.props_.drawUnder_) {
                        if (go.props_.drawOnGround_)
                            go.draw(this.graphicsData_, camera, time);
                        else
                            this.visibleUnder_.push(go);
                    } else
                        this.visible_.push(go);
                }
            }
        }

        for each (bo in this.boDict_) {
            bo.drawn_ = false;
            square = bo.square;
            if (!(square == null || square.lastVisible_ != time)) {
                bo.drawn_ = true;
                bo.computeSortVal(camera);
                this.visible_.push(bo);
            }
        }

        if (this.visibleUnder_.length > 0) {
            if (!Parameters.data.disableSorting)
                this.visibleUnder_.sortOn(VISIBLE_SORT_FIELDS, VISIBLE_SORT_PARAMS);
            for each (bo in this.visibleUnder_)
                bo.draw(this.graphicsData_, camera, time);
        }

        if (!Parameters.data.disableSorting)
            this.visible_.sortOn(VISIBLE_SORT_FIELDS, VISIBLE_SORT_PARAMS);

        for each (bo in this.visible_)
            bo.draw(this.graphicsData_, camera, time);

        if (this.topSquares_.length > 0)
            for each(square in this.topSquares_)
                square.drawTop(this.graphicsData_, camera, time);

        if (Renderer.inGame) {
            filter = this.getFilterIndex();
            render3D = StaticInjectorContext.getInjector().getInstance(Render3D);
            render3D.dispatch(this.graphicsData_, filter);
            if (time % 149 == 0)
                GraphicsFillExtra.manageSize();
        }

        this.mapOverlay_.draw(camera, time);
        this.partyOverlay_.draw(camera, time);
    }

    public function internalAddObj(_arg_1:BasicObject):void {
        if (!_arg_1.addTo(this, _arg_1.x_, _arg_1.y_)) {
            return;
        }
        var _local2:Dictionary = _arg_1 is GameObject ? goDict_ : boDict_;
        if (_local2[_arg_1.objectId_] != null) {
            if (!isPetYard) {
                return;
            }
        }
        if (name_ == "Oryx\'s Chamber" && this.oryxObjectId == 0) {
            if (_arg_1 is Character && (_arg_1 as Character).getName() == "Oryx the Mad God") {
                this.oryxObjectId = _arg_1.objectId_;
            }
        }
        _local2[_arg_1.objectId_] = _arg_1;
    }

    public function internalRemoveObj(_arg_1:int):void {
        var _local2:Dictionary = goDict_;
        var _local3:BasicObject = _local2[_arg_1];
        if (_local3 == null) {
            _local2 = boDict_;
            _local3 = _local2[_arg_1];
            if (_local3 == null) {
                return;
            }
            delete boDict_[_arg_1];
        } else delete goDict_[_arg_1];
        _local3.removeFromMap();
        if (name_ == "Oryx\'s Chamber" && _arg_1 == this.oryxObjectId) {
            StaticInjectorContext.getInjector().getInstance(RealmOryxSignal).dispatch();
        }
    }

    public function getSquare(_arg1:Number, _arg2:Number):Square {
        if ((((((((_arg1 < 0)) || ((_arg1 >= mapWidth)))) || ((_arg2 < 0)))) || ((_arg2 >= mapHeight)))) {
            return (null);
        }
        var _local3:int = (int(_arg1) + (int(_arg2) * mapWidth));
        var _local4:Square = squares[_local3];
        if (_local4 == null) {
            _local4 = new Square(this, int(_arg1), int(_arg2));
            squares[_local3] = _local4;
        }
        return (_local4);
    }

    public function lookupSquare(_arg1:int, _arg2:int):Square {
        if ((((((((_arg1 < 0)) || ((_arg1 >= mapWidth)))) || ((_arg2 < 0)))) || ((_arg2 >= mapHeight)))) {
            return (null);
        }
        return (squares[(_arg1 + (_arg2 * mapWidth))]);
    }

    private function forceSoftwareRenderCheck(_arg_1:String):void {
        forceSoftwareRender = this.forceSoftwareMap[_arg_1] != null || WebMain.STAGE != null && WebMain.STAGE.stage3Ds[0].context3D == null;
    }

    private function getFilterIndex() : uint {
        var index:int = 0;
        if (player_ != null && (player_.condition_[0] & ConditionEffect.MAP_FILTER_BITMASK) != 0) {
            if (player_.isPaused)
                index = 1;
            else if (player_.isBlind)
                index = 2;
            else if (player_.isDrunk)
                index = 3;
        }
        return index;
    }
}
}
