package com.company.assembleegameclient.sound {
import com.company.assembleegameclient.parameters.Parameters;

import flash.media.Sound;
import flash.media.SoundChannel;
import flash.media.SoundTransform;
import flash.net.URLRequest;

public class Music {

    private static const MUSIC_URL:String = "https://abrn.github.io/prodmafia-assets/sfx/sorc.mp3";

    private static var music_:Sound = null;

    private static var musicVolumeTransform:SoundTransform;

    private static var musicChannel_:SoundChannel = null;

    private static var volume:Number = 0.3;

    public static function load():void {
        volume = Parameters.data.musicVolume;
        musicVolumeTransform = new SoundTransform(Parameters.data.playMusic ? volume : 0);
        if (Parameters.data.playMusic) {
            if (!music_) {
                music_ = new Sound();
                music_.load(new URLRequest(MUSIC_URL));
            }
            musicChannel_ = music_.play(0, 0x7fffffff, musicVolumeTransform);
        }
    }

    public static function setPlayMusic(toggle: Boolean):void {
        Parameters.data.playMusic = toggle;
        Parameters.save();
        if (Parameters.data.playMusic) {
            if (!music_) {
                music_ = new Sound();
                music_.load(new URLRequest(MUSIC_URL));
            }
            musicChannel_ = music_.play(0, 0x7fffffff, musicVolumeTransform);
        } else {
            musicChannel_.stop();
            music_.close();
        }
        musicVolumeTransform.volume = volume;
        musicChannel_.soundTransform = musicVolumeTransform;
    }

    public static function setMusicVolume(volume: Number):void {
        Parameters.data.musicVolume = volume;
        Parameters.save();
        if (!Parameters.data.playMusic) {
            return;
        }
        if (musicVolumeTransform) {
            musicVolumeTransform.volume = volume;
        } else {
            musicVolumeTransform = new SoundTransform(volume);
        }
        musicChannel_.soundTransform = musicVolumeTransform;
    }

    public function Music() {
        super();
    }
}
}
