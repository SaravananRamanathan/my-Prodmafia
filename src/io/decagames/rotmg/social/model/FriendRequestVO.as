package io.decagames.rotmg.social.model {
    public class FriendRequestVO {
        
        
        public function FriendRequestVO(_arg_1: String, _arg_2: String, _arg_3: Function = null) {
            super();
            this.request = _arg_1;
            this.target = _arg_2;
            this.callback = _arg_3;
        }
        
        public var request: String;
        public var target: String;
        public var callback: Function;
    }
}
