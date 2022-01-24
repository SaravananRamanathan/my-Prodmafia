package io.decagames.rotmg.seasonalEvent.SeasonalLeaderBoard {
import com.company.assembleegameclient.util.TextureRedrawer;
import com.company.util.AssetLibrary;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.filters.DropShadowFilter;
import flash.geom.Rectangle;

import kabam.rotmg.text.view.TextFieldDisplayConcrete;
import kabam.rotmg.text.view.stringBuilder.LineBuilder;
import kabam.rotmg.ui.UIUtils;

public class SeasonalLeaderBoardButton extends Sprite {

    public static const IMAGE_NAME:String = "lofiObj4";

    public static const IMAGE_ID:int = 240;

    public static const NOTIFICATION_BACKGROUND_WIDTH:Number = 120;

    public static const NOTIFICATION_BACKGROUND_HEIGHT:Number = 25;

    public function SeasonalLeaderBoardButton() {
        super();
        this.icon = TextureRedrawer.redraw(AssetLibrary.getImageFromSet("lofiObj4", 4 * 60), 40, true, 0);
        this.background = UIUtils.makeHUDBackground(2 * 60, 25);
        this.bitmap = new Bitmap(this.icon);
        this.bitmap.x = -5;
        this.bitmap.y = -8;
        this.text = new TextFieldDisplayConcrete().setSize(16).setColor(0xffffff);
        this.text.setStringBuilder(new LineBuilder().setParams("Leaderboard"));
        this.text.filters = [new DropShadowFilter(0, 0, 0, 1, 4, 4, 2)];
        this.text.setVerticalAlign("bottom");
        var _local1:Rectangle = this.bitmap.getBounds(this);
        this.text.x = _local1.right - 10;
        this.text.y = _local1.bottom - 10 - 3;
        this._buttonMask = new Sprite();
        this._buttonMask.graphics.beginFill(0xff0000, 0);
        this._buttonMask.graphics.drawRect(0, 0, 2 * 60, 25);
        this._buttonMask.graphics.endFill();
        addChild(this.background);
        addChild(this.text);
        addChild(this.bitmap);
        addChild(this._buttonMask);
        mouseEnabled = true;
    }
    protected var _buttonMask:Sprite;
    private var bitmap:Bitmap;
    private var background:Sprite;
    private var icon:BitmapData;
    private var text:TextFieldDisplayConcrete;

    public function get button():Sprite {
        return this._buttonMask;
    }
}
}
