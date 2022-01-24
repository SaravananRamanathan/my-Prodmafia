package io.decagames.rotmg.fame.data {
    import flash.utils.Dictionary;
    
    import io.decagames.rotmg.fame.data.bonus.FameBonus;
    
    public class TotalFame {
        
        
        public function TotalFame(_arg_1: Number) {
            _bonuses = new Vector.<FameBonus>();
            super();
            this._baseFame = _arg_1;
            this._currentFame = _arg_1;
        }
        
        private var _bonuses: Vector.<FameBonus>;
        
        public function get bonuses(): Dictionary {
            var _local2: * = null;
            var _local1: Dictionary = new Dictionary();
            var _local4: int = 0;
            var _local3: * = this._bonuses;
            for each(_local2 in this._bonuses) {
                _local1[_local2.id] = _local2;
            }
            return _local1;
        }
        
        private var _baseFame: Number;
        
        public function get baseFame(): int {
            return this._baseFame;
        }
        
        private var _currentFame: Number;
        
        public function get currentFame(): int {
            return this._currentFame;
        }
        
        public function addBonus(_arg_1: FameBonus): void {
            if (_arg_1 != null) {
                this._bonuses.push(_arg_1);
                this._currentFame = this._currentFame + _arg_1.fameAdded;
            }
        }
    }
}
