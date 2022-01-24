package io.decagames.rotmg.social.widgets {
    import com.company.assembleegameclient.appengine.SavedCharacter;
    import com.company.assembleegameclient.parameters.Parameters;
    
    import flash.events.MouseEvent;
    
    import io.decagames.rotmg.social.model.FriendRequestVO;
    import io.decagames.rotmg.social.model.SocialModel;
    import io.decagames.rotmg.social.signals.FriendActionSignal;
    import io.decagames.rotmg.social.signals.RefreshListSignal;
    import io.decagames.rotmg.ui.buttons.BaseButton;
    import io.decagames.rotmg.ui.popups.modal.ConfirmationModal;
    import io.decagames.rotmg.ui.popups.modal.error.ErrorModal;
    import io.decagames.rotmg.ui.popups.signals.CloseCurrentPopupSignal;
    import io.decagames.rotmg.ui.popups.signals.RemoveLockFade;
    import io.decagames.rotmg.ui.popups.signals.ShowLockFade;
    import io.decagames.rotmg.ui.popups.signals.ShowPopupSignal;
    
    import kabam.rotmg.chat.control.ShowChatInputSignal;
    import kabam.rotmg.core.model.PlayerModel;
    import kabam.rotmg.game.model.GameInitData;
    import kabam.rotmg.game.signals.PlayGameSignal;
    import kabam.rotmg.text.view.stringBuilder.LineBuilder;
    import kabam.rotmg.ui.signals.EnterGameSignal;
    
    import robotlegs.bender.bundles.mvcs.Mediator;
    
    public class FriendListItemMediator extends Mediator {
        
        
        public function FriendListItemMediator() {
            super();
        }
        
        [Inject]
        public var view: FriendListItem;
        [Inject]
        public var showPopupSignal: ShowPopupSignal;
        [Inject]
        public var showFade: ShowLockFade;
        [Inject]
        public var friendsAction: FriendActionSignal;
        [Inject]
        public var showPopup: ShowPopupSignal;
        [Inject]
        public var removeFade: RemoveLockFade;
        [Inject]
        public var model: SocialModel;
        [Inject]
        public var refreshSignal: RefreshListSignal;
        [Inject]
        public var chatSignal: ShowChatInputSignal;
        [Inject]
        public var closeCurrentPopup: CloseCurrentPopupSignal;
        [Inject]
        public var enterGame: EnterGameSignal;
        [Inject]
        public var playerModel: PlayerModel;
        [Inject]
        public var playGame: PlayGameSignal;
        
        override public function initialize(): void {
            if (this.view.removeButton) {
                this.view.removeButton.addEventListener("click", this.onRemoveClick);
            }
            if (this.view.acceptButton) {
                this.view.acceptButton.addEventListener("click", this.onAcceptClick);
            }
            if (this.view.rejectButton) {
                this.view.rejectButton.addEventListener("click", this.onRejectClick);
            }
            if (this.view.messageButton) {
                this.view.messageButton.addEventListener("click", this.onMessageClick);
            }
            if (this.view.teleportButton) {
                this.view.teleportButton.addEventListener("click", this.onTeleportClick);
            }
            if (this.view.blockButton) {
                this.view.blockButton.addEventListener("click", this.onBlockClick);
            }
        }
        
        override public function destroy(): void {
            if (this.view.removeButton) {
                this.view.removeButton.removeEventListener("click", this.onRemoveClick);
            }
            if (this.view.acceptButton) {
                this.view.acceptButton.removeEventListener("click", this.onAcceptClick);
            }
            if (this.view.rejectButton) {
                this.view.rejectButton.removeEventListener("click", this.onRejectClick);
            }
            if (this.view.messageButton) {
                this.view.messageButton.removeEventListener("click", this.onMessageClick);
            }
            if (this.view.teleportButton) {
                this.view.teleportButton.removeEventListener("click", this.onTeleportClick);
            }
            if (this.view.blockButton) {
                this.view.blockButton.removeEventListener("click", this.onBlockClick);
            }
        }
        
        private function onRemoveConfirmed(_arg_1: BaseButton): void {
            var _local2: FriendRequestVO = new FriendRequestVO("/removeFriend", this.view.getLabelText(), this.onRemoveCallback);
            this.friendsAction.dispatch(_local2);
            this.showFade.dispatch();
        }
        
        private function onBlockConfirmed(_arg_1: BaseButton): void {
            var _local2: FriendRequestVO = new FriendRequestVO("/blockRequest", this.view.getLabelText(), this.onBlockCallback);
            this.friendsAction.dispatch(_local2);
            this.showFade.dispatch();
        }
        
        private function onRemoveCallback(_arg_1: Boolean, _arg_2: Object, _arg_3: String): void {
            if (_arg_1) {
                this.model.removeFriend(_arg_3);
            } else {
                this.showPopup.dispatch(new ErrorModal(350, "Friends List Error", LineBuilder.getLocalizedStringFromKey(String(_arg_2))));
            }
            this.removeFade.dispatch();
            this.refreshSignal.dispatch("RefreshListSignal.CONTEXT_FRIENDS_LIST", _arg_1);
        }
        
        private function onBlockCallback(_arg_1: Boolean, _arg_2: Object, _arg_3: String): void {
            if (_arg_1) {
                this.model.removeInvitation(_arg_3);
            } else {
                this.showPopup.dispatch(new ErrorModal(350, "Friends List Error", LineBuilder.getLocalizedStringFromKey(String(_arg_2))));
            }
            this.removeFade.dispatch();
            this.refreshSignal.dispatch("RefreshListSignal.CONTEXT_FRIENDS_LIST", _arg_1);
        }
        
        private function onAcceptCallback(_arg_1: Boolean, _arg_2: Object, _arg_3: String): void {
            if (_arg_1) {
                this.model.removeInvitation(_arg_3);
                this.model.seedFriends(XML(_arg_2));
            } else {
                this.showPopup.dispatch(new ErrorModal(350, "Friends List Error", LineBuilder.getLocalizedStringFromKey(String(_arg_2))));
            }
            this.removeFade.dispatch();
            this.refreshSignal.dispatch("RefreshListSignal.CONTEXT_FRIENDS_LIST", _arg_1);
        }
        
        private function onRejectCallback(_arg_1: Boolean, _arg_2: Object, _arg_3: String): void {
            if (_arg_1) {
                this.model.removeInvitation(_arg_3);
            } else {
                this.showPopup.dispatch(new ErrorModal(350, "Friends List Error", LineBuilder.getLocalizedStringFromKey(String(_arg_2))));
            }
            this.removeFade.dispatch();
            this.refreshSignal.dispatch("RefreshListSignal.CONTEXT_FRIENDS_LIST", _arg_1);
        }
        
        private function onMessageClick(_arg_1: MouseEvent): void {
            this.chatSignal.dispatch(true, "/tell " + this.view.getLabelText() + " ");
            this.closeCurrentPopup.dispatch();
        }
        
        private function onTeleportClick(_arg_1: MouseEvent): void {
            var _local4: Boolean = false;
            var _local3: SavedCharacter = this.playerModel.getCharacterById(this.playerModel.currentCharId);
            if (_local3) {
                _local4 = _local3.charXML_.IsChallenger;
            }
            if (_local4) {
                Parameters.data.preferredChallengerServer = this.view.vo.getServerName();
            } else {
                Parameters.data.preferredServer = this.view.vo.getServerName();
            }
            Parameters.save();
            this.enterGame.dispatch();
            var _local2: GameInitData = new GameInitData();
            _local2.createCharacter = false;
            _local2.charId = _local3.charId();
            _local2.isNewGame = true;
            this.playGame.dispatch(_local2);
            this.closeCurrentPopup.dispatch();
        }
        
        private function onRemoveClick(_arg_1: MouseEvent): void {
            var _local2: ConfirmationModal = new ConfirmationModal(350, LineBuilder.getLocalizedStringFromKey("Friend.RemoveTitle"), LineBuilder.getLocalizedStringFromKey("Friend.RemoveText", {"name": this.view.getLabelText()}), LineBuilder.getLocalizedStringFromKey("Friend.RemoveRight"), LineBuilder.getLocalizedStringFromKey("Frame.cancel"), 130);
            _local2.confirmButton.clickSignal.addOnce(this.onRemoveConfirmed);
            this.showPopupSignal.dispatch(_local2);
        }
        
        private function onAcceptClick(_arg_1: MouseEvent): void {
            var _local2: FriendRequestVO = new FriendRequestVO("/acceptRequest", this.view.getLabelText(), this.onAcceptCallback);
            this.friendsAction.dispatch(_local2);
            this.showFade.dispatch();
        }
        
        private function onRejectClick(_arg_1: MouseEvent): void {
            var _local2: FriendRequestVO = new FriendRequestVO("/rejectRequest", this.view.getLabelText(), this.onRejectCallback);
            this.friendsAction.dispatch(_local2);
            this.showFade.dispatch();
        }
        
        private function onBlockClick(_arg_1: MouseEvent): void {
            var _local2: ConfirmationModal = new ConfirmationModal(350, LineBuilder.getLocalizedStringFromKey("Friend.BlockTitle"), LineBuilder.getLocalizedStringFromKey("Friend.BlockText", {"name": this.view.getLabelText()}), LineBuilder.getLocalizedStringFromKey("Friend.BlockRight"), LineBuilder.getLocalizedStringFromKey("Frame.cancel"), 130);
            _local2.confirmButton.clickSignal.addOnce(this.onBlockConfirmed);
            this.showPopupSignal.dispatch(_local2);
        }
    }
}
