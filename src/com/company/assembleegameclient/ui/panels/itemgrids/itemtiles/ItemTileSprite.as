package com.company.assembleegameclient.ui.panels.itemgrids.itemtiles {
import com.company.assembleegameclient.objects.ObjectLibrary;
import com.company.util.PointUtil;

import flash.display.Bitmap;
import flash.display.Sprite;
import flash.filters.ColorMatrixFilter;
import flash.geom.Matrix;

import kabam.rotmg.text.view.BitmapTextFactory;
import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;
import kabam.rotmg.ui.view.components.PotionSlotView;

public class ItemTileSprite extends Sprite {

    protected static const DIM_FILTER:Array = [new ColorMatrixFilter([0.4, 0, 0, 0, 0, 0, 0.4, 0, 0, 0, 0, 0, 0.4, 0, 0, 0, 0, 0, 1, 0])];

    private static const IDENTITY_MATRIX:Matrix = new Matrix();

    private static const DOSE_MATRIX:Matrix = function ():Matrix {
        var _local1:* = new Matrix();
        _local1.translate(8, 7);
        return _local1;
    }();

    public function ItemTileSprite() {
        super();
        this.itemBitmap = new Bitmap();
        addChild(this.itemBitmap);
        this.itemId = -1;
    }
    public var itemId:int;
    public var itemBitmap:Bitmap;
    private var bitmapFactory:BitmapTextFactory;

    public function setDim(_arg_1:Boolean):void {
        filters = !!_arg_1 ? DIM_FILTER : null;
    }

    public function setType(_arg_1:int):void {
        this.itemId = _arg_1;
        this.drawTile();
    }

    public function drawTile():void {
        var _local2:* = null;
        var _local1:* = null;
        var _local3:* = null;
        var _local4:int = this.itemId;
        if (_local4 != -1) {
            _local2 = ObjectLibrary.getRedrawnTextureFromType(_local4, 80, true);
            _local1 = ObjectLibrary.xmlLibrary_[_local4];
            if (_local1 && "Doses" in _local1 && this.bitmapFactory) {
                _local2 = _local2.clone();
                _local3 = this.bitmapFactory.make(new StaticStringBuilder(_local1.Doses), 12, 0xffffff, false, IDENTITY_MATRIX, false);
                _local3.applyFilter(_local3, _local3.rect, PointUtil.ORIGIN, PotionSlotView.READABILITY_SHADOW_2);
                _local2.draw(_local3, DOSE_MATRIX);
            }
            if (_local1 && "Quantity" in _local1 && this.bitmapFactory) {
                _local2 = _local2.clone();
                _local3 = this.bitmapFactory.make(new StaticStringBuilder(_local1.Quantity), 12, 0xffffff, false, IDENTITY_MATRIX, false);
                _local3.applyFilter(_local3, _local3.rect, PointUtil.ORIGIN, PotionSlotView.READABILITY_SHADOW_2);
                _local2.draw(_local3, DOSE_MATRIX);
            }
            this.itemBitmap.bitmapData = _local2;
            this.itemBitmap.x = -_local2.width / 2;
            this.itemBitmap.y = -_local2.height / 2;
            visible = true;
        } else {
            visible = false;
        }
    }

    public function setBitmapFactory(_arg_1:BitmapTextFactory):void {
        this.bitmapFactory = _arg_1;
    }
}
}
