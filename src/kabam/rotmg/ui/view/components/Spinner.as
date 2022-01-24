package kabam.rotmg.ui.view.components {
import com.company.assembleegameclient.parameters.Parameters;

import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.Event;
import flash.utils.getTimer;

import kabam.rotmg.assets.EmbeddedAssets;

public class Spinner extends Sprite {


    public const graphic:DisplayObject = new EmbeddedAssets.StarburstSpinner();

    public function Spinner() {
        super();
        this.secondsElapsed = 0;
        this.defaultConfig();
        this.addGraphic();
        addEventListener("enterFrame", this.onEnterFrame);
        addEventListener("removedFromStage", this.onRemoved);
    }
    public var degreesPerSecond:Number;
    private var secondsElapsed:Number;
    private var previousSeconds:Number;

    private function defaultConfig():void {
        this.degreesPerSecond = 50;
    }

    private function addGraphic():void {
        addChild(this.graphic);
        this.graphic.x = -1 * width / 2;
        this.graphic.y = -1 * height / 2;
    }

    private function updateTimeElapsed():void {
        var _local1:Number = getTimer() / 1000;
        if (this.previousSeconds) {
            this.secondsElapsed = this.secondsElapsed + (_local1 - this.previousSeconds);
        }
        this.previousSeconds = _local1;
    }

    private function onRemoved(_arg_1:Event):void {
        removeEventListener("removedFromStage", this.onRemoved);
        removeEventListener("enterFrame", this.onEnterFrame);
    }

    private function onEnterFrame(_arg_1:Event):void {
        this.updateTimeElapsed();
        rotation = this.degreesPerSecond * this.secondsElapsed % 360;
    }
}
}
