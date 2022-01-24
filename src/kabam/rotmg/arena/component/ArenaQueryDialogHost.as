package kabam.rotmg.arena.component {
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;

public class ArenaQueryDialogHost extends Sprite {


    private const speechBubble:HostQuerySpeechBubble = makeSpeechBubble();

    private const detailBubble:HostQueryDetailBubble = makeDetailBubble();

    private const icon:Bitmap = makeHostIcon();

    public function ArenaQueryDialogHost() {
        super();
    }

    public function showDetail(_arg_1:String):void {
        this.detailBubble.setText(_arg_1);
        removeChild(this.speechBubble);
        addChild(this.detailBubble);
    }

    public function showSpeech():void {
        removeChild(this.detailBubble);
        addChild(this.speechBubble);
    }

    public function setHostIcon(_arg_1:BitmapData):void {
        this.icon.bitmapData = _arg_1;
    }

    private function makeSpeechBubble():HostQuerySpeechBubble {
        var _local1:* = null;
        _local1 = new HostQuerySpeechBubble("ArenaQueryDialog.info");
        _local1.x = 60;
        addChild(_local1);
        return _local1;
    }

    private function makeDetailBubble():HostQueryDetailBubble {
        var _local1:HostQueryDetailBubble = new HostQueryDetailBubble();
        _local1.y = 60;
        return _local1;
    }

    private function makeHostIcon():Bitmap {
        var _local1:Bitmap = new Bitmap(this.makeDebugBitmapData());
        _local1.x = 0;
        _local1.y = 0;
        addChild(_local1);
        return _local1;
    }

    private function makeDebugBitmapData():BitmapData {
        return new BitmapData(42, 42, true, 4278255360);
    }
}
}
