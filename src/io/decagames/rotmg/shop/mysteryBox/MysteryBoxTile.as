package io.decagames.rotmg.shop.mysteryBox {
    import flash.geom.Point;
    
    import io.decagames.rotmg.shop.genericBox.GenericBoxTile;
    import io.decagames.rotmg.shop.mysteryBox.contentPopup.UIItemContainer;
    import io.decagames.rotmg.ui.gird.UIGrid;
    
    import kabam.rotmg.mysterybox.model.MysteryBoxInfo;
    
    public class MysteryBoxTile extends GenericBoxTile {
        
        
        public function MysteryBoxTile(_arg_1: MysteryBoxInfo) {
            buyButtonBitmapBackground = "shop_box_button_background";
            super(_arg_1);
        }
        
        private var displayedItemsGrid: UIGrid;
        private var maxResultHeight: int = 75;
        private var maxResultWidth: int;
        private var resultElementWidth: int;
        private var gridConfig: Point;
        
        override protected function createBoxBackground(): void {
            var _local2: int = 0;
            var _local3: * = null;
            var _local1: int = 0;
            var _local4: Array = MysteryBoxInfo(_boxInfo).displayedItems.split(",");
            if (_local4.length == 0 || MysteryBoxInfo(_boxInfo).displayedItems == "") {
                return;
            }
            if (_infoButton) {
                _infoButton.alpha = 0;
            }
            switch (int(_local4.length) - 1) {
            case 0:
                break;
            case 1:
                _local2 = 50;
            }
            this.prepareResultGrid(_local4.length);
            while (_local1 < _local4.length) {
                _local3 = new UIItemContainer(_local4[_local1], 0, 0, this.resultElementWidth);
                this.displayedItemsGrid.addGridElement(_local3);
                _local1++;
            }
        }
        
        override public function resize(_arg_1: int, _arg_2: int = -1): void {
            background.width = _arg_1;
            backgroundTitle.width = _arg_1;
            backgroundButton.width = _arg_1;
            background.height = 184;
            backgroundTitle.y = 2;
            titleLabel.x = Math.round((_arg_1 - titleLabel.textWidth) / 2);
            titleLabel.y = 6;
            backgroundButton.y = 133;
            _buyButton.y = backgroundButton.y + 4;
            _buyButton.x = _arg_1 - 110;
            _infoButton.x = 130;
            _infoButton.y = 45;
            if (this.displayedItemsGrid) {
                this.displayedItemsGrid.x = 10 + Math.round((this.maxResultWidth - this.resultElementWidth * this.gridConfig.x) / 2);
            }
            updateSaleLabel();
            updateClickMask(_arg_1);
            updateStartTimeString(_arg_1);
            updateTimeEndString(_arg_1);
        }
        
        override public function dispose(): void {
            if (this.displayedItemsGrid) {
                this.displayedItemsGrid.dispose();
            }
            super.dispose();
        }
        
        private function prepareResultGrid(_arg_1: int): void {
            this.maxResultWidth = 160;
            this.gridConfig = this.calculateGrid(_arg_1);
            this.resultElementWidth = this.calculateElementSize(this.gridConfig);
            this.displayedItemsGrid = new UIGrid(this.resultElementWidth * this.gridConfig.x, this.gridConfig.x, 0);
            this.displayedItemsGrid.x = 20 + Math.round((this.maxResultWidth - this.resultElementWidth * this.gridConfig.x) / 2);
            this.displayedItemsGrid.y = Math.round(42 + (this.maxResultHeight - this.resultElementWidth * this.gridConfig.y) / 2);
            this.displayedItemsGrid.centerLastRow = true;
            addChild(this.displayedItemsGrid);
        }
        
        private function calculateGrid(_arg_1: int): Point {
            var _local3: int = 0;
            var _local5: int = 0;
            var _local2: Point = new Point(11, 4);
            var _local6: * = -2147483648;
            if (_arg_1 >= _local2.x * _local2.y) {
                return _local2;
            }
            var _local4: int = 11;
            while (_local4 >= 1) {
                _local3 = 4;
                while (_local3 >= 1) {
                    if (_local4 * _local3 >= _arg_1 && (_local4 - 1) * (_local3 - 1) < _arg_1) {
                        _local5 = this.calculateElementSize(new Point(_local4, _local3));
                        if (_local5 != -1) {
                            if (_local5 > _local6) {
                                _local6 = _local5;
                                _local2 = new Point(_local4, _local3);
                            } else if (_local5 == _local6) {
                                if (_local2.x * _local2.y - _arg_1 > _local4 * _local3 - _arg_1) {
                                    _local6 = _local5;
                                    _local2 = new Point(_local4, _local3);
                                }
                            }
                        }
                    }
                    _local3--;
                }
                _local4--;
            }
            return _local2;
        }
        
        private function calculateElementSize(_arg_1: Point): int {
            var _local2: int = Math.floor(this.maxResultHeight / _arg_1.y);
            if (_local2 * _arg_1.x > this.maxResultWidth) {
                _local2 = Math.floor(this.maxResultWidth / _arg_1.x);
            }
            if (_local2 * _arg_1.y > this.maxResultHeight) {
                return -1;
            }
            return _local2;
        }
    }
}
