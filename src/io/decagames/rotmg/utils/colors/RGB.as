package io.decagames.rotmg.utils.colors {
    public class RGB {
        
        
        public static function fromRGB(_arg_1: int, _arg_2: int, _arg_3: int): uint {
            return _arg_1 << 16 | _arg_2 << 8 | _arg_3;
        }
        
        public static function toRGB(_arg_1: uint): Array {
            return [getRed(_arg_1), getGreen(_arg_1), getBlue(_arg_1)];
        }
        
        public static function getRed(_arg_1: int): int {
            return _arg_1 >> 16 & 255;
        }
        
        public static function getGreen(_arg_1: int): int {
            return _arg_1 >> 8 & 255;
        }
        
        public static function getBlue(_arg_1: int): int {
            return _arg_1 & 255;
        }
        
        public function RGB() {
            super();
        }
    }
}
