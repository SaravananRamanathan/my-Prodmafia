package io.decagames.rotmg.pets.components.petPortrait {
    import com.company.assembleegameclient.ui.icons.IconButton;
    import com.company.assembleegameclient.ui.icons.IconButtonFactory;
    import com.company.util.AssetLibrary;
    import com.greensock.TweenLite;
    import com.greensock.plugins.TransformMatrixPlugin;
    import com.greensock.plugins.TweenPlugin;
    import com.gskinner.motion.easing.Sine;
    
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    
    import io.decagames.rotmg.pets.components.petIcon.PetIconFactory;
    import io.decagames.rotmg.pets.components.petSkinSlot.PetSkinSlot;
    import io.decagames.rotmg.pets.data.ability.AbilitiesUtil;
    import io.decagames.rotmg.pets.data.family.PetFamilyColors;
    import io.decagames.rotmg.pets.data.vo.IPetVO;
    import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
    import io.decagames.rotmg.ui.labels.UILabel;
    import io.decagames.rotmg.ui.sliceScaling.SliceScalingBitmap;
    import io.decagames.rotmg.ui.texture.TextureParser;
    import io.decagames.rotmg.utils.colors.Tint;
    
    import kabam.rotmg.core.StaticInjectorContext;
    import kabam.rotmg.text.view.stringBuilder.LineBuilder;
    
    import org.osflash.signals.Signal;
    
    public class PetPortrait extends Sprite {
        
        public static const INFO_HEIGHT: int = 207;
        
        public static const BASE_POS_Y: int = 15;
        
        public function PetPortrait(_arg_1: int, _arg_2: IPetVO, _arg_3: Boolean = false, _arg_4: Boolean = false, _arg_5: Boolean = false, _arg_6: Boolean = false) {
            releaseSignal = new Signal();
            super();
            TweenPlugin.activate([TransformMatrixPlugin]);
            this._petVO = _arg_2;
            this._switchable = _arg_3;
            this.showReleaseButton = _arg_5;
            this.slotWidth = _arg_1;
            this.showFeedPower = _arg_6;
            this._showCurrentPet = _arg_4;
            this.petName = new UILabel();
            addChild(this.petName);
            this.petName.y = 15;
            if (_arg_3) {
                this.petSwitch = new UILabel();
                this.petSwitch.text = "Click to switch Pet";
                DefaultLabelFormat.petInfoLabel(this.petSwitch, 0x686868);
                addChild(this.petSwitch);
                this.petSwitch.y = 35;
                this.petSwitch.x = _arg_1 / 2 - this.petSwitch.width / 2;
            }
            this.petRarity = new UILabel();
            DefaultLabelFormat.petInfoLabel(this.petRarity, 0xffffff);
            addChild(this.petRarity);
            this.petRarity.y = !_arg_3 ? 85 : 95;
            this.petFamily = new UILabel();
            this.contentDividerTitle = TextureParser.instance.getSliceScalingBitmap("UI", "content_divider_smalltitle_white", 320);
            addChild(this.contentDividerTitle);
            this.contentDividerTitle.y = !_arg_3 ? 100 : 110;
            addChild(this.petFamily);
            this.petFamily.y = !_arg_3 ? 100 : 110;
            this._petSkin = new PetSkinSlot(_arg_2, false);
            this._petSkin.x = _arg_1 / 2 - 20;
            this._petSkin.y = !this._switchable ? 42 : 52;
            addChild(this._petSkin);
            this.render();
        }
        
        public var releaseSignal: Signal;
        private var petName: UILabel;
        private var petSwitch: UILabel;
        private var petRarity: UILabel;
        private var contentDividerTitle: SliceScalingBitmap;
        private var petFamily: UILabel;
        private var slotWidth: int;
        private var isAnimating: Boolean;
        private var animationWaitCounter: int = 0;
        private var _releaseButton: IconButton;
        private var showReleaseButton: Boolean;
        private var showFeedPower: Boolean;
        
        private var _petVO: IPetVO;
        
        public function get petVO(): IPetVO {
            return this._petVO;
        }
        
        public function set petVO(_arg_1: IPetVO): void {
            this._petVO = _arg_1;
            this.render();
            this._petSkin.skinVO = _arg_1;
        }
        
        private var _switchable: Boolean;
        
        public function get switchable(): Boolean {
            return this._switchable;
        }
        
        private var _petSkin: PetSkinSlot;
        
        public function get petSkin(): PetSkinSlot {
            return this._petSkin;
        }
        
        private var _showCurrentPet: Boolean;
        
        public function get showCurrentPet(): Boolean {
            return this._showCurrentPet;
        }
        
        private var _enableAnimation: Boolean;
        
        public function get enableAnimation(): Boolean {
            return this._enableAnimation;
        }
        
        public function set enableAnimation(_arg_1: Boolean): void {
            this._petSkin.manualUpdate = _arg_1;
            this._enableAnimation = _arg_1;
        }
        
        public function hideRarityLabel(): void {
            this.petRarity.alpha = 0;
        }
        
        public function dispose(): void {
            if (this._releaseButton) {
                this._releaseButton.removeEventListener("click", this.onReleaseClickHandler);
            }
        }
        
        public function simulateFeed(_arg_1: Array, _arg_2: int): void {
            this.updateFeedPowerInfo(this.getCurrentPointsFromAbilitiesList() + _arg_2, this.getMaxPointsFromAbilitiesList(), _arg_2 != 0);
        }
        
        private function startAnimation(): void {
            if (this.isAnimating) {
                return;
            }
            this.animationWaitCounter = 0;
            this.isAnimating = true;
            var animationSpiral: SliceScalingBitmap = TextureParser.instance.getSliceScalingBitmap("UI", "animation_spiral");
            animationSpiral.x = Math.round((this.slotWidth - animationSpiral.width) / 2);
            animationSpiral.y = Math.round((207 - animationSpiral.height) / 2);
            var whiteRectangle: Sprite = new Sprite();
            whiteRectangle.graphics.beginFill(0xffffff);
            whiteRectangle.graphics.drawRect(0, 0, this.slotWidth, 207);
            whiteRectangle.graphics.endFill();
            whiteRectangle.alpha = 0;
            addChild(whiteRectangle);
            var flashDuration: Number = 0.3;
            var spinDuration: Number = 1.5;
            var spinAngle: int = 80;
            var hideDuration: Number = 0.3;
            TweenLite.to(whiteRectangle, flashDuration, {
                "alpha": 1,
                "ease": Sine.easeIn,
                "onComplete": function (): void {
                    applyPetChange();
                    _petSkin.addSkin(StaticInjectorContext.getInjector().getInstance(PetIconFactory).getPetSkinTexture(_petVO, 50));
                    addChildAt(animationSpiral, 0);
                    TweenLite.to(animationSpiral, spinDuration, {
                        "transformAroundCenter": {"rotation": spinAngle},
                        "ease": Sine.easeOut
                    });
                    TweenLite.to(animationSpiral, hideDuration, {
                        "alpha": 0,
                        "delay": spinDuration - 0.2,
                        "overwrite": false,
                        "ease": Sine.easeIn,
                        "onComplete": function (): void {
                            removeChild(whiteRectangle);
                            removeChild(animationSpiral);
                            isAnimating = false;
                        }
                    });
                }
            });
            TweenLite.to(whiteRectangle, flashDuration, {
                "alpha": 0,
                "delay": flashDuration,
                "ease": Sine.easeOut,
                "overwrite": false
            });
        }
        
        private function render(): void {
            if (this._petVO) {
                if (this._enableAnimation && (this.petName.text != "" && this.petName.text != this.petVO.name || this.petFamily.text != "" && this.petFamily.text != this.petVO.family)) {
                    this.startAnimation();
                } else {
                    this.applyPetChange();
                }
            } else {
                this.petName.text = "";
                this.petRarity.text = "";
                this.petFamily.text = "";
                if (this.contentDividerTitle.parent) {
                    removeChild(this.contentDividerTitle);
                }
                if (this._releaseButton) {
                    this._releaseButton.removeEventListener("click", this.onReleaseClickHandler);
                    removeChild(this._releaseButton);
                    this._releaseButton = null;
                }
            }
        }
        
        private function applyPetChange(): void {
            var _local1: * = null;
            Tint.add(this.contentDividerTitle, PetFamilyColors.getColorByFamilyKey(this.petVO.family), 1);
            this.petFamily.text = this.petVO.family;
            this.petRarity.text = LineBuilder.getLocalizedStringFromKey(this.petVO.rarity.rarityKey);
            DefaultLabelFormat.petFamilyLabel(this.petFamily, 0xffffff);
            this.petName.text = this.petVO.name;
            this.petName.y = !this.showFeedPower ? 15 : 8;
            this.contentDividerTitle.width = this.petFamily.width + 20;
            this.contentDividerTitle.x = this.slotWidth / 2 - this.contentDividerTitle.width / 2;
            if (!this.contentDividerTitle.parent) {
                addChild(this.contentDividerTitle);
                addChild(this.petFamily);
            }
            DefaultLabelFormat.petNameLabel(this.petName, this.petVO.rarity.color);
            if (this.petName.textWidth >= this.slotWidth) {
                DefaultLabelFormat.petNameLabelSmall(this.petName, this.petVO.rarity.color);
            }
            this.petRarity.x = this.slotWidth / 2 - this.petRarity.width / 2;
            this.petFamily.x = this.slotWidth / 2 - this.petFamily.width / 2;
            this.petName.x = this.slotWidth / 2 - this.petName.width / 2;
            if (this.showReleaseButton && !this._releaseButton) {
                _local1 = StaticInjectorContext.getInjector().getInstance(IconButtonFactory);
                this._releaseButton = _local1.create(AssetLibrary.getImageFromSet("lofiInterfaceBig", 42), "", "", "");
                this._releaseButton.x = 10;
                this._releaseButton.y = 10;
                this._releaseButton.addEventListener("click", this.onReleaseClickHandler);
                addChild(this._releaseButton);
            }
            if (this._releaseButton) {
                this._releaseButton.setToolTipText("Release " + this.petVO.name);
            }
            if (this.showFeedPower) {
                this.updateFeedPowerInfo(this.getCurrentPointsFromAbilitiesList(), this.getMaxPointsFromAbilitiesList(), false);
            }
        }
        
        private function getMaxPointsFromAbilitiesList(): int {
            var _local2: * = null;
            var _local1: int = 0;
            var _local4: int = 0;
            var _local3: * = this._petVO.abilityList;
            for each(_local2 in this._petVO.abilityList) {
                if (_local2.getUnlocked()) {
                    _local1 = _local1 + AbilitiesUtil.abilityPowerToMinPoints(this._petVO.maxAbilityPower);
                }
            }
            return _local1;
        }
        
        private function getCurrentPointsFromAbilitiesList(): int {
            var _local2: * = null;
            var _local1: int = 0;
            var _local4: int = 0;
            var _local3: * = this._petVO.abilityList;
            for each(_local2 in this._petVO.abilityList) {
                if (_local2.getUnlocked()) {
                    _local1 = _local1 + _local2.points;
                }
            }
            return _local1;
        }
        
        private function updateFeedPowerInfo(_arg_1: int, _arg_2: int, _arg_3: Boolean): void {
        }
        
        private function onReleaseClickHandler(_arg_1: MouseEvent): void {
            this.releaseSignal.dispatch();
        }
    }
}
