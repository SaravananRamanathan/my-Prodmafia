package kabam.rotmg.packages.view {
import flash.display.Sprite;
import flash.events.Event;
import flash.events.TimerEvent;
import flash.utils.Timer;

public class BusyIndicator extends Sprite {


    private const pinwheel:Sprite = makePinWheel();

    private const innerCircleMask:Sprite = makeInner();

    private const quarterCircleMask:Sprite = makeQuarter();

    private const timer:Timer = new Timer(25);

    private const radius:int = 22;

    private const color:uint = 16777215;

    public function BusyIndicator() {
        super();
        y = 22;
        x = 22;
        this.addChildren();
        addEventListener("addedToStage", this.onAdded);
        addEventListener("removedFromStage", this.onRemoved);
    }

    private function makePinWheel():Sprite {
        var _local1:* = null;
        _local1 = new Sprite();
        _local1.blendMode = "layer";
        _local1.graphics.beginFill(0xffffff);
        _local1.graphics.drawCircle(0, 0, 22);
        _local1.graphics.endFill();
        return _local1;
    }

    private function makeInner():Sprite {
        var _local1:Sprite = new Sprite();
        _local1.blendMode = "erase";
        _local1.graphics.beginFill(0x999999);
        _local1.graphics.drawCircle(0, 0, 11);
        _local1.graphics.endFill();
        return _local1;
    }

    private function makeQuarter():Sprite {
        var _local1:Sprite = new Sprite();
        _local1.graphics.beginFill(0xffffff);
        _local1.graphics.drawRect(0, 0, 22, 22);
        _local1.graphics.endFill();
        return _local1;
    }

    private function addChildren():void {
        this.pinwheel.addChild(this.innerCircleMask);
        this.pinwheel.addChild(this.quarterCircleMask);
        this.pinwheel.mask = this.quarterCircleMask;
        addChild(this.pinwheel);
    }

    private function onAdded(_arg_1:Event):void {
        this.timer.addEventListener("timer", this.updatePinwheel);
        this.timer.start();
    }

    private function onRemoved(_arg_1:Event):void {
        this.timer.stop();
        this.timer.removeEventListener("timer", this.updatePinwheel);
    }

    private function updatePinwheel(_arg_1:TimerEvent):void {
        this.quarterCircleMask.rotation = this.quarterCircleMask.rotation + 20;
    }
}
}
