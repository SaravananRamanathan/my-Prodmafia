package io.decagames.rotmg.pets.components.caretaker {
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    
    import kabam.rotmg.text.view.TextFieldDisplayConcrete;
    import kabam.rotmg.text.view.stringBuilder.LineBuilder;
    import kabam.rotmg.util.graphics.BevelRect;
    import kabam.rotmg.util.graphics.GraphicsHelper;
    
    import org.osflash.signals.Signal;
    
    public class CaretakerQueryDialogCategoryItem extends Sprite {
        
        private static const WIDTH: int = 440;
        
        private static const HEIGHT: int = 40;
        
        private static const BEVEL: int = 2;
        
        private static const OUT: uint = 6052956;
        
        private static const OVER: uint = 8355711;
        
        
        private const helper: GraphicsHelper = new GraphicsHelper();
        
        private const rect: BevelRect = new BevelRect(440, 40, 2);
        
        private const background: Shape = makeBackground();
        
        private const textfield: TextFieldDisplayConcrete = makeTextfield();
        
        public const textChanged: Signal = textfield.textChanged;
        
        public function CaretakerQueryDialogCategoryItem(_arg_1: String, _arg_2: String) {
            super();
            this.info = _arg_2;
            this.textfield.setStringBuilder(new LineBuilder().setParams(_arg_1));
            this.makeInteractive();
        }
        
        public var info: String;
        
        private function makeBackground(): Shape {
            var _local1: Shape = new Shape();
            this.drawBackground(_local1, 0x5c5c5c);
            addChild(_local1);
            return _local1;
        }
        
        private function drawBackground(_arg_1: Shape, _arg_2: uint): void {
            _arg_1.graphics.clear();
            _arg_1.graphics.beginFill(_arg_2);
            this.helper.drawBevelRect(0, 0, this.rect, _arg_1.graphics);
            _arg_1.graphics.endFill();
        }
        
        private function makeTextfield(): TextFieldDisplayConcrete {
            var _local1: TextFieldDisplayConcrete = new TextFieldDisplayConcrete().setSize(16).setColor(0xffffff).setBold(true).setAutoSize("center").setVerticalAlign("middle").setPosition(220, 20);
            _local1.mouseEnabled = false;
            addChild(_local1);
            return _local1;
        }
        
        private function makeInteractive(): void {
            addEventListener("mouseOver", this.onMouseOver);
            addEventListener("mouseOut", this.onMouseOut);
        }
        
        private function onMouseOver(_arg_1: MouseEvent): void {
            this.drawBackground(this.background, 0x7f7f7f);
        }
        
        private function onMouseOut(_arg_1: MouseEvent): void {
            this.drawBackground(this.background, 0x5c5c5c);
        }
    }
}
