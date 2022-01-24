package kabam.rotmg.death.view {
import com.company.assembleegameclient.ui.dialogs.Dialog;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.Event;
import flash.filters.ColorMatrixFilter;

import org.osflash.signals.Signal;

public class ResurrectionView extends Sprite {


    public const showDialog:Signal = new Signal(Sprite);

    public const closed:Signal = new Signal();

    private const POPUP_BACKGROUND_COLOR:Number = 0;

    private const POPUP_LINE_COLOR:Number = 3881787;

    private const POPUP_WIDTH:Number = 300;

    private const POPUP_HEIGHT:Number = 400;

    public function ResurrectionView() {
        super();
    }
    private var popup:Dialog;

    public function init(_arg_1:BitmapData):void {
        this.createBackground(_arg_1);
        this.createPopup();
    }

    public function createPopup():void {
        this.popup = new Dialog("ResurrectionView.YouDied", "ResurrectionView.deathText", "ResurrectionView.SaveMe", null, null);
        this.popup.addEventListener("dialogLeftButton", this.onButtonClick);
        this.showDialog.dispatch(this.popup);
    }

    private function createBackground(_arg_1:BitmapData):void {
        var _local3:* = null;
        var _local2:* = [0.33, 0.33, 0.33, 0, 0, 0.33, 0.33, 0.33, 0, 0, 0.33, 0.33, 0.33, 0, 0, 0.33, 0.33, 0.33, 1, 0];
        var _local4:ColorMatrixFilter = new ColorMatrixFilter(_local2);
        _local3 = new Bitmap(_arg_1);
        _local3.filters = [_local4];
        addChild(_local3);
    }

    private function onButtonClick(_arg_1:Event):void {
        this.closed.dispatch();
    }
}
}
