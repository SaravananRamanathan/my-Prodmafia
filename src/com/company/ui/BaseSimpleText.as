package com.company.ui {
    import flash.events.Event;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.text.TextLineMetrics;

    public class BaseSimpleText extends TextField {
        public var inputWidth_:int;
        public var inputHeight_:int;
        public var actualWidth_:int;
        public var actualHeight_:int;

        public function BaseSimpleText(size:int, color:uint, input:Boolean = false, w:int = 0, h:int = 0, bold:Boolean = false) {
            super();
            this.inputWidth_ = w;
            if (this.inputWidth_ != 0)
                width = w;
            this.inputHeight_ = h;
            if (this.inputHeight_ != 0)
                height = h;
            this.embedFonts = true;
            var format:TextFormat = new TextFormat();
            format.font = "Myriad Pro";
            format.bold = bold;
            format.size = size;
            format.color = color;
            this.defaultTextFormat = format;
            if (input) {
                this.selectable = true;
                this.mouseEnabled = true;
                this.type = "input";
                this.border = true;
                this.borderColor = color;
                this.addEventListener(Event.CHANGE, this.onChange, false, 0, true);
            } else {
                this.selectable = false;
                this.mouseEnabled = false;
            }
            this.setTextFormat(format);
        }

        public function setFont(fontName:String):void {
            var format:TextFormat = this.defaultTextFormat;
            format.font = fontName;
            this.applyFormat(format);
        }

        public function setSize(fontSize:int):void {
            var format:TextFormat = this.defaultTextFormat;
            format.size = fontSize;
            this.applyFormat(format);
        }

        public function setColor(fontColor:uint):void {
            var format:TextFormat = this.defaultTextFormat;
            format.color = fontColor;
            this.applyFormat(format);
        }

        public function setBold(bold:Boolean):void {
            var format:TextFormat = this.defaultTextFormat;
            format.bold = bold;
            this.applyFormat(format);
        }

        public function setAlignment(textAlign:String):void {
            var format:TextFormat = this.defaultTextFormat;
            format.align = textAlign;
            this.applyFormat(format);
        }

        public function setText(text:String):void {
            this.text = text;
        }

        public function setMultiLine(wordWrap:Boolean):void {
            this.wordWrap = wordWrap;
        }

        public function updateMetrics():void {
            var metrics:TextLineMetrics = null;
            var w:int = 0;
            var h:int = 0;

            this.actualWidth_ = 0;
            this.actualHeight_ = 0;

            for (var i:int = 0; i < this.numLines; i++) {
                metrics = this.getLineMetrics(i);
                w = metrics.width + 4;
                h = metrics.height + 4;
                if (w > this.actualWidth_)
                    this.actualWidth_ = w;

                this.actualHeight_ = this.actualHeight_ + h;
            }

            this.width = this.inputWidth_ == 0 ? this.actualWidth_ : this.inputWidth_;
            this.height = this.inputHeight_ == 0 ? this.actualHeight_ : this.inputHeight_;
        }

        public function useTextDimensions():void {
            this.width = this.inputWidth_ == 0 ? this.textWidth + 4 : this.inputWidth_;
            this.height = this.inputHeight_ == 0 ? this.textHeight + 4 : this.inputHeight_;
        }

        private function applyFormat(format:TextFormat):void {
            this.defaultTextFormat = format;
            this.setTextFormat(format);
        }

        private function onChange(_:Event):void {
            this.updateMetrics();
        }
    }
}
