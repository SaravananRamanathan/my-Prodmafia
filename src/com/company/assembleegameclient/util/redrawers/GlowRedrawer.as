package com.company.assembleegameclient.util.redrawers {
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.util.TextureRedrawer;
import com.company.util.PointUtil;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.filters.GlowFilter;
import flash.geom.Matrix;
import flash.utils.Dictionary;

public class GlowRedrawer {
    private static const GLOW_FILTER:GlowFilter = new GlowFilter(0, 0.3, 12, 12, 2, 1, false, false);
    private static const GLOW_FILTER_ALT:GlowFilter = new GlowFilter(0, 0.5, 16, 16, 3, 1, false, false);
    private static const GLOW_FILTER_SUPPORT:GlowFilter = new GlowFilter(0, 0.3, 12, 12, 3, 1, false, false);
    private static const GLOW_FILTER_SUPPORT_DARK:GlowFilter = new GlowFilter(0, 0.4, 6, 6, 2, 1, false, false);
    private static const GLOW_FILTER_SUPPORT_OUTLINE:GlowFilter = new GlowFilter(0, 1, 2, 2, 255, 1, false, false);
    private static const GLOW_FILTER_SUPPORT_ALT:GlowFilter = new GlowFilter(0, 0.3, 12, 12, 4, 1, false, false);
    private static const GLOW_FILTER_SUPPORT_DARK_ALT:GlowFilter = new GlowFilter(0, 0.4, 6, 6, 2, 1, false, false);
    private static const GLOW_FILTER_SUPPORT_OUTLINE_ALT:GlowFilter = new GlowFilter(0, 1, 2, 2, 255, 1, false, false);

    private static var tempMatrix_:Matrix = new Matrix();
    private static var glowHashes:Dictionary = new Dictionary();

    public function GlowRedrawer() {
        super();
    }

    public static function outlineGlow(tex:BitmapData, color:uint, mult:Number = 1.4,
                                       useCache:Boolean = false, supporter:Boolean = false) : BitmapData {
        var hash:String = getHash(color, mult, supporter);
        if (useCache && isCached(tex, hash))
            return glowHashes[tex][hash];

        var modTex:BitmapData = tex.clone();
        tempMatrix_.identity();
        tempMatrix_.scale(tex.width / 256, tex.height / 256);
        modTex.draw(new Bitmap(tex), null, null, "alpha");
        TextureRedrawer.OUTLINE_FILTER.blurX = mult;
        TextureRedrawer.OUTLINE_FILTER.blurY = mult;
        TextureRedrawer.OUTLINE_FILTER.color = 0;
        modTex.applyFilter(modTex, modTex.rect, PointUtil.ORIGIN, TextureRedrawer.OUTLINE_FILTER);
        if (!Parameters.data.evenLowerGraphics) {
            if (color != 0xFFFFFFFF) {
                if (color != 0) {
                    if (!supporter) {
                        GLOW_FILTER_ALT.color = color;
                        modTex.applyFilter(modTex, modTex.rect, PointUtil.ORIGIN, GLOW_FILTER_ALT);
                    } else {
                        GLOW_FILTER_SUPPORT_ALT.color = color;
                        GLOW_FILTER_SUPPORT_DARK_ALT.color = color - 2385408;
                        GLOW_FILTER_SUPPORT_OUTLINE_ALT.color = color;
                        modTex.applyFilter(modTex, modTex.rect, PointUtil.ORIGIN, GLOW_FILTER_SUPPORT_OUTLINE_ALT);
                        modTex.applyFilter(modTex, modTex.rect, PointUtil.ORIGIN, GLOW_FILTER_SUPPORT_DARK_ALT);
                        modTex.applyFilter(modTex, modTex.rect, PointUtil.ORIGIN, GLOW_FILTER_SUPPORT_ALT);
                    }
                } else if (!supporter) {
                    GLOW_FILTER.color = color;
                    modTex.applyFilter(modTex, modTex.rect, PointUtil.ORIGIN, GLOW_FILTER);
                } else {
                    GLOW_FILTER_SUPPORT.color = color;
                    GLOW_FILTER_SUPPORT_DARK.color = color - 2385408;
                    GLOW_FILTER_SUPPORT_OUTLINE.color = color;
                    modTex.applyFilter(modTex, modTex.rect, PointUtil.ORIGIN, GLOW_FILTER_SUPPORT_OUTLINE);
                    modTex.applyFilter(modTex, modTex.rect, PointUtil.ORIGIN, GLOW_FILTER_SUPPORT_DARK);
                    modTex.applyFilter(modTex, modTex.rect, PointUtil.ORIGIN, GLOW_FILTER_SUPPORT);
                }
            }
        }

        if (useCache)
            cache(tex, color, mult, supporter, modTex);

        return modTex;
    }

    public static function clearCache() : void {
        for each (var dict:Dictionary in glowHashes) {
            for each (var tex:BitmapData in dict) {
                tex.dispose();
                delete dict[tex];
            }
            delete glowHashes[dict];
        }
        glowHashes = new Dictionary();
    }

    private static function cache(tex:BitmapData, color:uint, mult:Number,
                                  supporter:Boolean, modTex:BitmapData) : void {
        var hash:String = getHash(color, mult, supporter);
        if (tex in glowHashes && hash in glowHashes[tex])
            glowHashes[tex][hash] = modTex;
        else {
            var dict:Dictionary = new Dictionary();
            dict[hash] = modTex;
            glowHashes[tex] = dict;
        }
    }

    private static function isCached(tex:BitmapData, hash:String) : Boolean {
        return glowHashes[tex] != null && glowHashes[tex][hash] != null;
    }

    private static function getHash(color:uint, mult:Number, supporter:Boolean) : String {
        return mult.toString() + color.toString() + supporter ? "1" : "0";
    }
}
}