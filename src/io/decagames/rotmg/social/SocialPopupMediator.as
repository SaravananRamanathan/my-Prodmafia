package io.decagames.rotmg.social {
    import com.company.assembleegameclient.ui.tooltip.TextToolTip;
    
    import flash.events.KeyboardEvent;
    
    import io.decagames.rotmg.social.model.GuildVO;
    import io.decagames.rotmg.social.model.SocialModel;
    import io.decagames.rotmg.social.popups.InviteFriendPopup;
    import io.decagames.rotmg.social.signals.RefreshListSignal;
    import io.decagames.rotmg.social.widgets.FriendListItem;
    import io.decagames.rotmg.social.widgets.GuildInfoItem;
    import io.decagames.rotmg.social.widgets.GuildListItem;
    import io.decagames.rotmg.ui.buttons.BaseButton;
    import io.decagames.rotmg.ui.buttons.SliceScalingButton;
    import io.decagames.rotmg.ui.popups.signals.ClosePopupSignal;
    import io.decagames.rotmg.ui.popups.signals.ShowPopupSignal;
    import io.decagames.rotmg.ui.texture.TextureParser;
    
    import kabam.rotmg.core.signals.HideTooltipsSignal;
    import kabam.rotmg.core.signals.ShowTooltipSignal;
    import kabam.rotmg.tooltips.HoverTooltipDelegate;
    import kabam.rotmg.ui.model.HUDModel;
    
    import robotlegs.bender.bundles.mvcs.Mediator;
    
    public class SocialPopupMediator extends Mediator {
        
        
        public function SocialPopupMediator() {
            super();
        }
        
        [Inject]
        public var view: SocialPopupView;
        [Inject]
        public var closePopupSignal: ClosePopupSignal;
        [Inject]
        public var showTooltipSignal: ShowTooltipSignal;
        [Inject]
        public var hideTooltipSignal: HideTooltipsSignal;
        [Inject]
        public var hudModel: HUDModel;
        [Inject]
        public var socialModel: SocialModel;
        [Inject]
        public var refreshSignal: RefreshListSignal;
        [Inject]
        public var showPopupSignal: ShowPopupSignal;
        private var _isFriendsListLoaded: Boolean;
        private var _isGuildListLoaded: Boolean;
        private var closeButton: SliceScalingButton;
        private var addFriendToolTip: TextToolTip;
        private var hoverTooltipDelegate: HoverTooltipDelegate;
        
        override public function initialize(): void {
            this.socialModel.socialDataSignal.add(this.onDataLoaded);
            this.view.tabs.tabSelectedSignal.add(this.onTabSelected);
            this.refreshSignal.add(this.refreshListHandler);
            this.closeButton = new SliceScalingButton(TextureParser.instance.getSliceScalingBitmap("UI", "close_button"));
            this.closeButton.clickSignal.addOnce(this.onClose);
            this.view.header.addButton(this.closeButton, "right_button");
            this.view.addButton.clickSignal.add(this.addButtonHandler);
            this.createAddButtonTooltip();
            this.view.search.addEventListener("keyUp", this.onSearchHandler);
        }
        
        override public function destroy(): void {
            this.closeButton.dispose();
            this.refreshSignal.remove(this.refreshListHandler);
            this.view.addButton.clickSignal.remove(this.addButtonHandler);
            this.view.search.removeEventListener("keyUp", this.onSearchHandler);
            this.addFriendToolTip = null;
            this.hoverTooltipDelegate.removeDisplayObject();
            this.hoverTooltipDelegate = null;
        }
        
        private function onTabSelected(_arg_1: String): void {
            if (_arg_1 == "Friends") {
                if (!this._isFriendsListLoaded) {
                    this.socialModel.loadFriendsData();
                }
            } else if (_arg_1 == "Guild") {
                if (!this._isGuildListLoaded) {
                    this.socialModel.loadGuildData();
                }
            }
        }
        
        private function onDataLoaded(_arg_1: String, _arg_2: Boolean, _arg_3: String): void {
            var _local4: * = _arg_1;
            switch (_local4) {
            case "SocialDataSignal.FRIENDS_DATA_LOADED":
                this.view.clearFriendsList();
                if (_arg_2) {
                    this.showFriends();
                    this._isFriendsListLoaded = true;
                } else {
                    this._isFriendsListLoaded = false;
                    this.showError(_arg_1, _arg_3);
                }
                return;
            case "SocialDataSignal.GUILD_DATA_LOADED":
                this.view.clearGuildList();
                this.showGuild();
                this._isGuildListLoaded = true;
                return;
            default:
                return;
            }
        }
        
        private function createAddButtonTooltip(): void {
            this.addFriendToolTip = new TextToolTip(0x363636, 0x9b9b9b, "Add a friend", "Click to add a friend", 200);
            this.hoverTooltipDelegate = new HoverTooltipDelegate();
            this.hoverTooltipDelegate.setShowToolTipSignal(this.showTooltipSignal);
            this.hoverTooltipDelegate.setHideToolTipsSignal(this.hideTooltipSignal);
            this.hoverTooltipDelegate.setDisplayObject(this.view.addButton);
            this.hoverTooltipDelegate.tooltip = this.addFriendToolTip;
        }
        
        private function addButtonHandler(_arg_1: BaseButton): void {
            this.showPopupSignal.dispatch(new InviteFriendPopup());
        }
        
        private function refreshListHandler(_arg_1: String, _arg_2: Boolean): void {
            if (_arg_1 == "RefreshListSignal.CONTEXT_FRIENDS_LIST") {
                this.view.search.reset();
                this.view.clearFriendsList();
                this.showFriends();
            } else if (_arg_1 == "RefreshListSignal.CONTEXT_GUILD_LIST") {
                this.view.clearGuildList();
                this.showGuild();
            }
        }
        
        private function onClose(_arg_1: BaseButton): void {
            this.closePopupSignal.dispatch(this.view);
        }
        
        private function showFriends(_arg_1: String = ""): void {
            var _local6: * = undefined;
            var _local7: int = 0;
            var _local8: * = undefined;
            var _local5: int = 0;
            var _local4: int = 0;
            var _local3: * = null;
            var _local2: * = _arg_1 != "";
            if (this.socialModel.hasInvitations) {
                _local8 = this.socialModel.getAllInvitations();
                this.view.addFriendCategory("Invitations (" + _local8.length + ")");
                _local5 = _local8.length > 3 ? 3 : _local8.length;
                _local4 = 0;
                while (_local4 < _local5) {
                    this.view.addInvites(new FriendListItem(_local8[_local4], 3));
                    _local4++;
                }
                this.view.showInviteIndicator(true, "Friends");
            } else {
                this.view.showInviteIndicator(false, "Friends");
            }
            _local6 = !_local2 ? this.socialModel.friendsList : this.socialModel.getFilterFriends(_arg_1);
            this.view.addFriendCategory("Friends (" + this.socialModel.numberOfFriends + "/" + 100 + ")");
            var _local10: int = 0;
            var _local9: * = _local6;
            for each(_local3 in _local6) {
                _local7 = !!_local3.isOnline ? 1 : 2;
                this.view.addFriend(new FriendListItem(_local3, _local7));
            }
            this.view.addFriendCategory("");
        }
        
        private function showError(_arg_1: String, _arg_2: String): void {
            var _local3: * = _arg_1;
            switch (_local3) {
            case "SocialDataSignal.FRIENDS_DATA_LOADED":
                this.view.addFriendCategory("Error: " + _arg_2);
                return;
            case "SocialDataSignal.FRIEND_INVITATIONS_LOADED":
                this.view.addFriendCategory("Invitation Error: " + _arg_2);
                return;
            default:
                return;
            }
        }
        
        private function showGuild(): void {
            var _local3: * = undefined;
            var _local8: int = 0;
            var _local5: int = 0;
            var _local4: * = null;
            var _local7: int = 0;
            var _local6: GuildVO = this.socialModel.guildVO;
            var _local2: String = !_local6 ? "No Guild" : _local6.guildName;
            var _local1: int = !_local6 ? 0 : _local6.guildTotalFame;
            this.view.addGuildInfo(new GuildInfoItem(_local2, _local1));
            if (_local6 && this.socialModel.numberOfGuildMembers > 0) {
                this.view.addGuildCategory("Guild Members (" + this.socialModel.numberOfGuildMembers + "/" + 50 + ")");
                _local3 = _local6.guildMembers;
                _local8 = _local3.length;
                _local5 = 0;
                while (_local5 < _local8) {
                    _local4 = _local3[_local5];
                    _local7 = !!_local4.isOnline ? 1 : 2;
                    this.view.addGuildMember(new GuildListItem(_local4, _local7, _local6.myRank));
                    _local5++;
                }
                this.view.addGuildCategory("");
            } else {
                this.view.addGuildDefaultMessage("You have not yet joined a Guild,\njoin a Guild to find Players to play with or\n create your own Guild.");
            }
        }
        
        private function onSearchHandler(_arg_1: KeyboardEvent): void {
            this.view.clearFriendsList();
            this.showFriends(this.view.search.text);
        }
    }
}
