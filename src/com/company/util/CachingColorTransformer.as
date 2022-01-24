package com.company.util {
import flash.display.BitmapData;
import flash.filters.BitmapFilter;
import flash.geom.ColorTransform;
import flash.geom.Point;
import flash.utils.Dictionary;

public class CachingColorTransformer {

    private static var bds_:Dictionary = new Dictionary();

    private static var colorTransform:ColorTransform = new ColorTransform(1, 1, 1);

    public static function transformBitmapData(tex:BitmapData, ct:ColorTransform) : BitmapData {
        var modTex:BitmapData = null;
        var cachedBd:Object = bds_[tex];
        var ctHash:uint = ((ct.redMultiplier * 907 + ct.greenMultiplier)
                * 911 + ct.blueMultiplier) * 919 + ct.alphaMultiplier;

        if (cachedBd)
            modTex = cachedBd[ctHash];
        else {
            cachedBd = {};
            bds_[tex] = cachedBd;
        }

        if (modTex == null) {
            modTex = tex.clone();
            modTex.colorTransform(modTex.rect, ct);
            cachedBd[ctHash] = modTex;
        }

        return modTex;
    }

    public static function filterBitmapData(_arg_1:BitmapData, _arg_2:BitmapFilter):BitmapData {
        var _local4:* = null;
        var _local3:* = bds_[_arg_1];
        if (_local3) {
            _local4 = _local3[_arg_2];
        } else {
            _local3 = {};
            bds_[_arg_1] = _local3;
        }
        if (_local4 == null) {
            _local4 = _arg_1.clone();
            _local4.applyFilter(_local4, _local4.rect, new Point(), _arg_2);
            _local3[_arg_2] = _local4;
        }
        return _local4;
    }

    public static function alphaBitmapData(_arg_1:BitmapData, _arg_2:Number):BitmapData {
        colorTransform.alphaMultiplier = _arg_2 * 100 * 0.01;
        return transformBitmapData(_arg_1, colorTransform);
    }

    public static function clear():void {
        var _local1:* = null;
        var _local2:* = null;
        var _local6:int = 0;
        var _local5:* = bds_;
        for each(_local1 in bds_) {
            var _local4:int = 0;
            var _local3:* = _local1;
            for each(_local2 in _local1) {
                _local2.dispose();
            }
        }
        bds_ = new Dictionary();
    }

    public function CachingColorTransformer() {
        super();
    }
}
}
