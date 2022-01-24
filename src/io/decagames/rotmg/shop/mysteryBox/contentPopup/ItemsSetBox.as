package io.decagames.rotmg.shop.mysteryBox.contentPopup {
    import io.decagames.rotmg.ui.gird.UIGridElement;
    
    public class ItemsSetBox extends UIGridElement {
        
        
        public function ItemsSetBox(_arg_1: Vector.<ItemBox>) {
            var _local2: int = 0;
            var _local3: * = null;
            super();
            this.items = _arg_1;
            var _local5: int = 0;
            var _local4: * = _arg_1;
            for each(_local3 in _arg_1) {
                _local3.y = _local2;
                addChild(_local3);
                _local2 = _local2 + _local3.height;
            }
            this.drawBackground(260);
        }
        
        private var items: Vector.<ItemBox>;
        
        override public function get height(): Number {
            return this.items.length * 48;
        }
        
        override public function resize(_arg_1: int, _arg_2: int = -1): void {
            this.drawBackground(_arg_1);
        }
        
        override public function dispose(): void {
            var _local1: * = null;
            var _local3: int = 0;
            var _local2: * = this.items;
            for each(_local1 in this.items) {
                _local1.dispose();
            }
            this.items = null;
            super.dispose();
        }
        
        private function drawBackground(_arg_1: int): void {
            this.graphics.clear();
            this.graphics.lineStyle(1, 10915138);
            this.graphics.beginFill(0x2d2d2d);
            this.graphics.drawRect(0, 0, _arg_1, this.items.length * 48);
            this.graphics.endFill();
        }
    }
}
