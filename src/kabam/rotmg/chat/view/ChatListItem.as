package kabam.rotmg.chat.view {
import com.company.assembleegameclient.objects.Player;
import com.company.assembleegameclient.parameters.Parameters;

import flash.display.Bitmap;
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.utils.getTimer;

import kabam.rotmg.core.StaticInjectorContext;
import kabam.rotmg.ui.model.HUDModel;

public class ChatListItem extends Sprite {

    private static const CHAT_ITEM_TIMEOUT:uint = 20000;

    public function ChatListItem(_arg_1:Vector.<DisplayObject>, _arg_2:int, _arg_3:int, _arg_4:Boolean, _arg_5:int, _arg_6:String, _arg_7:Boolean, _arg_8:Boolean) {
        super();
        mouseEnabled = true;
        tabEnabled = false;
        this.itemWidth = _arg_2;
        this.layoutHeight = _arg_3;
        this.list = _arg_1;
        this.count = _arg_1.length;
        this.creationTime = getTimer();
        this.timedOutOverride = _arg_4;
        this.playerObjectId = _arg_5;
        this.playerName = _arg_6;
        this.fromGuild = _arg_7;
        this.isTrade = _arg_8;
        this.layoutItems();
        this.addItems();
        addEventListener("rightMouseDown", this.onRightMouseDown);
    }
    public var playerObjectId:int;
    public var playerName:String = "";
    public var fromGuild:Boolean = false;
    public var isTrade:Boolean = false;
    private var itemWidth:int;
    private var list:Vector.<DisplayObject>;
    private var count:uint;
    private var layoutHeight:uint;
    private var creationTime:uint;
    private var timedOutOverride:Boolean;

    public function isTimedOut():Boolean {
        return getTimer() > this.creationTime + 20000 || this.timedOutOverride;
    }

    public function dispose():void {
        var _local1:* = 0;
        var _local3:int = 0;
        var _local2:* = null;
        removeEventListener("rightMouseDown", this.onRightMouseDown);
        while (numChildren > 0) {
            _local2 = removeChildAt(0);
            if (_local2 is ChatList) {
                ChatList(_local2).dispose();
            }
        }
        if (this.list) {
            _local1 = uint(this.list.length);
            _local3 = 0;
            while (_local3 < _local1) {
                if (this.list[_local3] as Bitmap != null) {
                    (this.list[_local3] as Bitmap).bitmapData.dispose();
                    this.list[_local3] = null;
                }
                _local3++;
            }
            this.list = null;
        }
    }

    private function layoutItems():void {
        var _local4:int = 0;
        var _local1:* = null;
        var _local2:* = null;
        var _local3:int = 0;
        var _local5:int = 0;
        _local4 = 0;
        while (_local4 < this.count) {
            _local1 = this.list[_local4];
            _local2 = _local1.getRect(_local1);
            _local1.x = _local5;
            _local1.y = (this.layoutHeight - _local2.height) * 0.5 - this.layoutHeight;
            if (_local5 + _local2.width > this.itemWidth) {
                _local1.x = 0;
                _local5 = 0;
                _local3 = 0;
                while (_local3 < _local4) {
                    this.list[_local3].y = this.list[_local3].y - this.layoutHeight;
                    _local3++;
                }
            }
            _local5 = _local5 + _local2.width;
            _local4++;
        }
    }

    private function addItems():void {
        var _local1:* = null;
        var _local3:int = 0;
        var _local2:* = this.list;
        for each(_local1 in this.list) {
            addChild(_local1);
        }
    }

    public function onRightMouseDown(_arg_1:MouseEvent):void {
        var _local2:* = null;
        var _local4:* = null;
        var _local3:* = null;
        try {
            _local2 = StaticInjectorContext.getInjector().getInstance(HUDModel);
            _local4 = _local2.gameSprite.map;
            if (_local4.goDict_[this.playerObjectId] != null && _local4.goDict_[this.playerObjectId] is Player && _local4.player_.objectId_ != this.playerObjectId) {
                _local3 = _local4.goDict_[this.playerObjectId] as Player;
                if (_arg_1.shiftKey) {
                    _local4.gs_.gsc_.teleport(_local3.objectId_);
                } else {
                    _local2.gameSprite.addChatPlayerMenu(_local3, _arg_1.stageX, _arg_1.stageY);
                }
            } else if (!this.isTrade && this.playerName && this.playerName != "" && _local4.player_.name_ != this.playerName) {
                _local2.gameSprite.addChatPlayerMenu(null, _arg_1.stageX, _arg_1.stageY, this.playerName, this.fromGuild);
            } else if (this.isTrade && this.playerName && this.playerName != "" && _local4.player_.name_ != this.playerName) {
                _local2.gameSprite.addChatPlayerMenu(null, _arg_1.stageX, _arg_1.stageY, this.playerName, false, true);
            }

        } catch (e:Error) {

        }
    }
}
}
