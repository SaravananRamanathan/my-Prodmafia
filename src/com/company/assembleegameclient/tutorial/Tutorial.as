package com.company.assembleegameclient.tutorial {
    import com.company.assembleegameclient.game.GameSprite;
    import com.company.assembleegameclient.parameters.Parameters;
    import com.company.util.PointUtil;

    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.filters.BlurFilter;
    import flash.utils.getTimer;

    import kabam.rotmg.assets.EmbeddedData;

    public class Tutorial extends Sprite {

        public static const NEXT_ACTION:String = "Next";
        public static const MOVE_FORWARD_ACTION:String = "MoveForward";
        public static const MOVE_BACKWARD_ACTION:String = "MoveBackward";
        public static const ROTATE_LEFT_ACTION:String = "RotateLeft";
        public static const ROTATE_RIGHT_ACTION:String = "RotateRight";
        public static const MOVE_LEFT_ACTION:String = "MoveLeft";
        public static const MOVE_RIGHT_ACTION:String = "MoveRight";
        public static const UPDATE_ACTION:String = "Update";
        public static const ATTACK_ACTION:String = "Attack";
        public static const DAMAGE_ACTION:String = "Damage";
        public static const KILL_ACTION:String = "Kill";
        public static const SHOW_LOOT_ACTION:String = "ShowLoot";
        public static const TEXT_ACTION:String = "Text";
        public static const SHOW_PORTAL_ACTION:String = "ShowPortal";
        public static const ENTER_PORTAL_ACTION:String = "EnterPortal";
        public static const NEAR_REQUIREMENT:String = "Near";
        public static const EQUIP_REQUIREMENT:String = "Equip";

        public function Tutorial(_arg_1:GameSprite) {
            steps_ = new Vector.<Step>();
            darkBox_ = new Sprite();
            boxesBack_ = new Shape();
            boxes_ = new Shape();
            var _local2:* = null;
            var _local3:* = null;
            super();
            this.gs_ = _arg_1;
            this.lastTrackingStepTimestamp = getTimer();
            var _local5:int = 0;
            var _local4:* = EmbeddedData.tutorialXML.Step;
            for each (_local2 in EmbeddedData.tutorialXML.Step) {
                this.steps_.push(new Step(_local2));
            }
            addChild(this.boxesBack_);
            addChild(this.boxes_);
            _local3 = this.darkBox_.graphics;
            _local3.clear();
            _local3.beginFill(0, 0.1);
            _local3.drawRect(0, 0, 800, 10 * 60);
            _local3.endFill();
            Parameters.data.needsTutorial = false;
            Parameters.save();
            addEventListener("addedToStage", this.onAddedToStage);
            addEventListener("removedFromStage", this.onRemovedFromStage);
        }
        public var gs_:GameSprite;
        public var steps_:Vector.<Step>;
        public var currStepId_:int = 0;
        private var darkBox_:Sprite;
        private var boxesBack_:Shape;
        private var boxes_:Shape;
        private var tutorialMessage_:TutorialMessage = null;
        private var lastTrackingStepTimestamp:uint;

        internal function doneAction(_arg_1:String):void {
            var _local5:* = undefined;
            var _local4:Boolean = false;
            var _local2:* = null;
            var _local6:Number = NaN;
            var _local8:* = null;
            var _local7:* = null;
            if (this.currStepId_ >= this.steps_.length) {
                return;
            }
            var _local3:Step = this.steps_[this.currStepId_];
            if (_arg_1 != _local3.action_) {
                return;
            }
            var _local12:int = 0;
            var _local11:* = _local3.reqs_;
            loop0: for each (_local8 in _local3.reqs_) {
                _local7 = this.gs_.map.player_;
                var _local10:* = _local8.type_;
                switch (_local10) {
                    case "Near":
                        _local4 = false;
                        _local10 = 0;
                        var _local9:* = this.gs_.map.goDict_;
                        for each (_local2 in this.gs_.map.goDict_) {
                            if (_local2.objectType_ == _local8.objectType_) {
                                _local6 = PointUtil.distanceXY(_local2.x_, _local2.y_, _local7.x_, _local7.y_);
                                if (_local6 <= _local8.radius_) {
                                    _local4 = true;
                                    break;
                                }
                            }
                        }
                        if (_local4) {
                            continue;
                        }
                        break loop0;
                    case "Equip":
                        if (_local7.equipment_[_local8.slot_] != _local8.objectType_) {
                            return;
                        }
                        continue;
                    default:
                        trace("ERROR: unrecognized req: " + _local8.type_);

                }
            }
            _local5 = this;
            this.currStepId_++;
            this.draw();
        }

        private function draw():void {
        }

        private function onAddedToStage(_arg_1:Event):void {
            addEventListener("enterFrame", this.onEnterFrame);
            this.draw();
        }

        private function onRemovedFromStage(_arg_1:Event):void {
            removeEventListener("enterFrame", this.onEnterFrame);
        }

        private function onEnterFrame(_arg_1:Event):void {
            var _local8:int = 0;
            var _local11:* = null;
            var _local4:Boolean = false;
            var _local6:* = null;
            var _local13:int = 0;
            var _local7:* = null;
            var _local2:* = null;
            var _local5:* = null;
            var _local3:Boolean = false;
            var _local10:* = null;
            var _local9:Number = NaN;
            var _local12:Number = Math.abs(Math.sin(getTimer() / 300));
            this.boxesBack_.filters = [new BlurFilter(5 + _local12 * 5, 5 + _local12 * 5)];
            this.boxes_.graphics.clear();
            this.boxesBack_.graphics.clear();
            _local8 = 0;
            while (_local8 < this.steps_.length) {
                _local11 = this.steps_[_local8];
                _local4 = true;
                var _local17:int = 0;
                var _local16:* = _local11.reqs_;
                for each (_local6 in _local11.reqs_) {
                    _local5 = this.gs_.map.player_;
                    var _local15:* = _local6.type_;
                    if ("Near" !== _local15) {
                        trace("ERROR: unrecognized req: " + _local6.type_);
                    } else {
                        _local3 = false;
                        _local15 = 0;
                        var _local14:* = this.gs_.map.goDict_;
                        for each (_local10 in this.gs_.map.goDict_) {
                            if (!(_local10.objectType_ != _local6.objectType_ || _local6.objectName_ != "" && _local10.name_ != _local6.objectName_)) {
                                _local9 = PointUtil.distanceXY(_local10.x_, _local10.y_, _local5.x_, _local5.y_);
                                if (_local9 <= _local6.radius_) {
                                    _local3 = true;
                                    break;
                                }
                            }
                        }
                        if (!_local3) {
                            _local4 = false;
                        }
                    }
                }
                if (!_local4) {
                    _local11.satisfiedSince_ = 0;
                } else {
                    if (_local11.satisfiedSince_ == 0) {
                        _local11.satisfiedSince_ = getTimer();
                    }
                    _local13 = getTimer() - _local11.satisfiedSince_;
                    var _local19:int = 0;
                    var _local18:* = _local11.uiDrawBoxes_;
                    for each (_local7 in _local11.uiDrawBoxes_) {
                        _local7.draw(5 * _local12, this.boxes_.graphics, _local13);
                        _local7.draw(6 * _local12, this.boxesBack_.graphics, _local13);
                    }
                    var _local21:int = 0;
                    var _local20:* = _local11.uiDrawArrows_;
                    for each (_local2 in _local11.uiDrawArrows_) {
                        _local2.draw(5 * _local12, this.boxes_.graphics, _local13);
                        _local2.draw(6 * _local12, this.boxesBack_.graphics, _local13);
                    }
                }
                _local8++;
            }
        }
    }
}
