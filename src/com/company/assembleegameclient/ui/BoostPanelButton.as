package com.company.assembleegameclient.ui {
import com.company.assembleegameclient.objects.Player;
import com.company.assembleegameclient.util.TextureRedrawer;
import com.company.util.AssetLibrary;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.Event;

public class BoostPanelButton extends Sprite {

    public static const IMAGE_SET_NAME:String = "lofiInterfaceBig";

    public static const IMAGE_ID:int = 22;

    public function BoostPanelButton(_arg_1:Player) {
        var _local3:* = null;
        super();
        this.player = _arg_1;
        var _local2:BitmapData = AssetLibrary.getImageFromSet("lofiInterfaceBig", 22);
        var _local4:BitmapData = TextureRedrawer.redraw(_local2, 20, true, 0);
        _local3 = new Bitmap(_local4);
        _local3.x = -7;
        _local3.y = -10;
        addChild(_local3);
        addEventListener("mouseOver", this.onButtonOver, false, 0, true);
        addEventListener("mouseOut", this.onButtonOut, false, 0, true);
    }
    private var boostPanel:BoostPanel;
    private var player:Player;

    private function positionBoostPanel():void {
        this.boostPanel.x = -this.boostPanel.width;
        this.boostPanel.y = -this.boostPanel.height;
    }

    private function onButtonOver(_arg_1:Event):void {
        var _local2:* = new BoostPanel(this.player);
        this.boostPanel = _local2;
        addChild(_local2);
        this.boostPanel.resized.add(this.positionBoostPanel);
        this.positionBoostPanel();
    }

    private function onButtonOut(_arg_1:Event):void {
        if (this.boostPanel) {
            this.boostPanel.dispose();
            removeChild(this.boostPanel);
        }
    }
}
}
