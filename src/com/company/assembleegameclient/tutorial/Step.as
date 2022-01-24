package com.company.assembleegameclient.tutorial {

    public class Step {

        public var text_:String;
        public var action_:String;
        public var uiDrawBoxes_:Vector.<UIDrawBox>;
        public var uiDrawArrows_:Vector.<UIDrawArrow>;
        public var reqs_:Vector.<Requirement>;
        public var satisfiedSince_:int = 0;
        public var trackingSent:Boolean;

        public function Step(_arg_1:XML) {
            uiDrawBoxes_ = new Vector.<UIDrawBox>();
            uiDrawArrows_ = new Vector.<UIDrawArrow>();
            reqs_ = new Vector.<Requirement>();
            var _local2:* = null;
            var _local4:* = null;
            var _local3:* = null;
            super();
            var _local6:int = 0;
            var _local5:* = _arg_1.UIDrawBox;
            for each (_local2 in _arg_1.UIDrawBox) {
                this.uiDrawBoxes_.push(new UIDrawBox(_local2));
            }
            var _local8:int = 0;
            var _local7:* = _arg_1.UIDrawArrow;
            for each (_local4 in _arg_1.UIDrawArrow) {
                this.uiDrawArrows_.push(new UIDrawArrow(_local4));
            }
            var _local10:int = 0;
            var _local9:* = _arg_1.Requirement;
            for each (_local3 in _arg_1.Requirement) {
                this.reqs_.push(new Requirement(_local3));
            }
        }

        public function toString():String {
            return "[" + this.text_ + "]";
        }
    }
}
