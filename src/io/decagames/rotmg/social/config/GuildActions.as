package io.decagames.rotmg.social.config {
    public class GuildActions {
        
        public static const BASE_DIRECTORY: String = "/guild";
        
        public static const GUILD_LIST: String = "/listMembers";
        
        public static function getURL(_arg_1: String): String {
            return "/guild" + _arg_1;
        }
        
        public function GuildActions() {
            super();
        }
    }
}
