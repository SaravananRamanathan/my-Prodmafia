package io.decagames.rotmg.pets.components.petSkinsCollection {
    import flash.display.Sprite;
    
    import io.decagames.rotmg.pets.components.petSkinSlot.PetSkinSlot;
    import io.decagames.rotmg.pets.data.vo.SkinVO;
    import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
    import io.decagames.rotmg.ui.gird.UIGrid;
    import io.decagames.rotmg.ui.gird.UIGridElement;
    import io.decagames.rotmg.ui.labels.UILabel;
    import io.decagames.rotmg.ui.scroll.UIScrollbar;
    import io.decagames.rotmg.ui.sliceScaling.SliceScalingBitmap;
    import io.decagames.rotmg.ui.texture.TextureParser;
    import io.decagames.rotmg.utils.colors.Tint;
    
    public class PetSkinsCollection extends Sprite {
        
        public static const COLLECTION_HEIGHT: int = 425;
        
        public static var COLLECTION_WIDTH: int = 360;
        
        public function PetSkinsCollection(_arg_1: int, _arg_2: int) {
            var _local4: * = null;
            var _local3: * = null;
            super();
            this.contentGrid = new UIGrid(COLLECTION_WIDTH - 40, 1, 15);
            this.contentInset = TextureParser.instance.getSliceScalingBitmap("UI", "popup_content_inset", COLLECTION_WIDTH);
            addChild(this.contentInset);
            this.contentInset.height = 425;
            this.contentInset.x = 0;
            this.contentInset.y = 0;
            this.contentTitle = TextureParser.instance.getSliceScalingBitmap("UI", "content_title_decoration", COLLECTION_WIDTH);
            addChild(this.contentTitle);
            this.contentTitle.x = 0;
            this.contentTitle.y = 0;
            this.title = new UILabel();
            this.title.text = "Collection";
            DefaultLabelFormat.petNameLabel(this.title, 0xffffff);
            this.title.width = COLLECTION_WIDTH;
            this.title.wordWrap = true;
            this.title.y = 4;
            this.title.x = 0;
            addChild(this.title);
            _local4 = TextureParser.instance.getSliceScalingBitmap("UI", "content_divider_smalltitle_white", 94);
            Tint.add(_local4, 0x333333, 1);
            addChild(_local4);
            _local4.x = Math.round((COLLECTION_WIDTH - _local4.width) / 2);
            _local4.y = 23;
            _local3 = new UILabel();
            DefaultLabelFormat.wardrobeCollectionLabel(_local3);
            _local3.text = _arg_1 + "/" + _arg_2;
            _local3.width = _local4.width;
            _local3.wordWrap = true;
            _local3.y = _local4.y + 1;
            _local3.x = _local4.x;
            addChild(_local3);
            this.createScrollview();
        }
        
        private var collectionContainer: Sprite;
        private var contentInset: SliceScalingBitmap;
        private var contentTitle: SliceScalingBitmap;
        private var title: UILabel;
        private var contentGrid: UIGrid;
        private var contentElement: UIGridElement;
        private var petGrid: UIGrid;
        
        public function addPetSkins(_arg_1: String, _arg_2: Vector.<SkinVO>): void {
            var _local3: * = null;
            var _local6: int = 0;
            var _local4: int = 0;
            if (_arg_2 == null) {
                return;
            }
            this.petGrid = new UIGrid(COLLECTION_WIDTH - 40, 7, 5);
            _arg_2 = _arg_2.sort(this.sortByRarity);
            var _local8: int = 0;
            var _local7: * = _arg_2;
            for each(_local3 in _arg_2) {
                this.petGrid.addGridElement(new PetSkinSlot(_local3, true));
                _local6++;
                if (_local3.isOwned) {
                    _local4++;
                }
            }
            this.petGrid.x = 10;
            this.petGrid.y = 25;
            var _local5: PetFamilyContainer = new PetFamilyContainer(_arg_1, _local4, _local6);
            _local5.addChild(this.petGrid);
            this.contentGrid.addGridElement(_local5);
        }
        
        private function createScrollview(): void {
            var _local3: * = null;
            var _local2: * = null;
            var _local1: * = null;
            _local3 = new Sprite();
            this.collectionContainer = new Sprite();
            this.collectionContainer.x = this.contentInset.x;
            this.collectionContainer.y = 2;
            this.collectionContainer.addChild(this.contentGrid);
            _local3.addChild(this.collectionContainer);
            _local2 = new UIScrollbar(368);
            _local2.mouseRollSpeedFactor = 1;
            _local2.scrollObject = this;
            _local2.content = this.collectionContainer;
            _local3.addChild(_local2);
            _local2.x = this.contentInset.x + this.contentInset.width - 25;
            _local2.y = 7;
            _local1 = new Sprite();
            _local1.graphics.beginFill(0);
            _local1.graphics.drawRect(0, 0, COLLECTION_WIDTH, 380);
            _local1.x = this.collectionContainer.x;
            _local1.y = this.collectionContainer.y;
            this.collectionContainer.mask = _local1;
            _local3.addChild(_local1);
            addChild(_local3);
            _local3.y = 42;
        }
        
        private function sortByName(_arg_1: SkinVO, _arg_2: SkinVO): int {
            if (_arg_1.name > _arg_2.name) {
                return 1;
            }
            return -1;
        }
        
        private function sortByRarity(_arg_1: SkinVO, _arg_2: SkinVO): int {
            if (_arg_1.rarity.ordinal == _arg_2.rarity.ordinal) {
                return this.sortByName(_arg_1, _arg_2);
            }
            if (_arg_1.rarity.ordinal > _arg_2.rarity.ordinal) {
                return 1;
            }
            return -1;
        }
    }
}
