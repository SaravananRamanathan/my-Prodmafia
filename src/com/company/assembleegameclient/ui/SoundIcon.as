package com.company.assembleegameclient.ui {
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.sound.Music;
import com.company.assembleegameclient.sound.SFX;
import com.company.util.AssetLibrary;

import flash.display.Bitmap;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.filters.GlowFilter;

public class SoundIcon extends Sprite {


    public function SoundIcon() {
        bitmap_ = new Bitmap();
        super();
        addChild(this.bitmap_);
        this.bitmap_.scaleX = 2;
        this.bitmap_.scaleY = 2;
        this.setBitmap();
        addEventListener("click", this.onIconClick, false, 0, true);
        filters = [new GlowFilter(0, 1, 4, 4, 2, 1)];
    }
    private var bitmap_:Bitmap;

    private function setBitmap():void {
        this.bitmap_.bitmapData = Parameters.data.playMusic || Parameters.data.playSFX ? AssetLibrary.getImageFromSet("lofiInterfaceBig", 3) : AssetLibrary.getImageFromSet("lofiInterfaceBig", 4);
    }

    private function onIconClick(_arg_1:MouseEvent):void {
        var _local2:* = !(Parameters.data.playMusic || Parameters.data.playSFX);
        Music.setPlayMusic(_local2);
        SFX.setPlaySFX(_local2);
        Parameters.data.playPewPew = _local2;
        Parameters.save();
        this.setBitmap();
    }
}
}
