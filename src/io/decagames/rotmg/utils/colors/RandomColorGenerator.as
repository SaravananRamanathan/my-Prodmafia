package io.decagames.rotmg.utils.colors {
    import flash.utils.Dictionary;
    
    public class RandomColorGenerator {
        
        
        public function RandomColorGenerator(_arg_1: int = -1) {
            super();
            this.seed = _arg_1;
            this.colorDictionary = new Dictionary();
            this.loadColorBounds();
        }
        
        private var colorDictionary: Dictionary;
        private var seed: int = -1;
        
        public function randomColor(_arg_1: String = ""): Array {
            var _local2: int = this.pickHue();
            var _local5: int = this.pickSaturation(_local2, _arg_1);
            var _local4: int = this.pickBrightness(_local2, _local5, _arg_1);
            var _local3: Array = this.HSVtoRGB([_local2, _local5, _local4]);
            return _local3;
        }
        
        private function HSVtoRGB(_arg_1: Array): Array {
            var _local4: * = Number(_arg_1[0]);
            if (_local4 === 0) {
                _local4 = 1;
            }
            if (_local4 === 6 * 60) {
                _local4 = 359;
            }
            _local4 = Number(_local4 / 360);
            var _local9: Number = _arg_1[1] / 100;
            var _local11: Number = _arg_1[2] / 100;
            var _local10: Number = Math.floor(_local4 * 6);
            var _local8: Number = _local4 * 6 - _local10;
            var _local6: Number = _local11 * (1 - _local9);
            var _local3: Number = _local11 * (1 - _local8 * _local9);
            var _local5: Number = _local11 * (1 - (1 - _local8) * _local9);
            var _local2: * = 256;
            var _local12: * = 256;
            var _local7: * = 256;
            var _local13: * = _local10;
            switch (_local13) {
            case 0:
                _local2 = _local11;
                _local12 = _local5;
                _local7 = _local6;
                break;
            case 1:
                _local2 = _local3;
                _local12 = _local11;
                _local7 = _local6;
                break;
            case 2:
                _local2 = _local6;
                _local12 = _local11;
                _local7 = _local5;
                break;
            case 3:
                _local2 = _local6;
                _local12 = _local3;
                _local7 = _local11;
                break;
            case 4:
                _local2 = _local5;
                _local12 = _local6;
                _local7 = _local11;
                break;
            case 5:
                _local2 = _local11;
                _local12 = _local6;
                _local7 = _local3;
            }
            return [Math.floor(_local2 * 255), Math.floor(_local12 * 255), Math.floor(_local7 * 255)];
        }
        
        private function pickSaturation(_arg_1: int, _arg_2: String): int {
            var _local5: Array = this.getSaturationRange(_arg_1);
            var _local4: int = _local5[0];
            var _local3: int = _local5[1];
            var _local6: * = _arg_2;
            switch (_local6) {
            case "bright":
                _local4 = 55;
                break;
            case "dark":
                _local4 = _local3 - 10;
                break;
            case "light":
                _local3 = 55;
            }
            return this.randomWithin([_local4, _local3]);
        }
        
        private function getColorInfo(_arg_1: int): Object {
            var _local2: * = undefined;
            var _local3: * = null;
            if (_arg_1 >= 334 && _arg_1 <= 6 * 60) {
                _arg_1 = _arg_1 - 360;
            }
            var _local5: int = 0;
            var _local4: * = this.colorDictionary;
            for (_local2 in this.colorDictionary) {
                _local3 = this.colorDictionary[_local2];
                if (_local3.hueRange && _arg_1 >= _local3.hueRange[0] && _arg_1 <= _local3.hueRange[1]) {
                    return this.colorDictionary[_local2];
                }
            }
            return null;
        }
        
        private function getSaturationRange(_arg_1: int): Array {
            return this.getColorInfo(_arg_1).saturationRange;
        }
        
        private function pickBrightness(_arg_1: int, _arg_2: int, _arg_3: String): int {
            var _local5: int = this.getMinimumBrightness(_arg_1, _arg_2);
            var _local4: int = 100;
            var _local6: * = _arg_3;
            switch (_local6) {
            case "dark":
                _local4 = _local5 + 20;
                break;
            case "light":
                _local5 = (_local4 + _local5) / 2;
                break;
            case "random":
                _local5 = 0;
                _local4 = 100;
            }
            return this.randomWithin([_local5, _local4]);
        }
        
        private function getMinimumBrightness(_arg_1: int, _arg_2: int): int {
            var _local10: int = 0;
            var _local6: int = 0;
            var _local5: int = 0;
            var _local9: int = 0;
            var _local3: Number = NaN;
            var _local8: Number = NaN;
            var _local4: int = 0;
            var _local7: Array = this.getColorInfo(_arg_1).lowerBounds;
            while (_local4 < _local7.length - 1) {
                _local10 = _local7[_local4][0];
                _local6 = _local7[_local4][1];
                _local5 = _local7[_local4 + 1][0];
                _local9 = _local7[_local4 + 1][1];
                if (_arg_2 >= _local10 && _arg_2 <= _local5) {
                    _local3 = (_local9 - _local6) / (_local5 - _local10);
                    _local8 = _local6 - _local3 * _local10;
                    return _local3 * _arg_2 + _local8;
                }
                _local4++;
            }
            return 0;
        }
        
        private function randomWithin(_arg_1: Array): int {
            var _local2: Number = NaN;
            var _local4: Number = NaN;
            var _local3: Number = NaN;
            if (this.seed == -1) {
                return Math.floor(_arg_1[0] + Math.random() * (_arg_1[1] + 1 - _arg_1[0]));
            }
            _local2 = (_arg_1[1] || 1);
            _local4 = (_arg_1[0] || 0);
            this.seed = (this.seed * 9301 + 49297) % 233280;
            _local3 = this.seed / 233280;
            return Math.floor(_local4 + _local3 * (_local2 - _local4));
        }
        
        private function pickHue(_arg_1: int = -1): int {
            var _local2: Array = this.getHueRange(_arg_1);
            var _local3: int = this.randomWithin(_local2);
            if (_local3 < 0) {
                _local3 = 6 * 60 + _local3;
            }
            return _local3;
        }
        
        private function getHueRange(_arg_1: int): Array {
            if (_arg_1 < 6 * 60 && _arg_1 > 0) {
                return [_arg_1, _arg_1];
            }
            return [0, 6 * 60];
        }
        
        private function defineColor(_arg_1: String, _arg_2: Array, _arg_3: Array): void {
            var _local4: int = _arg_3[0][0];
            var _local7: int = _arg_3[_arg_3.length - 1][0];
            var _local6: int = _arg_3[_arg_3.length - 1][1];
            var _local5: int = _arg_3[0][1];
            this.colorDictionary[_arg_1] = {
                "hueRange": _arg_2,
                "lowerBounds": _arg_3,
                "saturationRange": [_local4, _local7],
                "brightnessRange": [_local6, _local5]
            };
        }
        
        private function loadColorBounds(): void {
            this.defineColor("monochrome", null, [[0, 0], [100, 0]]);
            this.defineColor("red", [-26, 18], [[20, 100], [30, 92], [40, 89], [50, 85], [60, 78], [70, 70], [80, 60], [90, 55], [100, 50]]);
            this.defineColor("orange", [19, 46], [[20, 100], [30, 93], [40, 88], [50, 86], [60, 85], [70, 70], [100, 70]]);
            this.defineColor("yellow", [47, 62], [[25, 100], [40, 94], [50, 89], [60, 86], [70, 84], [80, 82], [90, 80], [100, 75]]);
            this.defineColor("green", [63, 178], [[30, 100], [40, 90], [50, 85], [60, 81], [70, 74], [80, 64], [90, 50], [100, 40]]);
            this.defineColor("blue", [179, 257], [[20, 100], [30, 86], [40, 80], [50, 74], [60, 60], [70, 52], [80, 44], [90, 39], [100, 35]]);
            this.defineColor("purple", [258, 282], [[20, 100], [30, 87], [40, 79], [50, 70], [60, 65], [70, 59], [80, 52], [90, 45], [100, 42]]);
            this.defineColor("pink", [283, 334], [[20, 100], [30, 90], [40, 86], [60, 84], [80, 80], [90, 75], [100, 73]]);
        }
    }
}
