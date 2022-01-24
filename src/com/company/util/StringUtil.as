package com.company.util {
    public class StringUtil {
        
        private static const SIGN_UNDEF: int = 0;
        private static const SIGN_POS: int = -1;
        private static const SIGN_NEG: int = 1;
        private static var i: int = 0;
        
        public static function arrayToString(array: Array): String {
            var returnStr: String = "";
            for each(var arrayObject in array) {
                returnStr = returnStr + arrayObject.toString();
            }
            return returnStr;
        }
    
        public static function trim(string: String): String {
            return StringUtil.ltrim(StringUtil.rtrim(string));
        }
        
        public static function ltrim(string: String): String {
            var strLen: Number = NaN;
            var counter: * = NaN;
            if (string != null) {
                strLen = string.length;
                counter = 0;
                while (counter < strLen) {
                    if (string.charCodeAt(counter) > 32) {
                        return string.substring(counter);
                    }
                    counter++;
                }
            }
            return "";
        }
        
        public static function rtrim(string: String): String {
            var strLen: Number = NaN;
            var counter: * = NaN;
            if (string != null) {
                strLen = string.length;
                counter = strLen;
                while (counter > 0) {
                    if (string.charCodeAt(counter - 1) > 32) {
                        return string.substring(0, counter);
                    }
                    counter--;
                }
            }
            return "";
        }
        
        public static function simpleEscape(string: String): String {
            string = string.split("\n").join("\\n");
            string = string.split("\r").join("\\r");
            string = string.split("\t").join("\\t");
            string = string.split("\f").join("\\f");
            string = string.split("\b").join("\\b");
            return string;
        }
        
        public static function strictEscape(string: String, param2: Boolean = true): String {
            var splitStr: * = null;
            var counter: * = 0;
            if (string != null && string.length > 0) {
                if (param2) {
                    string = StringUtil.trim(string);
                }
                string = encodeURIComponent(string);
                splitStr = string.split("");
                counter = uint(0);
                while (counter < splitStr.length) {
                    var currentChar: * = splitStr[counter];
                    switch (currentChar) {
                    case "!":
                        splitStr[counter] = "%21";
                        break;
                    case "\'":
                        splitStr[counter] = "%27";
                        break;
                    case "(":
                        splitStr[counter] = "%28";
                        break;
                    case ")":
                        splitStr[counter] = "%29";
                        break;
                    case "*":
                        splitStr[counter] = "%2A";
                        break;
                    case "-":
                        splitStr[counter] = "%2D";
                        break;
                    case ".":
                        splitStr[counter] = "%2E";
                        break;
                    case "_":
                        splitStr[counter] = "%5F";
                        break;
                    case "~":
                        splitStr[counter] = "%7E";
                    }
                    counter++;
                }
                return splitStr.join("");
            }
            return "";
        }
        
        public static function repeat(string: uint, indent: String = " "): String {
            return new Array(string + 1).join(indent);
        }
        
        public static function printf(string: String, ...rest): String {
            var _loc17_: * = null;
            var _loc25_: Boolean = false;
            var _loc4_: Boolean = false;
            var _loc23_: Boolean = false;
            var _loc19_: Boolean = false;
            var _loc13_: Boolean = false;
            var _loc26_: int = 0;
            var _loc5_: int = 0;
            var _loc7_: * = null;
            var _loc15_: * = undefined;
            var _loc20_: int = 0;
            var _loc29_: int = 0;
            var _loc3_: * = 0;
            var _loc18_: Boolean = false;
            var _loc12_: * = 0;
            var _loc22_: * = null;
            var _loc24_: * = null;
            var _loc9_: Number = NaN;
            var _loc8_: int = 0;
            var _loc6_: int = 0;
            var _loc28_: Number = NaN;
            var _loc10_: * = 0;
            var _loc30_: int = 0;
            var _loc31_: Boolean = false;
            var _loc14_: int = 0;
            var _loc27_: * = null;
            var _loc11_: String = "";
            var _loc32_: * = 0;
            var _loc16_: int = -1;
            var _loc21_: String = "diufFeEgGxXoscpn";
            i = 0;
            for (; i < string.length; i = Number(i) + 1) {
                _loc17_ = string.charAt(i);
                if (_loc17_ == "%") {
                    i = i + 1;
                    if (i + 1 < string.length) {
                        _loc17_ = string.charAt(i);
                        if (_loc17_ == "%") {
                            _loc11_ = _loc11_ + _loc17_;
                        } else {
                            _loc25_ = false;
                            _loc4_ = false;
                            _loc23_ = false;
                            _loc19_ = false;
                            _loc13_ = false;
                            _loc26_ = -1;
                            _loc5_ = -1;
                            _loc7_ = "";
                            _loc29_ = getIndex(string);
                            if (_loc29_ < -1 || _loc29_ == 0) {
                                trace("ERR parsing index");
                                break;
                            }
                            if (_loc29_ == -1) {
                                if (_loc16_ == 1) {
                                    trace("ERR: indexed placeholder expected");
                                    break;
                                }
                                if (_loc16_ == -1) {
                                    _loc16_ = 0;
                                }
                                _loc32_++;
                            } else {
                                if (_loc16_ == 0) {
                                    trace("ERR: non-indexed placeholder expected");
                                    break;
                                }
                                if (_loc16_ == -1) {
                                    _loc16_ = 1;
                                }
                                _loc32_ = _loc29_;
                            }
                            while (true) {
                                _loc17_ = string.charAt(i);
                                if (string.charAt(i) == "+" || _loc17_ == "-" || _loc17_ == "#" || _loc17_ == " " || _loc17_ == "0") {
                                    var _loc33_: * = _loc17_;
                                    switch (_loc33_) {
                                    case "+":
                                        _loc25_ = true;
                                        break;
                                    case "-":
                                        _loc4_ = true;
                                        break;
                                    case "#":
                                        _loc23_ = true;
                                        break;
                                    case " ":
                                        _loc19_ = true;
                                        break;
                                    case "0":
                                        _loc13_ = true;
                                    }
                                    i = i + 1;
                                    if (i + 1 != string.length) {
                                        _loc17_ = string.charAt(i);
                                        continue;
                                    }
                                    break;
                                }
                                break;
                            }
                            if (i != string.length) {
                                if (_loc17_ == "*") {
                                    _loc3_ = 0;
                                    i = i + 1;
                                    if (i + 1 != string.length) {
                                        _loc29_ = getIndex(string);
                                        if (_loc29_ < -1 || _loc29_ == 0) {
                                            trace("ERR parsing index for width");
                                            break;
                                        }
                                        if (_loc29_ == -1) {
                                            if (_loc16_ == 1) {
                                                trace("ERR: indexed placeholder expected for width");
                                                break;
                                            }
                                            if (_loc16_ == -1) {
                                                _loc16_ = 0;
                                            }
                                            _loc32_++;
                                            _loc3_ = int(_loc32_);
                                        } else {
                                            if (_loc16_ == 0) {
                                                trace("ERR: non-indexed placeholder expected for width");
                                                break;
                                            }
                                            if (_loc16_ == -1) {
                                                _loc16_ = 1;
                                            }
                                            _loc3_ = _loc29_;
                                        }
                                        _loc3_--;
                                        if (rest.length > _loc3_ && _loc3_ >= 0) {
                                            _loc26_ = parseInt(rest[_loc3_]);
                                            if (isNaN(_loc26_)) {
                                                _loc26_ = -1;
                                                trace("ERR NaN while parsing width");
                                                break;
                                            }
                                            _loc17_ = string.charAt(i);
                                        } else {
                                            trace("ERR index out of bounds while parsing width");
                                            break;
                                        }
                                    }
                                    break;
                                }
                                _loc18_ = false;
                                while (_loc17_ >= "0" && _loc17_ <= "9") {
                                    if (_loc26_ == -1) {
                                        _loc26_ = 0;
                                    }
                                    _loc26_ = _loc26_ * 10 + uint(_loc17_);
                                    i = i + 1;
                                    if (i + 1 != string.length) {
                                        _loc17_ = string.charAt(i);
                                        continue;
                                    }
                                    break;
                                }
                                if (_loc26_ != -1 && i == string.length) {
                                    trace("ERR eof while parsing width");
                                    break;
                                }
                                if (_loc17_ == ".") {
                                    i = i + 1;
                                    if (i + 1 != string.length) {
                                        _loc17_ = string.charAt(i);
                                        if (_loc17_ == "*") {
                                            _loc12_ = 0;
                                            i = i + 1;
                                            if (i + 1 != string.length) {
                                                _loc29_ = getIndex(string);
                                                if (_loc29_ < -1 || _loc29_ == 0) {
                                                    trace("ERR parsing index for precision");
                                                    break;
                                                }
                                                if (_loc29_ == -1) {
                                                    if (_loc16_ == 1) {
                                                        trace("ERR: indexed placeholder expected for precision");
                                                        break;
                                                    }
                                                    if (_loc16_ == -1) {
                                                        _loc16_ = 0;
                                                    }
                                                    _loc32_++;
                                                    _loc12_ = int(_loc32_);
                                                } else {
                                                    if (_loc16_ == 0) {
                                                        trace("ERR: non-indexed placeholder expected for precision");
                                                        break;
                                                    }
                                                    if (_loc16_ == -1) {
                                                        _loc16_ = 1;
                                                    }
                                                    _loc12_ = _loc29_;
                                                }
                                                _loc12_--;
                                                if (rest.length > _loc12_ && _loc12_ >= 0) {
                                                    _loc5_ = parseInt(rest[_loc12_]);
                                                    if (isNaN(_loc5_)) {
                                                        _loc5_ = -1;
                                                        trace("ERR NaN while parsing precision");
                                                        break;
                                                    }
                                                    _loc17_ = string.charAt(i);
                                                } else {
                                                    trace("ERR index out of bounds while parsing precision");
                                                    break;
                                                }
                                            }
                                            break;
                                        }
                                        while (_loc17_ >= "0" && _loc17_ <= "9") {
                                            if (_loc5_ == -1) {
                                                _loc5_ = 0;
                                            }
                                            _loc5_ = _loc5_ * 10 + uint(_loc17_);
                                            i = i + 1;
                                            if (i + 1 != string.length) {
                                                _loc17_ = string.charAt(i);
                                                continue;
                                            }
                                            break;
                                        }
                                        if (_loc5_ != -1 && i == string.length) {
                                            trace("ERR eof while parsing precision");
                                            break;
                                        }
                                    }
                                    break;
                                }
                                _loc33_ = _loc17_;
                                switch (_loc33_) {
                                case "h":
                                    i = i + 1;
                                    if (i + 1 == string.length) {
                                        trace("ERR eof after length");
                                        break;
                                    }
                                    _loc22_ = string.charAt(i);
                                    if (_loc17_ == "h" && _loc22_ == "h" || _loc17_ == "l" && _loc22_ == "l") {
                                        i = i + 1;
                                        if (i + 1 == string.length) {
                                            trace("ERR eof after length");
                                            break;
                                        }
                                        _loc17_ = string.charAt(i);
                                    } else {
                                        _loc17_ = _loc22_;
                                    }
                                    break;
                                case "l":
                                case "L":
                                case "z":
                                case "j":
                                    i = i + 1;
                                    if (i + 1 == string.length) {
                                        trace("ERR eof after length");
                                        break;
                                    }
                                    _loc17_ = string.charAt(i);
                                    break;
                                case "t":
                                }
                                if (_loc21_.indexOf(_loc17_) >= 0) {
                                    _loc7_ = _loc17_;
                                    if (rest.length >= _loc32_ && _loc32_ > 0) {
                                        _loc15_ = rest[_loc32_ - 1];
                                        _loc6_ = 0;
                                        _loc33_ = _loc7_;
                                        switch (_loc33_) {
                                        case "s":
                                            _loc24_ = _loc15_.toString();
                                            if (_loc5_ != -1) {
                                                _loc24_ = _loc24_.substr(0, _loc5_);
                                            }
                                            break;
                                        case "c":
                                            _loc24_ = _loc15_.toString().getAt(0);
                                            break;
                                        case "d":
                                            _loc8_ = typeof _loc15_ == "number" ? int(_loc15_) : parseInt(_loc15_);
                                            _loc24_ = Math.abs(_loc8_).toString();
                                            _loc6_ = _loc8_ < 0 ? 1 : -1;
                                            break;
                                        case "i":
                                            _loc24_ = (typeof _loc15_ == "number" ? uint(_loc15_) : uint(parseInt(_loc15_))).toString();
                                            break;
                                        case "u":
                                        case "f":
                                        case "F":
                                        case "e":
                                        case "E":
                                        case "g":
                                            if (_loc5_ == -1) {
                                                _loc5_ = 6;
                                            }
                                            _loc28_ = Math.pow(10, _loc5_);
                                            _loc9_ = typeof _loc15_ == "number" ? Number(_loc15_) : Number(parseFloat(_loc15_));
                                            _loc24_ = (Math.round(Math.abs(_loc9_) * _loc28_) / _loc28_).toString();
                                            if (_loc5_ > 0) {
                                                _loc30_ = _loc24_.indexOf(".");
                                                if (_loc30_ == -1) {
                                                    _loc24_ = _loc24_ + ".";
                                                    _loc10_ = _loc5_;
                                                } else {
                                                    _loc10_ = int(_loc5_ - (_loc24_.length - _loc30_ - 1));
                                                }
                                                _loc20_ = 0;
                                                while (_loc20_ < _loc10_) {
                                                    _loc24_ = _loc24_ + "0";
                                                    _loc20_++;
                                                }
                                            }
                                            _loc6_ = _loc9_ < 0 ? 1 : -1;
                                            break;
                                        case "G":
                                        case "x":
                                        case "X":
                                            _loc24_ = (typeof _loc15_ == "number" ? uint(_loc15_) : parseInt(_loc15_)).toString(16);
                                            if (_loc7_ == "X") {
                                                _loc24_ = _loc24_.toUpperCase();
                                            }
                                            break;
                                        case "p":
                                            _loc24_ = (typeof _loc15_ == "number" ? uint(_loc15_) : parseInt(_loc15_)).toString(8);
                                            break;
                                        case "o":
                                        }
                                        _loc31_ = _loc6_ == 1 || _loc25_ || _loc19_;
                                        if (_loc26_ > -1) {
                                            _loc14_ = _loc26_ - _loc24_.length;
                                            if (_loc31_) {
                                                _loc14_--;
                                            }
                                            if (_loc14_ > 0) {
                                                _loc27_ = _loc13_ && !_loc4_ ? "0" : " ";
                                                if (_loc4_) {
                                                    _loc20_ = 0;
                                                    while (_loc20_ < _loc14_) {
                                                        _loc24_ = _loc24_ + _loc27_;
                                                        _loc20_++;
                                                    }
                                                } else {
                                                    _loc20_ = 0;
                                                    while (_loc20_ < _loc14_) {
                                                        _loc24_ = _loc27_ + _loc24_;
                                                        _loc20_++;
                                                    }
                                                }
                                            }
                                        }
                                        if (_loc31_) {
                                            if (_loc6_ == -1) {
                                                _loc24_ = (!!_loc19_ ? " " : "0") + _loc24_;
                                            } else {
                                                _loc24_ = "-" + _loc24_;
                                            }
                                        }
                                        _loc11_ = _loc11_ + _loc24_;
                                    } else {
                                        trace("ERR value index out of bounds (" + _loc32_ + ")");
                                        break;
                                    }
                                } else {
                                    trace("ERR unknown type: " + _loc17_);
                                    break;
                                }
                            }
                            break;
                        }
                    } else {
                        _loc11_ = _loc11_ + _loc17_;
                    }
                } else {
                    _loc11_ = _loc11_ + _loc17_;
                }
            }
            return _loc11_;
        }
        
        private static function getIndex(string: String): int {
            var _loc2_: int = 0;
            var _loc3_: Boolean = false;
            var _loc4_: String = "";
            var _loc5_: int = i;
            while (true) {
                _loc4_ = string.charAt(i);
                if (!(string.charAt(i) >= "0" && _loc4_ <= "9")) {
                    break;
                }
                _loc3_ = true;
                _loc2_ = _loc2_ * 10 + uint(_loc4_);
                i = i + 1;
                if (i + 1 == string.length) {
                    return -2;
                }
            }
            if (_loc3_) {
                if (_loc4_ != "$") {
                    i = _loc5_;
                    return -1;
                }
                i = i + 1;
                if (i + 1 == string.length) {
                    return -2;
                }
                return _loc2_;
            }
            return -1;
        }
        
        public function StringUtil() {
            super();
        }
    }
}
