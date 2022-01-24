package io.decagames.rotmg.ui.gird {
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.events.Event;
    
    import io.decagames.rotmg.ui.scroll.UIScrollbar;
    import io.decagames.rotmg.ui.sliceScaling.SliceScalingBitmap;
    import io.decagames.rotmg.ui.texture.TextureParser;
    
    public class UIGrid extends Sprite {
        
        
        public function UIGrid(_arg_1: int, _arg_2: int, _arg_3: int, _arg_4: int = -1, _arg_5: int = 0, _arg_6: DisplayObject = null) {
            super();
            this.elements = new Vector.<UIGridElement>();
            this.decors = new Vector.<SliceScalingBitmap>();
            this.gridMargin = _arg_3;
            this.gridWidth = _arg_1;
            this.gridContent = new Sprite();
            this.addChild(this.gridContent);
            this.scrollHeight = _arg_4;
            if (_arg_4 > 0) {
                this.scroll = new UIScrollbar(_arg_4);
                this.scroll.x = _arg_1 + _arg_5;
                addChild(this.scroll);
                this.scroll.content = this.gridContent;
                this.scroll.scrollObject = _arg_6;
                this.gridMask = new Sprite();
            }
            this.numberOfColumns = _arg_2;
            this.addEventListener("addedToStage", this.onAddedHandler);
        }
        
        private var elements: Vector.<UIGridElement>;
        private var decors: Vector.<SliceScalingBitmap>;
        private var gridMargin: int;
        private var gridWidth: int;
        private var numberOfColumns: int;
        private var scrollHeight: int;
        private var scroll: UIScrollbar;
        private var gridContent: Sprite;
        private var gridMask: Sprite;
        private var lastRenderedItemsNumber: int = 0;
        private var elementWidth: int;
        
        override public function set width(_arg_1: Number): void {
            this.gridWidth = _arg_1;
            this.render();
        }
        
        private var _centerLastRow: Boolean;
        
        public function get centerLastRow(): Boolean {
            return this._centerLastRow;
        }
        
        public function set centerLastRow(_arg_1: Boolean): void {
            this._centerLastRow = _arg_1;
        }
        
        private var _decorBitmap: String = "";
        
        public function get decorBitmap(): String {
            return this._decorBitmap;
        }
        
        public function set decorBitmap(_arg_1: String): void {
            this._decorBitmap = _arg_1;
        }
        
        public function get numberOfElements(): int {
            return this.elements.length;
        }
        
        public function addGridElement(_arg_1: UIGridElement): void {
            if (this.elements) {
                this.elements.push(_arg_1);
                this.gridContent.addChild(_arg_1);
                if (this.stage) {
                    this.render();
                }
            }
        }
        
        public function clearGrid(): void {
            var _local1: * = null;
            var _local2: * = null;
            var _local4: int = 0;
            var _local3: * = this.elements;
            for each(_local1 in this.elements) {
                this.gridContent.removeChild(_local1);
                _local1.dispose();
            }
            var _local6: int = 0;
            var _local5: * = this.decors;
            for each(_local2 in this.decors) {
                this.gridContent.removeChild(_local2);
                _local2.dispose();
            }
            if (this.elements) {
                this.elements.length = 0;
            }
            if (this.decors) {
                this.decors.length = 0;
            }
            this.lastRenderedItemsNumber = 0;
        }
        
        public function render(): void {
            var _local7: int = 0;
            var _local2: int = 0;
            var _local1: int = 0;
            var _local3: int = 0;
            var _local4: * = 0;
            var _local8: * = null;
            if (this.lastRenderedItemsNumber == this.elements.length) {
                return;
            }
            this.elementWidth = (this.gridWidth - (this.numberOfColumns - 1) * this.gridMargin) / this.numberOfColumns;
            var _local6: int = 1;
            var _local9: int = Math.ceil(this.elements.length / this.numberOfColumns);
            var _local5: int = 1;
            var _local11: int = 0;
            var _local10: * = this.elements;
            for each(_local8 in this.elements) {
                _local8.resize(this.elementWidth);
                if (_local8.height > _local3) {
                    _local3 = _local8.height;
                }
                _local8.x = _local2;
                _local8.y = _local1;
                _local6++;
                if (_local6 > this.numberOfColumns) {
                    if (this._decorBitmap != "") {
                        _local4 = _local5;
                        this.addDecorToRow(_local1, _local3, _local6 - 1);
                    }
                    _local5++;
                    _local2 = 0;
                    if (_local5 == _local9 && this._centerLastRow) {
                        _local7 = _local5 * this.numberOfColumns - this.elements.length;
                        _local2 = Math.round((_local7 * this.elementWidth + (_local7 - 1) * this.gridMargin) / 2);
                    }
                    _local1 = _local1 + (_local3 + this.gridMargin);
                    _local3 = 0;
                    _local6 = 1;
                } else {
                    _local2 = _local2 + (this.elementWidth + this.gridMargin);
                }
            }
            if (this._decorBitmap != "" && _local4 != _local5) {
                this.addDecorToRow(_local1, _local3, _local6 - 1);
            }
            if (this.scrollHeight != -1) {
                this.gridMask.graphics.clear();
                this.gridMask.graphics.beginFill(0xff0000);
                this.gridMask.graphics.drawRect(0, 0, this.gridWidth, this.scrollHeight);
                this.gridContent.mask = this.gridMask;
                addChild(this.gridMask);
            }
            this.lastRenderedItemsNumber = this.elements.length;
        }
        
        public function dispose(): void {
            var _local1: * = null;
            var _local2: * = null;
            this.removeEventListener("enterFrame", this.onUpdate);
            var _local4: int = 0;
            var _local3: * = this.elements;
            for each(_local1 in this.elements) {
                _local1.dispose();
            }
            var _local6: int = 0;
            var _local5: * = this.decors;
            for each(_local2 in this.decors) {
                _local2.dispose();
            }
            this.elements = null;
        }
        
        private function addDecorToRow(_arg_1: int, _arg_2: int, _arg_3: int): void {
            var _local4: * = null;
            var _local5: int = 0;
            _arg_3--;
            if (_arg_3 == 0) {
                _arg_3 = 1;
            }
            while (_local5 < _arg_3) {
                _local4 = TextureParser.instance.getSliceScalingBitmap("UI", this._decorBitmap);
                _local4.x = Math.round(_local5 * (this.gridMargin / 2) + (_local5 + 1) * (this.elementWidth + this.gridMargin / 2) - _local4.width / 2);
                _local4.y = Math.round(_arg_1 + _arg_2 - _local4.height / 2 + this.gridMargin / 2);
                this.gridContent.addChild(_local4);
                this.decors.push(_local4);
                _local5++;
            }
        }
        
        private function onAddedHandler(_arg_1: Event): void {
            this.removeEventListener("addedToStage", this.onAddedHandler);
            this.addEventListener("enterFrame", this.onUpdate);
            this.render();
        }
        
        private function onUpdate(_arg_1: Event): void {
            var _local2: * = null;
            var _local4: int = 0;
            var _local3: * = this.elements;
            for each(_local2 in this.elements) {
                _local2.update();
            }
        }
    }
}
