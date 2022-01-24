package io.decagames.rotmg.fame.data.bonus {
    public class FameBonus {
        
        
        public function FameBonus(_arg_1: int, _arg_2: int, _arg_3: int, _arg_4: int, _arg_5: String, _arg_6: String) {
            super();
            this._added = _arg_2;
            this._numAdded = _arg_3;
            this._level = _arg_4;
            this._id = _arg_1;
            this._name = _arg_5;
            this._tooltip = _arg_6;
        }
        
        private var _added: int;
        
        public function get added(): int {
            return this._added;
        }
        
        private var _numAdded: int;
        
        public function get numAdded(): int {
            return this._numAdded;
        }
        
        private var _level: int;
        
        public function get level(): int {
            return this._level;
        }
        
        private var _fameAdded: int;
        
        public function get fameAdded(): int {
            return this._fameAdded;
        }
        
        public function set fameAdded(_arg_1: int): void {
            this._fameAdded = _arg_1;
        }
        
        private var _id: int;
        
        public function get id(): int {
            return this._id;
        }
        
        private var _name: String;
        
        public function get name(): String {
            return this._name;
        }
        
        private var _tooltip: String;
        
        public function get tooltip(): String {
            return this._tooltip;
        }
    }
}
