package io.decagames.rotmg.utils.dictionary {
    import flash.utils.Dictionary;
    
    public class DictionaryUtils {
        
        
        public static function countKeys(_arg_1: Dictionary): int {
            var _local3: * = undefined;
            var _local2: int = 0;
            var _local5: int = 0;
            var _local4: * = _arg_1;
            for (_local3 in _arg_1) {
                _local2++;
            }
            return _local2;
        }
        
        public function DictionaryUtils() {
            super();
        }
    }
}
