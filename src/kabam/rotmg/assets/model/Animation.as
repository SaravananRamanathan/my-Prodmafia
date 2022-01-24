package kabam.rotmg.assets.model {
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.TimerEvent;
import flash.utils.Timer;

public class Animation extends Sprite {


    private const DEFAULT_SPEED:int = 200;

    private const bitmap:Bitmap = makeBitmap();

    private const frames:Vector.<BitmapData> = new Vector.<BitmapData>(0);

    private const timer:Timer = makeTimer();

    public function Animation() {
        super();
    }
    private var started:Boolean;
    private var index:int;
    private var count:uint;
    private var disposed:Boolean;

    public function getSpeed():int {
        return this.timer.delay;
    }

    public function setSpeed(_arg_1:int):void {
        this.timer.delay = _arg_1;
    }

    public function setFrames(...rest):void {
        var _local2:* = null;
        this.frames.length = 0;
        this.index = 0;
        var _local4:int = 0;
        var _local3:* = rest;
        for each(_local2 in rest) {
            this.count = this.frames.push(_local2);
        }
        if (this.started) {
            this.start();
        } else {
            this.iterate();
        }
    }

    public function addFrame(_arg_1:BitmapData):void {
        this.count = this.frames.push(_arg_1);
    }

    public function start():void {
        if (!this.started && this.count > 0) {
            this.timer.start();
            this.iterate();
        }
        this.started = true;
    }

    public function stop():void {
        this.started && this.timer.stop();
        this.started = false;
    }

    public function dispose():void {
        var _local1:* = null;
        this.disposed = true;
        this.stop();
        this.index = 0;
        this.count = 0;
        this.frames.length = 0;
        var _local3:int = 0;
        var _local2:* = this.frames;
        for each(_local1 in this.frames) {
            _local1.dispose();
        }
    }

    public function isStarted():Boolean {
        return this.started;
    }

    public function isDisposed():Boolean {
        return this.disposed;
    }

    private function makeBitmap():Bitmap {
        var _local1:Bitmap = new Bitmap();
        addChild(_local1);
        return _local1;
    }

    private function makeTimer():Timer {
        var _local1:Timer = new Timer(200);
        _local1.addEventListener("timer", this.iterate);
        return _local1;
    }

    private function iterate(_arg_1:TimerEvent = null):void {
        var _local2:* = this.index + 1;
        this.index++;
        this.index = _local2 % this.count;
        this.bitmap.bitmapData = this.frames[this.index];
    }
}
}
