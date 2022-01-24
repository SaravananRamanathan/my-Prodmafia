package com.company.assembleegameclient.ui.panels {
import com.company.assembleegameclient.game.GameSprite;
import com.company.assembleegameclient.objects.Party;
import com.company.assembleegameclient.objects.Player;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.ui.PlayerGameObjectListItem;
import com.company.assembleegameclient.ui.menu.PlayerMenu;
import com.company.util.MoreColorUtil;

import flash.display.DisplayObjectContainer;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.ColorTransform;
import flash.utils.getTimer;

public class PartyPanel extends Panel {


    public function PartyPanel(_arg_1:GameSprite) {
        memberPanels = new Vector.<PlayerGameObjectListItem>(6, true);
        super(_arg_1);
        this.memberPanels[0] = this.createPartyMemberPanel(0, 0);
        this.memberPanels[1] = this.createPartyMemberPanel(100, 0);
        this.memberPanels[2] = this.createPartyMemberPanel(0, 32);
        this.memberPanels[3] = this.createPartyMemberPanel(100, 32);
        this.memberPanels[4] = this.createPartyMemberPanel(0, 64);
        this.memberPanels[5] = this.createPartyMemberPanel(100, 64);
        addEventListener("addedToStage", this.onAddedToStage, false, 0, true);
        addEventListener("removedFromStage", this.onRemovedFromStage, false, 0, true);
    }
    public var menuLayer:DisplayObjectContainer;
    public var memberPanels:Vector.<PlayerGameObjectListItem>;
    public var mouseOver_:Boolean;
    public var menu:PlayerMenu;

    override public function draw():void {
        var _local3:* = null;
        var _local8:* = null;
        var _local5:* = null;
        var _local4:Number = NaN;
        var _local7:int = 0;
        var _local2:int = 0;
        var _local1:int = 0;
        var _local6:Party = gs_.map.party_;
        if (_local6 == null) {
            var _local10:int = 0;
            var _local9:* = this.memberPanels;
            for each(_local3 in this.memberPanels) {
                _local3.clear();
            }
            return;
        }
        while (_local1 < 6) {
            if (this.mouseOver_ || this.menu != null && this.menu.parent != null) {
                _local8 = this.memberPanels[_local1].go as Player;
            } else {
                _local8 = _local6.members_[_local1];
            }
            if (_local8 != null && _local8.map_ == null) {
                _local8 = null;
            }
            _local5 = null;
            if (_local8 != null) {
                if (_local8.hp_ < _local8.maxHP_ * 0.2) {
                    if (_local2 == 0) {
                        _local2 = getTimer();
                    }
                    _local4 = int(Math.abs(Math.sin(_local2 / 200)) * 10) / 10;
                    _local7 = 128;
                    _local5 = new ColorTransform(1, 1, 1, 1, _local4 * _local7, -_local4 * _local7, -_local4 * _local7);
                }
                if (!_local8.starred_) {
                    if (_local5 != null) {
                        _local5.concat(MoreColorUtil.darkCT);
                    } else {
                        _local5 = MoreColorUtil.darkCT;
                    }
                }
            }
            this.memberPanels[_local1].draw(_local8, _local5);
            _local1++;
        }
    }

    public function dispose():void {
        this.menuLayer = null;
        this.menu = null;
        this.memberPanels = null;
        removeEventListener("addedToStage", this.onAddedToStage);
        removeEventListener("removedFromStage", this.onRemovedFromStage);
    }

    private function createPartyMemberPanel(_arg_1:int, _arg_2:int):PlayerGameObjectListItem {
        var _local3:PlayerGameObjectListItem = new PlayerGameObjectListItem(0xffffff, false, null);
        addChild(_local3);
        _local3.x = _arg_1 - 5;
        _local3.y = _arg_2 - 8;
        return _local3;
    }

    private function removeMenu():void {
        if (this.menu != null) {
            this.menu.remove();
            this.menu = null;
        }
    }

    private function onAddedToStage(_arg_1:Event):void {
        var _local2:* = null;
        var _local4:int = 0;
        var _local3:* = this.memberPanels;
        for each(_local2 in this.memberPanels) {
            _local2.addEventListener("mouseOver", this.onMouseOver, false, 0, true);
            _local2.addEventListener("mouseOut", this.onMouseOut, false, 0, true);
            _local2.addEventListener("mouseDown", this.onMouseDown);
        }
    }

    private function onRemovedFromStage(_arg_1:Event):void {
        var _local2:* = null;
        this.removeMenu();
        var _local4:int = 0;
        var _local3:* = this.memberPanels;
        for each(_local2 in this.memberPanels) {
            _local2.removeEventListener("mouseOver", this.onMouseOver);
            _local2.removeEventListener("mouseOut", this.onMouseOut);
            _local2.removeEventListener("mouseDown", this.onMouseDown);
        }
    }

    private function onMouseOver(_arg_1:MouseEvent):void {
        if (this.menu != null && this.menu.parent != null) {
            return;
        }
        var _local2:PlayerGameObjectListItem = _arg_1.currentTarget as PlayerGameObjectListItem;
        var _local3:Player = _local2.go as Player;
        if (_local3 == null || _local3.texture == null) {
            return;
        }
        this.mouseOver_ = true;
    }

    private function onMouseOut(_arg_1:MouseEvent):void {
        this.mouseOver_ = false;
    }

    private function onMouseDown(_arg_1:MouseEvent):void {
        this.removeMenu();
        var _local2:PlayerGameObjectListItem = _arg_1.currentTarget as PlayerGameObjectListItem;
        _local2.setEnabled(false);
        this.menu = new PlayerMenu();
        this.menu.init(gs_, _local2.go as Player);
        this.menuLayer.addChild(this.menu);
        this.menu.addEventListener("removedFromStage", this.onMenuRemoved);
    }

    private function onMenuRemoved(_arg_1:Event):void {
        var _local2:* = null;
        var _local3:* = null;
        var _local5:int = 0;
        var _local4:* = this.memberPanels;
        for each(_local2 in this.memberPanels) {
            _local3 = _local2 as PlayerGameObjectListItem;
            if (_local3) {
                _local3.setEnabled(true);
            }
        }
        _arg_1.currentTarget.removeEventListener("removedFromStage", this.onMenuRemoved);
    }
}
}
