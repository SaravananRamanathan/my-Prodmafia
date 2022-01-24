package io.decagames.rotmg.dailyQuests.utils {
    import flash.display.Sprite;
    
    import io.decagames.rotmg.dailyQuests.view.slot.DailyQuestItemSlot;
    
    public class SlotsRendered {
        
        
        public static function renderSlots(_arg_1: Vector.<int>, _arg_2: Vector.<int>, _arg_3: String, _arg_4: Sprite, _arg_5: int, _arg_6: int, _arg_7: int, _arg_8: Vector.<DailyQuestItemSlot>, _arg_9: Boolean = false): void {
            var _local10: int = 0;
            var _local17: int = 0;
            var _local13: int = 0;
            var _local21: int = 0;
            var _local11: int = 0;
            var _local22: int = 0;
            var _local23: int = 0;
            var _local12: Boolean = false;
            var _local16: * = null;
            var _local19: * = null;
            var _local14: Sprite = new Sprite();
            var _local15: Sprite = new Sprite();
            _local16 = _local14;
            _arg_4.addChild(_local14);
            _arg_4.addChild(_local15);
            _local15.y = 40 + _arg_6;
            var _local25: int = 0;
            var _local24: * = _arg_1;
            for each(_local10 in _arg_1) {
                if (!_local12) {
                    _local22++;
                } else {
                    _local23++;
                }
                _local21 = _arg_2.indexOf(_local10);
                if (_local21 >= 0) {
                    _arg_2.splice(_local21, 1);
                }
                _local19 = new DailyQuestItemSlot(_local10, _arg_3, _arg_3 == "reward" ? false : _local21 >= 0, _arg_9);
                _local19.x = _local11 * (40 + _arg_6);
                _local16.addChild(_local19);
                _arg_8.push(_local19);
                _local11++;
                if (_local11 >= 4) {
                    _local16 = _local15;
                    _local11 = 0;
                    _local12 = true;
                }
            }
            _local17 = _local22 * 40 + (_local22 - 1) * _arg_6;
            _local13 = _local23 * 40 + (_local23 - 1) * _arg_6;
            _arg_4.y = _arg_5;
            if (!_local12) {
                _arg_4.y = _arg_4.y + Math.round(20 + _arg_6 / 2);
            }
            _local14.x = Math.round((_arg_7 - _local17) / 2);
            _local15.x = Math.round((_arg_7 - _local13) / 2);
        }
        
        public function SlotsRendered() {
            super();
        }
    }
}
