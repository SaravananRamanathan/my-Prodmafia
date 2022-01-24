package io.decagames.rotmg.shop.mysteryBox.rollModal {
    import com.company.assembleegameclient.map.ParticleModalMap;
    import com.gskinner.motion.GTween;
    import com.gskinner.motion.easing.Sine;
    
    import flash.display.Bitmap;
    import flash.display.Sprite;
    import flash.geom.Point;
    import flash.utils.setTimeout;
    
    import io.decagames.rotmg.shop.ShopBuyButton;
    import io.decagames.rotmg.shop.mysteryBox.contentPopup.UIItemContainer;
    import io.decagames.rotmg.shop.mysteryBox.rollModal.elements.Spinner;
    import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
    import io.decagames.rotmg.ui.gird.UIGrid;
    import io.decagames.rotmg.ui.labels.UILabel;
    import io.decagames.rotmg.ui.popups.modal.ModalPopup;
    import io.decagames.rotmg.ui.sliceScaling.SliceScalingBitmap;
    import io.decagames.rotmg.ui.spinner.FixedNumbersSpinner;
    import io.decagames.rotmg.ui.texture.TextureParser;
    
    import kabam.rotmg.mysterybox.model.MysteryBoxInfo;
    
    import org.osflash.signals.Signal;
    
    public class MysteryBoxRollModal extends ModalPopup {
        
        
        private const iconSize: Number = 80;
        
        public function MysteryBoxRollModal(_arg_1: MysteryBoxInfo, _arg_2: int = 1) {
            finishedShowingResult = new Signal();
            spinnersContainer = new Sprite();
            super(415, 530, _arg_1.title);
            this._quantity = _arg_2;
            this._info = _arg_1;
            this.itemsBitmap = new Vector.<Bitmap>();
            this.createSpinners();
            this.vaultInfo = new UILabel();
            DefaultLabelFormat.mysteryBoxVaultInfo(this.vaultInfo);
            this.vaultInfo.text = "Rewards will be placed in your Vault!";
            this.vaultInfo.y = 2;
            this.vaultInfo.x = (contentWidth - this.vaultInfo.textWidth) / 2;
            addChild(this.vaultInfo);
            this.vaultInfo.alpha = 0;
            this.particleModalMap = new ParticleModalMap(2);
            addChild(this.particleModalMap);
            this.rollGrid = new UIGrid(this.maxInColumn * 80, this.maxInColumn, this.elementMargin);
            this.rollGrid.centerLastRow = true;
            this.addBuyButton();
        }
        
        public var buyButton: ShopBuyButton;
        public var spinner: FixedNumbersSpinner;
        public var bigSpinner: Spinner;
        public var littleSpinner: Spinner;
        public var finishedShowingResult: Signal;
        private var spinnersContainer: Sprite;
        private var itemsBitmap: Vector.<Bitmap>;
        private var rollGrid: UIGrid;
        private var resultGrid: UIGrid;
        private var maxInColumn: int = 5;
        private var elementMargin: int = 10;
        private var maxResultWidth: int;
        private var maxResultRows: int = 3;
        private var resultElementWidth: int;
        private var resultGridMargin: int = 10;
        private var spinnerTopMargin: int = 165;
        private var buyButtonBackground: SliceScalingBitmap;
        private var maxResultHeight: int = 135;
        private var buySectionContainer: Sprite;
        private var particleModalMap: ParticleModalMap;
        private var vaultInfo: UILabel;
        private var exposeDuration: Number = 0.4;
        private var exposeScale: Number = 1.5;
        private var movingDuration: Number = 0.2;
        private var movingDelay: Number = 0.1;
        private var buyButtonAnimationDuration: Number = 0.4;
        
        private var _quantity: int;
        
        public function get quantity(): int {
            return this._quantity;
        }
        
        private var _info: MysteryBoxInfo;
        
        public function get info(): MysteryBoxInfo {
            return this._info;
        }
        
        override public function dispose(): void {
            this.rollGrid.dispose();
            if (this.resultGrid) {
                this.resultGrid.dispose();
            }
            this.buyButtonBackground.dispose();
            this.buyButton.dispose();
            this.spinner.dispose();
            this.particleModalMap.dispose();
            this.finishedShowingResult.removeAll();
        }
        
        public function totalAnimationTime(_arg_1: int): Number {
            return this.exposeDuration * 2 + this.movingDuration + (_arg_1 - 1) * this.movingDelay;
        }
        
        public function prepareResultGrid(_arg_1: int): void {
            this.maxResultWidth = contentWidth - 2 * this.resultGridMargin;
            var _local2: Point = this.calculateGrid(_arg_1);
            this.resultElementWidth = this.calculateElementSize(_local2);
            var _local3: int = _arg_1 / _local2.x > 4 ? this.resultElementWidth * _local2.y : -1;
            this.resultGrid = new UIGrid(this.resultElementWidth * _local2.x, _local2.x, 0, _local3);
            this.resultGrid.x = this.resultGridMargin + Math.round((this.maxResultWidth - this.resultElementWidth * _local2.x) / 2);
            this.resultGrid.y = Math.round(330 + (this.maxResultHeight - this.resultElementWidth * _local2.y) / 2);
            addChild(this.resultGrid);
        }
        
        public function buyMore(_arg_1: int): void {
            this._quantity = _arg_1;
            removeChild(this.resultGrid);
            this.hideBuyButton();
        }
        
        public function showBuyButton(): void {
            new GTween(this.buySectionContainer, this.buyButtonAnimationDuration, {"alpha": 1}, {"ease": Sine.easeIn});
        }
        
        public function displayResult(_arg_1: Array): void {
            _arg_1 = _arg_1;
            var param1: Array = _arg_1;
            var items: Array = param1;
            var elements: Vector.<UIItemContainer> = this.displayItems(items);
            var resetTween: GTween = new GTween(this.rollGrid, this.exposeDuration, {
                "scaleX": 1,
                "scaleY": 1,
                "x": this.rollGrid.x,
                "y": this.rollGrid.y
            }, {"ease": Sine.easeIn});
            resetTween.beginning();
            resetTween.onComplete = function (): void {
                var _local2: int = 0;
                var _local1: * = null;
                var _local4: int = 0;
                var _local3: * = elements;
                for each(_local1 in elements) {
                    _local2 = elements.indexOf(_local1);
                    animateGridElement(_local1, _local2 * movingDelay, _local2 == elements.length - 1);
                }
            };
            var blinkTween: GTween = new GTween(this.rollGrid, this.exposeDuration, {
                "x": this.rollGrid.x - this.rollGrid.width * (this.exposeScale - 1) / 2,
                "y": this.rollGrid.y - this.rollGrid.height * (this.exposeScale - 1) / 2,
                "scaleX": this.exposeScale,
                "scaleY": this.exposeScale
            }, {"ease": Sine.easeOut});
            blinkTween.nextTween = resetTween;
        }
        
        public function displayItems(_arg_1: Array): Vector.<UIItemContainer> {
            var _local4: * = undefined;
            var _local5: int = 0;
            var _local6: * = null;
            var _local3: * = null;
            this.rollGrid.clearGrid();
            var _local2: Vector.<UIItemContainer> = new Vector.<UIItemContainer>();
            var _local10: int = 0;
            var _local9: * = _arg_1;
            for each(_local6 in _arg_1) {
                var _local8: int = 0;
                var _local7: * = _local6;
                for (_local4 in _local6) {
                    _local3 = new UIItemContainer(_local4, 0, 0, 80);
                    _local5 = _local6[_local4];
                    if (_local5 > 1) {
                        _local3.showQuantityLabel(_local5);
                    }
                    _local3.showTooltip = false;
                    _local2.push(_local3);
                    this.rollGrid.addGridElement(_local3);
                }
            }
            this.rollGrid.render();
            if (!this.rollGrid.parent) {
                addChild(this.rollGrid);
            }
            this.rollGrid.x = this.spinnersContainer.x - this.rollGrid.width / 2;
            this.rollGrid.y = this.spinnersContainer.y - this.rollGrid.height / 2;
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
        
        private function hideBuyButton(): void {
            new GTween(this.buySectionContainer, this.buyButtonAnimationDuration, {"alpha": 0}, {"ease": Sine.easeOut});
        }
        
        private function addBuyButton(): void {
            this.buySectionContainer = new Sprite();
            this.buySectionContainer.alpha = 0;
            this.spinner = new FixedNumbersSpinner(TextureParser.instance.getSliceScalingBitmap("UI", "spinner_up_arrow"), 0, new <int>[1, 2, 3, 5, 10], "x");
            if (this.info.isOnSale()) {
                this.buyButton = new ShopBuyButton(this.info.saleAmount, this.info.saleCurrency);
            } else {
                this.buyButton = new ShopBuyButton(this.info.priceAmount, this.info.priceCurrency);
            }
            this.buyButton.width = 95;
            this.buyButton.showCampaignTooltip = true;
            this.buyButtonBackground = TextureParser.instance.getSliceScalingBitmap("UI", "buy_button_background", this.buyButton.width + 60);
            this.buySectionContainer.addChild(this.buyButtonBackground);
            this.buySectionContainer.addChild(this.spinner);
            this.buySectionContainer.addChild(this.buyButton);
            this.buySectionContainer.x = 100;
            this.buySectionContainer.y = contentHeight - 45;
            this.buyButton.x = this.buyButtonBackground.width - this.buyButton.width - 6;
            this.buyButton.y = 4;
            this.spinner.y = -2;
            this.spinner.x = 32;
            addChild(this.buySectionContainer);
            this.buySectionContainer.x = Math.round((contentWidth - this.buySectionContainer.width) / 2);
        }
        
        private function animateGridElement(_arg_1: UIItemContainer, _arg_2: Number, _arg_3: Boolean): void {
            _arg_1 = _arg_1;
            _arg_2 = _arg_2;
            _arg_3 = _arg_3;
            var param1: UIItemContainer = _arg_1;
            var param2: Number = _arg_2;
            var param3: Boolean = _arg_3;
            var element: UIItemContainer = param1;
            var delay: Number = param2;
            var triggerEventOnEnd: Boolean = param3;
            var resultGridElement: UIItemContainer = new UIItemContainer(element.itemId, 0, 0, this.resultElementWidth);
            resultGridElement.alpha = 0;
            if (element.quantity > 1) {
                resultGridElement.showQuantityLabel(element.quantity);
            }
            resultGridElement.showTooltip = false;
            this.resultGrid.addGridElement(resultGridElement);
            var scale: Number = this.resultElementWidth / 80;
            var newX: Number = Math.abs(resultGridElement.x) + (this.resultGrid.x - this.rollGrid.x);
            var newY: Number = Math.abs(element.y - resultGridElement.y) + (this.resultGrid.y - this.rollGrid.y);
            var toPoint: Point = new Point(newX, newY);
            var tween1: GTween = new GTween(element, this.movingDuration, {
                "x": toPoint.x,
                "y": toPoint.y,
                "scaleX": scale,
                "scaleY": scale
            }, {"ease": Sine.easeIn});
            tween1.delay = delay;
            tween1.onComplete = function (): void {
                element.alpha = 0;
                resultGridElement.alpha = 1;
                resultGridElement.showTooltip = true;
                if (triggerEventOnEnd) {
                    finishedShowingResult.dispatch();
                }
            };
            var timeout: uint = setTimeout(function (): void {
                particleModalMap.doLightning(rollGrid.x + element.x + element.width / 2, rollGrid.y + element.y + element.height / 2, resultGrid.x + resultGridElement.x + resultGridElement.width / 2, resultGrid.y + resultGridElement.y + resultGridElement.height / 2, 115, 15787660, movingDuration);
            }, delay + 0.2);
        }
        
        private function createSpinners(): void {
            this.bigSpinner = new Spinner(50, true);
            this.littleSpinner = new Spinner(this.bigSpinner.degreesPerSecond * 1.5, true);
            this.littleSpinner.width = this.bigSpinner.width * 0.7;
            this.littleSpinner.height = this.bigSpinner.height * 0.7;
            this.bigSpinner.alpha = 0.7;
            this.littleSpinner.alpha = 0.7;
            this.spinnersContainer.addChild(this.bigSpinner);
            this.spinnersContainer.addChild(this.littleSpinner);
            this.littleSpinner.pause();
            addChild(this.spinnersContainer);
            this.spinnersContainer.x = contentWidth / 2;
            this.spinnersContainer.y = this.spinnerTopMargin;
        }
    }
}
