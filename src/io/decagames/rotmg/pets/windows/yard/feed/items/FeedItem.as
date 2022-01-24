package io.decagames.rotmg.pets.windows.yard.feed.items {
    import com.company.assembleegameclient.objects.ObjectLibrary;
    import com.company.assembleegameclient.ui.panels.itemgrids.itemtiles.InventoryTile;
    
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.geom.Matrix;
    
    import io.decagames.rotmg.ui.gird.UIGridElement;
    
    import kabam.rotmg.core.StaticInjectorContext;
    import kabam.rotmg.text.view.BitmapTextFactory;
    import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;
    
    public class FeedItem extends UIGridElement {
        
        
        public function FeedItem(_arg_1: InventoryTile) {
            super();
            this._item = _arg_1;
            this.renderBackground(0x454545, 0.25);
            this.renderItem();
        }
        
        private var imageBitmap: Bitmap;
        
        private var _item: InventoryTile;
        
        public function get item(): InventoryTile {
            return this._item;
        }
        
        private var _feedPower: int;
        
        public function get feedPower(): int {
            return this._feedPower;
        }
        
        private var _selected: Boolean;
        
        public function get selected(): Boolean {
            return this._selected;
        }
        
        public function set selected(_arg_1: Boolean): void {
            this._selected = _arg_1;
            if (_arg_1) {
                this.renderBackground(15306295, 1);
            } else {
                this.renderBackground(0x454545, 0.25);
            }
        }
        
        public function get itemId(): int {
            return this._item.getItemId();
        }
        
        override public function dispose(): void {
            super.dispose();
            this.imageBitmap.bitmapData.dispose();
        }
        
        private function renderBackground(_arg_1: uint, _arg_2: Number): void {
            graphics.clear();
            graphics.beginFill(_arg_1, _arg_2);
            graphics.drawRect(0, 0, 40, 40);
        }
        
        private function renderItem(): void {
            var _local4: * = null;
            var _local3: * = null;
            var _local5: * = null;
            this.imageBitmap = new Bitmap();
            var _local6: BitmapData = ObjectLibrary.getRedrawnTextureFromType(this._item.getItemId(), 40, true);
            _local6 = _local6.clone();
            var _local2: XML = ObjectLibrary.xmlLibrary_[this._item.getItemId()];
            this._feedPower = _local2.feedPower;
            var _local1: BitmapTextFactory = StaticInjectorContext.getInjector().getInstance(BitmapTextFactory);
            if (_local2 && _local2.hasOwnProperty("Quantity") && _local1) {
                _local3 = _local1.make(new StaticStringBuilder(_local2.Quantity), 12, 0xffffff, false, new Matrix(), true);
                _local5 = new Matrix();
                _local5.translate(8, 7);
                _local6.draw(_local3, _local5);
            }
            this.imageBitmap.bitmapData = _local6;
            addChild(this.imageBitmap);
        }
    }
}
