package com.company.assembleegameclient.sound {
import com.company.assembleegameclient.parameters.Parameters;

import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.media.SoundTransform;
import flash.net.URLRequest;
import flash.utils.Dictionary;

public class SoundEffectLibrary {

    public static const SOUND_URL = "https://abrn.github.io";
    public static var nameMap_:Dictionary = new Dictionary();
    private static var urlBase:String;
    private static var activeSfxList_:Dictionary = new Dictionary(true);
    private static var activeCustomSfxList_:Dictionary = new Dictionary(true);

    public function SoundEffectLibrary() {
        super();
    }

    public static function load(soundName: String):Sound {
        var soundObject:* = nameMap_[soundName] || makeSound(soundName);
        nameMap_[soundName] = soundObject;
        return soundObject;
    }

    public static function makeSound(soundName: String):Sound {
        var soundObject:Sound = new Sound();
        soundObject.addEventListener("ioError", onIOError);
        soundObject.load(makeSoundRequest(soundName));
        return soundObject;
    }

    public static function play(soundName: String, volumeMultiplier: Number = 1, isFX: Boolean = true):void {
        if (!Parameters.data.playSFX && isFX || !isFX && !Parameters.data.playPewPew) return;

        var volTransform: * = null;
        var soundObject: * = null;
        var sound: Sound = load(soundName);
        var totalVolume: Number = Parameters.data.SFXVolume * volumeMultiplier;
        try {
            volTransform = new SoundTransform(totalVolume);
            soundObject = sound.play(0, 0, volTransform);
            soundObject.addEventListener("soundComplete", onSoundComplete, false, 0, true);
            activeSfxList_[soundObject] = totalVolume;

        } catch (error: Error) {
            trace('Could not play sound ' + soundName + ' with error: ' + error.message);
        }
    }

    public static function playCustomSFX(soundName: String, volumeMultiplier: Number = 1) : void
    {
        var soundVolume: Number = NaN;
        var soundTransform:* = null;
        var soundPlayer:* = null;
        var soundObject:Sound = load(soundName);
        if(!soundObject) {
            trace('Couldn\'t find custom sound object ' + soundName);
            return;
        }

        var totalVolume:Number = Parameters.data.customVolume * volumeMultiplier;
        soundVolume = Parameters.data.customSounds ? Number(totalVolume) : 0;
        if(isNaN(soundVolume)) {
            return;
        }

        try {
            soundTransform = new SoundTransform(soundVolume);
            soundPlayer = soundObject.play(0,0,soundTransform);

            if(soundPlayer == null) {
                return;
            }
            soundPlayer.addEventListener("soundComplete", onCustomSoundComplete, false, 0, true);
            activeCustomSfxList_[soundPlayer] = totalVolume;
        } catch(error: Error) {
            trace('Could not play custom sound ' + soundName + ' with error: ' + error.message);
        }
    }

    public static function updateVolume(volume: Number):void {
        var soundObject:* = null;
        var soundTransform:* = null;
        for each (soundObject in activeSfxList_) {
            activeSfxList_[soundObject] = volume;
            soundTransform = soundObject.soundTransform;
            soundTransform.volume = Parameters.data.playSFX ? activeSfxList_[soundObject] : 0;
            soundObject.soundTransform = soundTransform;
        }
    }

    public static function updateCustomVolume(volume: Number):void {
        var soundObject:* = null;
        var soundTransform:* = null;
        for each (soundObject in activeCustomSfxList_) {
            activeCustomSfxList_[soundObject] = volume;
            soundTransform = soundObject.soundTransform;
            soundTransform.volume = Parameters.data.playSFX ? activeCustomSfxList_[soundObject] : 0;
            soundObject.soundTransform = soundTransform;
        }
    }

    public static function updateTransform():void {
        var soundObject:* = null;
        var soundTransform:* = null;
        for each (soundObject in activeSfxList_) {
            soundTransform = soundObject.soundTransform;
            soundTransform.volume = Parameters.data.playSFX ? activeSfxList_[soundObject] : 0;
            soundObject.soundTransform = soundTransform;
        }
    }

    public static function updateCustomTransform():void {
        var soundObject:* = null;
        var soundTransform:* = null;
        for each (soundObject in activeCustomSfxList_) {
            soundTransform = soundObject.soundTransform;
            soundTransform.volume = Parameters.data.playSFX ? activeCustomSfxList_[soundObject] : 0;
            soundObject.soundTransform = soundTransform;
        }
    }

    private static function makeSoundRequest(soundName: String):URLRequest {
        urlBase = urlBase || SOUND_URL;
        var soundURL: String = "{URLBASE}/prodmafia-assets/sfx/{NAME}.mp3".replace("{URLBASE}", urlBase).replace("{NAME}", soundName);
        return new URLRequest(soundURL);
    }

    private static function onSoundComplete(event: Event):void {
        var channel: SoundChannel = event.target as SoundChannel;
    }

    private static function onCustomSoundComplete(event: Event):void {
        var channel: SoundChannel = event.target as SoundChannel;
    }

    public static function onIOError(event: IOErrorEvent):void {
    }
}
}
