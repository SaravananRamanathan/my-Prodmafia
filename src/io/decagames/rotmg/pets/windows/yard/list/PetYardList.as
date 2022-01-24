package io.decagames.rotmg.pets.windows.yard.list {
    import flash.display.Sprite;
    
    import io.decagames.rotmg.pets.components.petItem.PetItem;
    import io.decagames.rotmg.ui.buttons.BaseButton;
    import io.decagames.rotmg.ui.buttons.SliceScalingButton;
    import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
    import io.decagames.rotmg.ui.gird.UIGrid;
    import io.decagames.rotmg.ui.gird.UIGridElement;
    import io.decagames.rotmg.ui.labels.UILabel;
    import io.decagames.rotmg.ui.scroll.UIScrollbar;
    import io.decagames.rotmg.ui.sliceScaling.SliceScalingBitmap;
    import io.decagames.rotmg.ui.texture.TextureParser;
    import io.decagames.rotmg.utils.colors.Tint;
    
    public class PetYardList extends Sprite {
        
        public static const YARD_HEIGHT: int = 425;
        
        public static var YARD_WIDTH: int = 275;
        
        public function PetYardList() {
            super();
            this.contentGrid = new UIGrid(YARD_WIDTH - 55, 1, 15);
            this.contentInset = TextureParser.instance.getSliceScalingBitmap("UI", "popup_content_inset", YARD_WIDTH);
            addChild(this.contentInset);
            this.contentInset.height = 425;
            this.contentInset.x = 0;
            this.contentInset.y = 0;
            this.contentTitle = TextureParser.instance.getSliceScalingBitmap("UI", "content_title_decoration", YARD_WIDTH);
            addChild(this.contentTitle);
            this.contentTitle.x = 0;
            this.contentTitle.y = 0;
            this.title = new UILabel();
            this.title.text = "Pet Yard";
            DefaultLabelFormat.petNameLabel(this.title, 0xffffff);
            this.title.width = YARD_WIDTH;
            this.title.wordWrap = true;
            this.title.y = 3;
            this.title.x = 0;
            addChild(this.title);
            this.createScrollview();
            this.createPetsGrid();
        }
        
        private var yardContainer: Sprite;
        private var contentInset: SliceScalingBitmap;
        private var contentTitle: SliceScalingBitmap;
        private var title: UILabel;
        private var contentGrid: UIGrid;
        private var contentElement: UIGridElement;
        private var petGrid: UIGrid;
        
        private var _upgradeButton: SliceScalingButton;
        
        public function get upgradeButton(): BaseButton {
            return this._upgradeButton;
        }
        
        public function showPetYardRarity(_arg_1: String, _arg_2: Boolean): void {
            var _local4: * = null;
            var _local3: * = null;
            _local4 = TextureParser.instance.getSliceScalingBitmap("UI", "content_divider_smalltitle_white", 3 * 60);
            Tint.add(_local4, 0x333333, 1);
            addChild(_local4);
            _local4.x = Math.round((YARD_WIDTH - _local4.width) / 2);
            _local4.y = 23;
            _local3 = new UILabel();
            DefaultLabelFormat.petYardRarity(_local3);
            _local3.text = _arg_1;
            _local3.width = _local4.width;
            _local3.wordWrap = true;
            _local3.y = _local4.y + 2;
            _local3.x = _local4.x;
            addChild(_local3);
            if (_arg_2) {
                this._upgradeButton = new SliceScalingButton(TextureParser.instance.getSliceScalingBitmap("UI", "upgrade_button"));
                this._upgradeButton.x = _local4.x + _local4.width - this._upgradeButton.width + 8;
                this._upgradeButton.y = _local4.y - this._upgradeButton.height / 2 + 8;
                addChild(this._upgradeButton);
            }
        }
        
        public function addPet(_arg_1: PetItem): void {
            var _local2: UIGridElement = new UIGridElement();
            _local2.addChild(_arg_1);
            this.petGrid.addGridElement(_local2);
        }
        
        public function clearPetsList(): void {
            this.petGrid.clearGrid();
        }
        
        private function createScrollview(): void {
            var _local3: Sprite = new Sprite();
            this.yardContainer = new Sprite();
            this.yardContainer.x = this.contentInset.x;
            this.yardContainer.y = 2;
            this.yardContainer.addChild(this.contentGrid);
            _local3.addChild(this.yardContainer);
            var _local2: UIScrollbar = new UIScrollbar(365);
            _local2.mouseRollSpeedFactor = 1;
            _local2.scrollObject = this;
            _local2.content = this.yardContainer;
            _local3.addChild(_local2);
            _local2.x = this.contentInset.x + this.contentInset.width - 25;
            _local2.y = 7;
            var _local1: Sprite = new Sprite();
            _local1.graphics.beginFill(0);
            _local1.graphics.drawRect(0, 0, YARD_WIDTH, 380);
            _local1.x = this.yardContainer.x;
            _local1.y = this.yardContainer.y;
            this.yardContainer.mask = _local1;
            _local3.addChild(_local1);
            addChild(_local3);
            _local3.y = 45;
        }
        
        private function createPetsGrid(): void {
            this.contentElement = new UIGridElement();
            this.petGrid = new UIGrid(YARD_WIDTH - 55, 5, 5);
            this.petGrid.x = 18;
            this.petGrid.y = 8;
            this.contentElement.addChild(this.petGrid);
            this.contentGrid.addGridElement(this.contentElement);
        }
    }
}
