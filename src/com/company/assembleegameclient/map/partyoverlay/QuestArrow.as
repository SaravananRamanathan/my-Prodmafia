package com.company.assembleegameclient.map.partyoverlay {
import com.company.assembleegameclient.map.Camera;
import com.company.assembleegameclient.map.Map;
import com.company.assembleegameclient.map.Quest;
import com.company.assembleegameclient.objects.Character;
import com.company.assembleegameclient.objects.GameObject;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.ui.tooltip.PortraitToolTip;
import com.company.assembleegameclient.ui.tooltip.QuestToolTip;
import com.company.assembleegameclient.ui.tooltip.ToolTip;
import com.greensock.TimelineMax;
import com.greensock.TweenMax;
import com.greensock.easing.Expo;

import flash.events.MouseEvent;
import flash.utils.getTimer;

import kabam.rotmg.core.StaticInjectorContext;
import kabam.rotmg.game.model.QuestModel;

public class QuestArrow extends GameObjectArrow {


    public function QuestArrow(_arg_1:Map) {
        super(16352321, 12919330, true);
        map_ = _arg_1;
        this.questModel = StaticInjectorContext.getInjector().getInstance(QuestModel);
    }
    private var questArrowTween:TimelineMax;
    private var questModel:QuestModel;

    override public function draw(_arg_1:int, _arg_2:Camera):void {
        var _local5:* = false;
        var _local4:Boolean = false;
        var _local3:* = null;
        var _local7:* = null;
        var _local6:GameObject = map_.quest_.getObject(_arg_1);
        if (_local6 && _local6 is Character) {
            _local3 = _local6 as Character;
            _local7 = _local3.getName();
            if (_local7 != this.questModel.currentQuestHero) {
                this.questModel.currentQuestHero = _local7;
            }
        }
        if (_local6 != go_) {
            setGameObject(_local6);
            setToolTip(this.getToolTip(_local6, _arg_1));
            if (!this.questArrowTween) {
                this.questArrowTween = new TimelineMax();
                this.questArrowTween.add(TweenMax.to(this, 0.15, {
                    "scaleX": 1.6,
                    "scaleY": 1.6
                }));
                this.questArrowTween.add(TweenMax.to(this, 0.05, {
                    "scaleX": 1.8,
                    "scaleY": 1.8
                }));
                this.questArrowTween.add(TweenMax.to(this, 0.3, {
                    "scaleX": 1,
                    "scaleY": 1,
                    "ease": Expo.easeOut
                }));
            } else {
                this.questArrowTween.play(0);
            }
        } else if (go_) {
            _local5 = tooltip_ is QuestToolTip;
            _local4 = this.shouldShowFullQuest(_arg_1);
            if (_local5 != _local4) {
                setToolTip(this.getToolTip(_local6, _arg_1));
            }
        }
        super.draw(_arg_1, _arg_2);
    }

    public function refreshToolTip():void {
        if (this.questArrowTween.isActive()) {
            this.questArrowTween.pause(0);
            this.scaleX = 1;
            this.scaleY = 1;
        }
        setToolTip(this.getToolTip(go_, getTimer()));
    }

    private function getToolTip(_arg_1:GameObject, _arg_2:int):ToolTip {
        if (_arg_1 == null || _arg_1.texture == null) {
            return null;
        }
        if (this.shouldShowFullQuest(_arg_2)) {
            return new QuestToolTip(go_);
        }
        if (Parameters.data.showQuestPortraits) {
            return new PortraitToolTip(_arg_1);
        }
        return null;
    }

    private function shouldShowFullQuest(_arg_1:int):Boolean {
        var _local2:Quest = map_.quest_;
        return mouseOver_ || _local2.isNew(_arg_1);
    }

    override protected function onMouseOver(_arg_1:MouseEvent):void {
        super.onMouseOver(_arg_1);
        this.refreshToolTip();
    }

    override protected function onMouseOut(_arg_1:MouseEvent):void {
        super.onMouseOut(_arg_1);
        this.refreshToolTip();
    }
}
}
