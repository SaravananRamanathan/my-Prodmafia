package kabam.rotmg.dialogs.view {
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Graphics;
import flash.display.Sprite;
import flash.events.Event;

public class DialogsView extends Sprite {


    public function DialogsView() {
        super();
        var _local1:* = new Sprite();
        this.background = _local1;
        addChild(_local1);
        _local1 = new Sprite();
        this.container = _local1;
        addChild(_local1);
        this.background.visible = false;
        this.background.mouseEnabled = true;
    }
    private var background:Sprite;
    private var container:DisplayObjectContainer;
    private var current:Sprite;
    private var pushed:DisplayObject;

    public function showBackground(_arg_1:int = 1381653):void {
        var _local2:Graphics = this.background.graphics;
        _local2.clear();
        _local2.beginFill(_arg_1, 0.6);
        _local2.drawRect(0, 0, 800, 10 * 60);
        _local2.endFill();
        this.background.visible = true;
    }

    public function show(_arg_1:Sprite, _arg_2:Boolean):void {
        this.removeCurrentDialog();
        this.addDialog(_arg_1);
    }

    public function hideAll():void {
        this.background.visible = false;
        this.removeCurrentDialog();
    }

    public function push(_arg_1:Sprite):void {
        this.current.visible = false;
        this.pushed = _arg_1;
        addChild(_arg_1);
        this.background.visible = true;
    }

    public function getPushed():DisplayObject {
        return this.pushed;
    }

    public function pop():void {
        removeChild(this.pushed);
        this.current.visible = true;
    }

    private function addDialog(_arg_1:Sprite):void {
        this.current = _arg_1;
        _arg_1.addEventListener("removed", this.onRemoved);
        this.container.addChild(_arg_1);
    }

    private function removeCurrentDialog():void {
        if (this.current && this.container.contains(this.current)) {
            this.current.removeEventListener("removed", this.onRemoved);
            this.container.removeChild(this.current);
            this.background.visible = false;
        }
    }

    private function onRemoved(_arg_1:Event):void {
        var _local2:Sprite = _arg_1.target as Sprite;
        if (this.current == _local2) {
            this.background.visible = false;
            this.current = null;
        }
    }
}
}
