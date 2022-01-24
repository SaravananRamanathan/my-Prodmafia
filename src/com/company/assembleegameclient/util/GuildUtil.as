package com.company.assembleegameclient.util {
import com.company.util.AssetLibrary;

import flash.display.BitmapData;

public class GuildUtil {

    public static const INITIATE:int = 0;

    public static const MEMBER:int = 10;

    public static const OFFICER:int = 20;

    public static const LEADER:int = 30;

    public static const FOUNDER:int = 40;

    public static const MAX_MEMBERS:int = 50;

    public static function rankToString(_arg_1:int):String {
        var _local2:* = _arg_1;
        switch (_local2) {
            case 0:
                return wrapInBraces("GuildUtil.initiate");
            case 10:
                return wrapInBraces("GuildUtil.member");
            case 20:
                return wrapInBraces("GuildUtil.officer");
            case 30:
                return wrapInBraces("GuildUtil.leader");
            case 40:
                return wrapInBraces("GuildUtil.founder");
            default:
                return "Unknown " + _arg_1;
        }
    }

    public static function rankToIcon(_arg_1:int, _arg_2:int):BitmapData {
        var _local4:* = null;
        var _local5:* = _arg_1;
        switch (_local5) {
            case 0:
                _local4 = AssetLibrary.getImageFromSet("lofiInterfaceBig", 20);
                break;
            case 10:
                _local4 = AssetLibrary.getImageFromSet("lofiInterfaceBig", 19);
                break;
            case 20:
                _local4 = AssetLibrary.getImageFromSet("lofiInterfaceBig", 18);
                break;
            case 30:
                _local4 = AssetLibrary.getImageFromSet("lofiInterfaceBig", 17);
                break;
            case 40:
                _local4 = AssetLibrary.getImageFromSet("lofiInterfaceBig", 16);
        }
        return TextureRedrawer.redraw(_local4, _arg_2, true, 0, true);
    }

    public static function guildFameIcon(_arg_1:int):BitmapData {
        var _local2:BitmapData = AssetLibrary.getImageFromSet("lofiObj3", 226);
        return TextureRedrawer.redraw(_local2, _arg_1, true, 0, true);
    }

    public static function allowedChange(_arg_1:int, _arg_2:int, _arg_3:int):Boolean {
        if (_arg_2 == _arg_3) {
            return false;
        }
        if (_arg_1 == 40 && _arg_2 < 40 && _arg_3 < 40) {
            return true;
        }
        if (_arg_1 == 30 && _arg_2 < 30 && _arg_3 <= 30) {
            return true;
        }
        if (_arg_1 == 20 && _arg_2 < 20 && _arg_3 < 20) {
            return true;
        }
        return false;
    }

    public static function promotedRank(_arg_1:int):int {
        var _local2:* = _arg_1;
        switch (_local2) {
            case 0:
                return 10;
            case 10:
                return 20;
            case 20:
                return 30;
            default:
                return 40;
        }
    }

    public static function canPromote(_arg_1:int, _arg_2:int):Boolean {
        var _local3:int = promotedRank(_arg_2);
        return allowedChange(_arg_1, _arg_2, _local3);
    }

    public static function demotedRank(_arg_1:int):int {
        var _local2:* = _arg_1;
        switch (_local2) {
            case 20:
                return 10;
            case 30:
                return 20;
            case 40:
                return 30;
            default:
                return 0;
        }
    }

    public static function canDemote(_arg_1:int, _arg_2:int):Boolean {
        var _local3:int = demotedRank(_arg_2);
        return allowedChange(_arg_1, _arg_2, _local3);
    }

    public static function canRemove(_arg_1:int, _arg_2:int):Boolean {
        return _arg_1 >= 20 && _arg_2 < _arg_1;
    }

    public static function getRankIconIdByRank(_arg_1:int):Number {
        var _local2:* = NaN;
        var _local3:* = _arg_1;
        switch (_local3) {
            case 0:
                _local2 = 20;
                break;
            case 10:
                _local2 = 19;
                break;
            case 20:
                _local2 = 18;
                break;
            case 30:
                _local2 = 17;
                break;
            case 40:
                _local2 = 16;
        }
        return _local2;
    }

    private static function wrapInBraces(_arg_1:String):String {
        return "{" + _arg_1 + "}";
    }

    public function GuildUtil() {
        super();
    }
}
}
