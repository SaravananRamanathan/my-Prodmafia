package com.company.assembleegameclient.map.mapoverlay {
import com.company.assembleegameclient.map.Camera;
import com.company.assembleegameclient.map.Map;
import com.company.assembleegameclient.parameters.Parameters;

import flash.display.Sprite;
import flash.events.MouseEvent;

import kabam.rotmg.game.view.components.QueuedStatusText;
import kabam.rotmg.game.view.components.QueuedStatusTextList;

public class MapOverlay extends Sprite {


    private const speechBalloons:Object = {};

    private const queuedText:Object = {};

    public function MapOverlay() {
        super();
        mouseEnabled = true;
        mouseChildren = true;
        addEventListener("mouseDown", this.onMouseDown, false, 0, true);
    }

    public function addSpeechBalloon(_arg_1:SpeechBalloon):void {
        var _local2:int = _arg_1.go_.objectId_;
        var _local3:SpeechBalloon = this.speechBalloons[_local2];
        if (_local3 && contains(_local3)) {
            removeChild(_local3);
        }
        this.speechBalloons[_local2] = _arg_1;
        addChild(_arg_1);
    }

    public function addStatusText(_arg_1:CharacterStatusText):void {
        if (Parameters.lowCPUMode && _arg_1.go_ != _arg_1.go_.map_.player_)
            return;

        addChild(_arg_1);
    }

    public function addQueuedText(_arg_1:QueuedStatusText):void {
        if (Parameters.lowCPUMode && _arg_1.go_ != _arg_1.go_.map_.player_) {
            return;
        }
        var _local2:int = _arg_1.go_.objectId_;
        var _local3:QueuedStatusTextList = this.makeQueuedStatusTextList();
        _local3.append(_arg_1);
    }

    public function draw(_arg_1:Camera, _arg_2:int):void {
        var _local4:* = null;
        var _local3:int = 0;
        while (_local3 < numChildren) {
            _local4 = getChildAt(_local3) as IMapOverlayElement;
            if (!_local4 || _local4.draw(_arg_1, _arg_2)) {
                _local3++;
            } else {
                _local4.dispose();
            }
        }
    }

    private function makeQueuedStatusTextList():QueuedStatusTextList {
        var _local1:QueuedStatusTextList = new QueuedStatusTextList();
        _local1.target = this;
        return _local1;
    }

    private function onMouseDown(_arg_1:MouseEvent):void {
        (parent as Map).mapHitArea.dispatchEvent(_arg_1);
    }
}
}
