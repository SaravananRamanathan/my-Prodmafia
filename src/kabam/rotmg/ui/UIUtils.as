package kabam.rotmg.ui {
import flash.display.Sprite;

public class UIUtils {

    private static const NOTIFICATION_BACKGROUND_WIDTH:Number = 95;

    public static const NOTIFICATION_BACKGROUND_HEIGHT:Number = 25;

    private static const NOTIFICATION_BACKGROUND_ALPHA:Number = 0.4;

    private static const NOTIFICATION_BACKGROUND_COLOR:Number = 0;

    public static const NOTIFICATION_SPACE:uint = 28;

    public static var SHOW_EXPERIMENTAL_MENU:Boolean = true;

    public static function makeStaticHUDBackground():Sprite {
        return makeHUDBackground(95, 25);
    }

    public static function makeHUDBackground(_arg_1:Number, _arg_2:Number):Sprite {
        var _local3:Sprite = new Sprite();
        return drawHUDBackground(_local3, _arg_1, _arg_2);
    }

    public static function toggleQuality(_arg_1:Boolean):void {
        if (WebMain.STAGE != null) {
            WebMain.STAGE.quality = !!_arg_1 ? "high" : "low";
        }
    }

    private static function drawHUDBackground(_arg_1:Sprite, _arg_2:Number, _arg_3:Number):Sprite {
        _arg_1.graphics.beginFill(0, 0.4);
        _arg_1.graphics.drawRoundRect(0, 0, _arg_2, _arg_3, 12, 12);
        _arg_1.graphics.endFill();
        return _arg_1;
    }

    public function UIUtils() {
        super();
    }
}
}
