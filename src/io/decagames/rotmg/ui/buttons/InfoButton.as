package io.decagames.rotmg.ui.buttons {
    import flash.display.Graphics;
    import flash.display.Shape;
    
    import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
    import io.decagames.rotmg.ui.labels.UILabel;
    
    public class InfoButton extends BaseButton {
        
        
        public function InfoButton(_arg_1: int) {
            super();
            this._radius = _arg_1;
            this.init();
        }
        
        private var _background: Shape;
        private var _label: UILabel;
        private var _radius: int;
        
        private function init(): void {
            this.createBackground();
            this.createLabel();
            this.buttonMode = true;
        }
        
        private function createBackground(): void {
            this._background = new Shape();
            var _local1: Graphics = this._background.graphics;
            _local1.beginFill(0xffffff);
            _local1.drawCircle(0, 0, this._radius);
            addChild(this._background);
        }
        
        private function createLabel(): void {
            this._label = new UILabel();
            DefaultLabelFormat.createLabelFormat(this._label, 16, 255, "center", true);
            this._label.text = "i";
            this._label.x = -this._radius / 2 + 1;
            this._label.y = -this._radius / 2 - 4;
            addChild(this._label);
        }
    }
}
