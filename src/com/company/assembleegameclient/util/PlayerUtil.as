package com.company.assembleegameclient.util {
import com.company.assembleegameclient.objects.Player;

public class PlayerUtil {


    public static function getPlayerNameColor(_arg_1:Player):Number {
        if (_arg_1.isFellowGuild_) {
            return 10944349;
        }
        if (_arg_1.hasSupporterFeature(2)) {
            return 0xcc66ff;
        }
        if (_arg_1.nameChosen_) {
            return 16572160;
        }
        return 0xffffff;
    }

    public function PlayerUtil() {
        super();
    }
}
}
