package io.decagames.rotmg.social.model {
    import com.company.assembleegameclient.objects.Player;
    
    import flash.display.BitmapData;
    
    public class FriendVO {
        
        
        public function FriendVO(_arg_1: Player, _arg_2: Boolean = false, _arg_3: String = "", _arg_4: String = "") {
            super();
            this._player = _arg_1;
            this._isOnline = _arg_2;
            this._serverName = _arg_3;
            this._serverAddr = _arg_4;
            this.playerName = this._player.getName();
        }
        
        public var playerName: String;
        protected var _player: Player;
        protected var _serverName: String;
        protected var _serverAddr: String;
        
        protected var _isOnline: Boolean;
        
        public function get isOnline(): Boolean {
            return this._isOnline;
        }
        
        private var _lastLogin: Number;
        
        public function get lastLogin(): Number {
            return this._lastLogin;
        }
        
        public function set lastLogin(_arg_1: Number): void {
            this._lastLogin = _arg_1;
        }
        
        public function updatePlayer(_arg_1: Player): void {
            this._player = _arg_1;
            this.playerName = this._player.getName();
        }
        
        public function getServerName(): String {
            return this._serverName;
        }
        
        public function getName(): String {
            return this._player.getName();
        }
        
        public function getPortrait(): BitmapData {
            return this._player.getPortrait();
        }
        
        public function online(_arg_1: String, _arg_2: String): void {
            this._isOnline = true;
            this._serverName = _arg_1;
            this._serverAddr = _arg_2;
        }
        
        public function offline(): void {
            this._isOnline = false;
            this._serverName = "";
            this._serverAddr = "";
        }
    }
}
