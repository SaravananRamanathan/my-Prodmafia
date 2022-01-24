package kabam.rotmg.friends.view {
import com.company.assembleegameclient.appengine.SavedCharacter;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.ui.dialogs.ErrorDialog;

import io.decagames.rotmg.social.model.FriendRequestVO;
import io.decagames.rotmg.social.model.SocialModel;
import io.decagames.rotmg.social.signals.FriendActionSignal;

import kabam.rotmg.chat.control.ShowChatInputSignal;
import kabam.rotmg.core.model.PlayerModel;
import kabam.rotmg.dialogs.control.CloseDialogsSignal;
import kabam.rotmg.dialogs.control.OpenDialogSignal;
import kabam.rotmg.game.model.GameInitData;
import kabam.rotmg.game.signals.PlayGameSignal;
import kabam.rotmg.ui.signals.EnterGameSignal;

import robotlegs.bender.bundles.mvcs.Mediator;

public class FriendListMediator extends Mediator {


    public function FriendListMediator() {
        super();
    }
    [Inject]
    public var view:FriendListView;
    [Inject]
    public var model:SocialModel;
    [Inject]
    public var openDialog:OpenDialogSignal;
    [Inject]
    public var closeDialog:CloseDialogsSignal;
    [Inject]
    public var actionSignal:FriendActionSignal;
    [Inject]
    public var chatSignal:ShowChatInputSignal;
    [Inject]
    public var enterGame:EnterGameSignal;
    [Inject]
    public var playerModel:PlayerModel;
    [Inject]
    public var playGame:PlayGameSignal;

    override public function initialize():void {
        this.view.actionSignal.add(this.onFriendActed);
        this.view.tabSignal.add(this.onTabSwitched);
        this.model.socialDataSignal.add(this.initView);
        this.model.loadFriendsData();
    }

    override public function destroy():void {
        this.view.actionSignal.removeAll();
        this.view.tabSignal.removeAll();
    }

    private function initView(_arg_1:Boolean = false):void {
        if (_arg_1) {
            this.view.init(this.model.friendsList, this.model.getAllInvitations(), this.model.getCurrentServerName());
        }
    }

    private function reportError(_arg_1:String):void {
        this.openDialog.dispatch(new ErrorDialog(_arg_1));
    }

    private function onTabSwitched(_arg_1:String):void {
        var _local2:* = _arg_1;
        switch (_local2) {
            case "Friends":
                this.view.updateFriendTab(this.model.friendsList, this.model.getCurrentServerName());
                return;
            case "Invitations":
                this.view.updateInvitationTab(this.model.getAllInvitations());
                return;
            default:
                return;
        }
    }

    private function onFriendActed(_arg_1:String, _arg_2:String):void {
        var _local4:* = null;
        var _local3:* = null;
        var _local5:FriendRequestVO = new FriendRequestVO(_arg_1, _arg_2);
        var _local6:* = _arg_1;
        switch (_local6) {
            case "searchFriend":
                if (_arg_2 != null && _arg_2 != "") {
                    this.view.updateFriendTab(this.model.getFilterFriends(_arg_2), this.model.getCurrentServerName());
                } else if (_arg_2 == "") {
                    this.view.updateFriendTab(this.model.friendsList, this.model.getCurrentServerName());
                }
                return;
            case "/requestFriend":
                if (this.model.ifReachMax()) {
                    this.view.updateInput("Friend.ReachCapacity");
                    return;
                }
                _local5.callback = this.inviteFriendCallback;
            case "/removeFriend":
                _local5.callback = this.removeFriendCallback;
                _local4 = "Friend.RemoveTitle";
                _local3 = "Friend.RemoveText";
                this.openDialog.dispatch(new FriendUpdateConfirmDialog(_local4, _local3, "Frame.cancel", "Friend.RemoveRight", _local5, {"name": _local5.target}));
                return;
            case "/acceptRequest":
                _local5.callback = this.acceptInvitationCallback;
            case "/rejectRequest":
                _local5.callback = this.rejectInvitationCallback;
            default:
                this.actionSignal.dispatch(_local5);
                return;
            case "/blockRequest":
                _local5.callback = this.blockInvitationCallback;
                _local4 = "Friend.BlockTitle";
                _local3 = "Friend.BlockText";
                this.openDialog.dispatch(new FriendUpdateConfirmDialog(_local4, _local3, "Frame.cancel", "Friend.BlockRight", _local5, {"name": _local5.target}));
                return;
            case "Whisper":
                this.whisperCallback(_arg_2);
                return;
            case "JumpServer":
                this.jumpCallback(_arg_2);
                return;
        }
    }

    private function inviteFriendCallback(_arg_1:Boolean, _arg_2:String, _arg_3:String):void {
        if (_arg_1) {
            this.view.updateInput("Friend.SentInvitationText", {"name": _arg_3});
        } else if (_arg_2 == "Blocked") {
            this.view.updateInput("Friend.SentInvitationText", {"name": _arg_3});
        } else {
            this.view.updateInput(_arg_2);
        }
    }

    private function removeFriendCallback(_arg_1:Boolean, _arg_2:String, _arg_3:String):void {
        if (_arg_1) {
            this.model.removeFriend(_arg_3);
        } else {
            this.reportError(_arg_2);
        }
    }

    private function acceptInvitationCallback(_arg_1:Boolean, _arg_2:String, _arg_3:String):void {
        if (_arg_1) {
            this.model.seedFriends(XML(_arg_2));
            if (this.model.removeInvitation(_arg_3)) {
                this.view.updateInvitationTab(this.model.getAllInvitations());
            }
        } else {
            this.reportError(_arg_2);
        }
    }

    private function rejectInvitationCallback(_arg_1:Boolean, _arg_2:String, _arg_3:String):void {
        if (_arg_1) {
            if (this.model.removeInvitation(_arg_3)) {
                this.view.updateInvitationTab(this.model.getAllInvitations());
            }
        } else {
            this.reportError(_arg_2);
        }
    }

    private function blockInvitationCallback(_arg_1:String):void {
        this.model.removeInvitation(_arg_1);
    }

    private function whisperCallback(_arg_1:String):void {
        this.chatSignal.dispatch(true, "/tell " + _arg_1 + " ");
        this.view.getCloseSignal().dispatch();
    }

    private function jumpCallback(_arg_1:String):void {
        var _local2:Boolean = false;
        var _local4:SavedCharacter = this.playerModel.getCharacterById(this.playerModel.currentCharId);
        if (_local4) {
            _local2 = _local4.charXML_.IsChallenger;
        }
        if (_local2) {
            Parameters.data.preferredChallengerServer = _arg_1;
        } else {
            Parameters.data.preferredServer = _arg_1;
        }
        Parameters.save();
        this.enterGame.dispatch();
        var _local3:GameInitData = new GameInitData();
        _local3.createCharacter = false;
        _local3.charId = _local4.charId();
        _local3.isNewGame = true;
        this.playGame.dispatch(_local3);
        this.closeDialog.dispatch();
    }
}
}
