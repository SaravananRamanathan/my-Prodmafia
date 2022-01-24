package com.company.assembleegameclient.objects {
import com.company.assembleegameclient.game.GameSprite;
import com.company.assembleegameclient.map.Camera;
import com.company.assembleegameclient.map.Map;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.ui.panels.Panel;
import com.company.assembleegameclient.ui.panels.PortalPanel;
import com.company.assembleegameclient.util.RandomUtil;

import flash.display.BitmapData;
import flash.display.GraphicsBitmapFill;
import flash.geom.Point;

import kabam.rotmg.core.StaticInjectorContext;
import kabam.rotmg.text.view.BitmapTextFactory;
import kabam.rotmg.text.view.stringBuilder.StringBuilder;

public class Portal extends GameObject implements IInteractiveObject {

    private static const NAME_PARSER:RegExp = /(^\s+)\s\(([0-9]+)\/[0-9]+\)/;

    public function Portal(_arg_1:XML) {
        super(_arg_1);
        isInteractive_ = true;
        this.nexusPortal_ = "NexusPortal" in _arg_1;
        this.lockedPortal_ = "LockedPortal" in _arg_1;
        if (Parameters.fameBotPortalId == this.objectId_) {
            Parameters.fameBotPortal = this;
            Parameters.fameBotPortalPoint = new Point(RandomUtil.plusMinus(0.3) + this.x_, RandomUtil.plusMinus(0.3) + this.y_);
        }
    }
    public var nexusPortal_:Boolean;
    public var lockedPortal_:Boolean;
    public var active_:Boolean = true;

    override public function addTo(param1:Map, param2:Number, param3:Number) : Boolean {
        var _local4:Boolean = super.addTo(param1,param2,param3);
        if(Parameters.data.autoEnterPortals) {
            if(Parameters.player && Parameters.player.getDistFromSelf(param2,param3) <= 4) {
                Parameters.player.follow(param2,param3);
            }
        }
        return _local4;
    }

    override protected function makeNameBitmapData():BitmapData {
        var _local2:StringBuilder = new PortalNameParser().makeBuilder(name_);
        var _local1:BitmapTextFactory = StaticInjectorContext.getInjector().getInstance(BitmapTextFactory);
        return _local1.make(_local2, 16, 0xffffff, true, IDENTITY_MATRIX, true);
    }

    override public function draw(_arg_1:Vector.<GraphicsBitmapFill>, _arg_2:Camera, _arg_3:int):void {
        super.draw(_arg_1, _arg_2, _arg_3);
        if (this.nexusPortal_) {
            drawName(_arg_1, _arg_2, false);
        }
    }

    public function getPanel(_arg_1:GameSprite):Panel {
        return new PortalPanel(_arg_1, this);
    }
}
}
