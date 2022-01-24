package io.decagames.rotmg.ui.sliceScaling {
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    
    public class SliceScalingBitmap extends Bitmap {
        
        public static var SCALE_TYPE_NONE: String = "none";
        
        public static var SCALE_TYPE_3: String = "3grid";
        
        public static var SCALE_TYPE_9: String = "9grid";
        
        public function SliceScalingBitmap(_arg_1: BitmapData, _arg_2: String, _arg_3: Rectangle = null, _arg_4: uint = 0, _arg_5: Number = 1) {
            margin = new Point();
            super();
            this.bitmapDataToSlice = _arg_1;
            this.scaleGrid = _arg_3;
            this.currentWidth = _arg_1.width;
            this.currentHeight = _arg_1.height;
            this._scaleType = _arg_2;
            this.fillColor = _arg_4;
            this.fillColorAlpha = _arg_5;
            if (_arg_2 != SCALE_TYPE_NONE) {
                this.render();
            } else {
                this.bitmapData = _arg_1;
            }
        }
        
        protected var margin: Point;
        private var scaleGrid: Rectangle;
        private var currentWidth: int;
        private var currentHeight: int;
        private var bitmapDataToSlice: BitmapData;
        private var fillColor: uint;
        private var fillColorAlpha: Number;
        
        override public function get width(): Number {
            return this.currentWidth;
        }
        
        override public function set width(_arg_1: Number): void {
            if (_arg_1 != this.currentWidth || this._forceRenderInNextFrame) {
                this.currentWidth = _arg_1;
                this.render();
            }
        }
        
        override public function get height(): Number {
            return this.currentHeight;
        }
        
        override public function set height(_arg_1: Number): void {
            if (_arg_1 != this.currentHeight) {
                this.currentHeight = _arg_1;
                this.render();
            }
        }
        
        override public function set x(_arg_1: Number): void {
            super.x = Math.round(_arg_1);
        }
        
        override public function set y(_arg_1: Number): void {
            super.y = Math.round(_arg_1);
        }
        
        private var _scaleType: String;
        
        public function get scaleType(): String {
            return this._scaleType;
        }
        
        public function set scaleType(_arg_1: String): void {
            this._scaleType = _arg_1;
        }
        
        private var _forceRenderInNextFrame: Boolean;
        
        public function get forceRenderInNextFrame(): Boolean {
            return this._forceRenderInNextFrame;
        }
        
        public function set forceRenderInNextFrame(_arg_1: Boolean): void {
            this._forceRenderInNextFrame = _arg_1;
        }
        
        private var _sourceBitmapName: String;
        
        public function get sourceBitmapName(): String {
            return this._sourceBitmapName;
        }
        
        public function set sourceBitmapName(_arg_1: String): void {
            this._sourceBitmapName = _arg_1;
        }
        
        public function get marginX(): int {
            return this.margin.x;
        }
        
        public function get marginY(): int {
            return this.margin.y;
        }
        
        public function clone(): SliceScalingBitmap {
            var _local1: SliceScalingBitmap = new SliceScalingBitmap(this.bitmapDataToSlice.clone(), this.scaleType, this.scaleGrid, this.fillColor, this.fillColorAlpha);
            _local1.sourceBitmapName = this._sourceBitmapName;
            return _local1;
        }
        
        public function addMargin(_arg_1: int, _arg_2: int): void {
            this.margin = new Point(_arg_1, _arg_2);
        }
        
        public function dispose(): void {
            this.bitmapData.dispose();
            this.bitmapDataToSlice.dispose();
        }
        
        protected function render(): void {
            if (this._scaleType == SCALE_TYPE_NONE) {
                return;
            }
            if (this.bitmapData) {
                this.bitmapData.dispose();
            }
            if (this._scaleType == SCALE_TYPE_3) {
                this.prepare3grid();
            }
            if (this._scaleType == SCALE_TYPE_9) {
                this.prepare9grid();
            }
            if (this._forceRenderInNextFrame) {
                this._forceRenderInNextFrame = false;
            }
        }
        
        private function prepare3grid(): void {
            var _local4: int = 0;
            var _local2: int = 0;
            var _local1: int = 0;
            var _local3: int = 0;
            if (this.scaleGrid.y == 0) {
                _local4 = this.currentWidth - this.bitmapDataToSlice.width + this.scaleGrid.width;
                this.bitmapData = new BitmapData(this.currentWidth + this.margin.x, this.currentHeight + this.margin.y, true, 0);
                this.bitmapData.copyPixels(this.bitmapDataToSlice, new Rectangle(0, 0, this.scaleGrid.x, this.bitmapDataToSlice.height), new Point(this.margin.x, this.margin.y));
                _local2 = 0;
                while (_local2 < _local4) {
                    this.bitmapData.copyPixels(this.bitmapDataToSlice, new Rectangle(this.scaleGrid.x, 0, this.scaleGrid.width, this.bitmapDataToSlice.height), new Point(this.scaleGrid.x + _local2 + this.margin.x, this.margin.y));
                    _local2++;
                }
                this.bitmapData.copyPixels(this.bitmapDataToSlice, new Rectangle(this.scaleGrid.x + this.scaleGrid.width, 0, this.bitmapDataToSlice.width - (this.scaleGrid.x + this.scaleGrid.width), this.bitmapDataToSlice.height), new Point(this.scaleGrid.x + _local4 + this.margin.x, this.margin.y));
            } else {
                _local1 = this.currentHeight - this.bitmapDataToSlice.height + this.scaleGrid.height;
                this.bitmapData = new BitmapData(this.currentWidth + this.margin.x, this.currentHeight + this.margin.y, true, 0);
                this.bitmapData.copyPixels(this.bitmapDataToSlice, new Rectangle(0, 0, this.bitmapDataToSlice.width, this.scaleGrid.y), new Point(this.margin.x, this.margin.y));
                _local3 = 0;
                while (_local3 < _local1) {
                    this.bitmapData.copyPixels(this.bitmapDataToSlice, new Rectangle(0, this.scaleGrid.y, this.scaleGrid.width, this.bitmapDataToSlice.height), new Point(this.margin.x, this.margin.y + this.scaleGrid.y + _local3));
                    _local3++;
                }
                this.bitmapData.copyPixels(this.bitmapDataToSlice, new Rectangle(0, this.scaleGrid.y + this.scaleGrid.height, this.bitmapDataToSlice.width, this.bitmapDataToSlice.height - (this.scaleGrid.y + this.scaleGrid.height)), new Point(this.margin.x, this.margin.y + this.scaleGrid.y + _local1));
            }
        }
        
        private function prepare9grid(): void {
            var _local9: int = 0;
            var _local1: int = 0;
            var _local7: Rectangle = new Rectangle();
            var _local3: Rectangle = new Rectangle();
            var _local2: Matrix = new Matrix();
            var _local4: BitmapData = new BitmapData(this.currentWidth + this.margin.x, this.currentHeight + this.margin.y, true, 0);
            var _local10: Array = [0, this.scaleGrid.top, this.scaleGrid.bottom, this.bitmapDataToSlice.height];
            var _local6: Array = [0, this.scaleGrid.left, this.scaleGrid.right, this.bitmapDataToSlice.width];
            var _local5: Array = [0, this.scaleGrid.top, this.currentHeight - (this.bitmapDataToSlice.height - this.scaleGrid.bottom), this.currentHeight];
            var _local8: Array = [0, this.scaleGrid.left, this.currentWidth - (this.bitmapDataToSlice.width - this.scaleGrid.right), this.currentWidth];
            while (_local1 < 3) {
                _local9 = 0;
                while (_local9 < 3) {
                    _local7.setTo(_local6[_local1], _local10[_local9], _local6[_local1 + 1] - _local6[_local1], _local10[_local9 + 1] - _local10[_local9]);
                    _local3.setTo(_local8[_local1], _local5[_local9], _local8[_local1 + 1] - _local8[_local1], _local5[_local9 + 1] - _local5[_local9]);
                    _local2.identity();
                    _local2.a = _local3.width / _local7.width;
                    _local2.d = _local3.height / _local7.height;
                    _local2.tx = _local3.x - _local7.x * _local2.a;
                    _local2.ty = _local3.y - _local7.y * _local2.d;
                    _local4.draw(this.bitmapDataToSlice, _local2, null, null, _local3);
                    _local9++;
                }
                _local1++;
            }
            this.bitmapData = _local4;
        }
    }
}
