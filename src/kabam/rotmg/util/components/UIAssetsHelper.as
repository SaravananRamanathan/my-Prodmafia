package kabam.rotmg.util.components {
import com.company.util.AssetLibrary;

import flash.display.Bitmap;
import flash.display.Sprite;

public class UIAssetsHelper {

    public static const LEFT_NEVIGATOR:String = "left";

    public static const RIGHT_NEVIGATOR:String = "right";

    public static function createLeftNevigatorIcon(_arg_1:String = "left", _arg_2:int = 4, _arg_3:Number = 0):Sprite {
        var _local5:* = null;
        if (_arg_1 == "left") {
            _local5 = AssetLibrary.getImageFromSet("lofiInterface", 55);
        } else {
            _local5 = AssetLibrary.getImageFromSet("lofiInterface", 54);
        }
        var _local4:Bitmap = new Bitmap(_local5);
        _local4.scaleX = _arg_2;
        _local4.scaleY = _arg_2;
        _local4.rotation = _arg_3;
        var _local6:Sprite = new Sprite();
        _local6.addChild(_local4);
        return _local6;
    }

    public function UIAssetsHelper() {
        super();
    }
}
}
