package com.company.assembleegameclient.appengine {
    import com.company.assembleegameclient.util.FameUtil;

    public class CharacterStats {

        public function CharacterStats(_arg_1:XML) {
            super();
            this.charStatsXML_ = _arg_1;
        }
        public var charStatsXML_:XML;

        public function bestLevel():int {
            return this.charStatsXML_.BestLevel;
        }

        public function bestFame():int {
            return this.charStatsXML_.BestFame;
        }

        public function numStars():int {
            return FameUtil.numStars(this.charStatsXML_.BestFame);
        }
    }
}
