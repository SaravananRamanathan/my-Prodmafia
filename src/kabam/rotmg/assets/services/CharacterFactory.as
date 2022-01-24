package kabam.rotmg.assets.services {
import com.company.assembleegameclient.util.AnimatedChar;
import com.company.assembleegameclient.util.AnimatedChars;
import com.company.assembleegameclient.util.MaskedImage;
import com.company.assembleegameclient.util.TextureRedrawer;
import com.company.assembleegameclient.util.redrawers.GlowRedrawer;
import com.company.util.BitmapUtil;

import flash.display.BitmapData;

import kabam.rotmg.assets.model.Animation;
import kabam.rotmg.assets.model.CharacterTemplate;

public class CharacterFactory {


    public function CharacterFactory() {
        super();
    }
    private var texture1:int;
    private var texture2:int;
    private var size:int;

    public function makeCharacter(_arg_1:CharacterTemplate):AnimatedChar {
        return AnimatedChars.getAnimatedChar(_arg_1.file, _arg_1.index);
    }

    public function makeIcon(_arg_1:CharacterTemplate, _arg_2:int = 100, _arg_3:int = 0, _arg_4:int = 0, _arg_5:Boolean = false):BitmapData {
        this.texture1 = _arg_3;
        this.texture2 = _arg_4;
        this.size = _arg_2;
        var _local6:AnimatedChar = this.makeCharacter(_arg_1);
        var _local7:BitmapData = this.makeFrame(_local6, 0, 0);
        _local7 = GlowRedrawer.outlineGlow(_local7, _arg_5 ? 0xff0000 : 0);
        _local7 = BitmapUtil.cropToBitmapData(_local7, 6, 6, _local7.width - 12, _local7.height - 6);
        return _local7;
    }

    public function makeWalkingIcon(_arg_1:CharacterTemplate, _arg_2:int = 100, _arg_3:int = 0, _arg_4:int = 0):Animation {
        this.texture1 = _arg_3;
        this.texture2 = _arg_4;
        this.size = _arg_2;
        var _local6:AnimatedChar = this.makeCharacter(_arg_1);
        var _local5:BitmapData = this.makeFrame(_local6, 1, 0.5);
        _local5 = GlowRedrawer.outlineGlow(_local5, 0);
        var _local8:BitmapData = this.makeFrame(_local6, 1, 0);
        _local8 = GlowRedrawer.outlineGlow(_local8, 0);
        var _local7:Animation = new Animation();
        _local7.setFrames(_local5, _local8);
        return _local7;
    }

    private function makeFrame(_arg_1:AnimatedChar, _arg_2:int, _arg_3:Number):BitmapData {
        var _local4:MaskedImage = _arg_1.imageFromDir(0, _arg_2, _arg_3);
        return TextureRedrawer.resize(_local4.image_, _local4.mask_, this.size, false, this.texture1, this.texture2);
    }
}
}
