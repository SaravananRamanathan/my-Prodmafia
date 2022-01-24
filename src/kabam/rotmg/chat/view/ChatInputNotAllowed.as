package kabam.rotmg.chat.view {
import com.company.assembleegameclient.util.TextureRedrawer;
import com.company.util.AssetLibrary;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;

import kabam.rotmg.chat.model.ChatModel;
import kabam.rotmg.text.view.TextFieldDisplayConcrete;
import kabam.rotmg.text.view.stringBuilder.LineBuilder;

public class ChatInputNotAllowed extends Sprite {

    public static const IMAGE_NAME:String = "lofiInterfaceBig";

    public static const IMADE_ID:int = 21;


    public function ChatInputNotAllowed() {
        super();
        this.makeTextField();
        this.makeSpeechBubble();
    }

    public function setup(_arg_1:ChatModel):void {
        x = 0;
        y = _arg_1.bounds.height - _arg_1.lineHeight;
    }

    private function makeTextField():TextFieldDisplayConcrete {
        var _local1:LineBuilder = new LineBuilder().setParams("chat.registertoChat");
        var _local2:TextFieldDisplayConcrete = new TextFieldDisplayConcrete();
        _local2.setStringBuilder(_local1);
        _local2.x = 29;
        addChild(_local2);
        return _local2;
    }

    private function makeSpeechBubble():Bitmap {
        var _local2:* = null;
        var _local1:BitmapData = AssetLibrary.getImageFromSet("lofiInterfaceBig", 21);
        _local1 = TextureRedrawer.redraw(_local1, 20, true, 0, false);
        _local2 = new Bitmap(_local1);
        _local2.x = -5;
        _local2.y = -10;
        addChild(_local2);
        return _local2;
    }
}
}
