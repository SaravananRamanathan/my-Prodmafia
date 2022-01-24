package kabam.rotmg.game.view.components {
import com.company.assembleegameclient.map.mapoverlay.CharacterStatusText;
import com.company.assembleegameclient.objects.GameObject;

public class QueuedStatusText extends CharacterStatusText {


    public function QueuedStatusText(_arg_1:GameObject, _arg_2:String, _arg_3:uint, _arg_4:int, _arg_5:int = 0) {
        super(_arg_1, _arg_3, _arg_4, _arg_5);
        setText(_arg_2);
    }
    public var list:QueuedStatusTextList;
    public var next:QueuedStatusText;

    override public function dispose():void {
        this.list.shift();
    }
}
}
