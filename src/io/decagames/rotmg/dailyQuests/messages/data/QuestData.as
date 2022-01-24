package io.decagames.rotmg.dailyQuests.messages.data {
    import flash.utils.IDataInput;
    
    public class QuestData {
        
        
        public function QuestData() {
            requirements = new Vector.<int>();
            rewards = new Vector.<int>();
            super();
        }
        
        public var id: String;
        public var name: String;
        public var description: String;
        public var expiration: String;
        public var requirements: Vector.<int>;
        public var rewards: Vector.<int>;
        public var completed: Boolean;
        public var itemOfChoice: Boolean;
        public var category: int;
        public var repeatable: Boolean;
        public var weight: int;
        
        public function parseFromInput(_arg_1: IDataInput): void {
            var _local3: int = 0;
            this.id = _arg_1.readUTF();
            this.name = _arg_1.readUTF();
            this.description = _arg_1.readUTF();
            this.expiration = _arg_1.readUTF();
            this.weight = _arg_1.readInt();
            this.category = _arg_1.readInt();
            var _local2: int = _arg_1.readShort();
            while (_local3 < _local2) {
                this.requirements.push(_arg_1.readInt());
                _local3++;
            }
            _local2 = _arg_1.readShort();
            _local3 = 0;
            while (_local3 < _local2) {
                this.rewards.push(_arg_1.readInt());
                _local3++;
            }
            this.completed = _arg_1.readBoolean();
            this.itemOfChoice = _arg_1.readBoolean();
            this.repeatable = _arg_1.readBoolean();
        }
    }
}
