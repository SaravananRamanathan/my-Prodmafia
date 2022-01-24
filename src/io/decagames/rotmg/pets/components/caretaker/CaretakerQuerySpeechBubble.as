package io.decagames.rotmg.pets.components.caretaker {
    import flash.display.Shape;
    import flash.display.Sprite;
    
    import kabam.rotmg.text.view.TextFieldDisplayConcrete;
    import kabam.rotmg.text.view.stringBuilder.LineBuilder;
    import kabam.rotmg.util.graphics.BevelRect;
    import kabam.rotmg.util.graphics.GraphicsHelper;
    
    public class CaretakerQuerySpeechBubble extends Sprite {
        
        
        private const WIDTH: int = 380;
        
        private const HEIGHT: int = 42;
        
        private const BEVEL: int = 4;
        
        private const POINT: int = 6;
        
        public function CaretakerQuerySpeechBubble(_arg_1: String) {
            super();
            addChild(this.makeBubble());
            addChild(this.makeText(_arg_1));
        }
        
        private function makeBubble(): Shape {
            var _local1: Shape = new Shape();
            this.drawBubble(_local1);
            return _local1;
        }
        
        private function drawBubble(_arg_1: Shape): void {
            var _local2: GraphicsHelper = new GraphicsHelper();
            var _local4: BevelRect = new BevelRect(380, 42, 4);
            _arg_1.graphics.beginFill(0xe0e0e0);
            _local2.drawBevelRect(0, 0, _local4, _arg_1.graphics);
            _arg_1.graphics.endFill();
            _arg_1.graphics.beginFill(0xe0e0e0);
            _arg_1.graphics.moveTo(0, 15);
            _arg_1.graphics.lineTo(-6, 21);
            _arg_1.graphics.lineTo(0, 27);
            _arg_1.graphics.endFill();
        }
        
        private function makeText(_arg_1: String): TextFieldDisplayConcrete {
            var _local2: TextFieldDisplayConcrete = new TextFieldDisplayConcrete().setSize(16).setAutoSize("center").setVerticalAlign("middle").setPosition(190, 21);
            _local2.setStringBuilder(new LineBuilder().setParams(_arg_1));
            return _local2;
        }
    }
}
