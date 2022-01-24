package com.company.assembleegameclient.util {
import com.company.assembleegameclient.util.redrawers.GlowRedrawer;
import com.company.util.AssetLibrary;
import com.company.util.PointUtil;

import flash.display.BitmapData;
import flash.filters.GlowFilter;
import flash.geom.Matrix;

import kabam.rotmg.text.model.TextKey;

public class ConditionEffect {
    public static const NOTHING:uint = 0;
    public static const DEAD:uint = 1;
    public static const QUIET:uint = 2;
    public static const WEAK:uint = 3;
    public static const SLOWED:uint = 4;
    public static const SICK:uint = 5;
    public static const DAZED:uint = 6;
    public static const STUNNED:uint = 7;
    public static const BLIND:uint = 8;
    public static const HALLUCINATING:uint = 9;
    public static const DRUNK:uint = 10;
    public static const CONFUSED:uint = 11;
    public static const STUN_IMMUNE:uint = 12;
    public static const INVISIBLE:uint = 13;
    public static const PARALYZED:uint = 14;
    public static const SPEEDY:uint = 15;
    public static const BLEEDING:uint = 16;
    public static const ARMOR_BROKEN_IMMUNE:uint = 17;
    public static const HEALING:uint = 18;
    public static const DAMAGING:uint = 19;
    public static const BERSERK:uint = 20;
    public static const PAUSED:uint = 21;
    public static const STASIS:uint = 22;
    public static const STASIS_IMMUNE:uint = 23;
    public static const INVINCIBLE:uint = 24;
    public static const INVULNERABLE:uint = 25;
    public static const ARMORED:uint = 26;
    public static const ARMOR_BROKEN:uint = 27;
    public static const HEXED:uint = 28;
    public static const NINJA_SPEEDY:uint = 29;
    public static const UNSTABLE:uint = 30;
    public static const DARKNESS:uint = 31;
    public static const SLOWED_IMMUNE:uint = 32;
    public static const DAZED_IMMUNE:uint = 33;
    public static const PARALYZED_IMMUNE:uint = 34;
    public static const PETRIFIED:uint = 35;
    public static const PETRIFIED_IMMUNE:uint = 36;
    public static const PET_EFFECT_ICON:uint = 37;
    public static const CURSE:uint = 38;
    public static const CURSE_IMMUNE:uint = 39;
    public static const HP_BOOST:uint = 40;
    public static const MP_BOOST:uint = 41;
    public static const ATT_BOOST:uint = 42;
    public static const DEF_BOOST:uint = 43;
    public static const SPD_BOOST:uint = 44;
    public static const VIT_BOOST:uint = 45;
    public static const WIS_BOOST:uint = 46;
    public static const DEX_BOOST:uint = 47;
    public static const SILENCED:uint = 48;
    public static const EXPOSED:uint = 49;
    public static const ENERGIZED:uint = 50;
    public static const HP_DEBUFF:uint = 51;
    public static const MP_DEBUFF:uint = 52;
    public static const ATT_DEBUFF:uint = 53;
    public static const DEF_DEBUFF:uint = 54;
    public static const SPD_DEBUFF:uint = 55;
    public static const VIT_DEBUFF:uint = 56;
    public static const WIS_DEBUFF:uint = 57;
    public static const DEX_DEBUFF:uint = 58;
    public static const INSPIRED:uint = 59;
    public static const GROUND_DAMAGE:uint = 99;

    public static const DEAD_BIT:uint = 1 << (DEAD - 1);
    public static const QUIET_BIT:uint = 1 << (QUIET - 1);
    public static const WEAK_BIT:uint = 1 << (WEAK - 1);
    public static const SLOWED_BIT:uint = 1 << (SLOWED - 1);
    public static const SICK_BIT:uint = 1 << (SICK - 1);
    public static const DAZED_BIT:uint = 1 << (DAZED - 1);
    public static const STUNNED_BIT:uint = 1 << (STUNNED - 1);
    public static const BLIND_BIT:uint = 1 << (BLIND - 1);
    public static const HALLUCINATING_BIT:uint = 1 << (HALLUCINATING - 1);
    public static const DRUNK_BIT:uint = 1 << (DRUNK - 1);
    public static const CONFUSED_BIT:uint = 1 << (CONFUSED - 1);
    public static const STUN_IMMUNE_BIT:uint = 1 << (STUN_IMMUNE - 1);
    public static const INVISIBLE_BIT:uint = 1 << (INVISIBLE - 1);
    public static const PARALYZED_BIT:uint = 1 << (PARALYZED - 1);
    public static const SPEEDY_BIT:uint = 1 << (SPEEDY - 1);
    public static const BLEEDING_BIT:uint = 1 << (BLEEDING - 1);
    public static const ARMOR_BROKEN_IMMUNE_BIT:uint = 1 << (ARMOR_BROKEN_IMMUNE - 1);
    public static const HEALING_BIT:uint = 1 << (HEALING - 1);
    public static const DAMAGING_BIT:uint = 1 << (DAMAGING - 1);
    public static const BERSERK_BIT:uint = 1 << (BERSERK - 1);
    public static const PAUSED_BIT:uint = 1 << (PAUSED - 1);
    public static const STASIS_BIT:uint = 1 << (STASIS - 1);
    public static const STASIS_IMMUNE_BIT:uint = 1 << (STASIS_IMMUNE - 1);
    public static const INVINCIBLE_BIT:uint = 1 << (INVINCIBLE - 1);
    public static const INVULNERABLE_BIT:uint = 1 << (INVULNERABLE - 1);
    public static const ARMORED_BIT:uint = 1 << (ARMORED - 1);
    public static const ARMOR_BROKEN_BIT:uint = 1 << (ARMOR_BROKEN - 1);
    public static const HEXED_BIT:uint = 1 << (HEXED - 1);
    public static const NINJA_SPEEDY_BIT:uint = 1 << (NINJA_SPEEDY - 1);
    public static const UNSTABLE_BIT:uint = 1 << (UNSTABLE - 1);
    public static const DARKNESS_BIT:uint = 1 << (DARKNESS - 1);
    public static const SLOWED_IMMUNE_BIT:uint = 1 << (SLOWED_IMMUNE - NEW_CON_THRESHOLD);
    public static const DAZED_IMMUNE_BIT:uint = 1 << (DAZED_IMMUNE - NEW_CON_THRESHOLD);
    public static const PARALYZED_IMMUNE_BIT:uint = 1 << (PARALYZED_IMMUNE - NEW_CON_THRESHOLD);
    public static const PETRIFIED_BIT:uint = 1 << (PETRIFIED - NEW_CON_THRESHOLD);
    public static const PETRIFIED_IMMUNE_BIT:uint = 16;
    public static const PET_EFFECT_ICON_BIT:uint = 32;
    public static const CURSE_BIT:uint = 64;
    public static const CURSE_IMMUNE_BIT:uint = 128;
    public static const HP_BOOST_BIT:uint = 256;
    public static const MP_BOOST_BIT:uint = 512;
    public static const ATT_BOOST_BIT:uint = 1024;
    public static const DEF_BOOST_BIT:uint = 2048;
    public static const SPD_BOOST_BIT:uint = 4096;
    public static const VIT_BOOST_BIT:uint = 8192;
    public static const WIS_BOOST_BIT:uint = 16384;
    public static const DEX_BOOST_BIT:uint = 32768;
    public static const SILENCED_BIT:uint = 65536;
    public static const EXPOSED_BIT:uint = 131072;
    public static const ENERGIZED_BIT:uint = 262144;
    public static const HP_DEBUFF_BIT:uint = 524288;
    public static const MP_DEBUFF_BIT:uint = 1048576;
    public static const ATT_DEBUFF_BIT:uint = 2097152;
    public static const DEF_DEBUFF_BIT:uint = 4194304;
    public static const SPD_DEBUFF_BIT:uint = 8388608;
    public static const VIT_DEBUFF_BIT:uint = 16777216;
    public static const WIS_DEBUFF_BIT:uint = 33554432;
    public static const DEX_DEBUFF_BIT:uint = 67108864;
    public static const INSPIRED_BIT:uint = 134217728;

    public static const MAP_FILTER_BITMASK:uint = DRUNK_BIT | BLIND_BIT | PAUSED_BIT;
    public static const PROJ_NOHIT_BITMASK:uint = INVINCIBLE_BIT | STASIS_BIT | PAUSED_BIT;

    public static const CE_FIRST_BATCH:uint = 0;
    public static const CE_SECOND_BATCH:uint = 1;
    public static const NUMBER_CE_BATCHES:uint = 2;
    public static const NEW_CON_THRESHOLD:uint = 32;
    public static const GLOW_FILTER:GlowFilter = new GlowFilter(0, 0.3, 6,
            6, 2, 1, false, false);

    public static var effects_:Vector.<ConditionEffect> =
            new <ConditionEffect>[
                new ConditionEffect("Nothing", 0, null, "Nothing"),
                new ConditionEffect("Dead", DEAD_BIT, null, "Dead"),
                new ConditionEffect("Quiet", QUIET_BIT, [32], "Quiet"),
                new ConditionEffect("Weak", WEAK_BIT, [34, 35, 36, 37], "Weak"),
                new ConditionEffect("Slowed", SLOWED_BIT, [1], "Slowed"),
                new ConditionEffect("Sick", SICK_BIT, [39], "Sick"),
                new ConditionEffect("Dazed", DAZED_BIT, [44], "Dazed"),
                new ConditionEffect("Stunned", STUNNED_BIT, [45], "Stunned"),
                new ConditionEffect("Blind", BLIND_BIT, [41], "Blind"),
                new ConditionEffect("Hallucinating", HALLUCINATING_BIT, [42], "Hallucinating"),
                new ConditionEffect("Drunk", DRUNK_BIT, [43], "Drunk"),
                new ConditionEffect("Confused", CONFUSED_BIT, [2], "Confused"),
                new ConditionEffect("Stun Immune", STUN_IMMUNE_BIT, null, "Stun Immune"),
                new ConditionEffect("Invisible", INVISIBLE_BIT, null, "Invisible"),
                new ConditionEffect("Paralyzed", PARALYZED_BIT, [53, 54], "Paralyzed"),
                new ConditionEffect("Speedy", SPEEDY_BIT, [0], "Speedy"),
                new ConditionEffect("Bleeding", BLEEDING_BIT, [46], "Bleeding"),
                new ConditionEffect("Armor Broken Immune", ARMOR_BROKEN_IMMUNE_BIT, null, "Armor Broken Immune"),
                new ConditionEffect("Healing", HEALING_BIT, [47], "Healing"),
                new ConditionEffect("Damaging", DAMAGING_BIT, [49], "Damaging"),
                new ConditionEffect("Berserk", BERSERK_BIT, [50], "Berserk"),
                new ConditionEffect("Paused", PAUSED_BIT, null, "Paused"),
                new ConditionEffect("Stasis", STASIS_BIT, null, "Stasis"),
                new ConditionEffect("Stasis Immune", STASIS_IMMUNE_BIT, null, "Stasis Immune"),
                new ConditionEffect("Invincible", INVINCIBLE_BIT, null, "Invincible"),
                new ConditionEffect("Invulnerable", INVULNERABLE_BIT, [17], "Invulnerable"),
                new ConditionEffect("Armored", ARMORED_BIT, [16], "Armored"),
                new ConditionEffect("Armor Broken", ARMOR_BROKEN_BIT, [55], "Armor Broken"),
                new ConditionEffect("Hexed", HEXED_BIT, [42], "Hexed"),
                new ConditionEffect("Ninja Speedy", NINJA_SPEEDY_BIT, [0], "Ninja Speedy"),
                new ConditionEffect("Unstable", UNSTABLE_BIT, [56], "Unstable"),
                new ConditionEffect("Darkness", DARKNESS_BIT, [57], "Darkness"),
                new ConditionEffect("Slowed Immune", SLOWED_IMMUNE_BIT, null, "Slowed Immune"),
                new ConditionEffect("Dazed Immune", DAZED_IMMUNE_BIT, null, "Dazed Immune"),
                new ConditionEffect("Paralyzed Immune", PARALYZED_IMMUNE_BIT, null, "Paralyzed Immune"),
                new ConditionEffect("Petrify", PETRIFIED_BIT, null, "Petrify"),
                new ConditionEffect("Petrify Immune", PETRIFIED_IMMUNE_BIT, null, "Petrify Immune"),
                new ConditionEffect("Pet Disable", PET_EFFECT_ICON_BIT, [27], "Pet Stasis", true),
                new ConditionEffect("Curse", CURSE_BIT, [58], "Curse"),
                new ConditionEffect("Curse Immune", CURSE_IMMUNE_BIT, null, "Curse Immune"),
                new ConditionEffect("HP Boost", HP_BOOST_BIT, [32], "HP Boost", true),
                new ConditionEffect("MP Boost", MP_BOOST_BIT, [33], "MP Boost", true),
                new ConditionEffect("Att Boost", ATT_BOOST_BIT, [34], "Att Boost", true),
                new ConditionEffect("Def Boost", DEF_BOOST_BIT, [35], "Def Boost", true),
                new ConditionEffect("Spd Boost", SPD_BOOST_BIT, [36], "Spd Boost", true),
                new ConditionEffect("Vit Boost", VIT_BOOST_BIT, [38], "Vit Boost", true),
                new ConditionEffect("Wis Boost", WIS_BOOST_BIT, [39], "Wis Boost", true),
                new ConditionEffect("Dex Boost", DEX_BOOST_BIT, [37], "Dex Boost", true),
                new ConditionEffect("Silenced", SILENCED_BIT, [33], "Silenced"),
                new ConditionEffect("Exposed", EXPOSED_BIT, [59], "Exposed"),
                new ConditionEffect("Energized", ENERGIZED_BIT, [60], "Energized"),
                new ConditionEffect("HP Debuff", HP_DEBUFF_BIT, [48], "HP Debuff", true),
                new ConditionEffect("MP Debuff", MP_DEBUFF_BIT, [49], "MP Debuff", true),
                new ConditionEffect("Att Debuff", ATT_DEBUFF_BIT, [50], "Att Debuff", true),
                new ConditionEffect("Def Debuff", DEF_DEBUFF_BIT, [51], "Def Debuff", true),
                new ConditionEffect("Spd Debuff", SPD_DEBUFF_BIT, [52], "Spd Debuff", true),
                new ConditionEffect("Vit Debuff", VIT_DEBUFF_BIT, [54], "Vit Debuff", true),
                new ConditionEffect("Wis Debuff", WIS_DEBUFF_BIT, [55], "Wis Debuff", true),
                new ConditionEffect("Dex Debuff", DEX_DEBUFF_BIT, [53], "Dex Debuff", true),
                new ConditionEffect("Inspired", INSPIRED_BIT, [62], "Inspired")
            ];

    private static var conditionEffectFromName_:Object = null;
    private static var bitToIcon_:Object = null;
    private static var bitToIcon2_:Object = null;

    public var name_:String;
    public var bit_:uint;
    public var iconOffsets_:Array;
    public var localizationKey_:String;
    public var icon16Bit_:Boolean;

    public function ConditionEffect(_arg_1:String, _arg_2:uint, _arg_3:Array, _arg_4:String = "", _arg_5:Boolean = false) {
        super();
        this.name_ = _arg_1;
        this.bit_ = _arg_2;
        this.iconOffsets_ = _arg_3;
        this.localizationKey_ = _arg_4;
        this.icon16Bit_ = _arg_5;
    }

    public static function getConditionEffectFromName(_arg_1:XML):uint {
        var _local2:* = 0;
        var _local3:int = 0;
        if (conditionEffectFromName_ == null) {
            conditionEffectFromName_ = {};
            _local2 = uint(effects_.length);
            _local3 = 0;
            while (_local3 < _local2) {
                conditionEffectFromName_[effects_[_local3].name_] = _local3;
                _local3++;
            }
        }
        return conditionEffectFromName_[_arg_1];
    }

    public static function getConditionEffectIcons(_arg_1:uint, _arg_2:Vector.<BitmapData>, _arg_3:int):void {
        var _local5:* = 0;
        var _local4:* = 0;
        var _local6:* = undefined;
        while (_arg_1 != 0) {
            _local5 = uint(_arg_1 & _arg_1 - 1);
            _local4 = uint(_arg_1 ^ _local5);
            _local6 = getIconsFromBit(_local4);
            if (_local6) {
                _arg_2.push(_local6[_arg_3 % _local6.length]);
            }
            _arg_1 = _local5;
        }
    }

    public static function getConditionEffectIcons2(_arg_1:uint, _arg_2:Vector.<BitmapData>, _arg_3:int):void {
        var _local5:* = 0;
        var _local4:* = 0;
        var _local6:* = undefined;
        while (_arg_1 != 0) {
            _local5 = uint(_arg_1 & _arg_1 - 1);
            _local4 = uint(_arg_1 ^ _local5);
            _local6 = getIconsFromBit2(_local4);
            if (_local6 != null) {
                _arg_2.push(_local6[_arg_3 % _local6.length]);
            }
            _arg_1 = _local5;
        }
    }

    private static function getIconsFromBit(_arg_1:uint):Vector.<BitmapData> {
        var _local4:int = 0;
        var _local6:* = 0;
        var _local7:* = null;
        var _local2:* = undefined;
        var _local5:int = 0;
        var _local3:* = null;
        if (bitToIcon_ == null) {
            bitToIcon_ = {};
            _local7 = new Matrix();
            _local7.translate(4, 4);
            _local4 = 0;
            while (_local4 < 32) {
                _local2 = null;
                if (effects_[_local4].iconOffsets_) {
                    _local2 = new Vector.<BitmapData>();
                    _local6 = uint(effects_[_local4].iconOffsets_.length);
                    _local5 = 0;
                    while (_local5 < _local6) {
                        _local3 = new BitmapData(16, 16, true, 0);
                        _local3.draw(AssetLibrary.getImageFromSet("lofiInterface2", effects_[_local4].iconOffsets_[_local5]), _local7);
                        _local3 = GlowRedrawer.outlineGlow(_local3, 0xFFFFFFFF);
                        _local3.applyFilter(_local3, _local3.rect, PointUtil.ORIGIN, GLOW_FILTER);
                        _local2.push(_local3);
                        _local5++;
                    }
                }
                bitToIcon_[effects_[_local4].bit_] = _local2;
                _local4++;
            }
        }
        return bitToIcon_[_arg_1];
    }

    private static function getIconsFromBit2(_arg_1:uint):Vector.<BitmapData> {
        var _local8:* = 0;
        var _local7:* = undefined;
        var _local5:* = null;
        var _local6:* = null;
        var _local9:* = null;
        var _local2:int = 0;
        var _local3:int = 0;
        var _local4:uint = effects_.length;
        if (bitToIcon2_ == null) {
            bitToIcon2_ = [];
            _local7 = new Vector.<BitmapData>();
            _local6 = new Matrix();
            _local6.translate(4, 4);
            _local9 = new Matrix();
            _local9.translate(1.5, 1.5);
            _local2 = 32;
            while (_local2 < _local4) {
                _local7 = null;
                if (effects_[_local2].iconOffsets_) {
                    _local7 = new Vector.<BitmapData>();
                    _local8 = uint(effects_[_local2].iconOffsets_.length);
                    _local3 = 0;
                    while (_local3 < _local8) {
                        if (effects_[_local2].icon16Bit_) {
                            _local5 = new BitmapData(18, 18, true, 0);
                            _local5.draw(AssetLibrary.getImageFromSet("lofiInterfaceBig", effects_[_local2].iconOffsets_[_local3]), _local9);
                        } else {
                            _local5 = new BitmapData(16, 16, true, 0);
                            _local5.draw(AssetLibrary.getImageFromSet("lofiInterface2", effects_[_local2].iconOffsets_[_local3]), _local6);
                        }
                        _local5 = GlowRedrawer.outlineGlow(_local5, 0xFFFFFFFF);
                        _local5.applyFilter(_local5, _local5.rect, PointUtil.ORIGIN, GLOW_FILTER);
                        _local7.push(_local5);
                        _local3++;
                    }
                }
                bitToIcon2_[effects_[_local2].bit_] = _local7;
                _local2++;
            }
        }
        if (bitToIcon2_ && bitToIcon2_[_arg_1]) {
            return bitToIcon2_[_arg_1];
        }
        return null;
    }
}
}