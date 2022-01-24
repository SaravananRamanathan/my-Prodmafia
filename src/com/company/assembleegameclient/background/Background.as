package com.company.assembleegameclient.background {
import com.company.assembleegameclient.map.Camera;

import flash.display.Sprite;

public class Background extends Sprite {

    public static const NO_BACKGROUND:int = 0;

    public static const STAR_BACKGROUND:int = 1;

    public static const NEXUS_BACKGROUND:int = 2;

    public static const NUM_BACKGROUND:int = 3;

    public static function getBackground(_arg_1:int):Background {
        switch (int(_arg_1)) {
            default:
                return null;
            case 1:
                return new StarBackground();
            case 2:
                return new NexusBackground();
        }
    }

    public function Background() {
        super();
        visible = false;
    }

    public function draw(_arg_1:Camera, _arg_2:int):void {
    }
}
}
