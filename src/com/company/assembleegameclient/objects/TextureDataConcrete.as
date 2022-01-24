package com.company.assembleegameclient.objects {
import com.company.assembleegameclient.appengine.RemoteTexture;
import com.company.assembleegameclient.objects.particles.EffectProperties;
import com.company.assembleegameclient.util.AnimatedChars;
import com.company.assembleegameclient.util.AssetLoader;
import com.company.util.AssetLibrary;

import flash.display.BitmapData;
import flash.utils.Dictionary;

import kabam.rotmg.application.api.ApplicationSetup;
import kabam.rotmg.core.StaticInjectorContext;

public class TextureDataConcrete extends TextureData {

    public static var remoteTexturesUsed:Boolean = false;

    public function TextureDataConcrete(_arg_1:XML) {
        var _local2:* = null;
        super();
        this.isUsingLocalTextures = this.getWhetherToUseLocalTextures();
        if ("Texture" in _arg_1) {
            this.parse(XML(_arg_1.Texture), String(_arg_1.@id));
        } else if ("AnimatedTexture" in _arg_1) {
            this.parse(XML(_arg_1.AnimatedTexture), String(_arg_1.@id));
        } else if ("RemoteTexture" in _arg_1) {
            this.parse(XML(_arg_1.RemoteTexture));
        } else if ("RandomTexture" in _arg_1) {
            this.parse(XML(_arg_1.RandomTexture), String(_arg_1.@id));
        } else {
            this.parse(_arg_1);
        }
        var _local4:int = 0;
        var _local3:* = _arg_1.AltTexture;
        for each(_local2 in _arg_1.AltTexture) {
            this.parse(_local2);
        }
        if ("Mask" in _arg_1) {
            this.parse(XML(_arg_1.Mask));
        }
        if ("Effect" in _arg_1) {
            this.parse(XML(_arg_1.Effect));
        }
    }
    private var isUsingLocalTextures:Boolean;

    override public function getTexture(_arg_1:int = 0):BitmapData {
        if (randomTextureData_ == null) {
            return texture_;
        }
        var _local2:TextureData = randomTextureData_[_arg_1 % randomTextureData_.length];
        return _local2.getTexture(_arg_1);
    }

    override public function getAltTextureData(_arg_1:int):TextureData {
        if (altTextures_ == null) {
            return null;
        }
        return altTextures_[_arg_1];
    }

    private function getWhetherToUseLocalTextures():Boolean {
        var _local1:ApplicationSetup = StaticInjectorContext.getInjector().getInstance(ApplicationSetup);
        return _local1.useLocalTextures();
    }

    private function parse(_arg_1:XML, _arg_2:String = ""):void {
        var _local6:* = null;
        var _local4:* = null;
        var _local5:* = null;
        var _local3:* = _arg_1;
        var _local7:* = _arg_2;
        var _local9:* = _local3.name().toString();
        switch (_local9) {
            case "Texture":
                texture_ = AssetLibrary.getImageFromSet(_local3.File, _local3.Index);
                return;
            case "Mask":
                mask_ = AssetLibrary.getImageFromSet(_local3.File, _local3.Index);
                return;
            case "Effect":
                effectProps_ = new EffectProperties(_local3);
                return;
            case "AnimatedTexture":
                animatedChar_ = AnimatedChars.getAnimatedChar(_local3.File, _local3.Index);
                _local6 = animatedChar_.imageFromAngle(0, 0, 0);
                texture_ = _local6.image_;
                mask_ = _local6.mask_;
                return;
            case "RemoteTexture":
                texture_ = AssetLibrary.getImageFromSet("lofiObj3", 255);
                if (this.isUsingLocalTextures) {
                    _local4 = new RemoteTexture(_local3.Id, _local3.Instance, this.onRemoteTexture);
                    _local4.run();
                    if (!AssetLoader.currentXmlIsTesting) {
                        remoteTexturesUsed = true;
                    }
                }
                remoteTextureDir_ = "Right" in _local3 ? 0 : 2;
                return;
            case "RandomTexture":
                randomTextureData_ = new Vector.<TextureData>();
                _local9 = 0;
                var _local8:* = _local3.children();
                for each(_local5 in _local3.children()) {
                    randomTextureData_.push(new TextureDataConcrete(_local5));
                }
                return;
            case "AltTexture":
                if (altTextures_ == null) {
                    altTextures_ = new Dictionary();
                }
                altTextures_[int(_local3.@id)] = new TextureDataConcrete(_local3);
                return;
            default:
                return;
        }
    }

    private function onRemoteTexture(_arg_1:BitmapData):void {
        if (_arg_1) {
            if (_arg_1.width > 16) {
                AnimatedChars.add("remoteTexture", _arg_1, null, _arg_1.width / 7, _arg_1.height, _arg_1.width, _arg_1.height, remoteTextureDir_);
                animatedChar_ = AnimatedChars.getAnimatedChar("remoteTexture", 0);
                texture_ = animatedChar_.imageFromAngle(0, 0, 0).image_;
            } else {
                texture_ = _arg_1;
            }
        }
    }
}
}
