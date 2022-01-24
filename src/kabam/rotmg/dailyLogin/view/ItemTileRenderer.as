package kabam.rotmg.dailyLogin.view {
import com.company.assembleegameclient.objects.ObjectLibrary;
import com.company.assembleegameclient.ui.panels.itemgrids.itemtiles.EquipmentTile;
import com.company.assembleegameclient.ui.panels.itemgrids.itemtiles.ItemTile;
import com.company.assembleegameclient.ui.tooltip.EquipmentToolTip;
import com.company.assembleegameclient.ui.tooltip.TextToolTip;
import com.company.assembleegameclient.ui.tooltip.ToolTip;

import flash.display.Bitmap;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.filters.ColorMatrixFilter;
import flash.geom.Matrix;

import kabam.rotmg.constants.ItemConstants;
import kabam.rotmg.core.StaticInjectorContext;
import kabam.rotmg.core.signals.HideTooltipsSignal;
import kabam.rotmg.core.signals.ShowTooltipSignal;
import kabam.rotmg.text.model.TextKey;
import kabam.rotmg.text.view.BitmapTextFactory;
import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;

import org.swiftsuspenders.Injector;

public class ItemTileRenderer extends Sprite {

    protected static const DIM_FILTER:Array = [new ColorMatrixFilter([0.4, 0, 0, 0, 0, 0, 0.4, 0, 0, 0, 0, 0, 0.4, 0, 0, 0, 0, 0, 1, 0])];

    private static const IDENTITY_MATRIX:Matrix = new Matrix();

    private static const DOSE_MATRIX:Matrix = function ():Matrix {
        var _local1:Matrix = new Matrix();
        _local1.translate(10, 5);
        return _local1;
    }();

    public function ItemTileRenderer(_arg_1:int) {
        super();
        this.itemId = _arg_1;
        this.itemBitmap = new Bitmap();
        addChild(this.itemBitmap);
        this.drawTile();
        this.addEventListener("mouseOver", this.onTileHover);
        this.addEventListener("mouseOut", this.onTileOut);
    }
    private var itemId:int;
    private var bitmapFactory:BitmapTextFactory;
    private var tooltip:ToolTip;
    private var itemBitmap:Bitmap;

    public function drawTile():void {
        var _local2:* = null;
        var _local1:* = null;
        var _local4:* = null;
        var _local3:* = null;
        var _local5:int = this.itemId;
        if (_local5 != -1) {
            _local2 = ObjectLibrary.getRedrawnTextureFromType(_local5, 100, true);
            _local1 = ObjectLibrary.xmlLibrary_[_local5];
            if (_local1 && _local1.hasOwnProperty("Doses") && this.bitmapFactory) {
                _local2 = _local2.clone();
                _local4 = this.bitmapFactory.make(new StaticStringBuilder(_local1.Doses), 12, 0xffffff, false, IDENTITY_MATRIX, false);
                _local2.draw(_local4, DOSE_MATRIX);
            }
            if (_local1 && _local1.hasOwnProperty("Quantity") && this.bitmapFactory) {
                _local2 = _local2.clone();
                _local3 = this.bitmapFactory.make(new StaticStringBuilder(_local1.Quantity), 12, 0xffffff, false, IDENTITY_MATRIX, false);
                _local2.draw(_local3, DOSE_MATRIX);
            }
            this.itemBitmap.bitmapData = _local2;
            this.itemBitmap.x = -_local2.width / 2;
            this.itemBitmap.y = -_local2.width / 2;
            visible = true;
        } else {
            visible = false;
        }
    }

    private function addToolTipToTile(_arg_1:ItemTile):void {
        var _local3:* = null;
        if (this.itemId > 0) {
            this.tooltip = new EquipmentToolTip(this.itemId, null, -1, "");
        } else {
            if (_arg_1 is EquipmentTile) {
                _local3 = ItemConstants.itemTypeToName((_arg_1 as EquipmentTile).itemType);
            } else {
                _local3 = "item.toolTip";
            }
            this.tooltip = new TextToolTip(0x363636, 0x9b9b9b, null, "item.emptySlot", 200, {"itemType": TextKey.wrapForTokenResolution(_local3)});
        }
        this.tooltip.attachToTarget(_arg_1);
        var _local2:Injector = StaticInjectorContext.getInjector();
        var _local4:ShowTooltipSignal = _local2.getInstance(ShowTooltipSignal);
        _local4.dispatch(this.tooltip);
    }

    private function onTileOut(_arg_1:MouseEvent):void {
        var _local2:Injector = StaticInjectorContext.getInjector();
        var _local3:HideTooltipsSignal = _local2.getInstance(HideTooltipsSignal);
        _local3.dispatch();
    }

    private function onTileHover(_arg_1:MouseEvent):void {
        if (!stage) {
            return;
        }
        var _local2:ItemTile = _arg_1.currentTarget as ItemTile;
        this.addToolTipToTile(_local2);
    }
}
}
