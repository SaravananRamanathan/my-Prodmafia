package io.decagames.rotmg.pets.components.caretaker {
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Sprite;
    
    public class CaretakerQueryDialogCaretaker extends Sprite {
        
        
        private const speechBubble: CaretakerQuerySpeechBubble = makeSpeechBubble();
        
        private const detailBubble: CaretakerQueryDetailBubble = makeDetailBubble();
        
        private const icon: Bitmap = makeCaretakerIcon();
        
        public function CaretakerQueryDialogCaretaker() {
            super();
        }
        
        public function showDetail(_arg_1: String): void {
            this.detailBubble.setText(_arg_1);
            removeChild(this.speechBubble);
            addChild(this.detailBubble);
        }
        
        public function showSpeech(): void {
            removeChild(this.detailBubble);
            addChild(this.speechBubble);
        }
        
        public function setCaretakerIcon(_arg_1: BitmapData): void {
            this.icon.bitmapData = _arg_1;
        }
        
        private function makeSpeechBubble(): CaretakerQuerySpeechBubble {
            var _local1: * = null;
            _local1 = new CaretakerQuerySpeechBubble("CaretakerQueryDialog.query");
            _local1.x = 60;
            addChild(_local1);
            return _local1;
        }
        
        private function makeDetailBubble(): CaretakerQueryDetailBubble {
            var _local1: CaretakerQueryDetailBubble = new CaretakerQueryDetailBubble();
            _local1.y = 60;
            return _local1;
        }
        
        private function makeCaretakerIcon(): Bitmap {
            var _local1: Bitmap = new Bitmap(this.makeDebugBitmapData());
            _local1.x = -16;
            _local1.y = -32;
            addChild(_local1);
            return _local1;
        }
        
        private function makeDebugBitmapData(): BitmapData {
            return new BitmapData(42, 42, true, 4278255360);
        }
    }
}
