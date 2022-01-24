package com.company.assembleegameclient.account.ui {
import com.company.assembleegameclient.game.GameSprite;
import com.company.assembleegameclient.game.events.GuildResultEvent;

import flash.events.MouseEvent;

import kabam.rotmg.core.StaticInjectorContext;
import kabam.rotmg.game.model.GameModel;

import org.osflash.signals.Signal;

public class CreateGuildFrame extends Frame {


    public const close:Signal = new Signal();

    public function CreateGuildFrame(_arg_1:GameSprite) {
        super("CreateGuildFrame.title", "Frame.cancel", "CreateGuildFrame.rightButton", "/createGuild");
        this.gs_ = _arg_1;
        this.name_ = new TextInputField("CreateGuildFrame.name", false);
        this.name_.inputText_.restrict = "A-Za-z ";
        this.name_.inputText_.maxChars = 20;
        addTextInputField(this.name_);
        addPlainText("Frame.maxChar", {"maxChars": 20});
        addPlainText("Frame.restrictChar");
        addPlainText("CreateGuildFrame.warning");
        leftButton_.addEventListener("click", this.onCancel);
        rightButton_.addEventListener("click", this.onCreate);
    }
    private var name_:TextInputField;
    private var gs_:GameSprite;

    private function onCancel(_arg_1:MouseEvent):void {
        this.close.dispatch();
    }

    private function onCreate(_arg_1:MouseEvent):void {
        this.gs_.addEventListener("GUILDRESULTEVENT", this.onResult);
        this.gs_.gsc_.createGuild(this.name_.text());
        disable();
    }

    private function onResult(_arg_1:GuildResultEvent):void {
        var _local2:* = null;
        this.gs_.removeEventListener("GUILDRESULTEVENT", this.onResult);
        if (_arg_1.success_) {
            _local2 = StaticInjectorContext.getInjector().getInstance(GameModel).player;
            if (_local2 != null) {
                _local2.fame_ = _local2.fame_ - 1000;
            }
            this.close.dispatch();
        } else {
            this.name_.setError(_arg_1.errorKey, _arg_1.errorTokens);
            enable();
        }
    }
}
}
