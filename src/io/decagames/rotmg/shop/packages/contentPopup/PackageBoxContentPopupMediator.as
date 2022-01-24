package io.decagames.rotmg.shop.packages.contentPopup {
    import flash.utils.Dictionary;
    
    import io.decagames.rotmg.shop.mysteryBox.contentPopup.ItemBox;
    import io.decagames.rotmg.shop.mysteryBox.contentPopup.SlotBox;
    import io.decagames.rotmg.ui.buttons.BaseButton;
    import io.decagames.rotmg.ui.buttons.SliceScalingButton;
    import io.decagames.rotmg.ui.gird.UIGrid;
    import io.decagames.rotmg.ui.popups.signals.ClosePopupSignal;
    import io.decagames.rotmg.ui.texture.TextureParser;
    
    import robotlegs.bender.bundles.mvcs.Mediator;
    
    public class PackageBoxContentPopupMediator extends Mediator {
        
        
        public function PackageBoxContentPopupMediator() {
            super();
        }
        
        [Inject]
        public var view: PackageBoxContentPopup;
        [Inject]
        public var closePopupSignal: ClosePopupSignal;
        private var closeButton: SliceScalingButton;
        private var contentGrids: UIGrid;
        
        override public function initialize(): void {
            this.closeButton = new SliceScalingButton(TextureParser.instance.getSliceScalingBitmap("UI", "close_button"));
            this.closeButton.clickSignal.addOnce(this.onClose);
            this.view.header.addButton(this.closeButton, "right_button");
            this.addContentList(this.view.info.contents, this.view.info.charSlot, this.view.info.vaultSlot, this.view.info.gold);
        }
        
        override public function destroy(): void {
            this.closeButton.clickSignal.remove(this.onClose);
            this.closeButton.dispose();
            this.contentGrids.dispose();
            this.contentGrids = null;
        }
        
        private function addContentList(_arg_1: String, _arg_2: int, _arg_3: int, _arg_4: int): void {
            var _local14: * = null;
            var _local7: * = null;
            var _local10: * = null;
            var _local9: * = null;
            var _local13: * = null;
            var _local11: * = null;
            var _local5: * = null;
            var _local6: * = null;
            var _local12: * = null;
            var _local15: * = 255;
            this.contentGrids = new UIGrid(_local15, 1, 2);
            if (_arg_1 != "") {
                _local14 = _arg_1.split(",");
                _local7 = new Dictionary();
                var _local20: int = 0;
                var _local19: * = _local14;
                for each(_local10 in _local14) {
                    if (_local7[_local10]) {
                        var _local16: * = _local7;
                        var _local17: * = _local10;
                        var _local18: * = Number(_local16[_local17]) + 1;
                        _local16[_local17] = _local18;
                    } else {
                        _local7[_local10] = 1;
                    }
                }
                _local9 = [];
                var _local22: int = 0;
                var _local21: * = _local14;
                for each(_local13 in _local14) {
                    if (_local9.indexOf(_local13) == -1) {
                        _local11 = new ItemBox(_local13, _local7[_local13], true, "", false);
                        this.contentGrids.addGridElement(_local11);
                        _local9.push(_local13);
                    }
                }
            }
            if (_arg_2 > 0) {
                _local5 = new SlotBox("CHAR_SLOT", _arg_2, true, "", false);
                this.contentGrids.addGridElement(_local5);
            }
            if (_arg_3 > 0) {
                _local6 = new SlotBox("VAULT_SLOT", _arg_3, true, "", false);
                this.contentGrids.addGridElement(_local6);
            }
            if (_arg_4 > 0) {
                _local12 = new SlotBox("GOLD_SLOT", _arg_4, true, "", false);
                this.contentGrids.addGridElement(_local12);
            }
            this.contentGrids.y = this.view.infoLabel.textHeight + 8;
            this.contentGrids.x = 10;
            this.view.addChild(this.contentGrids);
        }
        
        private function onClose(_arg_1: BaseButton): void {
            this.closePopupSignal.dispatch(this.view);
        }
    }
}
