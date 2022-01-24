package kabam.rotmg.minimap.view {
import com.company.assembleegameclient.map.AbstractMap;
import com.company.assembleegameclient.map.GroundLibrary;
import com.company.assembleegameclient.objects.Character;
import com.company.assembleegameclient.objects.GameObject;
import com.company.assembleegameclient.objects.GuildHallPortal;
import com.company.assembleegameclient.objects.Player;
import com.company.assembleegameclient.objects.Portal;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.ui.menu.PlayerGroupMenu;
import com.company.assembleegameclient.ui.tooltip.PlayerGroupToolTip;
import com.company.util.AssetLibrary;
import com.company.util.PointUtil;
import com.company.util.RectangleUtil;

import flash.display.BitmapData;
import flash.display.Shape;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.ColorTransform;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.utils.Dictionary;

public class MiniMapImp extends MiniMap {

    public static const MOUSE_DIST_SQ:int = 25;

    private static var objectTypeColorDict_:Dictionary = new Dictionary();

    public static function gameObjectToColor(_arg_1:GameObject):uint {
        var _local2:* = _arg_1.objectType_;
        if (!(_local2 in objectTypeColorDict_)) {
            objectTypeColorDict_[_local2] = _arg_1.getColor();
        }
        return objectTypeColorDict_[_local2];
    }

    public function MiniMapImp(_arg_1:int, _arg_2:int) {
        zoomLevels = new Vector.<Number>();
        mapMatrix_ = new Matrix();
        arrowMatrix_ = new Matrix();
        players_ = new Vector.<Player>();
        tempPoint = new Point();
        super();
        this._width = _arg_1;
        this._height = _arg_2;
        this._rotateEnableFlag = Parameters.data.allowMiniMapRotation;
        this.makeVisualLayers();
        this.addMouseListeners();
    }
    public var _width:int;
    public var _height:int;
    public var zoomIndex:int = 0;
    public var windowRect_:Rectangle;
    public var active:Boolean = true;
    public var maxWH_:Point;
    public var miniMapData_:BitmapData;
    public var slayermapData:BitmapData;
    public var zoomLevels:Vector.<Number>;
    public var blueArrow_:BitmapData;
    public var groundLayer_:Shape;
    public var characterLayer_:Shape;
    public var enemyLayer_:Shape;
    private var focus:GameObject;
    private var zoomButtons:MiniMapZoomButtons;
    private var isMouseOver:Boolean = false;
    private var tooltip:PlayerGroupToolTip = null;
    private var menu:PlayerGroupMenu = null;
    private var mapMatrix_:Matrix;
    private var arrowMatrix_:Matrix;
    private var players_:Vector.<Player>;
    private var tempPoint:Point;
    private var _rotateEnableFlag:Boolean;
    private var scores:Vector.<int>;

    override public function setMap(_arg_1:AbstractMap):void {
        this.map = _arg_1;
        this.makeViewModel();
        if (map.name_ == "Realm of the Mad God") {
            scores = new Vector.<int>(13);
        }
    }

    override public function setFocus(_arg_1:GameObject):void {
        this.focus = _arg_1;
    }

    override public function setGroundTile(_arg_1:int, _arg_2:int, _arg_3:uint):void {
        var _local4:uint = GroundLibrary.getColor(_arg_3);
        this.miniMapData_.setPixel(_arg_1, _arg_2, _local4);
    }

    override public function setGameObjectTile(_arg_1:int, _arg_2:int, _arg_3:GameObject):void {
        var _local4:uint = gameObjectToColor(_arg_3);
        this.miniMapData_.setPixel(_arg_1, _arg_2, _local4);
    }

    override public function draw():void {
        var _local15:Number = NaN;
        var _local13:Number = NaN;
        var _local6:Number = NaN;
        var _local11:Number = NaN;
        var _local19:Number = NaN;
        var _local9:* = 0;
        var _local2:* = null;
        var _local4:* = null;
        var _local8:* = null;
        var _local18:* = null;
        this._rotateEnableFlag = this._rotateEnableFlag && Parameters.data.allowMiniMapRotation;
        this.groundLayer_.graphics.clear();
        this.characterLayer_.graphics.clear();
        this.enemyLayer_.graphics.clear();
        if (!this.focus) {
            return;
        }
        if (!this.active) {
            return;
        }
        var _local22:Number = this.zoomLevels[this.zoomIndex];
        this.mapMatrix_.identity();
        this.mapMatrix_.translate(-this.focus.x_, -this.focus.y_);
        this.mapMatrix_.scale(_local22, _local22);
        var _local5:Point = this.mapMatrix_.transformPoint(PointUtil.ORIGIN);
        var _local10:Point = this.mapMatrix_.transformPoint(this.maxWH_);
        var _local3:* = 0;
        if (_local5.x > this.windowRect_.left) {
            _local3 = this.windowRect_.left - _local5.x;
        } else if (_local10.x < this.windowRect_.right) {
            _local3 = this.windowRect_.right - _local10.x;
        }
        var _local7:* = 0;
        if (_local5.y > this.windowRect_.top) {
            _local7 = this.windowRect_.top - _local5.y;
        } else if (_local10.y < this.windowRect_.bottom) {
            _local7 = this.windowRect_.bottom - _local10.y;
        }
        this.mapMatrix_.translate(_local3, _local7);
        _local5 = this.mapMatrix_.transformPoint(PointUtil.ORIGIN);
        if (_local22 >= 1 && this._rotateEnableFlag) {
            this.mapMatrix_.rotate(-Parameters.data.cameraAngle);
        }
        var _local1:Rectangle = new Rectangle();
        _local1.x = Math.max(this.windowRect_.x, _local5.x);
        _local1.y = Math.max(this.windowRect_.y, _local5.y);
        _local1.right = Math.min(this.windowRect_.right, _local5.x + this.maxWH_.x * _local22);
        _local1.bottom = Math.min(this.windowRect_.bottom, _local5.y + this.maxWH_.y * _local22);
        _local4 = this.groundLayer_.graphics;
        _local4.beginBitmapFill(this.miniMapData_, this.mapMatrix_, false);
        _local4.drawRect(_local1.x, _local1.y, _local1.width, _local1.height);
        _local4.endFill();
        _local4 = this.characterLayer_.graphics;
        _local8 = this.enemyLayer_.graphics;
        var _local21:Number = mouseX - this._width * 0.5;
        var _local20:Number = mouseY - this._height * 0.5;
        this.players_.length = 0;
        var _local24:int = 0;
        var _local23:* = map.goDict_;
        for each(_local18 in map.goDict_) {
            if (!(_local18.props_.noMiniMap_ || _local18 == this.focus)) {
                _local2 = _local18 as Player;
                if (_local2) {
                    if (_local2.isPaused) {
                        _local9 = 0x7f7f7f;
                    } else if (Parameters.data.newMiniMapColors && _local2.isFellowGuild_ && !_local2.starred_) {
                        _local9 = 0xcf00;
                    } else if (_local2.isFellowGuild_) {
                        _local9 = 0xff00;
                    } else if (Parameters.data.newMiniMapColors && !_local2.nameChosen_ && _local2.starred_) {
                        _local9 = 0xffffff;
                    } else if (Parameters.data.newMiniMapColors && !_local2.nameChosen_) {
                        _local9 = 0xcfcfcf;
                    } else if (Parameters.data.newMiniMapColors && !_local2.starred_) {
                        _local9 = 0xcfcf00;
                    } else {
                        _local9 = 0xffff00;
                    }
                } else if (_local18 is Character) {
                    if (_local18.props_.isEnemy_) {
                        if (_local18.props_.color_ != -1) {
                            _local9 = uint(_local18.props_.color_);
                        } else {
                            _local9 = 0xff0000;
                        }
                    } else {
                        _local9 = uint(gameObjectToColor(_local18));
                    }
                } else if (_local18 is Portal || _local18 is GuildHallPortal) {
                    _local9 = 255;
                } else {
                    continue;
                }
                _local15 = this.mapMatrix_.a * _local18.x_ + this.mapMatrix_.c * _local18.y_ + this.mapMatrix_.tx;
                _local13 = this.mapMatrix_.b * _local18.x_ + this.mapMatrix_.d * _local18.y_ + this.mapMatrix_.ty;
                if (_local15 <= this._width * -0.5 || _local15 >= this._width * 0.5 || _local13 <= this._height * -0.5 || _local13 >= this._height * 0.5) {
                    RectangleUtil.lineSegmentIntersectXY(this.windowRect_, 0, 0, _local15, _local13, this.tempPoint);
                    _local15 = this.tempPoint.x;
                    _local13 = this.tempPoint.y;
                }
                if (_local2 && this.isMouseOver && (this.menu == null || this.menu.parent == null)) {
                    _local6 = _local21 - _local15;
                    _local11 = _local20 - _local13;
                    _local19 = _local6 * _local6 + _local11 * _local11;
                    if (_local19 < 25) {
                        this.players_.push(_local2);
                    }
                }
                if (_local18 is Character && _local18.props_.isEnemy_) {
                    _local8.beginFill(_local9);
                    _local8.drawRect(_local15 - 2, _local13 - 2, 4, 4);
                    _local8.endFill();
                } else {
                    _local4.beginFill(_local9);
                    _local4.drawRect(_local15 - 2, _local13 - 2, 4, 4);
                    _local4.endFill();
                }
            }
        }
        if (this.players_.length != 0) {
            if (this.tooltip == null) {
                this.tooltip = new PlayerGroupToolTip(this.players_);
                menuLayer.addChild(this.tooltip);
            } else if (!this.areSamePlayers(this.tooltip.players_, this.players_)) {
                this.tooltip.setPlayers(this.players_);
            }
        } else if (this.tooltip) {
            if (this.tooltip.parent) {
                this.tooltip.parent.removeChild(this.tooltip);
            }
            this.tooltip = null;
        }
        var _local17:Number = this.focus.x_;
        var _local16:Number = this.focus.y_;
        var _local14:Number = this.mapMatrix_.a * _local17 + this.mapMatrix_.c * _local16 + this.mapMatrix_.tx;
        var _local12:Number = this.mapMatrix_.b * _local17 + this.mapMatrix_.d * _local16 + this.mapMatrix_.ty;
        this.arrowMatrix_.identity();
        this.arrowMatrix_.translate(-4, -5);
        this.arrowMatrix_.scale(8 / this.blueArrow_.width, 32 / this.blueArrow_.height);
        if (!(_local22 >= 1 && this._rotateEnableFlag)) {
            this.arrowMatrix_.rotate(Parameters.data.cameraAngle);
        }
        this.arrowMatrix_.translate(_local14, _local12);
        _local4.beginBitmapFill(this.blueArrow_, this.arrowMatrix_, false);
        _local4.drawRect(_local14 - 16, _local12 - 16, 32, 32);
        _local4.endFill();
    }

    override public function zoomIn():void {
        this.zoomIndex = this.zoomButtons.setZoomLevel(this.zoomIndex - 1);
    }

    override public function zoomOut():void {
        this.zoomIndex = this.zoomButtons.setZoomLevel(this.zoomIndex + 1);
    }

    override public function deactivate():void {
    }

    public function dispose():void {
        for each(var _local1:Player in this.players_) {
            _local1 && _local1.dispose();
            _local1 = null;
        }
        this.mapMatrix_ = null;
        this.arrowMatrix_ = null;
        this.removeDecorations();
    }

    private function makeViewModel():void {
        this.windowRect_ = new Rectangle(this._width * -0.5, this._height * -0.5, this._width, this._height);
        this.maxWH_ = new Point(map.mapWidth, map.mapHeight);
        this.miniMapData_ = new BitmapData(this.maxWH_.x, this.maxWH_.y, false, 0);
        var _local1:Number = Math.max(this._width / this.maxWH_.x, this._height / this.maxWH_.y);
        var _local2:* = 4;
        while (_local2 > _local1) {
            this.zoomLevels.push(_local2);
            _local2 = Number(_local2 / 2);
        }
        this.zoomLevels.push(_local1);
        if (this.zoomButtons)
            this.zoomButtons.setZoomLevels(this.zoomLevels.length);
    }

    private function makeVisualLayers():void {
        this.blueArrow_ = AssetLibrary.getImageFromSet("lofiInterface", 54).clone();
        this.blueArrow_.colorTransform(this.blueArrow_.rect, new ColorTransform(0, 0, 1));
        graphics.clear();
        graphics.beginFill(0x1b1b1b);
        graphics.drawRect(0, 0, this._width, this._height);
        graphics.endFill();
        this.groundLayer_ = new Shape();
        this.groundLayer_.x = this._width / 2;
        this.groundLayer_.y = this._height / 2;
        addChild(this.groundLayer_);
        this.characterLayer_ = new Shape();
        this.characterLayer_.x = this._width / 2;
        this.characterLayer_.y = this._height / 2;
        addChild(this.characterLayer_);
        this.enemyLayer_ = new Shape();
        this.enemyLayer_.x = this._width / 2;
        this.enemyLayer_.y = this._height / 2;
        addChild(this.enemyLayer_);
        this.zoomButtons = new MiniMapZoomButtons();
        this.zoomButtons.x = this._width - 20;
        this.zoomButtons.zoom.add(this.onZoomChanged);
        this.zoomButtons.setZoomLevels(this.zoomLevels.length);
        addChild(this.zoomButtons);
    }

    private function addMouseListeners():void {
        addEventListener("mouseOver", this.onMouseOver);
        addEventListener("mouseOut", this.onMouseOut);
        addEventListener("rightClick", this.onMapRightClick);
        addEventListener("click", this.onMapClick);
        addEventListener("removedFromStage", this.onRemovedFromStage);
    }

    private function onZoomChanged(_arg_1:int):void {
        this.zoomIndex = _arg_1;
    }

    private function addMenu():void {
        this.menu = new PlayerGroupMenu(map, this.tooltip.players_);
        this.menu.x = this.tooltip.x + 12;
        this.menu.y = this.tooltip.y;
        menuLayer.addChild(this.menu);
    }

    private function removeDecorations():void {
        this.removeTooltip();
        this.removeMenu();
    }

    private function removeTooltip():void {
        if (this.tooltip != null) {
            if (this.tooltip.parent != null) {
                this.tooltip.parent.removeChild(this.tooltip);
            }
            this.tooltip = null;
        }
    }

    private function removeMenu():void {
        if (this.menu != null) {
            if (this.menu.parent != null) {
                this.menu.parent.removeChild(this.menu);
            }
            this.menu = null;
        }
    }

    private function areSamePlayers(_arg_1:Vector.<Player>, _arg_2:Vector.<Player>):Boolean {
        var _local3:int = 0;
        var _local4:int = _arg_1.length;
        if (_local4 != _arg_2.length) {
            return false;
        }
        while (_local3 < _local4) {
            if (_arg_1[_local3] != _arg_2[_local3]) {
                return false;
            }
            _local3++;
        }
        return true;
    }

    private function onRemovedFromStage(_arg_1:Event):void {
        this.active = false;
        this.removeDecorations();
    }

    private function onMouseOver(_arg_1:MouseEvent):void {
        this.isMouseOver = true;
    }

    private function onMouseOut(_arg_1:MouseEvent):void {
        this.isMouseOver = false;
    }

    private function onMapRightClick(_arg_1:MouseEvent):void {
        if (this.players_.length != 0) {
            this.players_[0].map_.gs_.gsc_.teleport(this.players_[0].objectId_);
        }
    }

    private function onMapClick(_arg_1:MouseEvent):void {
        if (this.tooltip == null || this.tooltip.parent == null || this.tooltip.players_ == null || this.tooltip.players_.length == 0) {
            return;
        }
        this.removeMenu();
        this.addMenu();
        this.removeTooltip();
    }
}
}
