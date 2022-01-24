package io.decagames.rotmg.pets.popup.hatching {
    import com.company.assembleegameclient.objects.ObjectLibrary;
    import com.company.assembleegameclient.util.AnimatedChar;
    import com.company.assembleegameclient.util.AnimatedChars;
    import com.company.assembleegameclient.util.MaskedImage;
    import com.company.assembleegameclient.util.TextureRedrawer;
    import com.company.assembleegameclient.util.redrawers.GlowRedrawer;
    import com.greensock.TimelineMax;
    import com.greensock.TweenLite;
    import com.greensock.plugins.TransformMatrixPlugin;
    import com.greensock.plugins.TweenPlugin;
    import com.gskinner.motion.easing.Sine;
    
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Sprite;
    import flash.geom.Point;
    
    import io.decagames.rotmg.pets.data.vo.SkinVO;
    import io.decagames.rotmg.ui.buttons.SliceScalingButton;
    import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
    import io.decagames.rotmg.ui.labels.UILabel;
    import io.decagames.rotmg.ui.popups.modal.ModalPopup;
    import io.decagames.rotmg.ui.sliceScaling.SliceScalingBitmap;
    import io.decagames.rotmg.ui.texture.TextureParser;
    
    import kabam.rotmg.text.view.stringBuilder.LineBuilder;
    
    public class PetHatchingDialog extends ModalPopup {
        
        
        public function PetHatchingDialog(_arg_1: String, _arg_2: int, _arg_3: int, _arg_4: Boolean, _arg_5: SkinVO) {
            _arg_1 = _arg_1;
            _arg_2 = _arg_2;
            _arg_3 = _arg_3;
            _arg_4 = _arg_4;
            _arg_5 = _arg_5;
            var param1: String = _arg_1;
            var param2: int = _arg_2;
            var param3: int = _arg_3;
            var param4: Boolean = _arg_4;
            var param5: SkinVO = _arg_5;
            var petName: String = param1;
            var petSkin: int = param2;
            var itemType: int = param3;
            var unlocked: Boolean = param4;
            var skinVO: SkinVO = param5;
            super(270, 3 * 60, "Pet hatching!");
            this.unlockedSkin = unlocked;
            this._petSkin = petSkin;
            this.skinVO = skinVO;
            this.petName = petName;
            TweenPlugin.activate([TransformMatrixPlugin]);
            this.petImage = this.getTypeBitmap();
            this.animationContainer = new Sprite();
            this.contentInset = TextureParser.instance.getSliceScalingBitmap("UI", "popup_content_inset", 270);
            addChild(this.contentInset);
            this.contentInset.height = 130;
            this.contentInset.x = 0;
            this.contentInset.y = 0;
            this.animationContainer.x = this.contentInset.x;
            this.animationContainer.y = this.contentInset.y;
            addChild(this.animationContainer);
            var maskImage: SliceScalingBitmap = TextureParser.instance.getSliceScalingBitmap("UI", "popup_content_inset", this.contentInset.width);
            maskImage.height = this.contentInset.height;
            maskImage.x = this.contentInset.x;
            maskImage.y = this.contentInset.y;
            maskImage.cacheAsBitmap = true;
            this.animationContainer.cacheAsBitmap = true;
            addChild(maskImage);
            this.animationContainer.mask = maskImage;
            var texture: BitmapData = ObjectLibrary.getRedrawnTextureFromType(itemType, this.eggSize, true, false);
            this.eggImage = new Bitmap(texture);
            this.eggImage.x = this.contentInset.x + Math.round((this.contentInset.width - this.eggImage.width) / 2);
            this.eggImage.y = this.contentInset.y + Math.round((this.contentInset.height - this.eggImage.height) / 2);
            this.animationContainer.addChild(this.eggImage);
            this.animationTimeline = new TimelineMax();
            this.animateEgg(this.animationTimeline, this.eggImage, -20, 0.1, 0.5);
            this.animateEgg(this.animationTimeline, this.eggImage, 20, 0.1, 0);
            this.animateEgg(this.animationTimeline, this.eggImage, 0, 0.1, 0);
            this.animateEgg(this.animationTimeline, this.eggImage, 20, 0.1, 0.3);
            this.animateEgg(this.animationTimeline, this.eggImage, -20, 0.1, 0);
            this.animateEgg(this.animationTimeline, this.eggImage, 0, 0.1, 0, function (): void {
                showPet();
            });
            this.animationTimeline.to(this.eggImage, 0.1, {
                "transformAroundPoint": {
                    "point": new Point(this.eggImage.width / 2, this.eggImage.height / 2),
                    "pointIsLocal": true,
                    "scaleX": 2,
                    "scaleY": 2
                }
            });
            this.animationTimeline.play();
            this._okButton = new SliceScalingButton(TextureParser.instance.getSliceScalingBitmap("UI", "generic_green_button"));
            this._okButton.setLabel(LineBuilder.getLocalizedStringFromKey("Pets.sendToYard"), DefaultLabelFormat.questButtonCompleteLabel);
            this._okButton.width = 149;
            this._okButton.x = Math.round((_contentWidth - this._okButton.width) / 2);
            this._okButton.y = _contentHeight - this._okButton.height;
            addChild(this._okButton);
        }
        
        private var contentInset: SliceScalingBitmap;
        private var eggImage: Bitmap;
        private var animationContainer: Sprite;
        private var animationTimeline: TimelineMax;
        private var petImage: Bitmap;
        private var eggSize: int = 80;
        private var unlockedSkin: Boolean;
        private var skinVO: SkinVO;
        private var petName: String;
        
        private var _petSkin: int;
        
        public function get petSkin(): int {
            return this._petSkin;
        }
        
        private var _okButton: SliceScalingButton;
        
        public function get okButton(): SliceScalingButton {
            return this._okButton;
        }
        
        private function getTypeBitmap(): Bitmap {
            var _local6: String = ObjectLibrary.getIdFromType(this._petSkin);
            var _local2: XML = ObjectLibrary.getXMLfromId(_local6);
            var _local1: String = _local2.AnimatedTexture.File;
            var _local3: int = _local2.AnimatedTexture.Index;
            var _local7: AnimatedChar = AnimatedChars.getAnimatedChar(_local1, _local3);
            var _local5: MaskedImage = _local7.imageFromAngle(0, 0, 0);
            var _local4: BitmapData = TextureRedrawer.resize(_local5.image_, _local5.mask_, this.eggSize, true, 0, 0);
            _local4 = GlowRedrawer.outlineGlow(_local4, 0, 6);
            return new Bitmap(_local4);
        }
        
        private function showPet(): void {
            var animationSpiral: SliceScalingBitmap = TextureParser.instance.getSliceScalingBitmap("UI", "animation_spiral");
            animationSpiral.x = this.contentInset.x + Math.round((this.contentInset.width - animationSpiral.width) / 2);
            animationSpiral.y = this.contentInset.y + Math.round((this.contentInset.height - animationSpiral.height) / 2);
            var whiteRectangle: Sprite = new Sprite();
            whiteRectangle.graphics.beginFill(0xffffff);
            whiteRectangle.graphics.drawRect(0, 0, this.contentInset.width, this.contentInset.height);
            whiteRectangle.graphics.endFill();
            whiteRectangle.alpha = 0;
            this.animationContainer.addChild(whiteRectangle);
            var flashDuration: Number = 0.3;
            var spinDuration: Number = 1.5;
            var spinAngle: int = 80;
            var hideDuration: Number = 0.1;
            TweenLite.to(whiteRectangle, 0.1, {
                "alpha": 1,
                "ease": Sine.easeIn,
                "onComplete": function (): void {
                    var textInfo: * = undefined;
                    animationContainer.removeChild(eggImage);
                    animationContainer.addChild(animationSpiral);
                    petImage.x = contentInset.x + Math.round((contentInset.width - petImage.width) / 2);
                    petImage.y = contentInset.y + Math.round((contentInset.height - petImage.height) / 2);
                    animationContainer.addChild(petImage);
                    var petNameLabel: * = new UILabel();
                    DefaultLabelFormat.petNameLabel(petNameLabel, skinVO.rarity.color);
                    petNameLabel.y = contentInset.y + 15;
                    petNameLabel.width = _contentWidth;
                    petNameLabel.wordWrap = true;
                    petNameLabel.text = petName;
                    animationContainer.addChild(petNameLabel);
                    if (unlockedSkin) {
                        textInfo = new UILabel();
                        DefaultLabelFormat.newSkinHatched(textInfo);
                        textInfo.y = contentInset.y + contentInset.height - 30;
                        textInfo.width = _contentWidth;
                        textInfo.wordWrap = true;
                        textInfo.text = "New Pet Skin added to your Wardrobe!";
                        animationContainer.addChild(textInfo);
                    }
                    animationContainer.addChild(whiteRectangle);
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
                            animationContainer.removeChild(whiteRectangle);
                            animationContainer.removeChild(animationSpiral);
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
        
        private function animateEgg(_arg_1: TimelineMax, _arg_2: Bitmap, _arg_3: Number, _arg_4: Number, _arg_5: Number, _arg_6: Function = null): void {
            _arg_1.to(_arg_2, _arg_4, {
                "delay": _arg_5,
                "transformAroundPoint": {
                    "point": new Point(_arg_2.width / 2, _arg_2.height),
                    "pointIsLocal": true,
                    "rotation": _arg_3
                },
                "onComplete": _arg_6,
                "overwrite": false
            });
        }
    }
}
