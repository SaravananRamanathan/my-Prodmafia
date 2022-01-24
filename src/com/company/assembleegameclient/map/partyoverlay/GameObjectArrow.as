package com.company.assembleegameclient.map.partyoverlay {
import com.company.assembleegameclient.map.Camera;
import com.company.assembleegameclient.map.Map;
import com.company.assembleegameclient.objects.GameObject;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.ui.menu.Menu;
import com.company.assembleegameclient.ui.tooltip.ToolTip;
import com.company.util.RectangleUtil;
import com.company.util.Trig;

import flash.display.DisplayObjectContainer;
import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;
import flash.geom.Point;
import flash.geom.Rectangle;

public class GameObjectArrow extends Sprite {

    public static const SMALL_SIZE:int = 8;

    public static const BIG_SIZE:int = 11;

    public static const DIST:int = 3;

    private static var menu_:Menu = null;

    public static function removeMenu():void {
        if (menu_ != null) {
            if (menu_.parent != null) {
                menu_.parent.removeChild(menu_);
            }
            menu_ = null;
        }
    }

    public function GameObjectArrow(_arg_1:uint, _arg_2:uint, _arg_3:Boolean) {
        extraGOs_ = new Vector.<GameObject>();
        arrow_ = new Shape();
        tempPoint = new Point();
        super();
        this.lineColor_ = _arg_1;
        this.fillColor_ = _arg_2;
        this.big_ = _arg_3;
        addChild(this.arrow_);
        this.drawArrow();
        addEventListener("mouseOver", this.onMouseOver);
        addEventListener("mouseOut", this.onMouseOut);
        addEventListener("mouseDown", this.onMouseDown);
        filters = [new DropShadowFilter(0, 0, 0, 1, 8, 8)];
        visible = false;
    }
    public var menuLayer:DisplayObjectContainer;
    public var lineColor_:uint;
    public var fillColor_:uint;
    public var go_:GameObject = null;
    public var extraGOs_:Vector.<GameObject>;
    public var mouseOver_:Boolean = false;
    public var map_:Map;
    protected var tooltip_:ToolTip = null;
    private var big_:Boolean;
    private var arrow_:Shape;
    private var tempPoint:Point;

    public function setGameObject(_arg_1:GameObject):void {
        if (this.go_ != _arg_1) {
            this.go_ = _arg_1;
        }
        this.extraGOs_.length = 0;
        if (this.go_ == null) {
            visible = false;
        }
    }

    public function addGameObject(_arg_1:GameObject):void {
        this.extraGOs_.push(_arg_1);
    }

    public function correctQuestNote(_arg_1:Rectangle):Rectangle {
        var _local3:* = undefined;
        var _local2:Rectangle = _arg_1.clone();
        if (Parameters.data.uiscale) {
            _local3 = (stage.stageWidth < stage.stageHeight ? stage.stageWidth : int(stage.stageHeight)) / Parameters.data.mscale / 600;
            this.scaleX = _local3;
            this.scaleY = _local3;
        } else {
            this.scaleX = 1;
            this.scaleY = 1;
        }
        _local2.right = _local2.right - (800 - this.go_.map_.gs_.hudView.x) * stage.stageWidth / Parameters.data.mscale / 800;
        return _local2;
    }

    public function draw(_arg_1:int, _arg_2:Camera):void {
        var _local4:Number = NaN;
        var _local3:Number = NaN;
        var _local6:* = null;
        if (this.go_ == null) {
            visible = false;
            return;
        }
        this.go_.computeSortVal(_arg_2);
        _local6 = this.correctQuestNote(_arg_2.clipRect_);
        _local4 = this.go_.posS_[0];
        _local3 = this.go_.posS_[1];
        if (!RectangleUtil.lineSegmentIntersectXY(_local6, 0, 0, _local4, _local3, this.tempPoint)) {
            this.go_ = null;
            visible = false;
            return;
        }
        x = this.tempPoint.x;
        y = this.tempPoint.y;
        var _local5:* = Number(Trig.boundTo180(270 - 57.2957795130823 * Math.atan2(_local4, _local3)));
        if (this.tempPoint.x < _local6.left + 5) {
            if (_local5 > 45) {
                _local5 = 45;
            }
            if (_local5 < -45) {
                _local5 = -45;
            }
        } else if (this.tempPoint.x > _local6.right - 5) {
            if (_local5 > 0) {
                if (_local5 < 135) {
                    _local5 = 135;
                }
            } else if (_local5 > -135) {
                _local5 = -135;
            }
        }
        if (this.tempPoint.y < _local6.top + 5) {
            if (_local5 < 45) {
                _local5 = 45;
            }
            if (_local5 > 135) {
                _local5 = 135;
            }
        } else if (this.tempPoint.y > _local6.bottom - 5) {
            if (_local5 > -45) {
                _local5 = -45;
            }
            if (_local5 < -135) {
                _local5 = -135;
            }
        }
        this.arrow_.rotation = _local5;
        if (this.tooltip_) {
            this.positionTooltip(this.tooltip_);
        }
        visible = true;
    }

    protected function setToolTip(_arg_1:ToolTip):void {
        this.removeTooltip();
        this.tooltip_ = _arg_1;
        if (this.tooltip_ != null) {
            addChild(this.tooltip_);
            this.positionTooltip(this.tooltip_);
        }
    }

    protected function removeTooltip():void {
        if (this.tooltip_ != null) {
            if (this.tooltip_.parent != null) {
                this.tooltip_.parent.removeChild(this.tooltip_);
            }
            this.tooltip_ = null;
        }
    }

    protected function setMenu(_arg_1:Menu):void {
        this.removeTooltip();
        menu_ = _arg_1;
        this.menuLayer.addChild(menu_);
    }

    private function positionTooltip(_arg_1:ToolTip):void {
        var _local9:Number = NaN;
        var _local8:Number = NaN;
        var _local7:Number = NaN;
        var _local2:Number = this.arrow_.rotation;
        var _local3:Number = 26 * Math.cos(_local2 * 0.0174532925199433);
        _local9 = 26 * Math.sin(_local2 * 0.0174532925199433);
        var _local5:Number = _arg_1.contentWidth_;
        var _local4:Number = _arg_1.contentHeight_;
        if (_local2 >= 45 && _local2 <= 135) {
            _local8 = _local3 + _local5 / Math.tan(_local2 * 0.0174532925199433);
            _arg_1.x = (_local3 + _local8) / 2 - _local5 / 2;
            _arg_1.y = _local9;
        } else if (_local2 <= -45 && _local2 >= -135) {
            _local8 = _local3 - _local5 / Math.tan(_local2 * 0.0174532925199433);
            _arg_1.x = (_local3 + _local8) / 2 - _local5 / 2;
            _arg_1.y = _local9 - _local4;
        } else if (_local2 < 45 && _local2 > -45) {
            _arg_1.x = _local3;
            _local7 = _local9 + _local4 * Math.tan(_local2 * 0.0174532925199433);
            _arg_1.y = (_local9 + _local7) / 2 - _local4 / 2;
        } else {
            _arg_1.x = _local3 - _local5;
            _local7 = _local9 - _local4 * Math.tan(_local2 * 0.0174532925199433);
            _arg_1.y = (_local9 + _local7) / 2 - _local4 / 2;
        }
    }

    private function drawArrow():void {
        var _local1:Graphics = this.arrow_.graphics;
        _local1.clear();
        var _local2:int = this.big_ || this.mouseOver_ ? 11 : 8;
        _local1.lineStyle(1, this.lineColor_);
        _local1.beginFill(this.fillColor_);
        _local1.moveTo(3, 0);
        _local1.lineTo(_local2 + 3, _local2);
        _local1.lineTo(_local2 + 3, -_local2);
        _local1.lineTo(3, 0);
        _local1.endFill();
        _local1.lineStyle();
    }

    protected function onMouseOver(_arg_1:MouseEvent):void {
        this.mouseOver_ = true;
        this.drawArrow();
    }

    protected function onMouseOut(_arg_1:MouseEvent):void {
        this.mouseOver_ = false;
        this.drawArrow();
    }

    protected function onMouseDown(_arg_1:MouseEvent):void {
        this.map_.mapHitArea.dispatchEvent(_arg_1);
    }
}
}
