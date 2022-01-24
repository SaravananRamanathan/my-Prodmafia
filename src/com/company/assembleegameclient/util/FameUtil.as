package com.company.assembleegameclient.util {
import com.company.assembleegameclient.objects.ObjectLibrary;
import com.company.rotmg.graphics.StarGraphic;
import com.company.util.AssetLibrary;

import flash.display.BitmapData;
import flash.display.Sprite;
import flash.filters.DropShadowFilter;
import flash.geom.ColorTransform;

import io.decagames.rotmg.ui.sliceScaling.SliceScalingBitmap;
import io.decagames.rotmg.ui.texture.TextureParser;

public class FameUtil {

    public static const MAX_STARS:int = 80;

    public static const STARS:Vector.<int> = new <int>[20, 150, 400, 800, 2000];

    private static const lightBlueCT:ColorTransform = new ColorTransform(0.541176470588235, 0.596078431372549, 0.870588235294118);

    private static const darkBlueCT:ColorTransform = new ColorTransform(0.192156862745098, 0.301960784313725, 0.858823529411765);

    private static const redCT:ColorTransform = new ColorTransform(0.756862745098039, 0.152941176470588, 0.176470588235294);

    private static const orangeCT:ColorTransform = new ColorTransform(0.968627450980392, 0.576470588235294, 0.117647058823529);

    private static const yellowCT:ColorTransform = new ColorTransform(1, 1, 0);

    public static const COLORS:Vector.<ColorTransform> = new <ColorTransform>[lightBlueCT, darkBlueCT, redCT, orangeCT, yellowCT];

    public static function maxStars():int {
        return ObjectLibrary.playerChars_.length * STARS.length;
    }

    public static function numStars(_arg_1:int):int {
        var _local2:int = 0;
        _local2 = 0;
        while (_local2 < STARS.length && _arg_1 >= STARS[_local2]) {
            _local2++;
        }
        return _local2;
    }

    public static function nextStarFame(_arg_1:int, _arg_2:int):int {
        var _local3:int = 0;
        var _local4:int = Math.max(_arg_1, _arg_2);
        _local3 = 0;
        while (_local3 < STARS.length) {
            if (STARS[_local3] > _local4) {
                return STARS[_local3];
            }
            _local3++;
        }
        return -1;
    }

    public static function numAllTimeStars(_arg_1:int, _arg_2:int, _arg_3:XML):int {
        var _local5:int = 0;
        var _local4:int = 0;
        for each(var _local6:XML in _arg_3.ClassStats) {
            if (_arg_1 == int(_local6.@objectType)) {
                _local4 = _local6.BestFame;
            } else {
                _local5 = _local5 + FameUtil.numStars(_local6.BestFame);
            }
        }
        _local5 = _local5 + FameUtil.numStars(Math.max(_local4, _arg_2));
        return _local5;
    }

    public static function numStarsToBigImage(_arg_1:int, _arg_2:int = 0):Sprite {
        var _local3:Sprite = numStarsToImage(_arg_1, _arg_2);
        _local3.filters = [new DropShadowFilter(0, 0, 0, 1, 4, 4, 2)];
        _local3.scaleX = 1.4;
        _local3.scaleY = 1.4;
        return _local3;
    }

    public static function numStarsToImage(_arg_1:int, _arg_2:int = 0):Sprite {
        var _local4:* = null;
        var _local3:* = null;
        if (_arg_2 >= 0 && _arg_2 <= 4) {
            _local4 = new Sprite();
            _local4.addChild(challengerStarBackground(_arg_2));
            _local3 = getStar(_arg_1);
            _local3.x = (_local4.width - _local3.width) / 2;
            _local3.y = (_local4.height - _local3.height) / 2;
            _local4.addChild(_local3);
            return _local4;
        }
        return getStar(_arg_1);
    }

    public static function challengerStarBackground(_arg_1:int):SliceScalingBitmap {
        var _local2:* = null;
        switch (int(_arg_1)) {
            case 0:
                _local2 = "original_allStar";
                break;
            case 1:
                _local2 = "challenger_firstPlace";
                break;
            case 2:
                _local2 = "challenger_secondPlace";
                break;
            case 3:
                _local2 = "challenger_thirdPlace";
                break;
            case 4:
                _local2 = "challenger_topPlace";
        }
        return TextureParser.instance.getSliceScalingBitmap("UI", _local2);
    }

    public static function numStarsToIcon(_arg_1:int, _arg_2:int = 0):Sprite {
        var _local4:Sprite = numStarsToImage(_arg_1, _arg_2);
        var _local3:Sprite = new Sprite();
        _local3.addChild(_local4);
        _local3.filters = [new DropShadowFilter(0, 0, 0, 0.5, 6, 6, 1)];
        return _local3;
    }

    public static function getFameIcon():BitmapData {
        var _local1:BitmapData = AssetLibrary.getImageFromSet("lofiObj3", 224);
        return TextureRedrawer.redraw(_local1, 40, true, 0);
    }

    private static function getStar(_arg_1:int):Sprite {
        var _local2:Sprite = new StarGraphic();
        if (_arg_1 < ObjectLibrary.playerChars_.length) {
            _local2.transform.colorTransform = lightBlueCT;
        } else if (_arg_1 < ObjectLibrary.playerChars_.length * 2) {
            _local2.transform.colorTransform = darkBlueCT;
        } else if (_arg_1 < ObjectLibrary.playerChars_.length * 3) {
            _local2.transform.colorTransform = redCT;
        } else if (_arg_1 < ObjectLibrary.playerChars_.length * 4) {
            _local2.transform.colorTransform = orangeCT;
        } else if (_arg_1 < ObjectLibrary.playerChars_.length * 5) {
            _local2.transform.colorTransform = yellowCT;
        }
        return _local2;
    }

    public function FameUtil() {
        super();
    }
}
}
