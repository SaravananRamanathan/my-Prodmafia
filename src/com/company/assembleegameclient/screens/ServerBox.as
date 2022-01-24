package com.company.assembleegameclient.screens {
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;

import kabam.rotmg.servers.api.Server;
import kabam.rotmg.text.view.TextFieldDisplayConcrete;
import kabam.rotmg.text.view.stringBuilder.LineBuilder;
import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;

public class ServerBox extends Sprite {

    public static const WIDTH:int = 384;

    public static const HEIGHT:int = 52;

    public function ServerBox(_arg_1:Server) {
        super();
        this.value_ = _arg_1 == null ? null : _arg_1.name;
        this.nameText_ = new TextFieldDisplayConcrete().setSize(18).setColor(0xffffff).setBold(true);
        if (_arg_1 == null) {
            this.nameText_.setStringBuilder(new LineBuilder().setParams("ServerBox.best"));
        } else {
            this.nameText_.setStringBuilder(new StaticStringBuilder(_arg_1.name));
        }
        this.nameText_.filters = [new DropShadowFilter(0, 0, 0, 1, 8, 8)];
        this.nameText_.x = 18;
        this.nameText_.setVerticalAlign("middle");
        this.nameText_.y = 26;
        addChild(this.nameText_);
        this.addUI(_arg_1);
        this.draw();
        addEventListener("mouseOver", this.onMouseOver);
        addEventListener("rollOut", this.onRollOut);
    }
    public var value_:String;
    private var nameText_:TextFieldDisplayConcrete;
    private var statusText_:TextFieldDisplayConcrete;
    private var selected_:Boolean = false;
    private var over_:Boolean = false;

    public function setSelected(_arg_1:Boolean):void {
        this.selected_ = _arg_1;
        this.draw();
    }

    private function addUI(server:Server) : void {
        var onTextChanged:Function = function ():void {
            makeStatusText(color, text);
        };

        if (server != null) {
            var color:uint = 0xff00;
            var text:String = "ServerBox.normal";
            if (server.isFull()) {
                color = 0xff0000;
                text = "ServerBox.full";
            } else if (server.isCrowded()) {
                color = 16549442;
                text = "ServerBox.crowded";
            }
            this.nameText_.textChanged.addOnce(onTextChanged);
        }
    }

    private function makeStatusText(_arg_1:uint, _arg_2:String):void {
        this.statusText_ = new TextFieldDisplayConcrete().setSize(18).setColor(_arg_1).setBold(true).setAutoSize("center");
        this.statusText_.setStringBuilder(new LineBuilder().setParams(_arg_2));
        this.statusText_.filters = [new DropShadowFilter(0, 0, 0, 1, 8, 8)];
        this.statusText_.x = 288;
        this.statusText_.y = 26 - this.nameText_.height / 2;
        addChild(this.statusText_);
    }

    private function draw():void {
        graphics.clear();
        if (this.selected_) {
            graphics.lineStyle(2, 0xffff8f);
        }
        graphics.beginFill(!!this.over_ ? 0x6b6b6b : 6052956, 1);
        graphics.drawRect(0, 0, 384, 52);
        if (this.selected_) {
            graphics.lineStyle();
        }
    }

    private function onMouseOver(_arg_1:MouseEvent):void {
        this.over_ = true;
        this.draw();
    }

    private function onRollOut(_arg_1:MouseEvent):void {
        this.over_ = false;
        this.draw();
    }
}
}
