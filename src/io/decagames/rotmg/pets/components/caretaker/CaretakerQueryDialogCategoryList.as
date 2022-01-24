package io.decagames.rotmg.pets.components.caretaker {
    import flash.display.DisplayObject;
    import flash.events.MouseEvent;
    
    import kabam.lib.ui.impl.LayoutList;
    import kabam.lib.ui.impl.VerticalLayout;
    import kabam.rotmg.ui.view.SignalWaiter;
    
    import org.osflash.signals.Signal;
    
    public class CaretakerQueryDialogCategoryList extends LayoutList {
        
        
        private const waiter: SignalWaiter = new SignalWaiter();
        
        public const ready: Signal = waiter.complete;
        
        public const selected: Signal = new Signal(String);
        
        public function CaretakerQueryDialogCategoryList(_arg_1: Array) {
            super();
            setLayout(this.makeLayout());
            setItems(this.makeItems(_arg_1));
            this.ready.addOnce(updateLayout);
        }
        
        private function makeLayout(): VerticalLayout {
            var _local1: VerticalLayout = new VerticalLayout();
            _local1.setPadding(2);
            return _local1;
        }
        
        private function makeItems(_arg_1: Array): Vector.<DisplayObject> {
            var _local3: int = 0;
            var _local2: Vector.<DisplayObject> = new Vector.<DisplayObject>();
            while (_local3 < _arg_1.length) {
                _local2.push(this.makeItem(_arg_1[_local3]));
                _local3++;
            }
            return _local2;
        }
        
        private function makeItem(_arg_1: Object): CaretakerQueryDialogCategoryItem {
            var _local2: CaretakerQueryDialogCategoryItem = new CaretakerQueryDialogCategoryItem(_arg_1.category, _arg_1.info);
            _local2.addEventListener("click", this.onClick);
            this.waiter.push(_local2.textChanged);
            return _local2;
        }
        
        private function onClick(_arg_1: MouseEvent): void {
            var _local2: CaretakerQueryDialogCategoryItem = _arg_1.currentTarget as CaretakerQueryDialogCategoryItem;
            this.selected.dispatch(_local2.info);
        }
    }
}
