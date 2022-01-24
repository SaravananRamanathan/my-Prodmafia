package com.company.assembleegameclient.screens {
import com.company.assembleegameclient.screens.charrects.CharacterRectList;

import flash.display.Shape;
import flash.display.Sprite;

import kabam.rotmg.core.model.PlayerModel;

public class CharacterList extends Sprite {

    public static const WIDTH:int = 760;

    public static const HEIGHT:int = 415;

    public static const TYPE_CHAR_SELECT:int = 1;

    public static const TYPE_GRAVE_SELECT:int = 2;

    public static const TYPE_VAULT_SELECT:int = 3;

    public function CharacterList(_arg_1:PlayerModel, _arg_2:int) {
        var _local4:* = null;
        var _local3:* = null;
        super();
        switch (_arg_2 - 1) {
            case 0:
                this.charRectList_ = new CharacterRectList();
                break;
            case 1:
                this.charRectList_ = new Graveyard(_arg_1);
        }
        addChild(this.charRectList_);
        if (height > 400) {
            _local4 = new Shape();
            _local3 = _local4.graphics;
            _local3.beginFill(0);
            _local3.drawRect(0, 0, 760, 415);
            _local3.endFill();
            addChild(_local4);
            mask = _local4;
        }
    }
    public var charRectList_:Sprite;

    public function setPos(_arg_1:Number):void {
        this.charRectList_.y = _arg_1;
    }
}
}
