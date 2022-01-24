package io.decagames.rotmg.fame {
    import com.company.assembleegameclient.util.TextureRedrawer;
    import com.company.util.AssetLibrary;
    import com.company.util.GraphicsUtil;
    
    import flash.display.Bitmap;
    import flash.display.GraphicsPath;
    import flash.display.GraphicsSolidFill;
    import flash.display.IGraphicsData;
    import flash.display.Sprite;
    import flash.text.TextFormat;
    
    import io.decagames.rotmg.ui.labels.UILabel;
    import io.decagames.rotmg.utils.colors.Tint;
    
    import kabam.rotmg.text.model.FontModel;
    
    public class StatsLine extends Sprite {
        
        public static const TYPE_BONUS: int = 0;
        
        public static const TYPE_STAT: int = 1;
        
        public static const TYPE_TITLE: int = 2;
        
        public function StatsLine(_arg_1: String, _arg_2: String, _arg_3: String, _arg_4: int, _arg_5: Boolean = false) {
            var _local7: int = 0;
            fameValue = new UILabel();
            backgroundFill_ = new GraphicsSolidFill(0x1e1e1e);
            path_ = new GraphicsPath(new Vector.<int>(), new Vector.<Number>());
            super();
            var _local6: TextFormat = new TextFormat();
            _local6.color = 0x8a8a8a;
            _local6.font = FontModel.DEFAULT_FONT_NAME;
            _local6.size = 13;
            _local6.bold = true;
            _local6.align = "left";
            this.isLocked = _arg_5;
            this._lineType = _arg_4;
            this._labelText = _arg_1;
            if (_arg_4 == 2) {
                _local6.size = 15;
                _local6.color = 0xffffff;
            }
            var _local8: TextFormat = new TextFormat();
            if (_arg_4 == 0) {
                _local8.color = 16762880;
            } else {
                _local8.color = 5544494;
            }
            _local8.font = FontModel.DEFAULT_FONT_NAME;
            _local8.size = 13;
            _local8.bold = true;
            _local8.align = "left";
            this.label = new UILabel();
            this.label.defaultTextFormat = _local6;
            addChild(this.label);
            this.label.text = _arg_1;
            if (!_arg_5) {
                this.fameValue = new UILabel();
                this.fameValue.defaultTextFormat = _local8;
                if (_arg_2 == "0" || _arg_2 == "0.00%") {
                    this.fameValue.defaultTextFormat = _local6;
                }
                if (_arg_4 == 0) {
                    this.fameValue.text = "+" + _arg_2;
                } else {
                    this.fameValue.text = _arg_2;
                }
                this.fameValue.x = this.lineWidth - 4 - this.fameValue.textWidth;
                addChild(this.fameValue);
                this.fameValue.y = 2;
            } else {
                _local7 = 36;
                this.lock = new Bitmap(TextureRedrawer.resize(AssetLibrary.getImageFromSet("lofiInterface2", 5), null, _local7, true, 0, 0));
                Tint.add(this.lock, 9971490, 1);
                addChild(this.lock);
                this.lock.x = this.lineWidth - _local7 + 5;
                this.lock.y = -8;
            }
            this.setLabelsPosition();
            this._tooltipText = _arg_3;
        }
        
        protected var lineHeight: int;
        protected var fameValue: UILabel;
        protected var label: UILabel;
        protected var lock: Bitmap;
        private var backgroundFill_: GraphicsSolidFill;
        private var path_: GraphicsPath;
        private var lineWidth: int = 306;
        private var isLocked: Boolean;
        
        private var _tooltipText: String;
        
        public function get tooltipText(): String {
            return this._tooltipText;
        }
        
        private var _lineType: int;
        
        public function get lineType(): int {
            return this._lineType;
        }
        
        private var _labelText: String;
        
        public function get labelText(): String {
            return this._labelText;
        }
        
        public function clean(): void {
            if (this.lock) {
                removeChild(this.lock);
                this.lock.bitmapData.dispose();
            }
        }
        
        public function drawBrightBackground(): void {
            var _local1: Vector.<IGraphicsData> = new <IGraphicsData>[this.backgroundFill_, this.path_, GraphicsUtil.END_FILL];
            GraphicsUtil.drawCutEdgeRect(0, 0, this.lineWidth, this.lineHeight, 5, [1, 1, 1, 1], this.path_);
            graphics.drawGraphicsData(_local1);
        }
        
        protected function setLabelsPosition(): void {
            this.label.y = 2;
            this.label.x = 2;
            this.lineHeight = 20;
        }
    }
}
