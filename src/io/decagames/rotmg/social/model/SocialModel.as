package io.decagames.rotmg.social.model {
    import com.company.assembleegameclient.objects.Player;
    import com.company.assembleegameclient.parameters.Parameters;
    import com.company.assembleegameclient.util.FameUtil;
    import com.company.assembleegameclient.util.TimeUtil;
    
    import flash.utils.Dictionary;
    
    import io.decagames.rotmg.social.config.FriendsActions;
    import io.decagames.rotmg.social.config.GuildActions;
    import io.decagames.rotmg.social.signals.SocialDataSignal;
    import io.decagames.rotmg.social.tasks.FriendDataRequestTask;
    import io.decagames.rotmg.social.tasks.GuildDataRequestTask;
    import io.decagames.rotmg.social.tasks.ISocialTask;
    
    import kabam.lib.tasks.BaseTask;
    import kabam.rotmg.servers.api.Server;
    import kabam.rotmg.servers.api.ServerModel;
    import kabam.rotmg.ui.model.HUDModel;
    
    import org.osflash.signals.Signal;
    
    public class SocialModel {
        
        
        public function SocialModel() {
            socialDataSignal = new SocialDataSignal();
            noInvitationSignal = new Signal();
            super();
            this._initSocialModel();
        }
        
        [Inject]
        public var hudModel: HUDModel;
        [Inject]
        public var serverModel: ServerModel;
        [Inject]
        public var friendsDataRequest: FriendDataRequestTask;
        [Inject]
        public var guildDataRequest: GuildDataRequestTask;
        public var socialDataSignal: SocialDataSignal;
        public var noInvitationSignal: Signal;
        private var _onlineFriends: Vector.<FriendVO>;
        private var _offlineFriends: Vector.<FriendVO>;
        private var _onlineFilteredFriends: Vector.<FriendVO>;
        private var _offlineFilteredFriends: Vector.<FriendVO>;
        private var _onlineGuildMembers: Vector.<GuildMemberVO>;
        private var _offlineGuildMembers: Vector.<GuildMemberVO>;
        private var _guildMembers: Vector.<GuildMemberVO>;
        private var _friends: Dictionary;
        private var _invitations: Dictionary;
        private var _friendsLoadInProcess: Boolean;
        private var _invitationsLoadInProgress: Boolean;
        private var _guildLoadInProgress: Boolean;
        private var _numberOfInvitation: int;
        private var _isFriDataOK: Boolean;
        private var _serverDict: Dictionary;
        private var _currentServer: Server;
        
        private var _friendsList: Vector.<FriendVO>;
        
        public function get friendsList(): Vector.<FriendVO> {
            return this._friendsList;
        }
        
        private var _numberOfFriends: int;
        
        public function get numberOfFriends(): int {
            return this._numberOfFriends;
        }
        
        private var _numberOfGuildMembers: int;
        
        public function get numberOfGuildMembers(): int {
            return this._numberOfGuildMembers;
        }
        
        private var _guildVO: GuildVO;
        
        public function get guildVO(): GuildVO {
            return this._guildVO;
        }
        
        public function get hasInvitations(): Boolean {
            return this._numberOfInvitation > 0;
        }
        
        public function setCurrentServer(_arg_1: Server): void {
            this._currentServer = _arg_1;
        }
        
        public function getCurrentServerName(): String {
            return !this._currentServer ? "" : this._currentServer.name;
        }
        
        public function loadFriendsData(): void {
            if (this._friendsLoadInProcess || this._invitationsLoadInProgress) {
                return;
            }
            this._friendsLoadInProcess = true;
            this._invitationsLoadInProgress = true;
            this.loadList(this.friendsDataRequest, FriendsActions.getURL("/getList"), this.onFriendListResponse);
        }
        
        public function loadInvitations(): void {
            if (this._friendsLoadInProcess || this._invitationsLoadInProgress) {
                return;
            }
            this._invitationsLoadInProgress = true;
            this.loadList(this.friendsDataRequest, FriendsActions.getURL("/getRequests"), this.onInvitationListResponse);
        }
        
        public function loadGuildData(): void {
            if (this._guildLoadInProgress) {
                return;
            }
            this._guildLoadInProgress = true;
            this.loadList(this.guildDataRequest, GuildActions.getURL("/listMembers"), this.onGuildListResponse);
        }
        
        public function seedFriends(_arg_1: XML): void {
            var _local6: * = null;
            var _local4: * = null;
            var _local2: * = null;
            var _local3: * = null;
            var _local5: * = null;
            this._onlineFriends.length = 0;
            this._offlineFriends.length = 0;
            var _local10: int = 0;
            var _local9: * = _arg_1.Account;
            for each(_local5 in _arg_1.Account) {
                try {
                    _local2 = _local5.Name;
                    _local3 = this._friends[_local2] != null ? this._friends[_local2].vo as FriendVO : new FriendVO(Player.fromPlayerXML(_local2, _local5.Character[0]));
                    if (_local5.hasOwnProperty("Online")) {
                        _local4 = String(_local5.Online);
                        _local6 = this.serverNameDictionary()[_local4];
                        _local3.online(_local6, _local4);
                        this._onlineFriends.push(_local3);
                        this._friends[_local3.getName()] = {
                            "vo": _local3,
                            "list": this._onlineFriends
                        };
                        continue;
                    }
                    _local3.offline();
                    _local3.lastLogin = this.getLastLoginInSeconds(_local5.LastLogin);
                    this._offlineFriends.push(_local3);
                    this._friends[_local3.getName()] = {
                        "vo": _local3,
                        "list": this._offlineFriends
                    };
                } catch (error: Error) {
                    trace(error.toString());
                    
                }
            }
            this._onlineFriends.sort(this.sortFriend);
            this._offlineFriends.sort(this.sortFriend);
            this.updateFriendsList();
        }
        
        public function isMyFriend(_arg_1: String): Boolean {
            return this._friends[_arg_1] != null;
        }
        
        public function updateFriendVO(_arg_1: String, _arg_2: Player): void {
            var _local4: * = null;
            var _local3: * = null;
            if (this.isMyFriend(_arg_1)) {
                _local4 = this._friends[_arg_1];
                _local3 = _local4.vo as FriendVO;
                _local3.updatePlayer(_arg_2);
            }
        }
        
        public function getFilterFriends(_arg_1: String): Vector.<FriendVO> {
            var _local4: * = null;
            var _local3: int = 0;
            var _local2: RegExp = new RegExp(_arg_1, "gix");
            this._onlineFilteredFriends.length = 0;
            this._offlineFilteredFriends.length = 0;
            while (_local3 < this._onlineFriends.length) {
                _local4 = this._onlineFriends[_local3];
                if (_local4.getName().search(_local2) >= 0) {
                    this._onlineFilteredFriends.push(_local4);
                }
                _local3++;
            }
            _local3 = 0;
            while (_local3 < this._offlineFriends.length) {
                _local4 = this._offlineFriends[_local3];
                if (_local4.getName().search(_local2) >= 0) {
                    this._offlineFilteredFriends.push(_local4);
                }
                _local3++;
            }
            this._onlineFilteredFriends.sort(this.sortFriend);
            this._offlineFilteredFriends.sort(this.sortFriend);
            return this._onlineFilteredFriends.concat(this._offlineFilteredFriends);
        }
        
        public function ifReachMax(): Boolean {
            return this._numberOfFriends >= 100;
        }
        
        public function getAllInvitations(): Vector.<FriendVO> {
            var _local2: * = null;
            var _local1: Vector.<FriendVO> = new Vector.<FriendVO>();
            var _local4: int = 0;
            var _local3: * = this._invitations;
            for each(_local2 in this._invitations) {
                _local1.push(_local2);
            }
            _local1.sort(this.sortFriend);
            return _local1;
        }
        
        public function removeFriend(_arg_1: String): Boolean {
            var _local2: Object = this._friends[_arg_1];
            if (_local2) {
                this.removeFriendFromList(_arg_1);
                this.removeFromList(_local2.list, _arg_1);
                this._friends[_arg_1] = null;
                delete this._friends[_arg_1];
                return true;
            }
            return false;
        }
        
        public function removeInvitation(_arg_1: String): Boolean {
            if (this._invitations[_arg_1] != null) {
                this._invitations[_arg_1] = null;
                delete this._invitations[_arg_1];
                this._numberOfInvitation--;
                if (this._numberOfInvitation == 0) {
                    this.noInvitationSignal.dispatch();
                }
                return true;
            }
            return false;
        }
        
        public function removeGuildMember(_arg_1: String): void {
            var _local2: * = null;
            var _local4: int = 0;
            var _local3: * = this._onlineGuildMembers;
            for each(_local2 in this._onlineGuildMembers) {
                if (_local2.name == _arg_1) {
                    this._onlineGuildMembers.splice(this._onlineGuildMembers.indexOf(_local2), 1);
                    break;
                }
            }
            var _local6: int = 0;
            var _local5: * = this._offlineGuildMembers;
            for each(_local2 in this._offlineGuildMembers) {
                if (_local2.name == _arg_1) {
                    this._offlineGuildMembers.splice(this._offlineGuildMembers.indexOf(_local2), 1);
                    break;
                }
            }
            this.updateGuildData();
        }
        
        private function _initSocialModel(): void {
            this._numberOfFriends = 0;
            this._numberOfInvitation = 0;
            this._friends = new Dictionary(true);
            this._onlineFriends = new Vector.<FriendVO>(0);
            this._offlineFriends = new Vector.<FriendVO>(0);
            this._onlineFilteredFriends = new Vector.<FriendVO>(0);
            this._offlineFilteredFriends = new Vector.<FriendVO>(0);
            this._onlineGuildMembers = new Vector.<GuildMemberVO>(0);
            this._offlineGuildMembers = new Vector.<GuildMemberVO>(0);
            this._friendsLoadInProcess = false;
            this._invitationsLoadInProgress = false;
            this._guildLoadInProgress = false;
        }
        
        private function loadList(_arg_1: ISocialTask, _arg_2: String, _arg_3: Function): void {
            _arg_1.requestURL = _arg_2;
            (_arg_1 as BaseTask).finished.addOnce(_arg_3);
            (_arg_1 as BaseTask).start();
        }
        
        private function onFriendListResponse(_arg_1: FriendDataRequestTask, _arg_2: Boolean, _arg_3: String = ""): void {
            this._isFriDataOK = _arg_2;
            if (this._isFriDataOK) {
                this.seedFriends(_arg_1.xml);
                _arg_1.reset();
                this._friendsLoadInProcess = false;
                this.loadList(this.friendsDataRequest, FriendsActions.getURL("/getRequests"), this.onInvitationListResponse);
            } else {
                this.socialDataSignal.dispatch("SocialDataSignal.FRIENDS_DATA_LOADED", this._isFriDataOK, _arg_3);
            }
        }
        
        private function onInvitationListResponse(_arg_1: FriendDataRequestTask, _arg_2: Boolean, _arg_3: String = ""): void {
            if (_arg_2) {
                this.seedInvitations(_arg_1.xml);
                this.socialDataSignal.dispatch("SocialDataSignal.FRIENDS_DATA_LOADED", this._isFriDataOK, _arg_3);
            } else {
                this.socialDataSignal.dispatch("SocialDataSignal.FRIEND_INVITATIONS_LOADED", _arg_2, _arg_3);
            }
            _arg_1.reset();
            this._invitationsLoadInProgress = false;
        }
        
        private function onGuildListResponse(_arg_1: GuildDataRequestTask, _arg_2: Boolean, _arg_3: String = ""): void {
            if (_arg_2) {
                this.seedGuild(_arg_1.xml);
            } else {
                this.clearGuildData();
            }
            _arg_1.reset();
            this._guildLoadInProgress = false;
            this.socialDataSignal.dispatch("SocialDataSignal.GUILD_DATA_LOADED", _arg_2, _arg_3);
        }
        
        private function seedInvitations(_arg_1: XML): void {
            var _local2: * = null;
            var _local3: * = null;
            var _local4: * = null;
            this._invitations = new Dictionary(true);
            this._numberOfInvitation = 0;
            var _local8: int = 0;
            var _local7: * = _arg_1.Account;
            for each(_local4 in _arg_1.Account) {
                try {
                    if (_local4.Character[0] && _local4.Character[0].ObjectType != 0) {
                        if (this.starFilter(_local4.Character[0].ObjectType, _local4.Character[0].CurrentFame, _local4.Stats[0])) {
                            _local2 = _local4.Name;
                            _local3 = Player.fromPlayerXML(_local2, _local4.Character[0]);
                            this._invitations[_local2] = new FriendVO(_local3);
                            this._numberOfInvitation++;
                        } else {
                        
                        }
                    } else {
                    
                    }
                } catch (error: Error) {
                    trace(error.toString());
                    
                }
            }
        }
        
        private function seedGuild(_arg_1: XML): void {
            var _local6: * = null;
            var _local4: * = null;
            var _local3: * = null;
            var _local5: * = null;
            this.clearGuildData();
            this._guildVO = new GuildVO();
            this._guildVO.guildName = _arg_1.@name;
            this._guildVO.guildId = _arg_1.@id;
            this._guildVO.guildTotalFame = _arg_1.TotalFame;
            this._guildVO.guildCurrentFame = _arg_1.CurrentFame.value;
            this._guildVO.guildHallType = _arg_1.HallType;
            var _local2: XMLList = _arg_1.child("Member");
            if (_local2.length() > 0) {
                var _local8: int = 0;
                var _local7: * = _local2;
                for each(_local6 in _local2) {
                    _local4 = new GuildMemberVO();
                    _local3 = _local6.Name;
                    if (_local3 == this.hudModel.getPlayerName()) {
                        _local4.isMe = true;
                        this._guildVO.myRank = _local6.Rank;
                    }
                    _local4.name = _local3;
                    _local4.rank = _local6.Rank;
                    _local4.fame = _local6.Fame;
                    _local4.player = this.getPlayerObject(_local3, _local6);
                    if (_local6.hasOwnProperty("Online")) {
                        _local4.isOnline = true;
                        _local5 = String(_local6.Online);
                        _local4.serverAddress = _local5;
                        _local4.serverName = this.serverNameDictionary()[_local5];
                        this._onlineGuildMembers.push(_local4);
                    } else {
                        _local4.lastLogin = this.getLastLoginInSeconds(_local6.LastLogin);
                        this._offlineGuildMembers.push(_local4);
                    }
                }
            }
            this.updateGuildData();
        }
        
        private function getPlayerObject(_arg_1: String, _arg_2: XML): Player {
            var _local3: XML = _arg_2.Character[0];
            if (_local3.ObjectType == 0) {
                _local3.ObjectType = "782";
            }
            return Player.fromPlayerXML(_arg_1, _local3);
        }
        
        private function getLastLoginInSeconds(_arg_1: String): Number {
            var _local2: Date = new Date();
            return (_local2.getTime() - TimeUtil.parseUTCDate(_arg_1).getTime()) / 1000;
        }
        
        private function updateGuildData(): void {
            this._onlineGuildMembers.sort(this.sortGuildMemberByRank);
            this._offlineGuildMembers.sort(this.sortGuildMemberByRank);
            this._onlineGuildMembers.sort(this.sortGuildMemberByAlphabet);
            this._offlineGuildMembers.sort(this.sortGuildMemberByAlphabet);
            this._guildMembers = this._onlineGuildMembers.concat(this._offlineGuildMembers);
            this._numberOfGuildMembers = this._guildMembers.length;
            this._guildVO.guildMembers = this._guildMembers;
        }
        
        private function clearGuildData(): void {
            this._onlineGuildMembers.length = 0;
            this._offlineGuildMembers.length = 0;
            this._guildVO = null;
        }
        
        private function removeFriendFromList(_arg_1: String): void {
            var _local2: * = null;
            var _local4: int = 0;
            var _local3: * = this._onlineFriends;
            for each(_local2 in this._onlineFriends) {
                if (_local2.getName() == _arg_1) {
                    this._onlineFriends.splice(this._onlineFriends.indexOf(_local2), 1);
                    break;
                }
            }
            var _local6: int = 0;
            var _local5: * = this._offlineFriends;
            for each(_local2 in this._offlineFriends) {
                if (_local2.getName() == _arg_1) {
                    this._offlineFriends.splice(this._offlineFriends.indexOf(_local2), 1);
                    break;
                }
            }
            this.updateFriendsList();
        }
        
        private function removeFromList(_arg_1: Vector.<FriendVO>, _arg_2: String): void {
            var _local4: * = null;
            var _local3: int = 0;
            while (_local3 < _arg_1.length) {
                _local4 = _arg_1[_local3];
                if (_local4.getName() == _arg_2) {
                    _arg_1.slice(_local3, 1);
                    return;
                }
                _local3++;
            }
        }
        
        private function sortFriend(_arg_1: FriendVO, _arg_2: FriendVO): Number {
            if (_arg_1.getName() < _arg_2.getName()) {
                return -1;
            }
            if (_arg_1.getName() > _arg_2.getName()) {
                return 1;
            }
            return 0;
        }
        
        private function sortGuildMemberByRank(_arg_1: GuildMemberVO, _arg_2: GuildMemberVO): Number {
            if (_arg_1.rank > _arg_2.rank) {
                return -1;
            }
            if (_arg_1.rank < _arg_2.rank) {
                return 1;
            }
            return 0;
        }
        
        private function sortGuildMemberByAlphabet(_arg_1: GuildMemberVO, _arg_2: GuildMemberVO): Number {
            if (_arg_1.rank == _arg_2.rank) {
                if (_arg_1.name < _arg_2.name) {
                    return -1;
                }
                if (_arg_1.name > _arg_2.name) {
                    return 1;
                }
                return 0;
            }
            return 0;
        }
        
        private function serverNameDictionary(): Dictionary {
            var _local2: * = null;
            if (this._serverDict) {
                return this._serverDict;
            }
            var _local1: Vector.<Server> = this.serverModel.getServers();
            this._serverDict = new Dictionary(true);
            var _local4: int = 0;
            var _local3: * = _local1;
            for each(_local2 in _local1) {
                this._serverDict[_local2.address] = _local2.name;
            }
            return this._serverDict;
        }
        
        private function starFilter(_arg_1: int, _arg_2: int, _arg_3: XML): Boolean {
            return FameUtil.numAllTimeStars(_arg_1, _arg_2, _arg_3) >= Parameters.data.friendStarRequirement;
        }
        
        private function updateFriendsList(): void {
            this._friendsList = this._onlineFriends.concat(this._offlineFriends);
            this._numberOfFriends = this._friendsList.length;
        }
    }
}
