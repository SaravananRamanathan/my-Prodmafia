package io.decagames.rotmg.pets.components.petIcon {
    import com.company.assembleegameclient.util.TextureRedrawer;
    import com.company.assembleegameclient.util.redrawers.GlowRedrawer;
    
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    
    import io.decagames.rotmg.pets.data.vo.IPetVO;
    import io.decagames.rotmg.pets.data.vo.PetVO;
    
    public class PetIconFactory {
        
        
        public function PetIconFactory() {
            super();
        }
        
        public var outlineSize: Number = 1.4;
        
        public function create(_arg_1: PetVO, _arg_2: int): PetIcon {
            var _local5: BitmapData = this.getPetSkinTexture(_arg_1, _arg_2);
            var _local4: Bitmap = new Bitmap(_local5);
            var _local3: PetIcon = new PetIcon(_arg_1);
            _local3.setBitmap(_local4);
            return _local3;
        }
        
        public function getPetSkinTexture(_arg_1: IPetVO, _arg_2: int, _arg_3: uint = 0): BitmapData {
            var _local4: Number = NaN;
            var _local6: * = null;
            if (!_arg_1.getSkinMaskedImage() ? null : _arg_1.getSkinMaskedImage().image_) {
                _local4 = 5 * (16 / _arg_1.getSkinBitmap().width);
                _local6 = TextureRedrawer.resize(_arg_1.getSkinMaskedImage().image_, _arg_1.getSkinMaskedImage().mask_, _arg_2 * 3, true, 0, 0, _local4);
                _local6 = GlowRedrawer.outlineGlow(_local6, _arg_3, this.outlineSize);
                return _local6;
            }
            return new BitmapData(_arg_2, _arg_2);
        }
    }
}
