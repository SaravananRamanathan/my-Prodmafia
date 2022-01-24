package com.company.assembleegameclient.ui {
    import com.company.util.GraphicsUtil;
    import com.company.util.MoreColorUtil;

    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.GraphicsPath;
    import flash.display.GraphicsSolidFill;
    import flash.display.IGraphicsData;
    import flash.display.Sprite;
    import flash.filters.ColorMatrixFilter;
    import flash.geom.Matrix;
    import flash.geom.Point;

    import kabam.rotmg.constants.ItemConstants;
    import kabam.rotmg.core.StaticInjectorContext;
    import kabam.rotmg.text.view.BitmapTextFactory;
    import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;

    public class Slot extends Sprite {

        public static const IDENTITY_MATRIX:Matrix = new Matrix();
        public static const WIDTH:int = 40;
        public static const HEIGHT:int = 40;
        public static const BORDER:int = 4;
        private static const greyColorFilter:ColorMatrixFilter = new ColorMatrixFilter(MoreColorUtil.singleColorFilterMatrix(0x363636));
        public var type_:int;
        public var hotkey_:int;
        public var cuts_:Array;
        public var backgroundImage_:Bitmap;
        protected var fill_:GraphicsSolidFill;
        protected var path_:GraphicsPath;
        private var graphicsData_:Vector.<IGraphicsData>;

        public function Slot(_arg_1:int, _arg_2:int, _arg_3:Array) {
            fill_ = new GraphicsSolidFill(0x545454, 1);
            path_ = new GraphicsPath(new Vector.<int>(), new Vector.<Number>());
            graphicsData_ = new <IGraphicsData>[fill_, path_, GraphicsUtil.END_FILL];
            super();
            this.type_ = _arg_1;
            this.hotkey_ = _arg_2;
            this.cuts_ = _arg_3;
            this.drawBackground();
        }

        protected function offsets(_arg_1:int, _arg_2:int, _arg_3:Boolean):Point {
            var _local4:Point = new Point();
            switch (int(_arg_2) - 9) {
                case 0:
                    _local4.x = _arg_1 == 2878 ? 0 : -2;
                    _local4.y = !!_arg_3 ? -2 : 0;
                    break;
                default:
                    _local4.x = _arg_1 == 2878 ? 0 : -2;
                    _local4.y = !!_arg_3 ? -2 : 0;
                    break;
                case 2:
                    _local4.y = -2;
            }
            return _local4;
        }

        protected function drawBackground():void {
            var _local1:* = null;
            var _local3:* = null;
            GraphicsUtil.clearPath(this.path_);
            GraphicsUtil.drawCutEdgeRect(0, 0, 40, 40, 4, this.cuts_, this.path_);
            graphics.clear();
            graphics.drawGraphicsData(this.graphicsData_);
            var _local2:BitmapData = ItemConstants.itemTypeToBaseSprite(this.type_);
            if (this.backgroundImage_ == null) {
                if (_local2 != null) {
                    _local1 = this.offsets(-1, this.type_, true);
                    this.backgroundImage_ = new Bitmap(_local2);
                    this.backgroundImage_.x = 4 + _local1.x;
                    this.backgroundImage_.y = 4 + _local1.y;
                    this.backgroundImage_.scaleX = 4;
                    this.backgroundImage_.scaleY = 4;
                    this.backgroundImage_.filters = [greyColorFilter];
                    addChild(this.backgroundImage_);
                } else if (this.hotkey_ > 0) {
                    _local3 = StaticInjectorContext.getInjector().getInstance(BitmapTextFactory);
                    _local2 = _local3.make(new StaticStringBuilder(String(this.hotkey_)), 26, 0x363636, true, IDENTITY_MATRIX, false);
                    this.backgroundImage_ = new Bitmap(_local2);
                    this.backgroundImage_.x = 20 - _local2.width / 2;
                    this.backgroundImage_.y = 2;
                    addChild(this.backgroundImage_);
                }
            }
        }
    }
}
