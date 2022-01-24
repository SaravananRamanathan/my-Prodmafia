package com.company.assembleegameclient.util {
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.util.redrawers.GlowRedrawer;
import com.company.util.AssetLibrary;
import com.company.util.PointUtil;

import flash.display.BitmapData;
import flash.display.Shader;
import flash.display.ShaderData;
import flash.filters.GlowFilter;
import flash.filters.ShaderFilter;
import flash.geom.ColorTransform;
import flash.geom.Matrix;
import flash.geom.Rectangle;
import flash.utils.ByteArray;
import flash.utils.Dictionary;

public class TextureRedrawer {
    public static const magic:int = 12;
    public static const minSize:int = 24;
    private static const BORDER:int = 4;

    public static var OUTLINE_FILTER:GlowFilter = new GlowFilter(0, 0.8, 1.4, 1.4, 255, 1, false, false);
    public static var sharedTexture_:BitmapData = null;

    internal static var rect:Rectangle = new Rectangle();
    internal static var ct:ColorTransform = new ColorTransform();

    private static var caches:Dictionary = new Dictionary();
    private static var faceCaches:Dictionary = new Dictionary();
    private static var redrawCaches:Dictionary = new Dictionary();
    private static var textureShaderEmbed_:Class = TextureRedrawer_textureShaderEmbed;
    private static var textureShaderData_:ByteArray = new textureShaderEmbed_() as ByteArray;
    private static var shader:Shader = new Shader(textureShaderData_);
    private static var colorTexture1:BitmapData = new BitmapData(1, 1, false, 0);
    private static var colorTexture2:BitmapData = new BitmapData(1, 1, false, 0);

    public static function redraw(tex:BitmapData, size:int, padBottom:Boolean, glowColor:uint,
                                  useCache:Boolean = true, sMult:Number = 5, buffer:Number = 0, glowMult:Number = 1.4) : BitmapData {
        var hash:String = getHash(size, padBottom, glowColor, sMult, glowMult);
        if (useCache && isCached(tex, hash))
            return redrawCaches[tex][hash];
        var modTex:BitmapData = resize(tex, null, size, padBottom, 0, 0, sMult);
        modTex = GlowRedrawer.outlineGlow(modTex, glowColor, glowMult, useCache);
        if (useCache)
            cache(tex, hash, modTex);
        return modTex;
    }

    public static function resize(_arg_1:BitmapData, _arg_2:BitmapData, _arg_3:int, _arg_4:Boolean, _arg_5:int, _arg_6:int, _arg_7:Number = 5):BitmapData {
        if (_arg_2 && (_arg_5 != 0 || _arg_6 != 0)) {
            _arg_1 = retexture(_arg_1, _arg_2, _arg_5, _arg_6);
            _arg_3 = _arg_3 / 5;
        }
        _arg_5 = _arg_1.width;
        _arg_6 = _arg_1.height;
        var _local10:int = _arg_7 * (_arg_3 / 100) * _arg_5;
        var _local9:int = _arg_7 * (_arg_3 / 100) * _arg_6;
        var _local11:Matrix = new Matrix();
        _local11.scale(_local10 / _arg_5, _local9 / _arg_6);
        _local11.translate(12, 12);
        var _local8:BitmapData = new BitmapData(_local10 + 24, _local9 + (!!_arg_4 ? 12 : 1) + 12, true, 0);
        _local8.draw(_arg_1, _local11);
        return _local8;
    }


    public static function redrawSolidSquare(param1:uint, param2:int, param3:int, param4:int = 0) : BitmapData {
        var _loc6_:uint = ((param2 * 907 + param3) * 911 + param4) * 919 + param1;
        var _loc5_:BitmapData = caches[_loc6_];
        if(_loc5_) {
            return _loc5_;
        }
        _loc5_ = new BitmapData(param2 + 8,param3 + 8,true,0);
        rect.x = 4;
        rect.y = 4;
        rect.width = param2;
        rect.height = param3;
        _loc5_.fillRect(rect,4278190080 | param1);
        if(param4 != -1) {
            _loc5_.applyFilter(_loc5_,_loc5_.rect,PointUtil.ORIGIN,param4 == 0?OUTLINE_FILTER:new GlowFilter(param4,0.8,1.4,1.4,255,1,false,false));
        }
        caches[_loc6_] = _loc5_;
        return _loc5_;
    }

    public static function clearCache() : void {
        var tex:* = null;
        var dict:* = null;

        for each (dict in caches) {
            for each (tex in dict) {
                tex.dispose();
                delete dict[tex];
            }
            delete caches[dict];
        }
        caches = new Dictionary();

        for each (dict in faceCaches) {
            for each (tex in dict) {
                tex.dispose();
                delete dict[tex];
            }
            delete faceCaches[dict];
        }
        faceCaches = new Dictionary();

        for each (dict in redrawCaches) {
            for each (tex in dict) {
                tex.dispose();
                delete dict[tex];
            }
            delete redrawCaches[dict];
        }
        redrawCaches = new Dictionary();
    }

    public static function redrawFace(_arg_1:BitmapData, _arg_2:Number):BitmapData {
        if (_arg_2 == 1) {
            return _arg_1;
        }
        if (faceCaches[_arg_2] == null) {
            faceCaches[_arg_2] = new Dictionary();
        }
        var _local3:BitmapData = faceCaches[_arg_2][_arg_1];
        if (_local3) {
            return _local3;
        }
        _local3 = _arg_1.clone();
        ct.redMultiplier = _arg_2;
        ct.greenMultiplier = _arg_2;
        ct.blueMultiplier = _arg_2;
        _local3.colorTransform(_local3.rect, ct);
        faceCaches[_arg_2][_arg_1] = _local3;
        return _local3;
    }

    public static function retextureNoSizeChange(_arg_1:BitmapData, _arg_2:BitmapData, _arg_3:int, _arg_4:int):BitmapData {
        var _local6:ShaderData = null;
        var _local9:Matrix = new Matrix();
        _local9.scale(5, 5);
        var _local5:BitmapData = new BitmapData(_arg_1.width * 5, _arg_1.height * 5, true, 0);
        _local5.draw(_arg_1, _local9);
        var _local8:BitmapData = getTexture(_arg_3 >= 0 ? _arg_3 : 0, colorTexture1);
        var _local7:BitmapData = getTexture(_arg_4 >= 0 ? _arg_4 : 0, colorTexture2);
        if (!Parameters.data.evenLowerGraphics) {
            _local6 = shader.data;
            _local6.src.input = _local5;
            _local6.mask.input = _arg_2;
            _local6.texture1.input = _local8;
            _local6.texture2.input = _local7;
            _local6.texture1Size.value = [_arg_3 == 0 ? 0 : _local8.width];
            _local6.texture2Size.value = [_arg_4 == 0 ? 0 : _local7.width];
            _local5.applyFilter(_local5, _local5.rect, PointUtil.ORIGIN, new ShaderFilter(shader));
        }
        return _local5;
    }

    private static function getHash(size:int, padBottom:Boolean, glowColor:uint,
                                    sMult:Number, glowMult:Number) : String {
        var h:int = (padBottom ? (1 << 27) : 0) | (size * sMult);
        if (glowColor == 0)
            return h + glowMult.toString();

        return h.toString() + glowColor.toString() + glowMult.toString();
    }

    private static function cache(tex:BitmapData, hash:String, modifiedTex:BitmapData) : void {
        if (!(tex in redrawCaches))
            redrawCaches[tex] = new Dictionary();

        redrawCaches[tex][hash] = modifiedTex;
    }

    private static function isCached(tex:BitmapData, hash:String) : Boolean {
        return tex in redrawCaches && hash in redrawCaches[tex];
    }

    private static function getTexture(_arg_1:int, _arg_2:BitmapData):BitmapData {
        var _local4:* = null;
        var _local3:* = _arg_1 >> 24 & 255;
        if (_local3 == 0) {
            _local4 = _arg_2;
        } else if (_local3 == 1) {
            _arg_2.setPixel(0, 0, _arg_1 & 16777215);
            _local4 = _arg_2;
        } else if (_local3 == 4) {
            _local4 = AssetLibrary.getImageFromSet("textile4x4", _arg_1 & 16777215);
        } else if (_local3 == 5) {
            _local4 = AssetLibrary.getImageFromSet("textile5x5", _arg_1 & 16777215);
        } else if (_local3 == 9) {
            _local4 = AssetLibrary.getImageFromSet("textile9x9", _arg_1 & 16777215);
        } else if (_local3 == 10) {
            _local4 = AssetLibrary.getImageFromSet("textile10x10", _arg_1 & 16777215);
        } else if (_local3 == 255) {
            _local4 = sharedTexture_;
        } else {
            _local4 = _arg_2;
        }
        return _local4;
    }

    private static function retexture(_arg_1:BitmapData, _arg_2:BitmapData, _arg_3:int, _arg_4:int):BitmapData {
        var _local6:* = null;
        var _local9:Matrix = new Matrix();
        _local9.scale(5, 5);
        var _local5:BitmapData = new BitmapData(_arg_1.width * 5, _arg_1.height * 5, true, 0);
        _local5.draw(_arg_1, _local9);
        var _local8:BitmapData = getTexture(_arg_3 >= 0 ? _arg_3 : 0, colorTexture1);
        var _local7:BitmapData = getTexture(_arg_4 >= 0 ? _arg_4 : 0, colorTexture2);
        if (!Parameters.data.evenLowerGraphics) {
            _local6 = shader.data;
            _local6.src.input = _local5;
            _local6.mask.input = _arg_2;
            _local6.texture1.input = _local8;
            _local6.texture2.input = _local7;
            _local6.texture1Size.value = [_arg_3 == 0 ? 0 : _local8.width];
            _local6.texture2Size.value = [_arg_4 == 0 ? 0 : _local7.width];
            _local5.applyFilter(_local5, _local5.rect, PointUtil.ORIGIN, new ShaderFilter(shader));
        }
        return _local5;
    }

    public function TextureRedrawer() {
        super();
    }
}
}
