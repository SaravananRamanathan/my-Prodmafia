package kabam.rotmg.dailyLogin.view {
import com.company.assembleegameclient.util.TextureRedrawer;
import com.company.util.AssetLibrary;
import com.company.util.GraphicsUtil;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.GraphicsPath;
import flash.display.GraphicsSolidFill;
import flash.display.GraphicsStroke;
import flash.display.IGraphicsData;
import flash.display.Shape;
import flash.display.Sprite;
import flash.geom.Rectangle;

import kabam.rotmg.assets.services.IconFactory;
import kabam.rotmg.dailyLogin.config.CalendarSettings;
import kabam.rotmg.dailyLogin.model.CalendarDayModel;
import kabam.rotmg.text.view.TextFieldDisplayConcrete;
import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;

public class CalendarDayBox extends Sprite {


    public static function drawRectangleWithCuts(_arg_1:Array, _arg_2:int, _arg_3:int, _arg_4:uint, _arg_5:Number, _arg_6:Vector.<IGraphicsData>, _arg_7:GraphicsPath):Sprite {
        var _local9:Shape = new Shape();
        var _local10:Shape = new Shape();
        var _local8:Sprite = new Sprite();
        _local8.addChild(_local9);
        _local8.addChild(_local10);
        GraphicsUtil.clearPath(_arg_7);
        GraphicsUtil.drawCutEdgeRect(0, 0, _arg_2, _arg_3, 4, _arg_1, _arg_7);
        _local9.graphics.clear();
        _local9.graphics.drawGraphicsData(_arg_6);
        var _local11:GraphicsSolidFill = new GraphicsSolidFill(_arg_4, _arg_5);
        GraphicsUtil.clearPath(_arg_7);
        var _local12:Vector.<IGraphicsData> = new <IGraphicsData>[_local11, _arg_7, GraphicsUtil.END_FILL];
        GraphicsUtil.drawCutEdgeRect(0, 0, _arg_2, _arg_3, 4, _arg_1, _arg_7);
        _local10.graphics.drawGraphicsData(_local12);
        _local10.cacheAsBitmap = true;
        _local10.visible = false;
        return _local8;
    }

    public function CalendarDayBox(_arg_1:CalendarDayModel, _arg_2:int, _arg_3:Boolean) {
        var _local6:* = null;
        var _local5:* = null;
        var _local8:* = null;
        var _local7:* = null;
        fill_ = new GraphicsSolidFill(0x363636, 1);
        fillCurrent_ = new GraphicsSolidFill(4889165, 1);
        fillBlack_ = new GraphicsSolidFill(0, 0.7);
        lineStyle_ = new GraphicsStroke(2, false, "normal", "none", "round", 3, new GraphicsSolidFill(0xffffff));
        path_ = new GraphicsPath(new Vector.<int>(), new Vector.<Number>());
        graphicsDataBackground = new <IGraphicsData>[lineStyle_, fill_, path_, GraphicsUtil.END_FILL, GraphicsUtil.END_STROKE];
        graphicsDataBackgroundCurrent = new <IGraphicsData>[lineStyle_, fillCurrent_, path_, GraphicsUtil.END_FILL, GraphicsUtil.END_STROKE];
        graphicsDataClaimedOverlay = new <IGraphicsData>[lineStyle_, fillBlack_, path_, GraphicsUtil.END_FILL, GraphicsUtil.END_STROKE];
        super();
        this.day = _arg_1;
        var _local4:int = Math.ceil(_arg_1.dayNumber / 7);
        var _local9:int = Math.ceil(_arg_2 / 7);
        if (_arg_1.dayNumber == 1) {
            if (_local9 == 1) {
                this.boxCuts = [1, 0, 0, 1];
            } else {
                this.boxCuts = [1, 0, 0, 0];
            }
        } else if (_arg_1.dayNumber == _arg_2) {
            if (_local9 == 1) {
                this.boxCuts = [0, 1, 1, 0];
            } else {
                this.boxCuts = [0, 0, 1, 0];
            }
        } else if (_local4 == 1 && _arg_1.dayNumber % 7 == 0) {
            this.boxCuts = [0, 1, 0, 0];
        } else if (_local4 == _local9 && (_arg_1.dayNumber - 1) % 7 == 0) {
            this.boxCuts = [0, 0, 0, 1];
        } else {
            this.boxCuts = [0, 0, 0, 0];
        }
        this.drawBackground(this.boxCuts, _arg_3);
        if (_arg_1.gold == 0 && _arg_1.itemID > 0) {
            _local6 = new ItemTileRenderer(_arg_1.itemID);
            addChild(_local6);
            _local6.x = Math.round(35);
            _local6.y = Math.round(35);
        }
        if (_arg_1.gold > 0) {
            _local5 = new Bitmap();
            _local5.bitmapData = IconFactory.makeCoin(80);
            addChild(_local5);
            _local5.x = Math.round(35 - _local5.width / 2);
            _local5.y = Math.round(35 - _local5.height / 2);
        }
        this.displayDayNumber(_arg_1.dayNumber);
        if (_arg_1.claimKey != "") {
            _local8 = AssetLibrary.getImageFromSet("lofiInterface", 52);
            _local8.colorTransform(new Rectangle(0, 0, _local8.width, _local8.height), CalendarSettings.GREEN_COLOR_TRANSFORM);
            _local8 = TextureRedrawer.redraw(_local8, 40, true, 0);
            this.redDot = new Bitmap(_local8);
            this.redDot.x = 70 - Math.round(this.redDot.width / 2) - 10;
            this.redDot.y = -Math.round(this.redDot.width / 2) + 10;
            addChild(this.redDot);
        }
        if (_arg_1.quantity > 1 || _arg_1.gold > 0) {
            _local7 = new TextFieldDisplayConcrete().setSize(14).setColor(0xffffff).setTextWidth(70).setAutoSize("right");
            _local7.setStringBuilder(new StaticStringBuilder("x" + (_arg_1.gold > 0 ? _arg_1.gold.toString() : _arg_1.quantity.toString())));
            _local7.y = 52;
            _local7.x = -2;
            addChild(_local7);
        }
        if (_arg_1.isClaimed) {
            this.markAsClaimed();
        }
    }
    public var day:CalendarDayModel;
    private var fill_:GraphicsSolidFill;
    private var fillCurrent_:GraphicsSolidFill;
    private var fillBlack_:GraphicsSolidFill;
    private var lineStyle_:GraphicsStroke;
    private var path_:GraphicsPath;
    private var graphicsDataBackground:Vector.<IGraphicsData>;
    private var graphicsDataBackgroundCurrent:Vector.<IGraphicsData>;
    private var graphicsDataClaimedOverlay:Vector.<IGraphicsData>;
    private var redDot:Bitmap;
    private var boxCuts:Array;

    public function getDay():CalendarDayModel {
        return this.day;
    }

    public function markAsClaimed():void {
        if (this.redDot && this.redDot.parent) {
            removeChild(this.redDot);
        }
        var _local3:BitmapData = AssetLibrary.getImageFromSet("lofiInterfaceBig", 11);
        _local3 = TextureRedrawer.redraw(_local3, 60, true, 2997032);
        var _local2:Bitmap = new Bitmap(_local3);
        _local2.x = Math.round((70 - _local2.width) / 2);
        _local2.y = Math.round((70 - _local2.height) / 2);
        var _local1:Sprite = drawRectangleWithCuts(this.boxCuts, 70, 70, 0, 1, this.graphicsDataClaimedOverlay, this.path_);
        addChild(_local1);
        addChild(_local2);
    }

    public function drawBackground(_arg_1:Array, _arg_2:Boolean):void {
        addChild(drawRectangleWithCuts(_arg_1, 70, 70, 0x363636, 1, !!_arg_2 ? this.graphicsDataBackgroundCurrent : this.graphicsDataBackground, this.path_));
    }

    private function displayDayNumber(_arg_1:int):void {
        var _local2:* = null;
        _local2 = new TextFieldDisplayConcrete().setSize(16).setColor(0xffffff).setTextWidth(70);
        _local2.setBold(true);
        _local2.setStringBuilder(new StaticStringBuilder(_arg_1.toString()));
        _local2.x = 4;
        _local2.y = 4;
        addChild(_local2);
    }
}
}
