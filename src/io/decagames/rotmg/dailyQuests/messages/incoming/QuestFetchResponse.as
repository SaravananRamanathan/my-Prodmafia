package io.decagames.rotmg.dailyQuests.messages.incoming {
    import flash.utils.IDataInput;
    
    import io.decagames.rotmg.dailyQuests.messages.data.QuestData;
    
    import kabam.rotmg.messaging.impl.incoming.IncomingMessage;
    
    public class QuestFetchResponse extends IncomingMessage {
        
        
        public function QuestFetchResponse(_arg_1: uint, _arg_2: Function) {
            super(_arg_1, _arg_2);
            this.nextRefreshPrice = -1;
        }
        
        public var quests: Vector.<QuestData>;
        public var nextRefreshPrice: int;
        
        override public function parseFromInput(param1: IDataInput): void {
            var _local2: int = param1.readShort();
            this.quests = new Vector.<QuestData>(_local2);
            var _local3: int = 0;
            while (_local3 < _local2) {
                this.quests[_local3] = new QuestData();
                this.quests[_local3].parseFromInput(param1);
                _local3++;
            }
            this.nextRefreshPrice = param1.readShort();
        }
        
        override public function toString(): String {
            return formatToString("QUESTFETCHRESPONSE", "quests", "nextRefreshPrice");
        }
    }
}
