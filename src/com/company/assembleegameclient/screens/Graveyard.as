package com.company.assembleegameclient.screens {
import flash.display.Sprite;

import kabam.rotmg.core.model.PlayerModel;

public class Graveyard extends Sprite {


    public function Graveyard(_arg_1:PlayerModel) {
        lines_ = new Vector.<GraveyardLine>();
        var _local2:* = null;
        super();
        var _local4:int = 0;
        var _local3:* = _arg_1.getNews();
        for each(_local2 in _arg_1.getNews()) {
            if (_local2.isCharDeath()) {
                this.addLine(new GraveyardLine(_local2.getIcon(), _local2.title_, _local2.tagline_, _local2.link_, _local2.date_, _arg_1.getAccountId()));
                this.hasCharacters_ = true;
            }
        }
    }
    private var lines_:Vector.<GraveyardLine>;
    private var hasCharacters_:Boolean = false;

    public function hasCharacters():Boolean {
        return this.hasCharacters_;
    }

    public function addLine(_arg_1:GraveyardLine):void {
        _arg_1.y = 4 + this.lines_.length * 56;
        this.lines_.push(_arg_1);
        addChild(_arg_1);
    }
}
}
