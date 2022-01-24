package com.company.assembleegameclient.parameters {
import com.company.assembleegameclient.game.events.ReconnectEvent;
import com.company.assembleegameclient.objects.GameObject;
import com.company.assembleegameclient.objects.ObjectLibrary;
import com.company.assembleegameclient.objects.ObjectProperties;
import com.company.assembleegameclient.objects.Player;
import com.company.assembleegameclient.objects.Portal;
import com.company.util.KeyCodes;
import com.company.util.MoreDateUtil;
import com.company.util.MoreStringUtil;

import flash.display.DisplayObject;
import flash.events.Event;
import flash.geom.Point;
import flash.net.SharedObject;
import flash.utils.ByteArray;
import flash.utils.Dictionary;

public class Parameters {
    public static const CLIENT_VERSION:String = "1.2.0.2.0";
    public static const PORT:int = 2050;
    public static const UNITY_LAUNCHER_VERSION:String = "2019.3.14f1";
    public static const UNITY_GAME_VERSION:String = "2019.4.9f1";
    public static const FELLOW_GUILD_COLOR:uint = 10944349;
    public static const NAME_CHOSEN_COLOR:uint = 16572160;
    public static const PLAYER_ROTATE_SPEED:Number = 0.003;
    public static const BREATH_THRESH:int = 20;
    public static const SERVER_CHAT_NAME:String = "";
    public static const CLIENT_CHAT_NAME:String = "*Client*";
    public static const ERROR_CHAT_NAME:String = "*Error*";
    public static const HELP_CHAT_NAME:String = "*Help*";
    public static const GUILD_CHAT_NAME:String = "*Guild*";
    public static const NAME_CHANGE_PRICE:int = 1000;
    public static const GUILD_CREATION_PRICE:int = 1000;
    public static const TUTORIAL_GAMEID:int = -1;
    public static const NEXUS_GAMEID:int = -2;
    public static const RANDOM_REALM_GAMEID:int = -3;
    public static const MAPTEST_GAMEID:int = -6;
    public static const MAX_SINK_LEVEL:Number = 18;
    public static const TERMS_OF_USE_URL:String = "http://legal.decagames.com/tos/";
    public static const PRIVACY_POLICY_URL:String = "http://legal.decagames.com/privacy/";
    public static const USER_GENERATED_CONTENT_TERMS:String = "/UGDTermsofUse.html";
    public static const RANDOM1:String = "5a4d2016bc16dc64883194ffd9";
    public static const RANDOM2:String = "c91d9eec420160730d825604e0";
    public static const RSA_PUBLIC_KEY:String = "-----BEGIN PUBLIC KEY-----\n" +
            "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDCKFctVrhfF3m2Kes0FBL" +
            "/JFeOcmNg9eJz8k/hQy1kadD+XFUpluRqa//Uxp2s9W2qE0EoUCu59ugcf" +
            "/p7lGuL99UoSGmQEynkBvZct+/M40L0E0rZ4BVgzLOJmIbXMp0J4PnPcb6VLZ" +
            "vxazGcmSfjauC7F3yWYqUbZd/HCBtawwIDAQAB" +
            "\n-----END PUBLIC KEY-----";
    
    public static const skinTypes16:Vector.<int> = new <int>[1027,1028,1029,1030,10973,19494,19531,6346,30056,5505,7766,7769];
    public static const itemTypes16:Vector.<int> = new <int>[5473,5474,5475,5476,10939,19494,19531,6347,5506];
    public static const DefaultAAIgnore:Vector.<int> = new <int>[2312,2313,2370,2392,2393,2400,2401,3413,3418,3419,3420,3421,3427,3454,3638,3645,29594,29597,29710,29711,29742,29743,29746,29748,29781,30001];
    public static const DefaultAAException:Vector.<int> = new <int>[2309, 2310, 2311, 3448, 3449, 3472, 3334, 5952, 2354, 2369, 3368, 3366, 3367, 3391, 3389, 3390, 5920, 2314, 3412, 3639, 3634, 2327, 2335, 2336, 1755, 24582, 0x5f1f, 24363, 24135, 24133, 24134, 24132, 24136, 3356, 3357, 3358, 3359, 56 * 60, 3361, 3362, 3363, 3364, 2352, 2330, 28780, 28781, 28795, 28942, 28957, 28988, 28938, 29291, 29018, 29517, 24338, 493 * 60, 29712];
    public static const DefaultPriorityList:Vector.<int> = new Vector.<int>(0);
    
    public static const spamFilter:Vector.<String> = new <String>[
        "reaimbags,net", "r0tmg.0rg", "oryxsh0p.net", "wh!tebag,net", "wh!tebag.net", "realmshop.info", "realmshop.lnfo", "rotmgmarket.c",
        "rpgstash,com", "rpgstash.com", "realmitems", "reaimitems", "reaimltems", "realmltems", "realmpower,net", "reaimpower.net", "realmpower.net",
        "reaimpower,net", "rea!mkings.xyz", "buyrotmg.c", "lifepot. org", "rotmgmax.me", "rotmgmax,me", "rotmgmax me", "oryx.ln", "rpgstash com",
        "rwtmg", "rotmg.io", "jasonprimate", "rotmgmax", "realmpower", "reaimpower"];
    
    public static const defaultExclusions:Vector.<int> = new Vector.<int>(0);
    public static const defaultInclusions:Vector.<int> = new <int>[10 * 60, 601, 602, 603, 2295, 2296, 2297, 2298, 2524, 2525, 2526, 2527, 8608, 8609, 8610, 8611, 8615, 8617, 8616, 8618, 8962, 9017, 9015, 9016, 9055, 9054, 9052, 9053, 9059, 9058, 9056, 9057, 9063, 9062, 151 * 60, 9061, 32697, 32698, 32699, 545 * 60, 3004, 3005, 3006, 3007, 3088, 3100, 3096, 3091, 3113, 3114, 3112, 3111, 3032, 3033, 3034, 3035, 3177, 3266];
    
    public static const hpPotions:Vector.<int> = new <int>[1799,2594,2623,2632,2633,2689,2836,2837,2838,2839,2795,2868,2870,2872,2874,2876];
    public static const mpPotions:Vector.<int> = new <int>[2595,2634,2797,2798,2840,2841,2842,2843,2796,2869,2871,2873,2875,2877,3098];
    public static const lmPotions:Vector.<int> = new <int>[2793,9070,5471,9730,2794,9071,5472,9731];
    public static const raPotions:Vector.<int> = new <int>[2591,5465,9064,9729,2592,5466,9065,9727,2593,5467,9066,9726,2612,5468,9067,9724,2613,5469,9068,9725,2636,5470,9069,9728];

    public static var root:DisplayObject;
    public static var data:Object = null;
    public static var drawProj_:Boolean = true;
    public static var giftChestLootMode:int = 0;
    public static var iDrankVaultUnlocker:Boolean = false;
    public static var sendLogin_:Boolean = true;
    public static var player:Player = null;
    
    public static var reconRealm:ReconnectEvent = null;
    public static var reconDung:ReconnectEvent = null;
    public static var reconNexus:ReconnectEvent = null;
    public static var reconOryx:ReconnectEvent = null;
    public static var dungTime:uint = 0;
    public static var ignoreRecon:Boolean;
    public static var lockRecon:Boolean = false;
    
    public static var followName:String = "";
    public static var followPlayer:GameObject;
    public static var followingName:Boolean = false;
    public static var questFollow:Boolean = false;
    
    public static var lowCPUMode:Boolean = false;
    public static var preload:Boolean = false;
    public static var forceCharId:int = -1;
    public static var ignoringSecurityQuestions:Boolean = false;
    public static var ignoredShotCount:int = 0;
    public static var Cache_CHARLIST_valid:Boolean = false;
    public static var Cache_CHARLIST_data:String = "";
    public static var receivingPots:Boolean;
    public static var givingPotions:Boolean;
    public static var recvrName:String;

    public static var dailyCalendar1RunOnce:Boolean = false;
    public static var dailyCalendar2RunOnce:Boolean = false;
    public static var autoAcceptTrades:Boolean;
    public static var autoDrink:Boolean;
    public static var watchInv:Boolean;
    public static var timerActive:Boolean;
    public static var phaseChangeAt:int;
    public static var phaseName:String;
    public static var usingPortal:Boolean;
    public static var portalID:int;
    public static var portalSpamRate:int = 80;
    public static var realmJoining:Boolean;
    public static var realmName:String;
    public static var bazaarJoining:Boolean;
    public static var bazaarLR:String;
    public static var bazaarDist:Number;
    public static var manualTutorial:Boolean;
    public static var epmAVG:int = -1;
    public static var eLLength:int = 25;
    public static var fameBot:Boolean = false;
    public static var suicideMode:Boolean = false;
    public static var suicideAT:int = -1;
    public static var fameBotPortalId:int = 0;
    public static var fameBotPortal:Portal;
    public static var fameBotPortalPoint:Point;
    public static var famePointOffset: Number = 0;
    public static var fameSlideX: Number = 0;
    public static var fameSlideY: Number = 0;
    public static var fameWaitStartTime:int = 0;
    public static var fameWaitNTTime:int = 0;
    public static var fameWalkSleep_toFountainOrHall:int = 0;
    public static var fameWalkSleep_toRealms:int = 0;
    public static var fameWalkSleep2:int = 0;
    public static var fameWalkSleepStart:int = 0;
    public static var fpmGain:int = 0;
    public static var fpmStart:int = -1;
    public static var warnDensity:Boolean = false;
    public static var drownDamagePerSec:int = 94;
    public static var VHS:int = 0;
    public static var VHSRecordLength:int = -1;
    public static var VHSIndex:int = -1;
    public static var abi:Boolean = true;
    public static var oldFSmode:String = "exactFit";
    public static var keyHolders:String;
    public static var statsChar:String = "α";
    public static var keyk:Boolean;
    public static var keynames:String;
    public static var keyrate:int = 90;
    public static var needToRecalcDesireables:Boolean = false;
    public static var needsMapCheck:int = 0;
    public static var worldMessage:String = "";
    public static var constructToggle:Boolean = false;
    public static var paramIPJoinedOnce:Boolean = true;
    public static var paramServerJoinedOnce:Boolean = true;
    public static var currentMapHash:ByteArray = null;
    public static var savingMap_:Boolean = false;
    public static var swapINVandBP:Boolean = false;
    public static var swapINVandBPcounter:int = 0;
    public static var threadSupport:Boolean = false;
    public static var enteringRealm:Boolean = false;
    public static var RANDOM1_BA:ByteArray = new ByteArray();
    public static var RANDOM2_BA:ByteArray = new ByteArray();
    public static var reconList:Dictionary = new Dictionary();
    public static var appendage:Vector.<String> = new Vector.<String>(0);
    public static var filtered:Vector.<String> = new Vector.<String>(0);
    public static var dmgCounter:Array = [];
    public static var emptyOffer:Vector.<Boolean> = new <Boolean>[false, false, false, false, false, false, false, false, false, false, false, false];
    public static var potionsToTrade:Vector.<Boolean> = new <Boolean>[false, false, false, false, false, false, false, false, false, false, false, false];
    public static var timerPhaseTimes:Dictionary = new Dictionary();
    public static var timerPhaseNames:Dictionary = new Dictionary();
    public static var famePoint:Point = new Point(0, 0);
    public static var VHSRecord:Vector.<Point> = new Vector.<Point>();
    public static var VHSNext:Point = new Point();
    public static var announcedBags:Vector.<int> = new Vector.<int>(0);
    public static var mapSavingExclusionClasses:Vector.<String> = new <String>["Player", "Pet"];
    public static var charNames:Vector.<String> = new Vector.<String>(0);
    public static var charIds:Vector.<int> = new Vector.<int>(0);
    public static var mystics:Vector.<String> = new Vector.<String>(0);
    private static var savedOptions_:SharedObject = null;
    private static var keyNames_:Dictionary = new Dictionary();
    private static var ctrlrInputNames_:Dictionary = new Dictionary();

    public static function load():void {
        try {
            savedOptions_ = SharedObject.getLocal("AssembleeGameClientOptions", "/");
            data = savedOptions_.data;
        } catch (error:Error) {
            data = {};
        }
        setDefaults();
        setIgnores();
        setCustomPriorityList();
        Parameters.RANDOM1_BA = MoreStringUtil.hexStringToByteArray("5a4d2016bc16dc64883194ffd9");
        Parameters.RANDOM2_BA = MoreStringUtil.hexStringToByteArray("c91d9eec420160730d825604e0");
        setTimerPhases();
        setAutolootDesireables();
        fixFilter();
        save();
    }

    public static function setCustomPriorityList():void {
        var _local1:* = null;
        for each(var _local2:int in Parameters.data.CustomPriorityList) {
            _local1 = ObjectLibrary.propsLibrary_[_local2];
            if (_local1)
                _local1.customBoss_ = true;
        }
    }

    public static function fixFilter():void {
        var _local9:Boolean = false;
        var _local7:int = 0;
        var _local1:int = 0;
        var _local11:int = 0;
        var _local8:Boolean = false;
        var _local10:* = null;
        var _local4:* = null;
        filtered.length = 0;
        var _local6:Vector.<String> = new <String>["rwtmg","rwtstore","rwtshop","rotmgrwt",
        "realmgood","reaimgood","rpgrip","rpgrlp","realmshop","reaimshop","realmsh0p","reaimsh0p",
        "realmp0wer","reaimp0wer","realmpower","reaimpower","relmgood","reimgood","hyuk3d",
        "realmservices","rotmgstore","nv9p4r","v4sfdb","wgajrj","4hzb5","realmrwt","rotmgcheap",
        "realmgen","reaimgen","guills","rwtrealm","rwtgang","rea1mgen","rwtking","discordgg",
        "discordio","discordcom","realmstock","r883q5c"];
        for each(var _local5:String in _local6) {
            _local9 = false;
            for each(var _local2:String in data.spamFilter) {
                if (_local5 == _local2) {
                    _local9 = true;
                    break;
                }
            }
            if (!_local9) {
                filtered.push(_local5);
            }
        }
        filtered = filtered.concat(_local6);
        for each(_local2 in data.spamFilter) {
            _local2 = _local2.toLowerCase();
            _local10 = [];
            _local7 = _local2.length;
            if (_local7 > 0) {
                _local11 = 0;
                while (_local11 < _local7) {
                    _local1 = _local2.charCodeAt(_local11);
                    if (_local1 >= 48 && _local1 <= 57 || _local1 >= 97 && _local1 <= 122) {
                        _local10.push(_local1);
                    }
                    _local11++;
                }
            }
            _local4 = String.fromCharCode.apply(String, _local10);
            if (_local4.length > 0) {
                _local8 = false;
                for each(var _local3:String in filtered) {
                    if (_local3 == _local4) {
                        _local8 = true;
                    }
                }
                if (!_local8) {
                    filtered.push(_local4);
                }
            }
        }
    }

    public static function setTimerPhases():void {
        timerPhaseTimes["{\"key\":\"server.oryx_closed_realm\"}"] = 2 * 60 * 1000;
        timerPhaseNames["{\"key\":\"server.oryx_closed_realm\"}"] = "Realm Closed";
        timerPhaseTimes["{\"key\":\"server.oryx_minions_failed\"}"] = 200 * 60;
        timerPhaseNames["{\"key\":\"server.oryx_minions_failed\"}"] = "Oryx Shake";
        timerPhaseTimes["DIE! DIE! DIE!!!"] = 23000;
        timerPhaseNames["DIE! DIE! DIE!!!"] = "Vulnerable in";
        timerPhaseTimes["NO! This cannot be..."] = 4000;
        timerPhaseNames["NO! This cannot be"] = "Oryx 3 counter";
        timerPhaseTimes["Despicable mortals! A single realm freed is meaningless! Millions more remain in my grasp!"] = 15000;
        timerPhaseTimes["Despicable mortals! A single realm freed is meaningless! Millions more remain in my grasp!"] = "Oryx 3 vulnerable in"
        timerPhaseTimes["FALL BEFORE MY CELESTIAL STRENGTH!"] = 30000;
        timerPhaseTimes["Despicable mortals! A single realm freed is meaningless! Millions more remain in my grasp!"] = "Celestial phase"
    }

    public static function setAutolootDesireables():void {
        var _local2:int = 0;
        var _local3:int = 0;
        var _local1:ObjectProperties = null;
        var _local4:* = null;
        var _local10:int = 0;
        var _local9:* = ObjectLibrary.xmlLibrary_;
        for each(_local4 in ObjectLibrary.xmlLibrary_) {
            _local3 = _local4.@type;
            _local1 = ObjectLibrary.propsLibrary_[_local3];
            if (_local1 && _local1.isItem_) {
                _local1.desiredLoot_ = false;
                if (_local1.isPotion_ && desiredPotion(_local3)) {
                    _local1.desiredLoot_ = true;
                } else if (Parameters.data.autoLootWeaponTier != 999 && desiredWeapon(_local4, _local3, Parameters.data.autoLootWeaponTier)) {
                    _local1.desiredLoot_ = true;
                } else if (Parameters.data.autoLootAbilityTier != 999 && desiredAbility(_local4, _local3, Parameters.data.autoLootAbilityTier)) {
                    _local1.desiredLoot_ = true;
                } else if (Parameters.data.autoLootArmorTier != 999 && desiredArmor(_local4, _local3, Parameters.data.autoLootArmorTier)) {
                    _local1.desiredLoot_ = true;
                } else if (Parameters.data.autoLootRingTier != 999 && desiredRing(_local4, _local3, Parameters.data.autoLootRingTier)) {
                    _local1.desiredLoot_ = true;
                } else if (Parameters.data.autoLootUTs && desiredUT(_local4)) {
                    _local1.desiredLoot_ = true;
                } else if (Parameters.data.autoLootSkins && desiredSkin(_local4, _local4.@id)) {
                    _local1.desiredLoot_ = true;
                } else if (Parameters.data.autoLootPetSkins && desiredPetSkin(_local4, _local4.@id, int(_local4.@type))) {
                    _local1.desiredLoot_ = true;
                } else if (Parameters.data.autoLootKeys && desiredKey(_local4, _local4.@id)) {
                    _local1.desiredLoot_ = true;
                } else if (Parameters.data.autoLootMarks && String(_local4.@id).indexOf("Mark of ") != -1) {
                    _local1.desiredLoot_ = true;
                } else if (Parameters.data.autoLootConsumables && "Consumable" in _local4) {
                    _local1.desiredLoot_ = true;
                } else if (Parameters.data.autoLootSoulbound && "Soulbound" in _local4) {
                    _local1.desiredLoot_ = true;
                } else if (Parameters.data.autoLootEggs != -1 && desiredEgg(_local4, Parameters.data.autoLootEggs)) {
                    _local1.desiredLoot_ = true;
                } else if (Parameters.data.autoLootFeedPower != -1 && desiredFeedPower(_local4, Parameters.data.autoLootFeedPower)) {
                    _local1.desiredLoot_ = true;
                } else if (Parameters.data.autoLootFameBonus != -1 && desiredFameBonus(_local4, Parameters.data.autoLootFameBonus)) {
                    _local1.desiredLoot_ = true;
                } else if (Parameters.data.autoLootStackables && _local1.stackable_ || "Quantity" in _local4 && "ExtraTooltipData" in _local4 && _local4.ExtraTooltipData.EffectInfo.(@name == "Stack limit")) {
                    _local1.desiredLoot_ = true;
                }
            }
        }
        var _local12:int = 0;
        var _local11:* = Parameters.data.autoLootExcludes;
        for each(_local2 in Parameters.data.autoLootExcludes) {
            _local1 = ObjectLibrary.propsLibrary_[_local2];
            if (_local1) {
                _local1.desiredLoot_ = false;
            }
        }
        var _local14:int = 0;
        var _local13:* = Parameters.data.autoLootIncludes;
        for each(_local2 in Parameters.data.autoLootIncludes) {
            _local1 = ObjectLibrary.propsLibrary_[_local2];
            if (_local1) {
                _local1.desiredLoot_ = true;
            }
        }
    }

    public static function desiredPotion(_arg_1:int):Boolean {
        if (Parameters.data.autoLootHPPots) {
            if (hpPotions.indexOf(_arg_1) >= 0) {
                return true;
            }
        }
        if (Parameters.data.autoLootMPPots) {
            if (mpPotions.indexOf(_arg_1) >= 0) {
                return true;
            }
        }
        if (Parameters.data.autoLootLifeManaPots) {
            if (lmPotions.indexOf(_arg_1) >= 0) {
                return true;
            }
        }
        if (Parameters.data.autoLootRainbowPots) {
            if (raPotions.indexOf(_arg_1) >= 0) {
                return true;
            }
        }
        return false;
    }

    public static function desiredWeapon(_arg_1:XML, _arg_2:int, _arg_3:int):Boolean {
        if (!("SlotType" in _arg_1 && "Tier" in _arg_1)) {
            return false;
        }
        var _local4:Vector.<int> = new <int>[3, 2, 24, 17, 1, 8];
        return _arg_1.Tier >= _arg_3 && _local4.indexOf(_arg_1.SlotType) >= 0;
    }

    public static function desiredAbility(_arg_1:XML, _arg_2:int, _arg_3:int):Boolean {
        if (!("SlotType" in _arg_1 && "Tier" in _arg_1)) {
            return false;
        }
        var _local4:Vector.<int> = new <int>[13, 16, 21, 18, 22, 15, 23, 12, 5, 25, 19, 11, 4, 20];
        return _arg_1.Tier >= _arg_3 && _local4.indexOf(_arg_1.SlotType) >= 0;
    }

    public static function desiredArmor(_arg_1:XML, _arg_2:int, _arg_3:int):Boolean {
        if (!("SlotType" in _arg_1 && "Tier" in _arg_1)) {
            return false;
        }
        var _local4:Vector.<int> = new <int>[6, 7, 14];
        return _arg_1.Tier >= _arg_3 && _local4.indexOf(_arg_1.SlotType) >= 0;
    }

    public static function desiredRing(_arg_1:XML, _arg_2:int, _arg_3:int):Boolean {
        if (!("SlotType" in _arg_1 && "Tier" in _arg_1)) {
            return false;
        }
        return _arg_1.Tier >= _arg_3 && _arg_1.SlotType == 9;
    }

    public static function desiredUT(_arg_1:XML):Boolean {
        var _local2:int = 0;
        if (!("SlotType" in _arg_1)) {
            return false;
        }
        if ("BagType" in _arg_1) {
            _local2 = _arg_1.BagType;
            return _local2 == 6 || _local2 == 9;
        }
        return false;
    }

    public static function desiredST(param1:XML) : Boolean {
        var _local2:int = 0;
        if(!("SlotType" in param1)) {
            return false;
        }
        if("BagType" in param1) {
            _local2 = param1.BagType;
            return _local2 == 8;
        }
        return false;
    }

    public static function desiredSkin(_arg_1:XML, _arg_2:String):Boolean {
        if (_arg_1.Activate == "UnlockSkin") {
            return true;
        }
        if (_arg_2.lastIndexOf("Mystery Skin") >= 0) {
            return true;
        }
        return false;
    }

    public static function desiredPetSkin(_arg_1:XML, _arg_2:String, _arg_3:int):Boolean {
        var _local4:Vector.<int> = new <int>[8973, 8974, 8975];
        if (_arg_2.lastIndexOf("Pet Stone") >= 0) {
            return true;
        }
        if (_local4.indexOf(_arg_3) >= 0) {
            return true;
        }
        return false;
    }

    public static function desiredKey(_arg_1:XML, _arg_2:String):Boolean {
        if (_arg_1.Activate == "CreatePortal") {
            return true;
        }
        if (_arg_2.indexOf("Mystery Key") >= 0) {
            return true;
        }
        return false;
    }

    public static function desiredEgg(_arg_1:XML, _arg_2:int):Boolean {
        var _local3:int = 0;
        if ("Rarity" in _arg_1) {
            if (_arg_1.Rarity == "Common") {
                _local3 = 0;
            } else if (_arg_1.Rarity == "Uncommon") {
                _local3 = 1;
            } else if (_arg_1.Rarity == "Rare") {
                _local3 = 2;
            } else if (_arg_1.Rarity == "Legendary") {
                _local3 = 3;
            }
            return _local3 >= _arg_2;
        }
        return false;
    }

    public static function desiredFeedPower(_arg_1:XML, _arg_2:int):Boolean {
        return "feedPower" in _arg_1 && _arg_1.feedPower >= _arg_2;
    }

    public static function desiredFameBonus(_arg_1:XML, _arg_2:int):Boolean {
        return "FameBonus" in _arg_1 && _arg_1.FameBonus >= _arg_2;
    }

    public static function setIgnores():void {
        var _local3:* = null;
        for each(var _local2:int in Parameters.data.AAIgnore) {
            if (_local2 in ObjectLibrary.propsLibrary_) {
                _local3 = ObjectLibrary.propsLibrary_[_local2];
                _local3.ignored = true;
            }
            if (_local2 in ObjectLibrary.xmlLibrary_) {
                ObjectLibrary.xmlLibrary_[_local2].props_.ignored = true;
            }
        }
        for each(var _local1:int in Parameters.data.AAException) {
            if (_local1 in ObjectLibrary.propsLibrary_) {
                _local3 = ObjectLibrary.propsLibrary_[_local1];
                _local3.excepted = true;
            }
            if (_local1 in ObjectLibrary.xmlLibrary_) {
                ObjectLibrary.xmlLibrary_[_local1].props_.excepted = true;
            }
        }
    }

    public static function save():void {
        try {
            if (savedOptions_) {
                savedOptions_.flush();
            }

        } catch (error:Error) {

        }
    }

    public static function setKey(_arg_1:String, _arg_2:uint):void {
        for (var _local3:String in keyNames_) {
            if (data[_local3] == _arg_2) {
                data[_local3] = 0;
            }
        }
        data[_arg_1] = _arg_2;
    }

    public static function setDefaults():void {
        setDefaultKey("moveLeft", 65);
        setDefaultKey("moveRight", 68);
        setDefaultKey("moveUp", 87);
        setDefaultKey("moveDown", 83);
        setDefaultKey("rotateLeft", 81);
        setDefaultKey("rotateRight", 69);
        setDefaultKey("useSpecial", 32);
        setDefaultKey("interact", 86);
        setDefaultKey("useInvSlot1", 49);
        setDefaultKey("useInvSlot2", 50);
        setDefaultKey("useInvSlot3", 51);
        setDefaultKey("useInvSlot4", 52);
        setDefaultKey("useInvSlot5", 53);
        setDefaultKey("useInvSlot6", 54);
        setDefaultKey("useInvSlot7", 55);
        setDefaultKey("useInvSlot8", 56);
        setDefaultKey("escapeToNexus2", 116);
        setDefaultKey("escapeToNexus", 82);
        setDefaultKey("autofireToggle", 67);
        setDefaultKey("scrollChatUp", 33);
        setDefaultKey("scrollChatDown", 34);
        setDefaultKey("miniMapZoomOut", 189);
        setDefaultKey("miniMapZoomIn", 187);
        setDefaultKey("resetToDefaultCameraAngle", 70);
        setDefaultKey("togglePerformanceStats", 88);
        setDefaultKey("options", 79);
        setDefaultKey("toggleCentering", 84);
        setDefaultKey("chat", 13);
        setDefaultKey("chatCommand", 191);
        setDefaultKey("tell", 9);
        setDefaultKey("guildChat", 71);
        setDefaultKey("toggleFullscreen", 0);
        setDefaultKey("useHealthPotion", 90);
        setDefaultKey("GPURenderToggle", 0);
        setDefaultKey("friendList", 0);
        setDefaultKey("useMagicPotion", 89);
        setDefaultKey("switchTabs", 72);
        setDefaultKey("particleEffect", 0);
        setDefaultKey("toggleHPBar", 0);
        setDefaultKey("toggleProjectiles", 0);
        setDefaultKey("toggleMasterParticles", 0);
        setDefaultKey("toggleRealmQuestDisplay", 0);
        setDefault("playMusic", false);
        setDefault("playSFX", true);
        setDefault("playPewPew", true);
        setDefault("centerOnPlayer", true);
        setDefault("preferredServer", null);
        setDefault("bestServer", null);
        setDefault("preferredChallengerServer", null);
        setDefault("bestChallengerServer", null);
        setDefault("needsTutorial", false);
        setDefault("cameraAngle", 0);
        setDefault("defaultCameraAngle", 0);
        setDefault("showQuestPortraits", true);
        setDefault("fullscreenMode", false);
        setDefault("showProtips", false);
        setDefault("joinDate", MoreDateUtil.getDayStringInPT());
        setDefault("lastDailyAnalytics", null);
        setDefault("allowRotation", true);
        setDefault("allowMiniMapRotation", false);
        setDefault("charIdUseMap", {});
        setDefault("textBubbles", false);
        setDefault("showTradePopup", true);
        setDefault("paymentMethod", null);
        setDefault("filterLanguage", false);
        setDefault("showGuildInvitePopup", true);
        setDefault("showBeginnersOffer", false);
        setDefault("beginnersOfferTimeLeft", 0);
        setDefault("beginnersOfferShowNow", false);
        setDefault("beginnersOfferShowNowTime", 0);
        setDefault("inventorySwap", true);
        setDefault("particleEffect", false);
        setDefault("uiQuality", false);
        setDefault("disableEnemyParticles", false);
        setDefault("disableAllyShoot", 0);
        setDefault("disablePlayersHitParticles", false);
        setDefault("cursorSelect", "4");
        setDefault("GPURender", false);
        setDefault("forceChatQuality", false);
        setDefault("hidePlayerChat", false);
        setDefault("chatStarRequirement", 0);
        setDefault("chatAll", true);
        setDefault("chatWhisper", true);
        setDefault("chatGuild", true);
        setDefault("chatTrade", true);
        setDefault("toggleBarText", 0);
        setDefault("toggleToMaxText", false);
        setDefault("particleEffect", true);
        if ("playMusic" in data && data.playMusic == true) {
            setDefault("musicVolume", 1);
        } else {
            setDefault("musicVolume", 0);
        }
        if ("playSFX" in data && data.playMusic == true) {
            setDefault("SFXVolume", 0.2);
        } else {
            setDefault("SFXVolume", 0);
        }
        setDefaultKey("friendList", 0);
        setDefault("tradeWithFriends", false);
        setDefault("chatFriend", false);
        setDefault("friendStarRequirement", 0);
        setDefault("HPBar", 1);
        setDefault("newMiniMapColors", false);
        setDefault("noParticlesMaster",false);
        setDefault("noAllyNotifications", false);
        setDefault("noAllyDamage", false);
        setDefault("noEnemyDamage", false);
        setDefault("forceEXP", 1);
        setDefault("showFameGain", false);
        setDefault("curseIndication", false);
        setDefault("showTierTag", true);
        setDefault("characterGlow", 0);
        setDefault("gravestones", 0);
        setDefault("chatNameColor", 0);
        setDefault("expandRealmQuestsDisplay", true);
        setDefault("showChallengerInfo", true);
        if (!("needsSurvey" in data)) {
            data.needsSurvey = data.needsTutorial;
            switch (int(Math.random() * 5)) {
                case 0:
                    data.surveyDate = 0;
                    data.playTimeLeftTillSurvey = 5 * 60;
                    data.surveyGroup = "5MinPlaytime";
                    break;
                case 1:
                    data.surveyDate = 0;
                    data.playTimeLeftTillSurvey = 10 * 60;
                    data.surveyGroup = "10MinPlaytime";
                    break;
                case 2:
                    data.surveyDate = 0;
                    data.playTimeLeftTillSurvey = 30 * 60;
                    data.surveyGroup = "30MinPlaytime";
                    break;
                case 3:
                    data.surveyDate = new Date().time + 7 * 24 * 60 * 60 * 1000;
                    data.playTimeLeftTillSurvey = 2 * 60;
                    data.surveyGroup = "1WeekRealtime";
                    break;
                case 4:
                    data.surveyDate = new Date().time + 14 * 24 * 60 * 60 * 1000;
                    data.playTimeLeftTillSurvey = 2 * 60;
                    data.surveyGroup = "2WeekRealtime";
            }
        }
        setDefault("lastTab", "Options.Controls");
        setDefault("ssdebuffBitmask", 0);
        setDefault("ssdebuffBitmask2", 0);
        setDefault("ccdebuffBitmask", 0);
        setDefault("spamFilter", spamFilter);
        setDefault("AutoLootOn", false);
        setDefault("AutoHealPercentage", 99);
        setDefault("AAOn", true);
        setDefault("AAMinManaPercent", 50);
        setDefault("AATargetLead", true);
        setDefault("AABoundingDist", 4);
        setDefault("aimMode", 2);
        setDefault("AutoAbilityOn", false);
        setDefault("showQuestBar", false);
        setDefault("AutoNexus", 25);
        setDefault("AutoHeal", 65);
        setDefault("autoHPPercent", 40);
        setDefault("autoMPPercent", -1);
        setDefault("autompPotDelay", 200);
        setDefault("TombCycleBoss", 3368);
        setDefault("XYZdistance", 1);
        setDefaultKey("XYZleftHotkey", 0);
        setDefaultKey("XYZupHotkey", 0);
        setDefaultKey("XYZdownHotkey", 0);
        setDefaultKey("XYZrightHotkey", 0);
        setDefaultKey("TombCycleKey", 0);
        setDefaultKey("anchorTeleport", 0);
        setDefaultKey("DrinkAllHotkey", 0);
        setDefaultKey("SelfTPHotkey", 0);
        setDefaultKey("syncLeadHotkey", 118);
        setDefaultKey("syncFollowHotkey", 119);
        setDefault("vaultOnly", false);
        setDefault("AutoResponder", false);
        setDefault("FocusFPS", false);
        setDefault("bgFPS", 10);
        setDefault("fgFPS", 60);
        setDefault("timeScale",1)
        setDefault("timeScaleArr",new Vector.<Number>(0))
        setDefault("timeScaleArrIndex",0)
        setDefaultKey("timeScaleKey",0)
        setDefault("hideLockList", false);
        setDefault("hidePets2", 1);
        setDefault("hideOtherDamage", false);
        setDefault("mscale", 1);
        setDefault("stageScale", "noScale");
        setDefault("uiscale", true);
        setDefault("offsetVoidBow", false);
        setDefault("offsetColossus", false);
        setDefault("coloOffset", 0.225);
        setDefault("ethDisable", false);
        setDefault("cultiststaffDisable", false);
        setDefault("offsetCelestialBlade", false);
        setDefault("alphaOnOthers", false);
        setDefault("alphaMan", 0.4);
        setDefault("lootPreview", true);
        setDefault("showQuestBar", false);
        setDefaultKey("LowCPUModeHotKey", 0);
        setDefaultKey("Cam45DegInc", 0);
        setDefaultKey("Cam45DegDec", 0);
        setDefaultKey("QuestTeleport", 0);
        setDefaultKey("ReconRealm", 97);
        setDefaultKey("PassesCoverHotkey", 0);
        setDefaultKey("AAHotkey", 0);
        setDefaultKey("AAModeHotkey", 0);
        setDefaultKey("AutoAbilityHotkey", 0);
        setDefaultKey("AutoLootHotkey", 0);
        setDefault("damageIgnored", false);
        setDefault("ignoreIce", false);
        setDefaultKey("TextPause", 113);
        setDefaultKey("TextThessal", 114);
        setDefaultKey("TextCem", 112);
        setDefault("AAException", DefaultAAException);
        setDefault("AAIgnore", DefaultAAIgnore);
        setDefault("CustomPriorityList", DefaultPriorityList);
        setDefault("passThroughInvuln", false);
        setDefault("autoaimAtInvulnerable", false);
        setDefault("showDamageOnEnemy", false);
        setDefault("fameBlockTP", false);
        setDefault("fameBlockAbility", false);
        setDefault("fameBlockCubes", false);
        setDefault("fameBlockGodsOnly", false);
        setDefault("fameBlockThirsty", false);
        setDefault("spellbombHPThreshold", 50 * 60);
        setDefault("skullHPThreshold", 800);
        setDefault("skullTargets", 5);
        setDefault("liteMonitor", true);
        setDefaultKey("TogglePlayerFollow", 2 * 60);
        setDefaultKey("resetClientHP", 0);
        setDefaultKey("famebotToggleHotkey", 0);
        setDefault("addMoveRecPoint", false);
        setDefault("trainOffset", 500);
        setDefault("densityThreshold", 625);
        setDefault("teleDistance", 64);
        setDefault("WalkAroundRocks", false);
        setDefault("famebotContinue", 0);
        setDefault("fameTpCdTime", 5000);
        setDefault("famePointOffset", 1.5);
        setDefault("skipPopups", false);
        setDefault("TradeDelay", true);
        setDefault("showHPBarOnAlly", true);
        setDefault("showEXPFameOnAlly", true);
        setDefault("showClientStat", false);
        setDefault("liteParticle", false);
        setDefault("onlyAimAtExcepted", false);
        setDefault("ignoreStatusText", false);
        setDefault("ignoreQuiet", false);
        setDefault("ignoreWeak", false);
        setDefault("ignoreSlowed", false);
        setDefault("ignoreSick", false);
        setDefault("ignoreDazed", false);
        setDefault("ignoreStunned", false);
        setDefault("ignoreParalyzed", false);
        setDefault("ignoreBleeding", false);
        setDefault("ignoreArmorBroken", false);
        setDefault("ignorePetStasis", false);
        setDefault("ignorePetrified", false);
        setDefault("ignoreSilenced", false);
        setDefault("ignoreBlind", true);
        setDefault("ignoreHallucinating", true);
        setDefault("ignoreDrunk", true);
        setDefault("ignoreConfused", true);
        setDefault("ignoreUnstable", false);
        setDefault("ignoreDarkness", true);
        setDefault("autoDecrementHP", false);
        setDefault("bigLootBags", false);
        setDefault("replaceCon", false);
        setDefault("AutoSyncClientHP", false);
        setDefault("extraPlayerMenu", true);
        setDefault("safeWalk", false);
        setDefault("evenLowerGraphics", false);
        setDefault("showCHbar", true);
        setDefault("rightClickOption", 0);
        setDefault("dynamicHPcolor", true);
        setDefault("keyList", false);
        setDefault("uiTextSize", 15);
        setDefault("mobNotifier", true);
        setDefault("showMobInfo", false);
        setDefault("aaDistance", 1);
        setDefault("hideLowCPUModeChat", false);
        setDefault("fameOryx", false);
        setDefault("tiltCam", false);
        setDefault("showBG",false);
        setDefault("BossPriority", true);
        setDefaultKey("sayCustom1", 0);
        setDefaultKey("sayCustom2", 0);
        setDefaultKey("sayCustom3", 0);
        setDefaultKey("sayCustom4", 0);
        setDefault("customMessage1", "");
        setDefault("customMessage2", "");
        setDefault("customMessage3", "");
        setDefault("customMessage4", "");
        setDefault("autoLootExcludes", Parameters.defaultExclusions);
        setDefault("autoLootIncludes", Parameters.defaultInclusions);
        setDefault("autoLootUpgrades", false);
        setDefault("autoLootWeaponTier", 11);
        setDefault("autoLootAbilityTier", 5);
        setDefault("autoLootArmorTier", 12);
        setDefault("autoLootRingTier", 5);
        setDefault("autoLootSkins", true);
        setDefault("autoLootPetSkins", true);
        setDefault("autoLootKeys", true);
        setDefault("autoLootHPPots", true);
        setDefault("autoLootMPPots", true);
        setDefault("autoLootHPPotsInv", true);
        setDefault("autoLootMPPotsInv", false);
        setDefault("autoLootLifeManaPots", true);
        setDefault("autoLootRainbowPots", true);
        setDefault("autoLootUTs", true);
        setDefault("autoLootFameBonus", 5);
        setDefault("autoLootFeedPower", -1);
        setDefault("autoLootMarks", false);
        setDefault("autoLootConsumables", false);
        setDefault("autoLootSoulbound", false);
        setDefault("autoLootEggs", 1);
        setDefault("autoLootStackables", true);
        setDefault("showFameGoldRealms", false);
        setDefault("showEnemyCounter", true);
        setDefault("showTimers", true);
        setDefault("showAOGuildies", false);
        setDefault("autoDrinkFromBags", false);
        setDefault("cacheCharList", false);
        setDefault("PassesCover", false);
        setDefault("chatLength", 10);
        setDefault("autohpPotDelay", 400);
        setDefault("mapHack", false);
        setDefault("fixTabHotkeys", true);
        setDefault("noRotate", false);
        setDefault("customSounds",false);
        setDefault("customVolume",1);
        setDefault("aimAtQuest", 0);
        setDefault("followIntoPortals", false);
        setDefault("spamPrismNumber", 0);
        setDefault("instaNexus", true);
        setDefault("rightClickSelectAll", false);
        setDefault("lastVersionCheck1", -1);
        setDefault("shownGotoWarning", false);
        setDefaultControllerInput("ctrlEnterPortal", 4);
        setDefaultControllerInput("ctrlTeleQuest", 7);
        setDefaultControllerInput("ctrlNexus", 5);
        setDefaultControllerInput("ctrlAbility", 6);
        setDefaultControllerInput("ctrlItemMenu", 14);
        setDefault("useControllerNumber", 0);
        setDefault("selectedItemColor", 0);
        setDefault("cNameBypass", false);
        setDefault("AutoDungeonEnterList", new Vector.<String>(0));
        setDefault("customVersion", "");
        setDefault("autoLootInVault", false);
        setDefault("seenUnityPopup", false);
        setDefault("showWhiteBagEffect", true);
        setDefault("customFPS",60);
        setDefault("fameDistDelta", 0.5);
        setDefault("fameCheckMS", 150);
        setDefault("perfStats", false);
        setDefault("showOrangeBagEffect",false);
        setDefault("mouseCameraMultiplier",0);
        setDefault("frameSkipMS",-1);
        setDefault("showInventoryTooltip",true);
        setDefault("autoEnterPortals",false);
        setDefault("bypassTpPositionCheck",false);
        setDefault("reconnectDelay",250);
        setDefault("mysticAAShootGroup",false);
        setDefaultKey("walkKey", KeyCodes.SHIFT);
        setDefault("projFace", true);
        setDefault("disableSorting", false);
        setDefault("noClip", false);
        setDefaultKey("noClipKey", KeyCodes.UNSET);
        setDefault("fakeLag", 0);
        setDefault("renderDistance", 16);
        setDefault("showRange", false);
        setDefault("multiLeader", "");
    }

    private static function setDefaultKey(_arg_1:String, _arg_2:uint):void {
        if (!(_arg_1 in data)) {
            data[_arg_1] = _arg_2;
        }
        keyNames_[_arg_1] = true;
    }

    private static function setDefaultControllerInput(_arg_1:String, _arg_2:uint):void {
        if (!(_arg_1 in data)) {
            data[_arg_1] = _arg_2;
        }
        ctrlrInputNames_[_arg_1] = true;
    }

    private static function setDefault(_arg_1:String, _arg_2:*):void {
        if (!(_arg_1 in data)) {
            data[_arg_1] = _arg_2;
        }
    }

    public function Parameters() {
        super();
    }
}
}
