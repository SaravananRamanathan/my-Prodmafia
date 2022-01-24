package com.company.assembleegameclient.appengine {
import com.company.assembleegameclient.objects.ObjectLibrary;
import com.company.assembleegameclient.objects.Player;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.util.AnimatedChar;
import com.company.assembleegameclient.util.AnimatedChars;
import com.company.assembleegameclient.util.MaskedImage;
import com.company.assembleegameclient.util.TextureRedrawer;
import com.company.assembleegameclient.util.redrawers.GlowRedrawer;
import com.company.util.CachingColorTransformer;

import flash.display.BitmapData;
import flash.geom.ColorTransform;

import io.decagames.rotmg.pets.data.PetsModel;
import io.decagames.rotmg.pets.data.vo.PetVO;

import kabam.rotmg.assets.services.CharacterFactory;
import kabam.rotmg.classes.model.CharacterClass;
import kabam.rotmg.classes.model.CharacterSkin;
import kabam.rotmg.classes.model.ClassesModel;
import kabam.rotmg.core.StaticInjectorContext;

import org.swiftsuspenders.Injector;

public class SavedCharacter {


    public static function getImage(_arg_1:SavedCharacter, _arg_2:XML, _arg_3:int, _arg_4:int, _arg_5:Number, _arg_6:Boolean, _arg_7:Boolean):BitmapData {
        var _local9:AnimatedChar = AnimatedChars.getAnimatedChar(_arg_2.AnimatedTexture.File, _arg_2.AnimatedTexture.Index);
        var _local10:MaskedImage = _local9.imageFromDir(_arg_3, _arg_4, _arg_5);
        var _local8:int = _arg_1 != null ? _arg_1.tex1() : 0;
        var _local11:int = _arg_1 != null ? _arg_1.tex2() : 0;
        var _local12:BitmapData = TextureRedrawer.resize(_local10.image_, _local10.mask_, 100, false, _local8, _local11);
        _local12 = GlowRedrawer.outlineGlow(_local12, 0);
        if (!_arg_6) {
            _local12 = CachingColorTransformer.transformBitmapData(_local12, new ColorTransform(0, 0, 0, 0.5, 0, 0, 0, 0));
        } else if (!_arg_7) {
            _local12 = CachingColorTransformer.transformBitmapData(_local12, new ColorTransform(0.75, 0.75, 0.75, 1, 0, 0, 0, 0));
        }
        return _local12;
    }

    public static function compare(_arg_1:SavedCharacter, _arg_2:SavedCharacter):Number {
        var _local4:Number = !Parameters.data.charIdUseMap.hasOwnProperty(_arg_1.charId()) ? 0 : Parameters.data.charIdUseMap[_arg_1.charId()];
        var _local3:Number = !Parameters.data.charIdUseMap.hasOwnProperty(_arg_2.charId()) ? 0 : Parameters.data.charIdUseMap[_arg_2.charId()];
        if (_local4 != _local3) {
            return _local3 - _local4;
        }
        return _arg_2.xp() - _arg_1.xp();
    }

    public function SavedCharacter(_arg_1:XML, _arg_2:String) {
        var _local5:* = null;
        var _local4:int = 0;
        var _local3:* = null;
        super();
        this.charXML_ = _arg_1;
        this.name_ = _arg_2;
        if (this.charXML_.hasOwnProperty("Pet")) {
            _local5 = new XML(this.charXML_.Pet);
            _local4 = _local5.@instanceId;
            _local3 = StaticInjectorContext.getInjector().getInstance(PetsModel).getPetVO(_local4);
            _local3.apply(_local5);
            this.setPetVO(_local3);
        }
    }
    public var charXML_:XML;
    public var name_:String = null;
    private var pet:PetVO;

    public function charId():int {
        return int(this.charXML_.@id);
    }

    public function fameBonus():int {
        var _local3:int = 0;
        var _local5:int = 0;
        var _local4:* = null;
        var _local2:int = 0;
        var _local1:Player = Player.fromPlayerXML("", this.charXML_);
        _local3 = 0;
        while (_local3 < 4) {
            if (_local1.equipment_ && _local1.equipment_.length > _local3) {
                _local5 = _local1.equipment_[_local3];
                if (_local5 != -1) {
                    _local4 = ObjectLibrary.xmlLibrary_[_local5];
                    if (_local4 && "FameBonus" in _local4) {
                        _local2 = _local2 + _local4.FameBonus;
                    }
                }
            }
            _local3++;
        }
        return _local2;
    }

    public function name():String {
        return this.name_;
    }

    public function objectType():int {
        return this.charXML_.ObjectType;
    }

    public function skinType():int {
        return this.charXML_.Texture;
    }

    public function level():int {
        return this.charXML_.Level;
    }

    public function tex1():int {
        return this.charXML_.Tex1;
    }

    public function tex2():int {
        return this.charXML_.Tex2;
    }

    public function xp():int {
        return this.charXML_.Exp;
    }

    public function fame():int {
        return this.charXML_.CurrentFame;
    }

    public function hp():int {
        return this.charXML_.MaxHitPoints;
    }

    public function mp():int {
        return this.charXML_.MaxMagicPoints;
    }

    public function att():int {
        return this.charXML_.Attack;
    }

    public function def():int {
        return this.charXML_.Defense;
    }

    public function spd():int {
        return this.charXML_.Speed;
    }

    public function dex():int {
        return this.charXML_.Dexterity;
    }

    public function vit():int {
        return this.charXML_.HpRegen;
    }

    public function wis():int {
        return this.charXML_.MpRegen;
    }

    public function displayId():String {
        return ObjectLibrary.typeToDisplayId_[this.objectType()];
    }

    public function getIcon(_arg_1:int = 100):BitmapData {
        var _local2:Injector = StaticInjectorContext.getInjector();
        var _local6:ClassesModel = _local2.getInstance(ClassesModel);
        var _local3:CharacterFactory = _local2.getInstance(CharacterFactory);
        var _local7:CharacterClass = _local6.getCharacterClass(this.objectType());
        var _local5:CharacterSkin = _local7.skins.getSkin(this.skinType()) || _local7.skins.getDefaultSkin();
        var _local4:BitmapData = _local3.makeIcon(_local5.template, _arg_1, this.tex1(), this.tex2());
        return _local4;
    }

    public function bornOn():String {
        if (!("CreationDate" in this.charXML_)) {
            return "Unknown";
        }
        return this.charXML_.CreationDate;
    }

    public function getPetVO():PetVO {
        return this.pet;
    }

    public function setPetVO(_arg_1:PetVO):void {
        this.pet = _arg_1;
    }
}
}
