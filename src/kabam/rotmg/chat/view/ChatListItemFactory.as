package kabam.rotmg.chat.view {
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.util.FameUtil;
import com.company.assembleegameclient.util.StageProxy;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.geom.Matrix;
import flash.text.TextField;
import flash.text.TextFormat;

import io.decagames.rotmg.supportCampaign.data.SupporterCampaignModel;

import kabam.rotmg.chat.model.ChatMessage;
import kabam.rotmg.chat.model.ChatModel;
import kabam.rotmg.text.model.FontModel;
import kabam.rotmg.text.view.BitmapTextFactory;
import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;
import kabam.rotmg.text.view.stringBuilder.StringBuilder;

public class ChatListItemFactory {

    private static const IDENTITY_MATRIX:Matrix = new Matrix();

    private static const SERVER:String = "";

    private static const CLIENT:String = "*Client*";

    private static const HELP:String = "*Help*";

    private static const ERROR:String = "*Error*";

    private static const GUILD:String = "*Guild*";

    private static const SYNC:String = "*Sync*";

    private static const ALERT:String = "*Alert*";

    private static const testField:TextField = makeTestTextField();

    public static function isTradeMessage(_arg_1:int, _arg_2:int, _arg_3:String):Boolean {
        return (_arg_1 == -1 || _arg_2 == -1) && _arg_3.search("/trade") != -1;
    }

    public static function isGuildMessage(_arg_1:String):Boolean {
        return _arg_1 == "*Guild*";
    }

    private static function makeTestTextField():TextField {
        var _local1:TextField = new TextField();
        var _local2:TextFormat = new TextFormat();
        _local2.size = 15;
        _local2.bold = true;
        _local1.defaultTextFormat = _local2;
        return _local1;
    }

    public function ChatListItemFactory() {
        delete_ = new Vector.<DisplayObject>();
        super();
    }
    [Inject]
    public var factory:BitmapTextFactory;
    [Inject]
    public var model:ChatModel;
    [Inject]
    public var fontModel:FontModel;
    [Inject]
    public var supporterCampaignModel:SupporterCampaignModel;
    [Inject]
    public var stageProxy:StageProxy;
    private var message:ChatMessage;
    private var buffer:Vector.<DisplayObject>;
    private var delete_:Vector.<DisplayObject>;

    public function make(_arg_1:ChatMessage, _arg_2:Boolean = false):ChatListItem {
        var _local8:int = 0;
        var _local4:* = null;
        var _local7:* = 0;
        var _local9:Boolean = false;
        this.message = _arg_1;
        if (this.buffer != null) {
            for each(var _local3:DisplayObject in buffer) {
                delete_.push(_local3);
            }
        }
        this.buffer = new Vector.<DisplayObject>();
        this.setTFonTestField();
        this.makeStarsIcon();
        this.makeWhisperText();
        this.makeNameText();
        this.makeMessageText();
        var _local6:Boolean = _arg_1.numStars == -1 || _arg_1.objectId == -1;
        var _local5:* = _arg_1.name;
        if (_local6 && _arg_1.text.search("/trade ") != -1) {
            _local8 = _local8 + 7;
            _local4 = "";
            _local7 = _local8;
            _local8 = _local8 + 10;
            while (_local7 < _local8) {
                if (_arg_1.text.charAt(_local7) != "\"") {
                    _local4 = _local4 + _arg_1.text.charAt(_local7);
                    _local7++;
                    continue;
                }
                break;
            }
            _local5 = _local4;
            _local9 = true;
        }
        return new ChatListItem(this.buffer, this.model.bounds.width, this.model.lineHeight, _arg_2, _arg_1.objectId, _local5, _arg_1.recipient == "*Guild*", _local9);
    }

    public function dispose():void {
        var _local3:int = 0;
        var _local2:* = null;
        var _local1:uint = this.delete_.length;
        _local3 = 0;
        while (_local3 < _local1) {
            _local2 = delete_[_local3] as Bitmap;
            if (_local2) {
                _local2.bitmapData.dispose();
                _local2.bitmapData = null;
                _local2 = null;
                delete_[_local3] = null;
            }
            _local3++;
        }
        this.delete_.length = 0;
    }

    private function makeStarsIcon():void {
        var _local1:int = this.message.numStars;
        var _local2:int = this.message.starBg;
        if (_local1 >= 0) {
            this.buffer.push(FameUtil.numStarsToIcon(_local1, _local2));
        }
    }

    private function makeWhisperText():void {
        var _local1:* = null;
        var _local2:* = null;
        if (this.message.isWhisper && !this.message.isToMe) {
            _local1 = new StaticStringBuilder("To: ");
            _local2 = this.getBitmapData(_local1, 0xf0ff);
            this.buffer.push(new Bitmap(_local2));
        }
    }

    private function makeNameText():void {
        if (!this.isSpecialMessageType()) {
            this.bufferNameText();
        }
    }

    private function isSpecialMessageType():Boolean {
        var _local1:String = this.message.name;
        return _local1 == "" || _local1 == "*Client*" || _local1 == "*Help*" || _local1 == "*Error*" || _local1 == "*Guild*";
    }

    private function bufferNameText():void {
        var _local1:StringBuilder = new StaticStringBuilder(this.processName());
        var _local2:BitmapData = this.getBitmapData(_local1, this.getNameColor());
        this.buffer.push(new Bitmap(_local2));
    }

    private function processName():String {
        var _local1:String = this.message.isWhisper && !this.message.isToMe ? this.message.recipient : this.message.name;
        if (_local1.charAt(0) == "#" || _local1.charAt(0) == "@") {
            _local1 = _local1.substr(1);
        }
        return "<" + _local1 + ">";
    }

    private function makeMessageText():void {
        var _local3:int = 0;
        var _local2:Array = this.message.text.split("\n");
        var _local1:uint = _local2.length;
        if (_local1 > 0) {
            this.makeNewLineFreeMessageText(_local2[0], true);
            _local3 = 1;
            while (_local3 < _local1) {
                this.makeNewLineFreeMessageText(_local2[_local3], false);
                _local3++;
            }
        }
    }

    private function makeNewLineFreeMessageText(_arg_1:String, _arg_2:Boolean):void {
        var _local6:* = null;
        var _local9:int = 0;
        var _local3:* = 0;
        var _local4:* = 0;
        var _local5:int = 0;
        var _local11:int = 0;
        var _local10:int = 0;
        var _local8:* = _arg_1;
        if (_arg_2) {
            var _local13:int = 0;
            var _local12:* = this.buffer;
            for each(_local6 in this.buffer) {
                _local11 = _local11 + _local6.width;
            }
            _local10 = _local8.length;
            testField.text = _local8;
            while (testField.textWidth >= this.model.bounds.width - _local11) {
                _local10 = _local10 - 10;
                testField.text = _local8.substr(0, _local10);
            }
            if (_local10 < _local8.length) {
                _local9 = _local8.substr(0, _local10).lastIndexOf(" ");
                _local10 = _local9 == 0 || _local9 == -1 ? _local10 : _local9 + 1;
            }
            this.makeMessageLine(_local8.substr(0, _local10));
        }
        var _local7:int = _local8.length;
        if (_local7 > _local10) {
            _local3 = uint(_local8.length);
            _local4 = _local10;
            while (_local4 < _local7) {
                testField.text = _local8.substr(_local4, _local3);
                while (testField.textWidth >= this.model.bounds.width) {
                    _local3 = uint(_local3 - 2);
                    testField.text = _local8.substr(_local4, _local3);
                }
                _local5 = _local3;
                if (_local8.length > _local4 + _local3) {
                    _local5 = _local8.substr(_local4, _local3).lastIndexOf(" ");
                    _local5 = _local5 == 0 || _local5 == -1 ? _local3 : _local5 + 1;
                }
                this.makeMessageLine(_local8.substr(_local4, _local5));
                _local4 = int(_local4 + _local5);
            }
        }
    }

    private function makeMessageLine(_arg_1:String):void {
        var _local2:StringBuilder = new StaticStringBuilder(_arg_1);
        var _local3:BitmapData = this.getBitmapData(_local2, this.getTextColor());
        this.buffer.push(new Bitmap(_local3));
    }

    private function getNameColor():uint {
        if (this.message.name.charAt(0) == "#") {
            return 16754688;
        }
        if (this.message.name.charAt(0) == "@") {
            return 0xffff00;
        }
        if (this.message.recipient == "*Guild*") {
            return 10944349;
        }
        if (this.message.recipient != "") {
            return 0xf0ff;
        }
        if (this.message.isFromSupporter) {
            return 0xcc66ff;
        }
        return 0xff00;
    }

    private function getTextColor():uint {
        var _local1:String = this.message.name;
        if (_local1 == "") {
            return 0xffff00;
        }
        if (_local1 == "*Client*") {
            return 255;
        }
        if (_local1 == "*Help*") {
            return 16734981;
        }
        if (_local1 == "*Error*") {
            return 0xff0000;
        }
        if (_local1 == "*Sync*") {
            return 1168896;
        }
        if (_local1.charAt(0) == "@") {
            return 0xffff00;
        }
        if (this.message.recipient == "*Guild*") {
            return 10944349;
        }
        if (this.message.recipient != "") {
            return 0xf0ff;
        }
        return 0xffffff;
    }

    private function getBitmapData(_arg_1:StringBuilder, _arg_2:uint):BitmapData {
        var _local5:String = this.stageProxy.getQuality();
        var _local4:Boolean = Parameters.data.forceChatQuality;
        _local4 && this.stageProxy.setQuality("high");
        var _local3:BitmapData = this.factory.make(_arg_1, 14, _arg_2, true, IDENTITY_MATRIX, true);
        _local4 && this.stageProxy.setQuality(_local5);
        return _local3;
    }

    private function setTFonTestField():void {
        var _local1:TextFormat = testField.getTextFormat();
        _local1.font = this.fontModel.getFont().getName();
        testField.defaultTextFormat = _local1;
    }
}
}
