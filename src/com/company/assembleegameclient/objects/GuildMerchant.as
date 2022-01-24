package com.company.assembleegameclient.objects {
import com.company.assembleegameclient.ui.tooltip.TextToolTip;
import com.company.assembleegameclient.ui.tooltip.ToolTip;

import flash.display.BitmapData;

public class GuildMerchant extends SellableObject implements IInteractiveObject {


    public function GuildMerchant(_arg_1:XML) {
        super(_arg_1);
        price_ = _arg_1.Price;
        currency_ = 2;
        this.description_ = _arg_1.Description;
        guildRankReq_ = 30;
    }
    public var description_:String;

    override public function soldObjectName():String {
        return ObjectLibrary.typeToDisplayId_[objectType_];
    }

    override public function soldObjectInternalName():String {
        var _local1:XML = ObjectLibrary.xmlLibrary_[objectType_];
        return _local1.@id.toString();
    }

    override public function getTooltip():ToolTip {
        return new TextToolTip(0x363636, 0x9b9b9b, this.soldObjectName(), this.description_, 200);
    }

    override public function getSellableType():int {
        return objectType_;
    }

    override public function getIcon():BitmapData {
        return ObjectLibrary.getRedrawnTextureFromType(objectType_, 80, true);
    }
}
}
