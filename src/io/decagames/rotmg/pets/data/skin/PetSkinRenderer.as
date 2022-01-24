package io.decagames.rotmg.pets.data.skin {
    import com.company.assembleegameclient.objects.ObjectLibrary;
    import com.company.assembleegameclient.util.AnimatedChar;
    import com.company.assembleegameclient.util.AnimatedChars;
    import com.company.assembleegameclient.util.MaskedImage;
    import com.company.assembleegameclient.util.TextureRedrawer;
    import com.company.assembleegameclient.util.redrawers.GlowRedrawer;
    
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    
    public class PetSkinRenderer {
        
        
        public function PetSkinRenderer() {
            super();
        }
        
        protected var _skinType: int;
        protected var skin: AnimatedChar;
        
        public function getSkinBitmap(): Bitmap {
            this.makeSkin();
            if (this.skin == null) {
                return null;
            }
            var _local3: MaskedImage = this.skin.imageFromAngle(0, 0, 0);
            var _local2: int = this.skin.getHeight() == 16 ? 40 : 80;
            var _local1: BitmapData = TextureRedrawer.resize(_local3.image_, _local3.mask_, _local2, true, 0, 0);
            _local1 = GlowRedrawer.outlineGlow(_local1, 0);
            return new Bitmap(_local1);
        }
        
        public function getSkinMaskedImage(): MaskedImage {
            this.makeSkin();
            return !this.skin ? null : this.skin.imageFromAngle(0, 0, 0);
        }
        
        protected function makeSkin(): void {
            var _local3: XML = ObjectLibrary.getXMLfromId(ObjectLibrary.getIdFromType(this._skinType));
            if (_local3 == null) {
                return;
            }
            var _local2: String = _local3.AnimatedTexture.File;
            var _local1: int = _local3.AnimatedTexture.Index;
            this.skin = AnimatedChars.getAnimatedChar(_local2, _local1);
        }
    }
}
