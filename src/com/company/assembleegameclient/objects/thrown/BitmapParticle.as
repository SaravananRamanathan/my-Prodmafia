package com.company.assembleegameclient.objects.thrown {
    import com.company.assembleegameclient.map.Camera;
    import com.company.assembleegameclient.objects.BasicObject;

    import flash.display.BitmapData;
    import flash.display.GraphicsBitmapFill;
    import flash.geom.Matrix;

    public class BitmapParticle extends BasicObject {


        public function BitmapParticle(_arg_1:BitmapData, _arg_2:Number) {
            bitmapFill_ = new GraphicsBitmapFill();
            vS_ = new Vector.<Number>();
            fillMatrix_ = new Matrix();
            super();
            objectId_ = getNextFakeObjectId();
            this._bitmapData = _arg_1;
            z_ = _arg_2;
        }
        public var size_:int;
        public var _bitmapData:BitmapData;
        public var _rotation:Number = 0;
        protected var bitmapFill_:GraphicsBitmapFill;
        protected var vS_:Vector.<Number>;
        protected var fillMatrix_:Matrix;
        protected var _rotationDelta:Number = 0;

        override public function draw(_arg_1:Vector.<GraphicsBitmapFill>, _arg_2:Camera, _arg_3:int):void {
            var _local5:int = 0;
            var _local9:int = 0;
            var _local6:* = null;
            _local6 = this._bitmapData;
            _local5 = _local6.width;
            _local9 = _local6.height;
            if (!_local5 || !_local9) {
                return;
            }
            this.vS_.length = 0;
            this.vS_.push(posS_[3] - _local5 / 2, posS_[4] - _local9 / 2, posS_[3] + _local5 / 2, posS_[4] - _local9 / 2, posS_[3] + _local5 / 2, posS_[4] + _local9 / 2, posS_[3] - _local5 / 2, posS_[4] + _local9 / 2);
            this.bitmapFill_.bitmapData = _local6;
            this.fillMatrix_.identity();
            if (this._rotation || this._rotationDelta) {
                if (this._rotationDelta)
                    this._rotation = this._rotation + this._rotationDelta;

                this.fillMatrix_.translate(-_local5 / 2, -_local9 / 2);
                this.fillMatrix_.rotate(this._rotation);
                this.fillMatrix_.translate(_local5 / 2, _local9 / 2);
            }
            this.fillMatrix_.translate(this.vS_[0], this.vS_[1]);
            this.bitmapFill_.matrix = this.fillMatrix_;
            _arg_1.push(this.bitmapFill_);
        }

        public function moveTo(_arg_1:Number, _arg_2:Number):Boolean {
            var _local3:* = null;
            _local3 = map_.getSquare(_arg_1, _arg_2);
            if (!_local3) {
                return false;
            }
            x_ = _arg_1;
            y_ = _arg_2;
            square = _local3;
            return true;
        }

        public function setSize(_arg_1:int):void {
            this.size_ = _arg_1 / 100 * 5;
        }
    }
}
