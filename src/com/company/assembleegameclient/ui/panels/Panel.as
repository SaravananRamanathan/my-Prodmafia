package com.company.assembleegameclient.ui.panels {
import com.company.assembleegameclient.game.AGameSprite;

import flash.display.Sprite;

public class Panel extends Sprite {

    public static const WIDTH:int = 188;

    public static const HEIGHT:int = 84;

    public function Panel(_arg_1:AGameSprite) {
        super();
        this.gs_ = _arg_1;
    }
    public var gs_:AGameSprite;

    public function draw():void {
    }
}
}
