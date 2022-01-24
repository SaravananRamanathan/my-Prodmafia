package io.decagames.rotmg.pets.components.petSkinSlot {
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Sprite;
    
    import io.decagames.rotmg.pets.components.tooltip.PetTooltip;
    import io.decagames.rotmg.pets.data.vo.IPetVO;
    import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
    import io.decagames.rotmg.ui.gird.UIGridElement;
    import io.decagames.rotmg.ui.labels.UILabel;
    import io.decagames.rotmg.utils.colors.GreyScale;
    
    import kabam.rotmg.core.signals.HideTooltipsSignal;
    import kabam.rotmg.core.signals.ShowTooltipSignal;
    import kabam.rotmg.tooltips.HoverTooltipDelegate;
    import kabam.rotmg.tooltips.TooltipAble;
    
    import org.osflash.signals.Signal;
    
    public class PetSkinSlot extends UIGridElement implements TooltipAble {
        
        public static const SLOT_SIZE: int = 40;
        
        public function PetSkinSlot(_arg_1: IPetVO, _arg_2: Boolean) {
            hoverTooltipDelegate = new HoverTooltipDelegate();
            updatedVOSignal = new Signal();
            super();
            this._skinVO = _arg_1;
            this._isSkinSelectableSlot = _arg_2;
            this.renderSlotBackground();
            this.updateTooltip();
        }
        
        public var hoverTooltipDelegate: HoverTooltipDelegate;
        public var updatedVOSignal: Signal;
        private var skinBitmap: Bitmap;
        private var newLabel: Sprite;
        
        private var _skinVO: IPetVO;
        
        public function get skinVO(): IPetVO {
            return this._skinVO;
        }
        
        public function set skinVO(_arg_1: IPetVO): void {
            this._skinVO = _arg_1;
            this.updateTooltip();
            this.updatedVOSignal.dispatch();
        }
        
        private var _isSkinSelectableSlot: Boolean;
        
        public function get isSkinSelectableSlot(): Boolean {
            return this._isSkinSelectableSlot;
        }
        
        private var _selected: Boolean;
        
        public function set selected(_arg_1: Boolean): void {
            this._selected = _arg_1;
            this.renderSlotBackground();
        }
        
        private var _manualUpdate: Boolean;
        
        public function get manualUpdate(): Boolean {
            return this._manualUpdate;
        }
        
        public function set manualUpdate(_arg_1: Boolean): void {
            this._manualUpdate = _arg_1;
        }
        
        override public function dispose(): void {
            this.clearSkinBitmap();
            super.dispose();
        }
        
        public function addSkin(_arg_1: BitmapData): void {
            this.clearSkinBitmap();
            if (_arg_1 == null) {
                this.graphics.clear();
                return;
            }
            this.renderSlotBackground();
            this.clearNewLabel();
            if (this._isSkinSelectableSlot && !this._skinVO.isOwned) {
                _arg_1 = GreyScale.setGreyScale(_arg_1);
            }
            this.skinBitmap = new Bitmap(_arg_1);
            this.skinBitmap.x = Math.round((40 - _arg_1.width) / 2);
            this.skinBitmap.y = Math.round((40 - _arg_1.height) / 2);
            addChild(this.skinBitmap);
            if (this._skinVO.isNew) {
                this.newLabel = this.createNewLabel(24);
                addChild(this.newLabel);
            }
        }
        
        public function clearNewLabel(): void {
            if (this.newLabel && this.newLabel.parent) {
                removeChild(this.newLabel);
            }
        }
        
        public function setShowToolTipSignal(_arg_1: ShowTooltipSignal): void {
            this.hoverTooltipDelegate.setShowToolTipSignal(_arg_1);
        }
        
        public function getShowToolTip(): ShowTooltipSignal {
            return this.hoverTooltipDelegate.getShowToolTip();
        }
        
        public function setHideToolTipsSignal(_arg_1: HideTooltipsSignal): void {
            this.hoverTooltipDelegate.setHideToolTipsSignal(_arg_1);
        }
        
        public function getHideToolTips(): HideTooltipsSignal {
            return this.hoverTooltipDelegate.getHideToolTips();
        }
        
        private function updateTooltip(): void {
            if (this._skinVO) {
                if (!this.hoverTooltipDelegate.getDisplayObject()) {
                    this.hoverTooltipDelegate.setDisplayObject(this);
                }
                this.hoverTooltipDelegate.tooltip = new PetTooltip(this._skinVO);
            }
        }
        
        private function renderSlotBackground(): void {
            this.graphics.clear();
            this.graphics.beginFill(!this._selected ? this._isSkinSelectableSlot && this._skinVO.isOwned ? this._skinVO.rarity.backgroundColor : 0x1d1d1d : 15306295);
            this.graphics.drawRect(-1, -1, 42, 42);
        }
        
        private function createNewLabel(_arg_1: int): Sprite {
            var _local2: Sprite = new Sprite();
            _local2.graphics.beginFill(0xffffff);
            _local2.graphics.drawRect(0, 0, _arg_1, 9);
            _local2.graphics.endFill();
            var _local3: UILabel = new UILabel();
            DefaultLabelFormat.newSkinLabel(_local3);
            _local3.width = _arg_1;
            _local3.wordWrap = true;
            _local3.text = "NEW";
            _local3.y = -1;
            _local2.addChild(_local3);
            return _local2;
        }
        
        private function clearSkinBitmap(): void {
            if (this.skinBitmap && this.skinBitmap.bitmapData) {
                this.skinBitmap.bitmapData.dispose();
            }
        }
    }
}
