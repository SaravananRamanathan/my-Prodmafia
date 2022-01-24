package com.company.assembleegameclient.tutorial {
    import com.company.assembleegameclient.parameters.Parameters;
    import com.company.assembleegameclient.ui.DeprecatedTextButton;
    import com.company.util.GraphicsUtil;

    import flash.display.GraphicsPath;
    import flash.display.GraphicsSolidFill;
    import flash.display.GraphicsStroke;
    import flash.display.IGraphicsData;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.geom.Rectangle;
    import flash.utils.getTimer;

    import kabam.rotmg.text.view.TextFieldDisplayConcrete;
    import kabam.rotmg.text.view.stringBuilder.LineBuilder;

    public class TutorialMessage extends Sprite {

        public static const BORDER:int = 8;

        public function TutorialMessage(_arg_1:Tutorial, _arg_2:String, _arg_3:Boolean, _arg_4:Rectangle) {
            fill_ = new GraphicsSolidFill(0x363636, 1);
            lineStyle_ = new GraphicsStroke(1, false, "normal", "none", "round", 3, new GraphicsSolidFill(0xffffff));
            path_ = new GraphicsPath(new Vector.<int>(), new Vector.<Number>());
            graphicsData_ = new <IGraphicsData>[lineStyle_, fill_, path_, GraphicsUtil.END_FILL, GraphicsUtil.END_STROKE];
            super();
            this.tutorial_ = _arg_1;
            this.rect_ = _arg_4.clone();
            x = this.rect_.x;
            y = this.rect_.y;
            this.rect_.x = 0;
            this.rect_.y = 0;
            this.messageText_ = new TextFieldDisplayConcrete().setSize(15).setColor(0xffffff).setTextWidth(this.rect_.width - 32);
            this.messageText_.setStringBuilder(new LineBuilder().setParams(_arg_2));
            this.messageText_.x = 16;
            this.messageText_.y = 16;
            if (_arg_3) {
                this.nextButton_ = new DeprecatedTextButton(18, "Next");
                this.nextButton_.addEventListener("click", this.onNextButton);
                this.nextButton_.x = this.rect_.width - this.nextButton_.width - 20;
                this.nextButton_.y = this.rect_.height - this.nextButton_.height - 10;
            }
            addEventListener("addedToStage", this.onAddedToStage);
            addEventListener("removedFromStage", this.onRemovedFromStage);
        }
        private var tutorial_:Tutorial;
        private var rect_:Rectangle;
        private var messageText_:TextFieldDisplayConcrete;
        private var nextButton_:DeprecatedTextButton = null;
        private var startTime_:int;
        private var fill_:GraphicsSolidFill;
        private var lineStyle_:GraphicsStroke;
        private var path_:GraphicsPath;
        private var graphicsData_:Vector.<IGraphicsData>;

        private function drawRect():void {
            var _local1:Number = Math.min(1, 0.1 + 0.9 * (getTimer() - this.startTime_) / 200);
            if (_local1 == 1) {
                addChild(this.messageText_);
                if (this.nextButton_ != null) {
                    addChild(this.nextButton_);
                }
                removeEventListener("enterFrame", this.onEnterFrame);
            }
            var _local2:Rectangle = this.rect_.clone();
            _local2.inflate(-(1 - _local1) * this.rect_.width / 2, -(1 - _local1) * this.rect_.height / 2);
            GraphicsUtil.clearPath(this.path_);
            GraphicsUtil.drawCutEdgeRect(_local2.x, _local2.y, _local2.width, _local2.height, 4, [1, 1, 1, 1], this.path_);
            graphics.clear();
            graphics.drawGraphicsData(this.graphicsData_);
        }

        private function onAddedToStage(_arg_1:Event):void {
            this.startTime_ = getTimer();
            addEventListener("enterFrame", this.onEnterFrame);
        }

        private function onRemovedFromStage(_arg_1:Event):void {
            removeEventListener("enterFrame", this.onEnterFrame);
        }

        private function onEnterFrame(_arg_1:Event):void {
            this.drawRect();
        }

        private function onNextButton(_arg_1:MouseEvent):void {
            this.tutorial_.doneAction("Next");
        }
    }
}
