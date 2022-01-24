package com.company.assembleegameclient.objects {
import com.company.assembleegameclient.objects.animation.AnimationsData;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.util.ConditionEffect;
import com.company.assembleegameclient.util.TextureRedrawer;
import com.company.assembleegameclient.util.redrawers.GlowRedrawer;
import com.company.util.AssetLibrary;
import com.company.util.ConversionUtil;
import com.company.util.PointUtil;

import flash.display.BitmapData;
import flash.geom.Matrix;
import flash.utils.Dictionary;
import flash.utils.getDefinitionByName;

import kabam.rotmg.assets.EmbeddedData;

public class ObjectLibrary {

    public static const IMAGE_SET_NAME:String = "lofiObj3";

    public static const IMAGE_ID:int = 255;

    public static const propsLibrary_:Dictionary = new Dictionary();

    public static const xmlLibrary_:Dictionary = new Dictionary();

    public static const xmlPatchLibrary_:Dictionary = new Dictionary();

    public static const setLibrary_:Dictionary = new Dictionary();

    public static const idToType_:Dictionary = new Dictionary();

    public static const typeToDisplayId_:Dictionary = new Dictionary();

    public static const typeToTextureData_:Dictionary = new Dictionary();

    public static const typeToTopTextureData_:Dictionary = new Dictionary();

    public static const typeToAnimationsData_:Dictionary = new Dictionary();

    public static const petXMLDataLibrary_:Dictionary = new Dictionary();

    public static const skinSetXMLDataLibrary_:Dictionary = new Dictionary();

    public static const dungeonToPortalTextureData_:Dictionary = new Dictionary();

    public static const petSkinIdToPetType_:Dictionary = new Dictionary();

    public static const dungeonsXMLLibrary_:Dictionary = new Dictionary(true);

    public static const ENEMY_FILTER_LIST:Vector.<String> = new <String>["None", "Hp", "Defense"];

    public static const TILE_FILTER_LIST:Vector.<String> = new <String>["ALL", "Walkable", "Unwalkable", "Slow", "Speed=1"];

    public static const defaultProps_:ObjectProperties = new ObjectProperties(null);

    public static const TYPE_MAP:Object = {
        "ArenaGuard": ArenaGuard,
        "ArenaPortal": ArenaPortal,
        "CaveWall": GameObject,
        "Character": Character,
        "CharacterChanger": CharacterChanger,
        "VaultContainer":VaultContainer,
        "VaultGiftContainer":VaultGiftContainer,
        "PremiumVaultContainer":PremiumVaultContainer,
        "ConnectedWall": GameObject,
        "Container": Container,
        "DoubleWall": DoubleWall,
        "GameObject": GameObject,
        "GuildBoard": GuildBoard,
        "GuildChronicle": GuildChronicle,
        "GuildHallPortal": GuildHallPortal,
        "GuildMerchant": GuildMerchant,
        "GuildRegister": GuildRegister,
        "Merchant": Merchant,
        "MoneyChanger": MoneyChanger,
        "MysteryBoxGround": MysteryBoxGround,
        "NameChanger": NameChanger,
        "ReskinVendor": ReskinVendor,
        "OneWayContainer": OneWayContainer,
        "Player": Player,
        "Portal": Portal,
        "Projectile": Projectile,
        "QuestRewards": QuestRewards,
        "DailyLoginRewards": DailyLoginRewards,
        "Sign": Sign,
        "SpiderWeb": GameObject,
        "Stalagmite": GameObject,
        "Wall": Wall,
        "Pet": Pet,
        "PetUpgrader": PetUpgrader,
        "YardUpgrader": YardUpgrader,
        "WallOfFame":WallOfFame
    };

    public static var textureDataFactory:TextureDataFactory = new TextureDataFactory();

    public static var playerChars_:Vector.<XML> = new Vector.<XML>();

    public static var hexTransforms_:Vector.<XML> = new Vector.<XML>();

    public static var playerClassAbbr_:Dictionary = new Dictionary();

    public static var itemIds_:Vector.<String> = new Vector.<String>();

    private static var currentDungeon:String = "";

    public static function parseDungeonXML(_arg_1:String, _arg_2:XML):void {
        var _local4:int = _arg_1.indexOf("_") + 1;
        var _local3:int = _arg_1.indexOf("CXML");
        if (_arg_1.indexOf("_ObjectsCXML") == -1 && _arg_1.indexOf("_StaticObjectsCXML") == -1) {
            if (_arg_1.indexOf("Objects") != -1) {
                _local3 = _arg_1.indexOf("ObjectsCXML");
            } else if (_arg_1.indexOf("Object") != -1) {
                _local3 = _arg_1.indexOf("ObjectCXML");
            }
        }
        currentDungeon = _arg_1.substr(_local4, _local3 - _local4);
        dungeonsXMLLibrary_[currentDungeon] = new Dictionary(true);
        parseFromXML(_arg_2, parseDungeonCallbak);
    }

    public static function parsePatchXML(_arg_1:XML, _arg_2:Function = null):void {
        var _local3:int = 0;
        var _local5:* = null;
        var _local4:* = null;
        var _local6:* = null;
        var _local7:* = null;
        var _local9:int = 0;
        var _local8:* = _arg_1.Object;
        for each(_local5 in _arg_1.Object) {
            _local4 = String(_local5.@id);
            _local6 = _local4;
            if (_local5.hasOwnProperty("DisplayId")) {
                _local6 = _local5.DisplayId;
            }
            _local3 = _local5.@type;
            _local7 = propsLibrary_[_local3];
            if (_local7 != null) {
                xmlPatchLibrary_[_local3] = _local5;
            }
        }
    }

    public static function parseFromXML(_arg_1:XML, _arg_2:Function = null):void {
        var _local8:int = 0;
        var _local6:Boolean = false;
        var _local4:int = 0;
        var _local7:* = null;
        var _local5:* = null;
        var _local9:* = null;
        var _local3:* = [29053, 29053, 29054, 29258, 29259, 29260, 29261, 29262, 29308, 29309, 29550, 29551, 2050, 2051, 2052, 2053, 6282];
        var _local11:int = 0;
        var _local10:* = _arg_1.Object;
        for each(_local7 in _arg_1.Object) {
            _local5 = String(_local7.@id);
            _local9 = _local5;
            if ("DisplayId" in _local7) {
                _local9 = _local7.DisplayId;
            }
            if ("Group" in _local7) {
                if (_local7.Group == "Hexable") {
                    hexTransforms_.push(_local7);
                }
            }
            _local8 = _local7.@type;
            if (_local3.indexOf(_local8) >= 0) {
                _local7.Class = "Character";
            }
            if ("PetBehavior" in _local7 || "PetAbility" in _local7) {
                petXMLDataLibrary_[_local8] = _local7;
            } else {
                propsLibrary_[_local8] = new ObjectProperties(_local7);
                xmlLibrary_[_local8] = _local7;
                idToType_[_local5] = _local8;
                typeToDisplayId_[_local8] = _local9;
                if (_arg_2) {
                    _arg_2(_local8, _local7);
                }
                if (_local7.Class == "Player") {
                    playerClassAbbr_[_local8] = String(_local7.@id).substr(0, 2);
                    _local6 = false;
                    _local4 = 0;
                    while (_local4 < playerChars_.length) {
                        if (int(playerChars_[_local4].@type) == _local8) {
                            playerChars_[_local4] = _local7;
                            _local6 = true;
                        }
                        _local4++;
                    }
                    if (!_local6) {
                        playerChars_.push(_local7);
                    }
                }
                typeToTextureData_[_local8] = textureDataFactory.create(_local7);
                if ("Top" in _local7) {
                    typeToTopTextureData_[_local8] = textureDataFactory.create(XML(_local7.Top));
                }
                if ("Animation" in _local7) {
                    typeToAnimationsData_[_local8] = new AnimationsData(_local7);
                }
                if ("IntergamePortal" in _local7 && "DungeonName" in _local7) {
                    dungeonToPortalTextureData_[_local7.DungeonName] = typeToTextureData_[_local8];
                }
                if (_local7.Class == "Pet" && "DefaultSkin" in _local7) {
                    petSkinIdToPetType_[_local7.DefaultSkin] = _local8;
                }
            }
        }
    }

    public static function getIdFromType(_arg_1:int):String {
        var _local2:XML = xmlLibrary_[_arg_1];
        if (_local2 == null) {
            return null;
        }
        return String(_local2.@id);
    }

    public static function getSetXMLFromType(_arg_1:int):XML {
        var _local3:int = 0;
        var _local2:* = null;
        if (setLibrary_[_arg_1] != undefined) {
            return setLibrary_[_arg_1];
        }
        var _local5:int = 0;
        var _local4:* = EmbeddedData.skinsEquipmentSetsXML.EquipmentSet;
        for each(_local2 in EmbeddedData.skinsEquipmentSetsXML.EquipmentSet) {
            _local3 = _local2.@type;
            setLibrary_[_local3] = _local2;
        }
        return setLibrary_[_arg_1];
    }

    public static function getPropsFromId(_arg_1:String):ObjectProperties {
        var _local2:int = idToType_[_arg_1];
        return propsLibrary_[_local2];
    }

    public static function getPropsFromType(_arg_1:int):ObjectProperties {
        return propsLibrary_[_arg_1];
    }

    public static function getXMLfromId(_arg_1:String):XML {
        var _local2:int = idToType_[_arg_1];
        return xmlLibrary_[_local2];
    }

    public static function getObjectFromType(_arg_1:int):GameObject {
        var _local5:* = null;
        var _local4:* = null;
        var _local2:* = null;
        var _local3:* = _arg_1;
        _local4 = xmlLibrary_[_local3];
        if (_local4) {
            _local5 = _local4.Class;
            _local2 = TYPE_MAP[_local5] || makeClass(_local5);
            return new _local2(_local4);
        }
        return null;
    }

    public static function getItemIcon(_arg_1:int):BitmapData {
        var _local4:int = 0;
        var _local8:int = 0;
        var _local10:* = null;
        var _local7:* = null;
        var _local3:* = null;
        var _local9:* = null;
        var _local2:* = null;
        var _local6:* = null;
        var _local5:Matrix = new Matrix();
        if (_arg_1 == -1) {
            _local10 = scaleBitmapData(AssetLibrary.getImageFromSet("lofiInterface", 7), 2);
            _local5.translate(4, 4);
            _local7 = new BitmapData(22, 22, true, 0);
            _local7.draw(_local10, _local5);
            return _local7;
        }
        _local3 = xmlLibrary_[_arg_1];
        _local9 = typeToTextureData_[_arg_1];
        _local2 = !!_local9 ? _local9.mask_ : null;
        _local4 = "Tex1" in _local3 ? _local3.Tex1 : 0;
        _local8 = "Tex2" in _local3 ? _local3.Tex2 : 0;
        _local6 = getTextureFromType(_arg_1);
        if (_local4 > 0 || _local8 > 0) {
            _local6 = TextureRedrawer.retextureNoSizeChange(_local6, _local2, _local4, _local8);
            _local5.scale(0.2, 0.2);
        }
        _local10 = scaleBitmapData(_local6, _local6.rect.width == 16 ? 1 : 2);
        _local5.translate(4, 4);
        _local7 = new BitmapData(22, 22, true, 0);
        _local7.draw(_local10, _local5);
        _local7 = GlowRedrawer.outlineGlow(_local7, 0);
        _local7.applyFilter(_local7, _local7.rect, PointUtil.ORIGIN, ConditionEffect.GLOW_FILTER);
        return _local7;
    }

    public static function scaleBitmapData(_arg_1:BitmapData, _arg_2:Number):BitmapData {
        _arg_2 = Math.abs(_arg_2);
        var _local6:BitmapData = new BitmapData(1, 1, true, 0);
        var _local4:Matrix = new Matrix();
        _local4.scale(_arg_2, _arg_2);
        _local6.draw(_arg_1, _local4);
        return _local6;
    }

    public static function getTextureFromType(_arg_1:int):BitmapData {
        var _local2:TextureData = typeToTextureData_[_arg_1];
        if (_local2 == null) {
            return null;
        }
        return _local2.getTexture();
    }

    public static function getBitmapData(_arg_1:int):BitmapData {
        var _local2:TextureData = typeToTextureData_[_arg_1];
        var _local3:BitmapData = !!_local2 ? _local2.getTexture() : null;
        if (_local3) {
            return _local3;
        }
        return AssetLibrary.getImageFromSet("lofiObj3", 255);
    }

    public static function getRedrawnTextureFromType(_arg_1:int, _arg_2:int, _arg_3:Boolean, _arg_4:Boolean = true, _arg_5:Number = 5):BitmapData {
        var _local8:BitmapData = getBitmapData(_arg_1);
        if (Parameters.itemTypes16.indexOf(_arg_1) != -1 || _local8.height == 16) {
            _arg_2 = _arg_2 * 0.5;
        }
        var _local10:TextureData = typeToTextureData_[_arg_1];
        return TextureRedrawer.redraw(_local8, _arg_2, _arg_3, 0, _arg_4, _arg_5);
    }

    public static function getSizeFromType(_arg_1:int):int {
        var _local2:XML = xmlLibrary_[_arg_1];
        if (!("Size" in _local2)) {
            return 100;
        }
        return _local2.Size;
    }

    public static function getSlotTypeFromType(_arg_1:int):int {
        var _local2:XML = xmlLibrary_[_arg_1];
        if (!("SlotType" in _local2)) {
            return -1;
        }
        return _local2.SlotType;
    }

    public static function isEquippableByPlayer(_arg_1:int, _arg_2:Player):Boolean {
        var _local3:int = 0;
        if (_arg_1 == -1) {
            return false;
        }
        var _local5:XML = xmlLibrary_[_arg_1];
        var _local4:int = _local5.SlotType.toString();
        while (_local3 < 4) {
            if (_arg_2.slotTypes_[_local3] == _local4) {
                return true;
            }
            _local3++;
        }
        return false;
    }

    public static function getMatchingSlotIndex(_arg_1:int, _arg_2:Player):int {
        var _local5:* = null;
        var _local4:int = 0;
        var _local3:int = 0;
        if (_arg_1 != -1) {
            _local5 = xmlLibrary_[_arg_1];
            _local4 = _local5.SlotType;
            _local3 = 0;
            while (_local3 < 4) {
                if (_arg_2.slotTypes_[_local3] == _local4) {
                    return _local3;
                }
                _local3++;
            }
        }
        return -1;
    }

    public static function isUsableByPlayer(_arg_1:int, _arg_2:Player):Boolean {
        var _local3:int = 0;
        if (_arg_2 == null || _arg_2.slotTypes_ == null) {
            return true;
        }
        var _local5:XML = xmlLibrary_[_arg_1];
        if (_local5 == null || !("SlotType" in _local5)) {
            return false;
        }
        var _local4:int = _local5.SlotType;
        if (_local4 == 10 || _local4 == 26) {
            return true;
        }
        _local3 = 0;
        while (_local3 < _arg_2.slotTypes_.length) {
            if (_arg_2.slotTypes_[_local3] == _local4) {
                return true;
            }
            _local3++;
        }
        return false;
    }

    public static function isSoulbound(_arg_1:int):Boolean {
        var _local2:XML = xmlLibrary_[_arg_1];
        return _local2 && "Soulbound" in _local2;
    }

    public static function isDropTradable(_arg_1:int):Boolean {
        var _local2:XML = xmlLibrary_[_arg_1];
        return _local2 && _local2.hasOwnProperty("DropTradable");
    }

    public static function usableBy(_arg_1:int):Vector.<String> {
        var _local5:* = undefined;
        var _local7:int = 0;
        var _local8:* = 0;
        var _local3:* = null;
        var _local2:XML = xmlLibrary_[_arg_1];
        if (_local2 == null || !("SlotType" in _local2)) {
            return null;
        }
        var _local6:int = _local2.SlotType;
        if (_local6 == 10 || _local6 == 9 || _local6 == 26) {
            return null;
        }
        var _local4:Vector.<String> = new Vector.<String>();
        var _local10:int = 0;
        var _local9:* = playerChars_;
        for each(_local3 in playerChars_) {
            _local5 = ConversionUtil.toIntVector(_local3.SlotTypes);
            _local8 = uint(_local5.length);
            _local7 = 0;
            while (_local7 < _local8) {
                if (_local5[_local7] == _local6) {
                    _local4.push(typeToDisplayId_[int(_local3.@type)]);
                    break;
                }
                _local7++;
            }
        }
        return _local4;
    }

    public static function playerMeetsRequirements(_arg_1:int, _arg_2:Player):Boolean {
        var _local3:* = null;
        if (_arg_2 == null) {
            return true;
        }
        var _local4:XML = xmlLibrary_[_arg_1];
        var _local6:int = 0;
        var _local5:* = _local4.EquipRequirement;
        for each(_local3 in _local4.EquipRequirement) {
            if (!playerMeetsRequirement(_local3, _arg_2)) {
                return false;
            }
        }
        return true;
    }

    public static function playerMeetsRequirement(_arg_1:XML, _arg_2:Player):Boolean {
        var _local3:int = 0;
        if (_arg_1.toString() == "Stat") {
            _local3 = _arg_1.@value;
            var _local4:int = _arg_1.@stat;
            switch (_local4) {
                case 0:
                    return _arg_2.maxHP_ >= _local3;
                case 3:
                    return _arg_2.maxMP_ >= _local3;
                case 7:
                    return _arg_2.level_ >= _local3;
                case 20:
                    return _arg_2.attack_ >= _local3;
                case 21:
                    return _arg_2.defense_ >= _local3;
                case 22:
                    return _arg_2.speed_ >= _local3;
                case 26:
                    return _arg_2.vitality_ >= _local3;
                case 27:
                    return _arg_2.wisdom >= _local3;
                case 28:
                    return _arg_2.dexterity_ >= _local3;
            }
        }
        return false;
    }

    public static function getPetDataXMLByType(_arg_1:int):XML {
        return petXMLDataLibrary_[_arg_1];
    }

    public static function searchItems(_arg_1:String):Vector.<int> {
        return new Vector.<int>();
    }

    private static function parseDungeonCallbak(_arg_1:int, _arg_2:XML):void {
        if (currentDungeon != "" && dungeonsXMLLibrary_[currentDungeon] != null) {
            dungeonsXMLLibrary_[currentDungeon][_arg_1] = _arg_2;
        }
    }

    private static function makeClass(_arg_1:String):Class {
        var _local2:String = "com.company.assembleegameclient.objects." + _arg_1;
        return getDefinitionByName(_local2) as Class;
    }

    public function ObjectLibrary() {
        super();
    }
}
}
