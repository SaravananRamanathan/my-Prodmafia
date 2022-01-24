package com.company.assembleegameclient.screens {

import flash.events.Event;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;

import com.company.assembleegameclient.account.ui.Frame;
import com.company.assembleegameclient.account.ui.TextInputField;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.ui.DeprecatedClickableText;
import com.company.util.KeyCodes;

import kabam.rotmg.core.StaticInjectorContext;
import kabam.rotmg.core.model.PlayerModel;
import kabam.rotmg.dialogs.control.CloseDialogsSignal;
import kabam.rotmg.text.view.TextFieldDisplayConcrete;
import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;

import org.swiftsuspenders.Injector;
import starling.events.KeyboardEvent;

public class MultiboxOptions extends Frame{
    private var title:TextFieldDisplayConcrete;
    private var closeBox: CloseDialogsSignal;
    private var setLead: DeprecatedClickableText;
    private var model: PlayerModel;
    private var leaderName: TextInputField;

    public function MultiboxOptions() {
        super("", "Close", "Save");
        this.createTitle();
        this.initialize();
        this.leftButton_.addEventListener(MouseEvent.CLICK, onClose);
        this.rightButton_.addEventListener(MouseEvent.CLICK, onSave);
        addEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDown);
        addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
        this.makeUI();
    }

    private function createTitle():void {
        this.title = new TextFieldDisplayConcrete().setSize(13).setColor(0xB3B3B3);
        this.title.setStringBuilder(new StaticStringBuilder("Multi"));
        this.title.filters = [new DropShadowFilter(0, 0, 0)];
        this.title.x = 5;
        this.title.y = 3;
        addChild(this.title);
    }

    private function initialize():void {
        var injector:Injector = StaticInjectorContext.getInjector();
        this.closeBox = injector.getInstance(CloseDialogsSignal);
        this.model = injector.getInstance(PlayerModel);
    }

    private function makeUI():void {
        this.leaderName = new TextInputField("Leader name", false);
        this.leaderName.inputText_.setText(Parameters.data.multiLeader);
        addTextInputField(this.leaderName);
        this.setLead = new DeprecatedClickableText(12, false, "Set this client as leader");
        this.setLead.addEventListener(MouseEvent.CLICK, onSetMeLead);
        addNavigationText(this.setLead);
    }

    private function onSetMeLead(_arg_1:MouseEvent):void {
        this.leaderName.inputText_.setText(this.model.getName());
    }

    private function onKeyDown(_arg_1:KeyboardEvent):void {
        if (_arg_1.keyCode == KeyCodes.ENTER) {
            this.onSave(null);
        }
    }

    private function onRemove(_arg_1:Event):void {
        removeEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDown);
        removeEventListener(Event.REMOVED_FROM_STAGE, this.onRemove);
    }

    private function onSave(_arg_1: MouseEvent):void {
        Parameters.data.multiLeader = this.leaderName.text();
        Parameters.save();
        this.closeBox.dispatch();
    }

    private function onClose(_arg_1: MouseEvent):void {
        this.closeBox.dispatch();
    }
    }
}
