package com.company.assembleegameclient.util {
import com.company.assembleegameclient.map.GroundLibrary;
import com.company.assembleegameclient.map.RegionLibrary;
import com.company.assembleegameclient.objects.ObjectLibrary;
import com.company.assembleegameclient.objects.particles.ParticleLibrary;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.sound.IMusic;
import com.company.assembleegameclient.sound.SFX;
import com.company.assembleegameclient.sound.SoundEffectLibrary;
import com.company.assembleegameclient.ui.options.Options;
import com.company.util.AssetLibrary;

import flash.utils.getQualifiedClassName;
import flash.display.BitmapData;

import kabam.rotmg.assets.EmbeddedAssets;
import kabam.rotmg.assets.EmbeddedData;

public class AssetLoader {

    public static var atlases:Vector.<BitmapData> = new <BitmapData>[new EmbeddedAssets.ground().bitmapData,new EmbeddedAssets.chars().bitmapData,new EmbeddedAssets.charMasks().bitmapData,new EmbeddedAssets.mapObjs().bitmapData];

    public function AssetLoader() {
        music = new MusicProxy();
        super();
    }
    public var music:IMusic;

    public function load():void {
        this.addImages();
        this.addAnimatedCharacters();
        this.addSoundEffects();
        this.parseParticleEffects();
        this.parseGroundFiles();
        this.parseObjectFiles();
        this.parseRegionFiles();
        Parameters.load();
        Options.refreshCursor();
        this.music.load();
        SFX.load();
    }

    private static function addImages() : void
    {
        var spritePos:* = null;
        var spriteWidth:int = 0;
        var spriteHeight:int = 0;
        var currentSprite:* = null;
        var spriteIndex:int = 0;
        var spriteSheetName:* = null;
        var spriteDirection:int = 0;
        var counter:int;
        var spriteCounter:int = 0;
        var previousAtlasId:* = null;
        var atlasId:int = 0;
        var spritePosX:int = 0;
        var spriteSheetSize:int = 0;
        var spriteData:* = null;
        var spriteAction:int = 0;
        var _loc35_:int = 0;
        var _loc19_:int = 0;
        var _loc5_:int = 0;
        var _loc20_:* = null;
        var _loc13_:* = null;
        var _loc42_:* = null;
        var _loc17_:* = null;
        var _loc21_:* = null;
        var _loc12_:* = undefined;
        var _loc30_:int = 0;
        var _loc4_:* = undefined;
        var _loc40_:int = 0;
        var _loc39_:int = 0;
        var _loc8_:* = null;
        var _loc26_:* = undefined;
        var _loc27_:int = 0;
        var _loc46_:* = undefined;
        var _loc41_:int = 0;
        var _loc34_:int = 0;
        var _loc1_:int = 0;
        var _loc33_:int = 0;
        var _loc43_:* = null;
        var _loc36_:* = undefined;
        var spriteSheets:Dictionary = new Dictionary();
        var _loc31_:Dictionary = new Dictionary();
        var _loc45_:Dictionary = new Dictionary();
        var spriteSheet:Object = JSON.parse(String(new EmbeddedAssets.atlasData()));
        var spriteCount:int = spriteSheet.sprites.length;
        var allSpriteSheets:Vector.<String> = new Vector.<String>();
        var _loc10_:Vector.<String> = new Vector.<String>();
        counter = 0;
        while(counter < spriteCount)
        {
            currentSprite = spriteSheet.sprites[counter];
            spriteIndex = parseInt(currentSprite.index);
            spriteSheetName = currentSprite.spriteSheetName;
            atlasId = parseInt(currentSprite.atlasId);
            previousAtlasId = atlases[atlasId - 1];

            spritePos = currentSprite.position;
            spriteWidth = parseInt(spritePos.w);
            spriteHeight = parseInt(spritePos.h);
            spritePosX = parseInt(spritePos.x);
            var spritePosY:int = parseInt(spritePos.y);
            
            if(atlasId == 1)
            {
                spritePosX = spritePosX + 1;
                spritePosY = spritePosY + 1;
                spriteWidth = spriteWidth - 2;
                spriteHeight = spriteHeight - 2;
            }
            
            if(!(spriteSheetName in spriteSheets))
            {
                spriteSheets[spriteSheetName] = new Vector.<BitmapData>(0);
            }
            
            spriteSheetSize = spriteSheets[spriteSheetName].length;
            if(spriteSheetSize - 1 < spriteIndex)
            {
                spriteCounter = 0;
                while(spriteCounter < spriteIndex - spriteSheetSize + 1)
                {
                    spriteSheets[spriteSheetName].push(null);
                    spriteCounter++;
                }
            }
            
            spriteSheets[spriteSheetName][spriteIndex] = BitmapUtil.cropToBitmapData(previousAtlasId, spritePosX, spritePosY, spriteWidth, spriteHeight, atlasId == 1 ? 0 : spritePos.padding);
            counter++;
        }
        
        var animationCount:int = spriteSheet.animatedSprites.length;

        counter = 0;
        while(counter < animationCount)
        {
            currentSprite = spriteSheet.animatedSprites[counter];
            spriteIndex = parseInt(currentSprite.index);
            spriteSheetName = currentSprite.spriteSheetName;
            spriteData = currentSprite.spriteData;
            spriteAction = parseInt(currentSprite.action);

            spritePos = spriteData.position;
            spriteWidth = parseInt(spriteData.w);
            spriteHeight = parseInt(spriteData.h);
            spriteDirection = parseInt(currentSprite.direction);
            previousAtlasId = atlases[spriteData.atlasId - 1];

            if(allSpriteSheets.indexOf(spriteSheetName) == -1 && spriteDirection == 0)
            {
                allSpriteSheets.push(spriteSheetName);
            }

            if(allSpriteSheets.indexOf(spriteSheetName) != -1 && spriteDirection != 0)
            {
                allSpriteSheets.splice(allSpriteSheets.indexOf(spriteSheetName),1);
            }

            if(_loc10_.indexOf(spriteSheetName) == -1 && spriteDirection == 2)
            {
                _loc10_.push(spriteSheetName);
            }

            if(_loc10_.indexOf(spriteSheetName) != -1 && spriteDirection != 2)
            {
                _loc10_.splice(_loc10_.indexOf(spriteSheetName),1);
            }

            if(!(spriteSheetName in _loc31_))
            {
                _loc31_[spriteSheetName] = new Vector.<Vector.<Vector.<Vector.<MaskedImage>>>>(0);
            }
            if(!(spriteSheetName in _loc45_))
            {
                _loc45_[spriteSheetName] = new Vector.<int>(0);
            }
            _loc35_ = _loc31_[spriteSheetName].length;
            if(_loc35_ - 1 < spriteIndex)
            {
                spriteCounter = 0;
                while(spriteCounter < spriteIndex - _loc35_ + 1)
                {
                    _loc31_[spriteSheetName].push(new Vector.<Vector.<Vector.<MaskedImage>>>(0));
                    _loc31_[spriteSheetName][_loc35_ + spriteCounter].push(new <Vector.<MaskedImage>>[new Vector.<MaskedImage>(0),new Vector.<MaskedImage>(0),new Vector.<MaskedImage>(0)],new <Vector.<MaskedImage>>[new Vector.<MaskedImage>(0),new Vector.<MaskedImage>(0),new Vector.<MaskedImage>(0)],new <Vector.<MaskedImage>>[new Vector.<MaskedImage>(0),new Vector.<MaskedImage>(0),new Vector.<MaskedImage>(0)],new <Vector.<MaskedImage>>[new Vector.<MaskedImage>(0),new Vector.<MaskedImage>(0),new Vector.<MaskedImage>(0)]);
                    spriteCounter++;
                }
            }
            _loc19_ = _loc45_[spriteSheetName].length;
            if(_loc19_ - 1 < spriteIndex)
            {
                spriteCounter = 0;
                while(spriteCounter < spriteIndex - _loc19_ + 1)
                {
                    _loc45_[spriteSheetName].push(new <int>[-1,-1,-1]);
                    spriteCounter++;
                }
            }
            _loc5_ = spritePos.w == spritePos.h * 2 && spriteAction == 2?spriteData.padding:0;
            _loc20_ = null;
            _loc13_ = spriteData.maskPosition;
            if(_loc13_.h != 0 && _loc13_.w != 0)
            {
                _loc20_ = BitmapUtil.cropToBitmapData(atlases[2],_loc13_.x,_loc13_.y,_loc13_.w,_loc13_.h,0,_loc5_);
            }
            _loc42_ = BitmapUtil.cropToBitmapData(previousAtlasId,spritePos.x,spritePos.y,spritePos.w,spritePos.h,0,_loc5_);
            if(!_loc31_[spriteSheetName][spriteIndex][spriteDirection][spriteAction])
            {
                _loc31_[spriteSheetName][spriteIndex][spriteDirection][spriteAction] = new Vector.<MaskedImage>();
            }
            else
            {
                _loc31_[spriteSheetName][spriteIndex][spriteDirection][spriteAction].push(new MaskedImage(_loc42_,_loc20_));
            }
            if(spritePos.h > _loc45_[spriteSheetName][spriteIndex])
            {
                _loc45_[spriteSheetName][spriteIndex] = spritePos.h;
            }
            counter++;
        }
        
        var _loc49_:int = 0;
        var _loc48_:* = spriteSheets;
        for(_loc17_ in spriteSheets)
        {
            _loc21_ = new ImageSet();
            _loc12_ = spriteSheets[_loc17_];
            _loc30_ = _loc12_.length;
            counter = 0;
            while(counter < _loc30_)
            {
                _loc21_.add(_loc12_[counter]);
                counter++;
            }
            AssetLibrary.addImageSet(_loc17_ as String,_loc21_);
        }
        _loc17_ = null;
        var _loc51_:int = 0;
        var _loc50_:* = _loc31_;
        for(_loc17_ in _loc31_)
        {
            _loc4_ = _loc31_[_loc17_];
            _loc40_ = _loc4_.length;
            counter = 0;
            while(counter < _loc40_)
            {
                _loc39_ = _loc45_[_loc17_][counter];
                if(_loc39_ == 0 || _loc39_ == -1)
                {
                    _loc39_ = 32;
                }
                spriteDirection = 1;
                _loc8_ = new AnimatedChar(_loc39_,_loc39_);
                _loc26_ = _loc4_[counter];
                _loc27_ = _loc26_.length;
                spriteCounter = 0;
                while(spriteCounter < _loc27_)
                {
                    if(!(spriteCounter == 1 || spriteCounter != 0 && allSpriteSheets.indexOf(_loc17_ as String) != -1 || spriteCounter != 2 && _loc10_.indexOf(_loc17_ as String) != -1))
                    {
                        _loc46_ = _loc26_[spriteCounter];
                        _loc41_ = _loc46_.length;
                        _loc33_ = 1;
                        while(_loc33_ < _loc41_)
                        {
                            _loc1_ = 4 - _loc33_ - _loc46_[_loc33_].length;
                            if(_loc1_ > 0)
                            {
                                if(_loc46_[_loc33_].length > 0)
                                {
                                    _loc43_ = _loc46_[_loc33_][_loc46_[_loc33_].length - 1];
                                }
                                else if(_loc46_[_loc33_ == 1?2:1].length > 0)
                                {
                                    _loc43_ = _loc46_[_loc33_ == 1?2:1][_loc46_[_loc33_ == 1?2:1].length - 1];
                                }
                            }
                            _loc34_ = 0;
                            while(_loc34_ < _loc1_)
                            {
                                _loc46_[_loc33_].push(!!_loc43_?_loc43_:new MaskedImage(new BitmapData(_loc39_,_loc39_,true,0),null));
                                _loc34_++;
                            }
                            _loc8_.setImageVec(spriteCounter,_loc33_,_loc46_[_loc33_]);
                            if(allSpriteSheets.indexOf(_loc17_ as String) != -1)
                            {
                                _loc8_.setImageVec(2,_loc33_,_loc46_[_loc33_]);
                                _loc8_.setImageVec(3,_loc33_,_loc46_[_loc33_]);
                            }
                            if(_loc10_.indexOf(_loc17_ as String) != -1)
                            {
                                _loc8_.setImageVec(0,_loc33_,_loc46_[_loc33_]);
                                _loc8_.setImageVec(3,_loc33_,_loc46_[_loc33_]);
                            }
                            if(_loc46_[_loc33_].length == 1 && _loc33_ == 2)
                            {
                                _loc36_ = new Vector.<MaskedImage>(0);
                                _loc34_ = 0;
                                while(_loc34_ < 3)
                                {
                                    _loc36_.push(_loc46_[1][0]);
                                    _loc34_++;
                                }
                                _loc8_.setImageVec(spriteCounter,_loc33_,_loc36_);
                                if(allSpriteSheets.indexOf(_loc17_ as String) != -1)
                                {
                                    _loc34_ = 1;
                                    while(_loc34_ < 3)
                                    {
                                        _loc8_.setImageVec(2,_loc34_,_loc36_);
                                        _loc8_.setImageVec(3,_loc34_,_loc36_);
                                        _loc34_++;
                                    }
                                }
                                if(_loc10_.indexOf(_loc17_ as String) != -1)
                                {
                                    _loc34_ = 1;
                                    while(_loc34_ < 3)
                                    {
                                        _loc8_.setImageVec(0,_loc34_,_loc36_);
                                        _loc8_.setImageVec(3,_loc34_,_loc36_);
                                        _loc34_++;
                                    }
                                }
                            }
                            _loc33_++;
                        }
                    }
                    spriteCounter++;
                }
                AnimatedChars.add(_loc17_ as String,_loc8_);
                counter++;
            }
        }
        atlases.length = 0;
    }

    private function addSoundEffects():void {
        SoundEffectLibrary.load("button_click");
        SoundEffectLibrary.load("death_screen");
        SoundEffectLibrary.load("enter_realm");
        SoundEffectLibrary.load("error");
        SoundEffectLibrary.load("inventory_move_item");
        SoundEffectLibrary.load("level_up");
        SoundEffectLibrary.load("loot_appears");
        SoundEffectLibrary.load("no_mana");
        SoundEffectLibrary.load("use_key");
        SoundEffectLibrary.load("use_potion");
    }

    private function parseParticleEffects():void {
        var _local1:XML = XML(new EmbeddedAssets.particlesEmbed());
        ParticleLibrary.parseFromXML(_local1);
    }

    private function parseGroundFiles():void {
        var _local1:* = undefined;
        var _local3:int = 0;
        var _local2:* = EmbeddedData.groundFiles;
        for each(_local1 in EmbeddedData.groundFiles) {
            GroundLibrary.parseFromXML(XML(_local1));
        }
    }

    private function parseObjectFiles():void {
        var _local3:* = undefined;
        var _local2:int = 0;
        var _local1:int = 0;
        while (_local2 < 25) {
            ObjectLibrary.parseFromXML(XML(EmbeddedData.objectFiles[_local2]));
            _local2++;
        }
        while (_local1 < EmbeddedData.objectFiles.length) {
            ObjectLibrary.parseDungeonXML(getQualifiedClassName(EmbeddedData.objectFiles[_local1]), XML(EmbeddedData.objectFiles[_local1]));
            _local1++;
        }
        ObjectLibrary.parseFromXML(XML(EmbeddedData.objectFiles[_local2]));
    }

    private function parseRegionFiles():void {
        var _local1:* = undefined;
        var _local3:int = 0;
        var _local2:* = EmbeddedData.regionFiles;
        for each(_local1 in EmbeddedData.regionFiles) {
            RegionLibrary.parseFromXML(XML(_local1));
        }
    }


}
}
