package com.company.assembleegameclient.sound {

import com.company.assembleegameclient.parameters.Parameters;
import flash.media.SoundTransform;

public class SFX {

    public function SFX() {
        super();
    }

    public static function load():void {
        var sfxTrans_:flash.media.SoundTransform = new SoundTransform(Parameters.data.playSFX ? 1 : 0);
    }

    public static function setPlaySFX(toggle: Boolean):void {
        Parameters.data.playSFX = toggle;
        Parameters.save();
        SoundEffectLibrary.updateTransform();
    }

    public static function setSFXVolume(volume: Number):void {
        Parameters.data.SFXVolume = volume;
        Parameters.save();
        SoundEffectLibrary.updateVolume(volume);
    }

    public static function setPlayCustomSFX(param1:Boolean) : void
    {
        Parameters.data.customSounds = param1;
        Parameters.save();
        SoundEffectLibrary.updateCustomTransform();
    }

    public static function setCustomSFXVolume(param1:Number) : void
    {
        Parameters.data.customVolume = param1;
        Parameters.save();
        SoundEffectLibrary.updateCustomVolume(param1);
    }
}
}
