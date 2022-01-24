package io.decagames.rotmg.dailyQuests.view.slot {
    import com.company.assembleegameclient.objects.ObjectLibrary;
    
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.geom.Matrix;
    
    import io.decagames.rotmg.utils.colors.GreyScale;
    
    import kabam.rotmg.core.StaticInjectorContext;
    import kabam.rotmg.text.view.BitmapTextFactory;
    import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;
    
    public class DailyQuestItemSlot extends Sprite {
        
        public static const SELECTED_BORDER_SIZE: int = 2;
        
        public static const SLOT_SIZE: int = 40;
        
        public function DailyQuestItemSlot(_arg_1: int, _arg_2: String, _arg_3: Boolean = false, _arg_4: Boolean = false) {
            super();
            this._itemID = _arg_1;
            this._type = _arg_2;
            this._isSlotsSelectable = _arg_4;
            this.hasItem = _arg_3;
            this.imageBitmap = new Bitmap();
            this.imageContainer = new Sprite();
            addChild(this.imageContainer);
            this.imageContainer.x = Math.round(20);
            this.imageContainer.y = Math.round(20);
            this.createBackground();
            this.renderItem();
        }
        
        private var bitmapFactory: BitmapTextFactory;
        private var imageContainer: Sprite;
        private var backgroundShape: Shape;
        private var hasItem: Boolean;
        private var imageBitmap: Bitmap;
        
        private var _itemID: int;
        
        public function get itemID(): int {
            return this._itemID;
        }
        
        private var _type: String;
        
        public function get type(): String {
            return this._type;
        }
        
        private var _isSlotsSelectable: Boolean;
        
        public function get isSlotsSelectable(): Boolean {
            return this._isSlotsSelectable;
        }
        
        public var _selected: Boolean;
        
        public function get selected(): Boolean {
            return this._selected;
        }
        
        public function set selected(_arg_1: Boolean): void {
            this._selected = _arg_1;
            this.createBackground();
            this.renderItem();
        }
        
        public function dispose(): void {
            if (this.imageBitmap && this.imageBitmap.bitmapData) {
                this.imageBitmap.bitmapData.dispose();
            }
        }
        
        private function createBackground(): void {
            if (!this.backgroundShape) {
                this.backgroundShape = new Shape();
                this.imageContainer.addChild(this.backgroundShape);
            }
            this.backgroundShape.graphics.clear();
            if (this.isSlotsSelectable) {
                if (this._selected) {
                    this.backgroundShape.graphics.beginFill(14846006, 1);
                    this.backgroundShape.graphics.drawRect(-2, -2, 44, 44);
                    this.backgroundShape.graphics.beginFill(14846006, 1);
                } else {
                    this.backgroundShape.graphics.beginFill(0x454545, 1);
                }
            } else {
                this.backgroundShape.graphics.beginFill(!!this.hasItem ? 1286144 : 4539717, 1);
            }
            this.backgroundShape.graphics.drawRect(0, 0, 40, 40);
            this.backgroundShape.x = -Math.round(22);
            this.backgroundShape.y = -Math.round(22);
        }
        
        private function renderItem(): void {
            var _local1: * = null;
            var _local3: * = null;
            if (this.imageBitmap.bitmapData) {
                this.imageBitmap.bitmapData.dispose();
            }
            var _local4: BitmapData = ObjectLibrary.getRedrawnTextureFromType(this._itemID, 80, true);
            _local4 = _local4.clone();
            var _local2: XML = ObjectLibrary.xmlLibrary_[this._itemID];
            this.bitmapFactory = StaticInjectorContext.getInjector().getInstance(BitmapTextFactory);
            if (_local2 && _local2.hasOwnProperty("Quantity") && this.bitmapFactory) {
                _local1 = this.bitmapFactory.make(new StaticStringBuilder(_local2.Quantity), 12, 0xffffff, false, new Matrix(), true);
                _local3 = new Matrix();
                _local3.translate(8, 7);
                _local4.draw(_local1, _local3);
            }
            this.imageBitmap.bitmapData = _local4;
            if (this.isSlotsSelectable && !this._selected) {
                GreyScale.setGreyScale(_local4);
            }
            if (!this.imageBitmap.parent) {
                this.imageBitmap.x = -Math.round(this.imageBitmap.width / 2);
                this.imageBitmap.y = -Math.round(this.imageBitmap.height / 2);
                this.imageContainer.addChild(this.imageBitmap);
            }
        }
    }
}
