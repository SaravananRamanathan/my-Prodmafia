package kabam.rotmg.ui.view {
import flash.display.Bitmap;
import flash.display.Sprite;

import kabam.rotmg.ui.model.Key;

public class KeysView extends Sprite {

    private static var keyBackgroundPng:Class = KeysView_keyBackgroundPng;

    private static var greenKeyPng:Class = KeysView_greenKeyPng;

    private static var redKeyPng:Class = KeysView_redKeyPng;

    private static var yellowKeyPng:Class = KeysView_yellowKeyPng;

    private static var purpleKeyPng:Class = KeysView_purpleKeyPng;

    public function KeysView() {
        super();
        this.base = new keyBackgroundPng();
        addChild(this.base);
        this.keys = new Vector.<Bitmap>(4, true);
        this.keys[0] = new purpleKeyPng();
        this.keys[0].x = 12;
        this.keys[0].y = 12;
        this.keys[1] = new greenKeyPng();
        this.keys[1].x = 52;
        this.keys[1].y = 12;
        this.keys[2] = new redKeyPng();
        this.keys[2].x = 92;
        this.keys[2].y = 12;
        this.keys[3] = new yellowKeyPng();
        this.keys[3].x = 132;
        this.keys[3].y = 12;
    }
    private var base:Bitmap;
    private var keys:Vector.<Bitmap>;

    public function showKey(_arg_1:Key):void {
        var _local2:Bitmap = this.keys[_arg_1.position];
        if (!contains(_local2)) {
            addChild(_local2);
        }
    }

    public function hideKey(_arg_1:Key):void {
        var _local2:Bitmap = this.keys[_arg_1.position];
        if (contains(_local2)) {
            removeChild(_local2);
        }
    }
}
}
