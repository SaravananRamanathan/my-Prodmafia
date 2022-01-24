package com.company.assembleegameclient.ui {
    import com.company.assembleegameclient.objects.ObjectLibrary;
    import com.company.assembleegameclient.objects.Player;
    import com.company.util.GraphicsUtil;
    import com.company.util.MoreColorUtil;
    import com.company.util.SpriteUtil;

    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.GraphicsPath;
    import flash.display.GraphicsSolidFill;
    import flash.display.GraphicsStroke;
    import flash.display.IGraphicsData;
    import flash.display.Shape;
    import flash.geom.Matrix;
    import flash.geom.Point;

    import kabam.rotmg.core.signals.HideTooltipsSignal;
    import kabam.rotmg.core.signals.ShowTooltipSignal;
    import kabam.rotmg.text.view.BitmapTextFactory;
    import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;
    import kabam.rotmg.tooltips.HoverTooltipDelegate;
    import kabam.rotmg.tooltips.TooltipAble;

    public class TradeSlot extends Slot implements TooltipAble {

        private static const IDENTITY_MATRIX:Matrix = new Matrix();

        public static const EMPTY:int = -1;

        private static const DOSE_MATRIX:Matrix = makeDoseMatrix();


        public const hoverTooltipDelegate:HoverTooltipDelegate = new HoverTooltipDelegate();

        private static function makeDoseMatrix():Matrix {
            var _local1:Matrix = new Matrix();
            _local1.translate(10, 5);
            return _local1;
        }

        public function TradeSlot(_arg_1:int, _arg_2:Boolean, _arg_3:Boolean, _arg_4:int, _arg_5:int, _arg_6:Array, _arg_7:uint) {
            equipmentToolTipFactory = new EquipmentToolTipFactory();
            overlayFill_ = new GraphicsSolidFill(16711310, 1);
            lineStyle_ = new GraphicsStroke(2, false, "normal", "none", "round", 3, overlayFill_);
            overlayPath_ = new GraphicsPath(new Vector.<int>(), new Vector.<Number>());
            graphicsData_ = new <IGraphicsData>[lineStyle_, overlayPath_, GraphicsUtil.END_STROKE];
            super(_arg_4, _arg_5, _arg_6);
            this.id = _arg_7;
            this.item_ = _arg_1;
            this.included_ = _arg_3;
            this.drawItemIfAvailable();
            if (!_arg_2) {
                transform.colorTransform = MoreColorUtil.veryDarkCT;
            }
            this.overlay_ = this.getOverlay();
            addChild(this.overlay_);
            this.setIncluded(_arg_3);
            this.hoverTooltipDelegate.setDisplayObject(this);
        }
        public var included_:Boolean;
        public var equipmentToolTipFactory:EquipmentToolTipFactory;
        private var id:uint;
        private var item_:int;
        private var overlay_:Shape;
        private var overlayFill_:GraphicsSolidFill;
        private var lineStyle_:GraphicsStroke;
        private var overlayPath_:GraphicsPath;
        private var graphicsData_:Vector.<IGraphicsData>;
        private var bitmapFactory:BitmapTextFactory;

        public function setIncluded(_arg_1:Boolean):void {
            this.included_ = _arg_1;
            this.overlay_.visible = this.included_;
            if (this.included_) {
                fill_.color = 16764247;
            } else {
                fill_.color = 0x545454;
            }
            drawBackground();
        }

        public function setBitmapFactory(_arg_1:BitmapTextFactory):void {
            this.bitmapFactory = _arg_1;
            this.drawItemIfAvailable();
        }

        public function setShowToolTipSignal(_arg_1:ShowTooltipSignal):void {
            this.hoverTooltipDelegate.setShowToolTipSignal(_arg_1);
        }

        public function getShowToolTip():ShowTooltipSignal {
            return this.hoverTooltipDelegate.getShowToolTip();
        }

        public function setHideToolTipsSignal(_arg_1:HideTooltipsSignal):void {
            this.hoverTooltipDelegate.setHideToolTipsSignal(_arg_1);
        }

        public function getHideToolTips():HideTooltipsSignal {
            return this.hoverTooltipDelegate.getHideToolTips();
        }

        public function setPlayer(_arg_1:Player):void {
            if (!this.isEmpty()) {
                this.hoverTooltipDelegate.tooltip = this.equipmentToolTipFactory.make(this.item_, _arg_1, -1, "OTHER_PLAYER", this.id);
            }
        }

        public function isEmpty():Boolean {
            return this.item_ == -1;
        }

        private function drawItemIfAvailable():void {
            if (!this.isEmpty()) {
                this.drawItem();
            }
        }

        private function drawItem():void {
            var _local3:* = null;
            var _local4:* = null;
            SpriteUtil.safeRemoveChild(this, backgroundImage_);
            var _local5:BitmapData = ObjectLibrary.getRedrawnTextureFromType(this.item_, 80, true);
            var _local2:XML = ObjectLibrary.xmlLibrary_[this.item_];
            if ("Doses" in _local2 && this.bitmapFactory) {
                _local5 = _local5.clone();
                _local3 = this.bitmapFactory.make(new StaticStringBuilder(_local2.Doses), 12, 0xffffff, false, IDENTITY_MATRIX, false);
                _local5.draw(_local3, DOSE_MATRIX);
            }
            if ("Quantity" in _local2 && this.bitmapFactory) {
                _local5 = _local5.clone();
                _local3 = this.bitmapFactory.make(new StaticStringBuilder(_local2.Quantity), 12, 0xffffff, false, IDENTITY_MATRIX, false);
                _local5.draw(_local3, DOSE_MATRIX);
            }
            var _local1:Point = offsets(this.item_, type_, false);
            _local4 = new Bitmap(_local5);
            _local4.x = 20 - _local4.width / 2 + _local1.x;
            _local4.y = 20 - _local4.height / 2 + _local1.y;
            SpriteUtil.safeAddChild(this, _local4);
        }

        private function getOverlay():Shape {
            var _local1:Shape = new Shape();
            GraphicsUtil.clearPath(this.overlayPath_);
            GraphicsUtil.drawCutEdgeRect(0, 0, 40, 40, 4, cuts_, this.overlayPath_);
            _local1.graphics.drawGraphicsData(this.graphicsData_);
            return _local1;
        }
    }
}
