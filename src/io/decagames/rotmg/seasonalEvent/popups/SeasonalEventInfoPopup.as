package io.decagames.rotmg.seasonalEvent.popups {
    import flash.display.Shape;
    import flash.display.Sprite;
    
    import io.decagames.rotmg.ui.buttons.SliceScalingButton;
    import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
    import io.decagames.rotmg.ui.labels.UILabel;
    import io.decagames.rotmg.ui.popups.modal.ModalPopup;
    import io.decagames.rotmg.ui.scroll.UIScrollbar;
    import io.decagames.rotmg.ui.sliceScaling.SliceScalingBitmap;
    import io.decagames.rotmg.ui.texture.TextureParser;
    
    public class SeasonalEventInfoPopup extends ModalPopup {
        
        
        private const WIDTH: int = 550;
        
        private const HEIGHT: int = 400;
        
        public function SeasonalEventInfoPopup(_arg_1: String) {
            super(550, 400, "RIFTS: Rules & Explanations");
            this._infoText = _arg_1;
            this.init();
        }
        
        private var _infoText: String;
        private var _infoLabel: UILabel;
        private var _scrollContainer: Sprite;
        private var _scroll: UIScrollbar;
        
        override public function get width(): Number {
            return 550;
        }
        
        override public function get height(): Number {
            return 470;
        }
        
        private var _okButton: SliceScalingButton;
        
        public function get okButton(): SliceScalingButton {
            return this._okButton;
        }
        
        private function init(): void {
            this.createContentInset();
            this.createOkButton();
            this.createScrollContainer();
            this.createInfoLabel();
        }
        
        private function createScrollContainer(): void {
            var _local1: Shape = new Shape();
            _local1.graphics.beginFill(0xccff00, 0.6);
            _local1.graphics.drawRect(0, 2, 550, 346);
            addChild(_local1);
            this._scrollContainer = new Sprite();
            this._scrollContainer.mask = _local1;
            addChild(this._scrollContainer);
            scroll = new UIScrollbar(346);
            scroll.mouseRollSpeedFactor = 1.5;
            scroll.content = this._scrollContainer;
            scroll.x = 530;
            scroll.y = 2;
            scroll.visible = true;
            addChild(scroll);
        }
        
        private function createInfoLabel(): void {
            this._infoLabel = new UILabel();
            DefaultLabelFormat.createLabelFormat(this._infoLabel, 16);
            this._infoLabel.autoSize = "left";
            this._infoLabel.multiline = true;
            this._infoLabel.wordWrap = true;
            this._infoLabel.width = 516;
            this._infoLabel.htmlText = this._infoText;
            this._infoLabel.x = 10;
            this._infoLabel.y = 8;
            this._scrollContainer.addChild(this._infoLabel);
        }
        
        private function createOkButton(): void {
            var _local1: * = null;
            _local1 = new TextureParser().getSliceScalingBitmap("UI", "main_button_decoration", 194);
            _local1.scaleY = 0.8;
            _local1.y = 6 * 60;
            _local1.x = Math.round((550 - _local1.width) / 2);
            addChild(_local1);
            this._okButton = new SliceScalingButton(TextureParser.instance.getSliceScalingBitmap("UI", "generic_green_button"));
            this._okButton.setLabel("OK", DefaultLabelFormat.questButtonCompleteLabel);
            this._okButton.width = 149;
            this._okButton.x = Math.round(200.5);
            this._okButton.y = 362;
            addChild(this._okButton);
        }
        
        private function createContentInset(): void {
            var _local1: SliceScalingBitmap = TextureParser.instance.getSliceScalingBitmap("UI", "popup_content_inset", 550);
            _local1.height = 350;
            addChild(_local1);
        }
    }
}
