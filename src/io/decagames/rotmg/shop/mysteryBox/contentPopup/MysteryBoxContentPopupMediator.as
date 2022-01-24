package io.decagames.rotmg.shop.mysteryBox.contentPopup {
    import flash.utils.Dictionary;
    
    import io.decagames.rotmg.ui.buttons.BaseButton;
    import io.decagames.rotmg.ui.buttons.SliceScalingButton;
    import io.decagames.rotmg.ui.gird.UIGrid;
    import io.decagames.rotmg.ui.popups.signals.ClosePopupSignal;
    import io.decagames.rotmg.ui.texture.TextureParser;
    
    import robotlegs.bender.bundles.mvcs.Mediator;
    
    public class MysteryBoxContentPopupMediator extends Mediator {
        
        
        public function MysteryBoxContentPopupMediator() {
            super();
        }
        
        [Inject]
        public var view: MysteryBoxContentPopup;
        [Inject]
        public var closePopupSignal: ClosePopupSignal;
        private var closeButton: SliceScalingButton;
        private var contentGrids: Vector.<UIGrid>;
        private var jackpotsNumber: int = 0;
        private var jackpotsHeight: int = 0;
        private var jackpotUI: JackpotContainer;
        
        override public function initialize(): void {
            this.closeButton = new SliceScalingButton(TextureParser.instance.getSliceScalingBitmap("UI", "close_button"));
            this.closeButton.clickSignal.addOnce(this.onClose);
            this.view.header.addButton(this.closeButton, "right_button");
            this.addJackpots(this.view.info.jackpots);
            this.addContentList(this.view.info.contents, this.view.info.jackpots);
        }
        
        override public function destroy(): void {
            var _local1: * = null;
            this.closeButton.dispose();
            var _local3: int = 0;
            var _local2: * = this.contentGrids;
            for each(_local1 in this.contentGrids) {
                _local1.dispose();
            }
            this.contentGrids = null;
        }
        
        private function addJackpots(_arg_1: String): void {
            var _local8: * = null;
            var _local11: * = null;
            var _local10: * = null;
            var _local7: * = null;
            var _local6: * = null;
            var _local9: int = 0;
            var _local2: * = null;
            var _local3: * = null;
            var _local5: int = 0;
            var _local4: Array = _arg_1.split("|");
            var _local17: int = 0;
            var _local16: * = _local4;
            for each(_local8 in _local4) {
                _local11 = _local8.split(",");
                _local10 = [];
                _local7 = [];
                var _local13: int = 0;
                var _local12: * = _local11;
                for each(_local6 in _local11) {
                    _local9 = _local10.indexOf(_local6);
                    if (_local9 == -1) {
                        _local10.push(_local6);
                        _local7.push(1);
                    } else {
                        _local7[_local9] = _local7[_local9] + 1;
                    }
                }
                if (_arg_1.length > 0) {
                    _local2 = new UIGrid(220, 5, 4);
                    _local2.centerLastRow = true;
                    var _local15: int = 0;
                    var _local14: * = _local10;
                    for each(_local6 in _local10) {
                        _local3 = new UIItemContainer(parseInt(_local6), 0x484848, 0, 40);
                        _local3.showTooltip = true;
                        _local2.addGridElement(_local3);
                        _local5 = _local7[_local10.indexOf(_local6)];
                        if (_local5 > 1) {
                            _local3.showQuantityLabel(_local5);
                        }
                    }
                    this.jackpotUI = new JackpotContainer();
                    this.jackpotUI.x = 10;
                    this.jackpotUI.y = 55 + this.jackpotsHeight - 22;
                    if (this.jackpotsNumber == 0) {
                        this.jackpotUI.diamondBackground();
                    } else if (this.jackpotsNumber == 1) {
                        this.jackpotUI.goldBackground();
                    } else if (this.jackpotsNumber == 2) {
                        this.jackpotUI.silverBackground();
                    }
                    this.jackpotUI.addGrid(_local2);
                    this.view.addChild(this.jackpotUI);
                    this.jackpotsHeight = this.jackpotsHeight + (this.jackpotUI.height + 5);
                    this.jackpotsNumber++;
                }
            }
        }
        
        private function addContentList(_arg_1: String, _arg_2: String): void {
            var _local19: * = null;
            var _local25: int = 0;
            var _local24: int = 0;
            var _local16: * = null;
            var _local23: * = null;
            var _local21: * = null;
            var _local13: * = null;
            var _local14: Boolean = false;
            var _local17: * = null;
            var _local11: * = null;
            var _local27: * = null;
            var _local3: * = null;
            var _local26: * = undefined;
            var _local6: * = null;
            var _local7: * = null;
            var _local8: * = null;
            var _local9: * = null;
            var _local4: * = null;
            var _local5: * = null;
            var _local15: int = 0;
            var _local12: Array = _arg_1.split("|");
            var _local20: Array = _arg_2.split("|");
            var _local22: * = [];
            var _local33: int = 0;
            var _local32: * = _local12;
            for each(_local19 in _local12) {
                _local23 = [];
                _local21 = _local19.split(";");
                var _local31: * = 0;
                var _local30: * = _local21;
                for each(_local13 in _local21) {
                    _local14 = false;
                    var _local29: * = 0;
                    var _local28: * = _local20;
                    for each(_local17 in _local20) {
                        if (_local17 == _local13) {
                            _local14 = true;
                            break;
                        }
                    }
                    if (!_local14) {
                        _local11 = _local13.split(",");
                        _local23.push(_local11);
                    }
                }
                _local22[_local15] = _local23;
                _local15++;
            }
            _local25 = 475;
            _local24 = 30;
            if (this.jackpotsNumber > 0) {
                _local25 = _local25 - (this.jackpotsHeight + 10);
                _local24 = _local24 + (this.jackpotsHeight + 10);
            }
            this.contentGrids = new Vector.<UIGrid>(0);
            var _local18: Number = (260 - 5 * (_local22.length - 1)) / _local22.length;
            var _local41: int = 0;
            var _local40: * = _local22;
            for each(_local16 in _local22) {
                _local27 = new UIGrid(_local18, 1, 5);
                var _local39: int = 0;
                var _local38: * = _local16;
                for each(_local3 in _local16) {
                    _local26 = new Vector.<ItemBox>();
                    _local6 = new Dictionary();
                    var _local35: int = 0;
                    var _local34: * = _local3;
                    for each(_local7 in _local3) {
                        if (_local6[_local7]) {
                            _local29 = _local6;
                            _local28 = _local7;
                            _local31 = Number(_local29[_local28]) + 1;
                            _local29[_local28] = _local31;
                        } else {
                            _local6[_local7] = 1;
                        }
                    }
                    _local8 = [];
                    var _local37: int = 0;
                    var _local36: * = _local3;
                    for each(_local9 in _local3) {
                        if (_local8.indexOf(_local9) == -1) {
                            _local5 = new ItemBox(_local9, _local6[_local9], _local22.length == 1, "", false);
                            _local5.clearBackground();
                            _local26.push(_local5);
                            _local8.push(_local9);
                        }
                    }
                    _local4 = new ItemsSetBox(_local26);
                    _local27.addGridElement(_local4);
                }
                _local27.y = _local24;
                _local27.x = 10 + _local18 * this.contentGrids.length + 5 * this.contentGrids.length;
                this.view.addChild(_local27);
                this.contentGrids.push(_local27);
            }
        }
        
        private function onClose(_arg_1: BaseButton): void {
            this.closePopupSignal.dispatch(this.view);
        }
    }
}
