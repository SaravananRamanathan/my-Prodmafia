package com.company.assembleegameclient.map.partyoverlay {
import com.company.assembleegameclient.map.Camera;
import com.company.assembleegameclient.map.Map;
import com.company.assembleegameclient.objects.Party;

import flash.display.Sprite;
import flash.events.Event;

public class PartyOverlay extends Sprite {


    public function PartyOverlay(_arg_1:Map) {
        var _local3:* = null;
        var _local2:int = 0;
        super();
        this.map_ = _arg_1;
        this.partyMemberArrows_ = new Vector.<PlayerArrow>(6, true);
        while (_local2 < 6) {
            _local3 = new PlayerArrow();
            this.partyMemberArrows_[_local2] = _local3;
            addChild(_local3);
            _local2++;
        }
        this.questArrow_ = new QuestArrow(this.map_);
        addChild(this.questArrow_);
        addEventListener("removedFromStage", this.onRemovedFromStage);
    }
    public var map_:Map;
    public var partyMemberArrows_:Vector.<PlayerArrow> = null;
    public var questArrow_:QuestArrow;

    public function draw(_arg_1:Camera, _arg_2:int):void {
        var _local5:Number = NaN;
        var _local11:Number = NaN;
        var _local10:int = 0;
        var _local9:int = 0;
        var _local6:* = null;
        var _local4:* = null;
        var _local8:* = null;
        if (this.map_.player_ == null) {
            return;
        }
        var _local3:Party = this.map_.party_;
        var _local7:uint = _local3.members_.length;
        _local10 = 0;
        while (_local10 < 6) {
            _local6 = this.partyMemberArrows_[_local10];
            if (!_local6.mouseOver_) {
                if (_local10 >= _local7) {
                    _local6.setGameObject(null);
                } else {
                    _local4 = _local3.members_[_local10];
                    if (_local4.drawn_ || _local4.map_ == null || _local4.dead_) {
                        _local6.setGameObject(null);
                    } else {
                        _local6.setGameObject(_local4);
                        _local9 = 0;
                        while (_local9 < _local10) {
                            _local8 = this.partyMemberArrows_[_local9];
                            _local5 = _local6.x - _local8.x;
                            _local11 = _local6.y - _local8.y;
                            if (_local5 * _local5 + _local11 * _local11 < 64) {
                                if (!_local8.mouseOver_) {
                                    _local8.addGameObject(_local4);
                                }
                                _local6.setGameObject(null);
                                break;
                            }
                            _local9++;
                        }
                        _local6.draw(_arg_2, _arg_1);
                    }
                }
            }
            _local10++;
        }
        if (!this.questArrow_.mouseOver_) {
            this.questArrow_.draw(_arg_2, _arg_1);
        }
    }

    private function onRemovedFromStage(_arg_1:Event):void {
        GameObjectArrow.removeMenu();
    }
}
}
