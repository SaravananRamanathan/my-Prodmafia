package com.company.assembleegameclient.objects {
import com.company.assembleegameclient.map.Camera;
import com.company.assembleegameclient.util.TextureRedrawer;

import flash.display.BitmapData;
import flash.text.TextField;
import flash.text.TextFormat;

import kabam.rotmg.core.StaticInjectorContext;
import kabam.rotmg.language.model.StringMap;
import kabam.rotmg.text.model.FontModel;

public class Sign extends GameObject {


    public function Sign(_arg_1:XML) {
        super(_arg_1);
        texture = null;
        this.stringMap = StaticInjectorContext.getInjector().getInstance(StringMap);
        this.fontModel = StaticInjectorContext.getInjector().getInstance(FontModel);
    }
    private var stringMap:StringMap;
    private var fontModel:FontModel;

    override protected function getTexture(_arg_1:Camera, _arg_2:int):BitmapData {
        if (texture != null) {
            return texture;
        }
        var _local6:TextField = new TextField();
        _local6.multiline = true;
        _local6.wordWrap = false;
        _local6.autoSize = "left";
        _local6.textColor = 0xffffff;
        _local6.embedFonts = true;
        var _local4:TextFormat = new TextFormat();
        _local4.align = "center";
        _local4.font = this.fontModel.getFont().getName();
        _local4.size = 24;
        _local4.color = 0xffffff;
        _local4.bold = true;
        _local6.defaultTextFormat = _local4;
        var _local3:String = this.stringMap.getValue(this.stripCurlyBrackets(name_));
        if (_local3 == null) {
            _local3 = name_ != null ? name_ : "null";
        }
        _local6.text = _local3.split("|").join("\n");
        var _local5:BitmapData = new BitmapData(_local6.width, _local6.height, true, 0);
        _local5.draw(_local6);
        texture = TextureRedrawer.redraw(_local5, size_, false, 0);
        return texture;
    }

    private function stripCurlyBrackets(_arg_1:String):String {
        var _local2:Boolean = _arg_1 != null && _arg_1.charAt(0) == "{" && _arg_1.charAt(_arg_1.length - 1) == "}";
        return !!_local2 ? _arg_1.substr(1, _arg_1.length - 2) : _arg_1;
    }
}
}
