package kabam.rotmg.friends.view {
import com.company.assembleegameclient.account.ui.TextInputField;
import com.company.assembleegameclient.ui.DeprecatedTextButton;
import com.company.assembleegameclient.ui.dialogs.DialogCloser;
import com.company.ui.BaseSimpleText;
import com.company.util.GraphicsUtil;

import flash.display.GraphicsPath;
import flash.display.GraphicsSolidFill;
import flash.display.GraphicsStroke;
import flash.display.IGraphicsData;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.FocusEvent;
import flash.events.MouseEvent;

import io.decagames.rotmg.pets.utils.PetsViewAssetFactory;
import io.decagames.rotmg.social.model.FriendVO;

import kabam.rotmg.pets.view.components.DialogCloseButton;
import kabam.rotmg.text.view.TextFieldDisplayConcrete;
import kabam.rotmg.text.view.stringBuilder.LineBuilder;

import org.osflash.signals.Signal;

public class FriendListView extends Sprite implements DialogCloser {

    public static const TEXT_WIDTH:int = 500;

    public static const TEXT_HEIGHT:int = 500;

    public static const LIST_ITEM_WIDTH:int = 490;

    public static const LIST_ITEM_HEIGHT:int = 40;


    private const closeButton:DialogCloseButton = PetsViewAssetFactory.returnCloseButton(500);

    private var graphicsData_:Vector.<IGraphicsData>;

    public function FriendListView() {
        closeDialogSignal = new Signal();
        actionSignal = new Signal(String, String);
        tabSignal = new Signal(String);
        backgroundFill_ = new GraphicsSolidFill(0x333333, 1);
        outlineFill_ = new GraphicsSolidFill(0xffffff, 1);
        lineStyle_ = new GraphicsStroke(2, false, "normal", "none", "round", 3, outlineFill_);
        path_ = new GraphicsPath(new Vector.<int>(), new Vector.<Number>());
        this.graphicsData_ = new <IGraphicsData>[lineStyle_, backgroundFill_, path_, GraphicsUtil.END_FILL, GraphicsUtil.END_STROKE];
        super();
    }
    public var closeDialogSignal:Signal;
    public var actionSignal:Signal;
    public var tabSignal:Signal;
    public var _tabView:FriendTabView;
    public var _w:int;
    public var _h:int;
    private var _friendTotalText:TextFieldDisplayConcrete;
    private var _friendDefaultText:TextFieldDisplayConcrete;
    private var _inviteDefaultText:TextFieldDisplayConcrete;
    private var _addButton:DeprecatedTextButton;
    private var _findButton:DeprecatedTextButton;
    private var _nameInput:TextInputField;
    private var _friendsContainer:FriendListContainer;
    private var _invitationsContainer:FriendListContainer;
    private var _currentServerName:String;
    private var backgroundFill_:GraphicsSolidFill;
    private var outlineFill_:GraphicsSolidFill;
    private var lineStyle_:GraphicsStroke;
    private var path_:GraphicsPath;

    public function init(_arg_1:Vector.<FriendVO>, _arg_2:Vector.<FriendVO>, _arg_3:String):void {
        this._w = 500;
        addEventListener("removedFromStage", this.onRemovedFromStage);
        this._tabView = new FriendTabView(500, 500);
        this._tabView.tabSelected.add(this.onTabClicked);
        addChild(this._tabView);
        this.createFriendTab();
        this.createInvitationsTab();
        addChild(this.closeButton);
        this.drawBackground();
        this._currentServerName = _arg_3;
        this.seedData(_arg_1, _arg_2);
        this._tabView.setSelectedTab(0);
    }

    public function destroy():void {
        while (numChildren > 0) {
            this.removeChildAt(numChildren - 1);
        }
        this._addButton.removeEventListener("click", this.onAddFriendClicked);
        this._addButton = null;
        this._tabView.destroy();
        this._tabView = null;
        this._nameInput.removeEventListener("focusIn", this.onFocusIn);
        this._nameInput = null;
        this._friendsContainer = null;
        this._invitationsContainer = null;
    }

    public function updateFriendTab(_arg_1:Vector.<FriendVO>, _arg_2:String):void {
        var _local3:int = 0;
        var _local5:* = null;
        var _local4:* = null;
        this._friendDefaultText.visible = _arg_1.length <= 0;
        _local3 = this._friendsContainer.getTotal() - _arg_1.length;
        while (_local3 > 0) {
            this._friendsContainer.removeChildAt(this._friendsContainer.getTotal() - 1);
            _local3--;
        }
        _local3 = 0;
        while (_local3 < this._friendsContainer.getTotal()) {
            _local5 = _arg_1.pop();
            if (_local5 != null) {
                _local4 = this._friendsContainer.getChildAt(_local3) as FListItem;
                _local4.update(_local5, _arg_2);
            }
            _local3++;
        }
        var _local7:int = 0;
        var _local6:* = _arg_1;
        for each(_local5 in _arg_1) {
            _local4 = new FriendListItem(_local5, 490, 40, _arg_2);
            _local4.actionSignal.add(this.onListItemAction);
            _local4.x = 2;
            this._friendsContainer.addListItem(_local4);
        }
        _arg_1.length = 0;
        _arg_1 = null;
    }

    public function updateInvitationTab(_arg_1:Vector.<FriendVO>):void {
        var _local3:int = 0;
        var _local2:* = null;
        var _local4:* = null;
        this._tabView.showTabBadget(1, _arg_1.length);
        this._inviteDefaultText.visible = _arg_1.length == 0;
        _local3 = this._invitationsContainer.getTotal() - _arg_1.length;
        while (_local3 > 0) {
            this._invitationsContainer.removeChildAt(this._invitationsContainer.getTotal() - 1);
            _local3--;
        }
        _local3 = 0;
        while (_local3 < this._invitationsContainer.getTotal()) {
            _local2 = _arg_1.pop();
            if (_local2 != null) {
                _local4 = this._invitationsContainer.getChildAt(_local3) as FListItem;
                _local4.update(_local2, "");
            }
            _local3++;
        }
        var _local6:int = 0;
        var _local5:* = _arg_1;
        for each(_local2 in _arg_1) {
            _local4 = new InvitationListItem(_local2, 490, 40);
            _local4.actionSignal.add(this.onListItemAction);
            this._invitationsContainer.addListItem(_local4);
        }
        _arg_1.length = 0;
        _arg_1 = null;
    }

    public function getCloseSignal():Signal {
        return this.closeDialogSignal;
    }

    public function updateInput(_arg_1:String, _arg_2:Object = null):void {
        this._nameInput.setError(_arg_1, _arg_2);
    }

    private function createFriendTab():void {
        var _local1:Sprite = new Sprite();
        _local1.name = "Friends";
        this._nameInput = new TextInputField("Friend.AddTitle", false);
        this._nameInput.x = 3;
        this._nameInput.y = 0;
        this._nameInput.addEventListener("focusIn", this.onFocusIn);
        _local1.addChild(this._nameInput);
        this._addButton = new DeprecatedTextButton(14, "Friend.AddButton", 110);
        this._addButton.y = 30;
        this._addButton.x = 253;
        this._addButton.addEventListener("click", this.onAddFriendClicked);
        _local1.addChild(this._addButton);
        this._findButton = new DeprecatedTextButton(14, "Editor.Search", 110);
        this._findButton.y = 30;
        this._findButton.x = 380;
        this._findButton.addEventListener("click", this.onSearchFriendClicked);
        _local1.addChild(this._findButton);
        this._friendDefaultText = new TextFieldDisplayConcrete().setSize(18).setColor(0xffffff).setBold(true).setAutoSize("center");
        this._friendDefaultText.setStringBuilder(new LineBuilder().setParams("Friend.FriendDefaultText"));
        this._friendDefaultText.x = 250;
        this._friendDefaultText.y = 200;
        _local1.addChild(this._friendDefaultText);
        this._friendTotalText = new TextFieldDisplayConcrete().setSize(16).setColor(0xffffff).setBold(true).setAutoSize("center");
        this._friendTotalText.x = 400;
        this._friendTotalText.y = 0;
        _local1.addChild(this._friendTotalText);
        this._friendsContainer = new FriendListContainer(500, 390);
        this._friendsContainer.x = 3;
        this._friendsContainer.y = 80;
        _local1.addChild(this._friendsContainer);
        var _local2:BaseSimpleText = new BaseSimpleText(18, 0xffffff, false, 100, 26);
        _local2.setAlignment("center");
        _local2.text = "Friends";
        this._tabView.addTab(_local2, _local1);
    }

    private function createInvitationsTab():void {
        var _local1:* = null;
        _local1 = new Sprite();
        _local1.name = "Invitations";
        this._invitationsContainer = new FriendListContainer(500, 470);
        this._invitationsContainer.x = 3;
        _local1.addChild(this._invitationsContainer);
        this._inviteDefaultText = new TextFieldDisplayConcrete().setSize(18).setColor(0xffffff).setBold(true).setAutoSize("center");
        this._inviteDefaultText.setStringBuilder(new LineBuilder().setParams("Friend.FriendInvitationDefaultText"));
        this._inviteDefaultText.x = 250;
        this._inviteDefaultText.y = 200;
        _local1.addChild(this._inviteDefaultText);
        var _local2:BaseSimpleText = new BaseSimpleText(18, 0xffffff, false, 100, 26);
        _local2.text = "Invitations";
        _local2.setAlignment("center");
        this._tabView.addTab(_local2, _local1);
    }

    private function seedData(_arg_1:Vector.<FriendVO>, _arg_2:Vector.<FriendVO>):void {
        this._friendTotalText.setStringBuilder(new LineBuilder().setParams("Friend.TotalFriend", {"total": _arg_1.length}));
        this.updateFriendTab(_arg_1, this._currentServerName);
        this.updateInvitationTab(_arg_2);
    }

    private function onTabClicked(_arg_1:String):void {
        this.tabSignal.dispatch(_arg_1);
    }

    private function onListItemAction(_arg_1:String, _arg_2:String):void {
        this.actionSignal.dispatch(_arg_1, _arg_2);
    }

    private function drawBackground():void {
        this._h = 508;
        x = 400 - this._w / 2;
        y = 300 - this._h / 2;
        graphics.clear();
        GraphicsUtil.clearPath(this.path_);
        GraphicsUtil.drawCutEdgeRect(-6, -6, this._w + 12, this._h + 12, 4, [1, 1, 1, 1], this.path_);
        graphics.drawGraphicsData(this.graphicsData_);
    }

    private function onFocusIn(_arg_1:FocusEvent):void {
        this._nameInput.clearText();
        this._nameInput.clearError();
        this.actionSignal.dispatch("searchFriend", this._nameInput.text());
    }

    private function onAddFriendClicked(_arg_1:MouseEvent):void {
        this.actionSignal.dispatch("/requestFriend", this._nameInput.text());
    }

    private function onSearchFriendClicked(_arg_1:MouseEvent):void {
        this.actionSignal.dispatch("searchFriend", this._nameInput.text());
    }

    private function onRemovedFromStage(_arg_1:Event):void {
        removeEventListener("removedFromStage", this.onRemovedFromStage);
        this.destroy();
    }
}
}
