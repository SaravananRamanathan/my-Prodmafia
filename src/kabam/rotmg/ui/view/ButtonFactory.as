package kabam.rotmg.ui.view {
import com.company.assembleegameclient.screens.TitleMenuOption;

import kabam.rotmg.text.model.TextKey;

public class ButtonFactory {
    public static const BUTTON_SIZE_LARGE:uint = 36;
    public static const BUTTON_SIZE_SMALL:uint = 22;
    private static const LEFT:String = "left";
    private static const CENTER:String = "center";
    private static const RIGHT:String = "right";

    public function ButtonFactory() {
        super();
    }

    public function getPlayButton():TitleMenuOption {
        return makeButton(TextKey.SCREENS_PLAY, BUTTON_SIZE_LARGE, CENTER, true);
    }

    public function getClassesButton():TitleMenuOption {
        return makeButton(TextKey.SCREENS_CLASSES, BUTTON_SIZE_SMALL, LEFT);
    }

    public function getMainButton():TitleMenuOption {
        return makeButton(TextKey.SCREENS_MAIN, BUTTON_SIZE_SMALL, RIGHT);
    }

    public function getDoneButton():TitleMenuOption {
        return makeButton(TextKey.DONE_TEXT, BUTTON_SIZE_LARGE, CENTER);
    }

    public function getAccountButton():TitleMenuOption {
        return makeButton(TextKey.SCREENS_ACCOUNT, BUTTON_SIZE_SMALL, LEFT);
    }

    public function getLegendsButton():TitleMenuOption {
        return makeButton(TextKey.SCREENS_LEGENDS, BUTTON_SIZE_SMALL, LEFT);
    }

    public function getServersButton():TitleMenuOption {
        return makeButton(TextKey.SCREENS_SERVERS, BUTTON_SIZE_SMALL, RIGHT);
    }

    public function getBackButton():TitleMenuOption {
        return makeButton(TextKey.SCREENS_BACK, BUTTON_SIZE_LARGE, CENTER);
    }

    private static function makeButton(text:String, size:int, autoSize:String,
                                pulse:Boolean = false, color:uint = 0xFFFFFF) : TitleMenuOption {
        var option:TitleMenuOption = new TitleMenuOption(text, size, pulse, color);
        option.setAutoSize(autoSize);
        option.setVerticalAlign("middle");
        return option;
    }
}
}