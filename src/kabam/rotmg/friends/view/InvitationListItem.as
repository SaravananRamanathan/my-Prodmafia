package kabam.rotmg.friends.view {
import com.company.assembleegameclient.ui.icons.IconButton;
import com.company.assembleegameclient.ui.icons.IconButtonFactory;
import com.company.util.AssetLibrary;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.ColorTransform;

import io.decagames.rotmg.social.model.FriendVO;

import kabam.rotmg.core.StaticInjectorContext;
import kabam.rotmg.text.view.TextFieldDisplayConcrete;
import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;

public class InvitationListItem extends FListItem {


    public function InvitationListItem(_arg_1:FriendVO, _arg_2:Number, _arg_3:Number) {
        super();
        this.init(_arg_2, _arg_3);
        this.update(_arg_1, "");
    }
    private var _senderName:String;
    private var _portrait:Bitmap;
    private var _nameText:TextFieldDisplayConcrete;
    private var _rejectButton:IconButton;
    private var _acceptButton:IconButton;
    private var _blockButton:IconButton;

    override protected function init(_arg_1:Number, _arg_2:Number):void {
        var _local4:* = null;
        this.graphics.beginFill(0x666666);
        this.graphics.drawRoundRect(0, 0, _arg_1, _arg_2, 10, 10);
        this.graphics.endFill();
        this._portrait = new Bitmap();
        this._portrait.x = 2;
        addChild(this._portrait);
        this._nameText = new TextFieldDisplayConcrete().setSize(18).setBold(true).setColor(0xb3b3b3);
        this._nameText.y = 11;
        addChild(this._nameText);
        _local4 = StaticInjectorContext.getInjector().getInstance(IconButtonFactory);
        var _local3:BitmapData = AssetLibrary.getImageFromSet("lofiInterfaceBig", 11);
        _local3.colorTransform(_local3.rect, new ColorTransform(0, 1, 0, 1, 182, 255, 160, 0));
        this._acceptButton = _local4.create(_local3, "Guild.accept", "", "");
        this._acceptButton.x = this.width - 200;
        this._acceptButton.y = 11;
        this._acceptButton.addEventListener("click", this.onAcceptClicked);
        addChild(this._acceptButton);
        _local3 = AssetLibrary.getImageFromSet("lofiInterfaceBig", 12);
        _local3.colorTransform(_local3.rect, new ColorTransform(1, 0, 0, 1, 255, 188, 188, 0));
        this._rejectButton = _local4.create(_local3, "Guild.rejection", "", "");
        this._rejectButton.x = this.width - 110;
        this._rejectButton.y = 11;
        this._rejectButton.addEventListener("click", this.onRejectClicked);
        addChild(this._rejectButton);
        this._blockButton = _local4.create(AssetLibrary.getImageFromSet("lofiInterfaceBig", 8), "", "Friend.BlockRight", "");
        this._blockButton.setToolTipText("Friend.BlockRightDesc");
        this._blockButton.addEventListener("click", this.onBlockClicked);
        this._blockButton.x = this.width - 25;
        this._blockButton.y = 12;
        addChild(this._blockButton);
        this.addEventListener("removedFromStage", this.onRemovedFromState);
    }

    override public function update(_arg_1:FriendVO, _arg_2:String):void {
        if (_arg_1.getName() != this._senderName) {
            this._senderName = _arg_1.getName();
            this._portrait.bitmapData = _arg_1.getPortrait();
            this._nameText.setStringBuilder(new StaticStringBuilder(this._senderName));
            this._nameText.x = this._portrait.width + 12;
        }
    }

    override public function destroy():void {
        while (numChildren > 0) {
            this.removeChildAt(numChildren - 1);
        }
        this._portrait = null;
        this._nameText = null;
        this._acceptButton.removeEventListener("click", this.onAcceptClicked);
        this._acceptButton = null;
        this._rejectButton.removeEventListener("click", this.onRejectClicked);
        this._rejectButton = null;
        this._blockButton.removeEventListener("click", this.onBlockClicked);
        this._blockButton = null;
    }

    private function onRemovedFromState(_arg_1:Event):void {
        this.removeEventListener("removedFromStage", this.onRemovedFromState);
        this.destroy();
    }

    private function onAcceptClicked(_arg_1:MouseEvent):void {
        actionSignal.dispatch("/acceptRequest", this._senderName);
    }

    private function onRejectClicked(_arg_1:MouseEvent):void {
        actionSignal.dispatch("/rejectRequest", this._senderName);
    }

    private function onBlockClicked(_arg_1:MouseEvent):void {
        actionSignal.dispatch("/blockRequest", this._senderName);
    }
}
}
