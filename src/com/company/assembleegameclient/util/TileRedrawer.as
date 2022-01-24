package com.company.assembleegameclient.util {
import com.company.assembleegameclient.map.GroundLibrary;
import com.company.assembleegameclient.map.GroundProperties;
import com.company.assembleegameclient.map.Map;
import com.company.assembleegameclient.map.Square;
import com.company.util.AssetLibrary;
import com.company.util.BitmapUtil;
import com.company.util.ImageSet;
import com.company.util.PointUtil;

import flash.display.BitmapData;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.utils.Dictionary;

public class TileRedrawer {

    private static const INNER:int = 0;

    private static const SIDE0:int = 1;

    private static const SIDE1:int = 2;

    private static const OUTER:int = 3;

    private static const INNERP1:int = 4;

    private static const INNERP2:int = 5;

    private static const rect0:Rectangle = new Rectangle(0,0,4,4);

    private static const p0:Point = new Point(0,0);

    private static const rect1:Rectangle = new Rectangle(4,0,4,4);

    private static const p1:Point = new Point(4,0);

    private static const rect2:Rectangle = new Rectangle(0,4,4,4);

    private static const p2:Point = new Point(0,4);

    private static const rect3:Rectangle = new Rectangle(4,4,4,4);

    private static const p3:Point = new Point(4,4);

    private static const mlist_:Vector.<Vector.<ImageSet>> = getMasks();

    private static const RECT01:Rectangle = new Rectangle(0,0,8,4);

    private static const RECT13:Rectangle = new Rectangle(4,0,4,8);

    private static const RECT23:Rectangle = new Rectangle(0,4,8,4);

    private static const RECT02:Rectangle = new Rectangle(0,0,4,8);

    private static const RECT0:Rectangle = new Rectangle(0,0,4,4);

    private static const RECT1:Rectangle = new Rectangle(4,0,4,4);

    private static const RECT2:Rectangle = new Rectangle(0,4,4,4);

    private static const RECT3:Rectangle = new Rectangle(4,4,4,4);

    private static const POINT0:Point = new Point(0,0);

    private static const POINT1:Point = new Point(4,0);

    private static const POINT2:Point = new Point(0,4);

    private static const POINT3:Point = new Point(4,4);

    private static var cache__:Dictionary = new Dictionary();

    private static var cache_:Vector.<Object> = new <Object>[null,{}];


    public function TileRedrawer() {
        super();
    }

    public static function clearCache() : void {
        for each(var _local1:BitmapData in cache__) {
            _local1 && _local1.dispose();
        }
        cache__ = new Dictionary();
    }

    public static function redraw(_arg_1:Square, _arg_2:Boolean) : BitmapData {
        var _local4:Boolean = false;
        var _local9:Boolean = false;
        var _local3:Boolean = false;
        var _local7:* = null;
        var _local6:* = null;
        var _local5:* = _arg_1.tileType == 253;
        if(_local5) {
            _local7 = getCompositeSig(_arg_1);
        } else if(_arg_1.props_.hasEdge_) {
            _local7 = getEdgeSig(_arg_1);
        } else {
            _local7 = getSig(_arg_1);
        }
        if(_local7 == null) {
            return null;
        }
        if(_local7 in cache__) {
            return cache__[_local7];
        }
        if(_local5) {
            _local6 = buildComposite(_local7);
            cache__[_local7] = _local6;
            return _local6;
        }
        if(_arg_1.props_.hasEdge_) {
            _local6 = drawEdges(_local7);
            cache__[_local7] = _local6;
            return _local6;
        }
        var _local10:uint = _local7[4];
        if(_local7[1] != _local10) {
            _local5 = true;
            _local4 = true;
        }
        if(_local7[3] != _local10) {
            _local5 = true;
            _local9 = true;
        }
        if(_local7[5] != _local10) {
            _local4 = true;
            _local3 = true;
        }
        if(_local7[7] != _local10) {
            _local9 = true;
            _local3 = true;
        }
        if(!_local5 && _local7[0] != _local10) {
            _local5 = true;
        }
        if(!_local4 && _local7[2] != _local10) {
            _local4 = true;
        }
        if(!_local9 && _local7[6] != _local10) {
            _local9 = true;
        }
        if(!_local3 && _local7[8] != _local10) {
            _local3 = true;
        }
        if(!_local5 && !_local4 && !_local9 && !_local3) {
            cache__[_local7] = null;
            return null;
        }
        var _local8:BitmapData = _arg_1.bmpRect_;
        if(_arg_2) {
            _local6 = _local8.clone();
        } else {
            _local6 = new BitmapData(_local8.width,_local8.height,true,0);
        }
        if(_local5) {
            redrawRect(_local6,rect0,p0,mlist_[0],_local10,_local7[3],_local7[0],_local7[1]);
        }
        if(_local4) {
            redrawRect(_local6,rect1,p1,mlist_[1],_local10,_local7[1],_local7[2],_local7[5]);
        }
        if(_local9) {
            redrawRect(_local6,rect2,p2,mlist_[2],_local10,_local7[7],_local7[6],_local7[3]);
        }
        if(_local3) {
            redrawRect(_local6,rect3,p3,mlist_[3],_local10,_local7[5],_local7[8],_local7[7]);
        }
        cache__[_local7] = _local6;
        _local7.length = 0;
        return _local6;
    }

    private static function redrawRect(_arg_1:BitmapData, _arg_2:Rectangle, _arg_3:Point, _arg_4:Vector.<ImageSet>, _arg_5:uint, _arg_6:uint, _arg_7:uint, _arg_8:uint) : void {
        var _local9:* = null;
        var _local10:* = null;
        if(_arg_5 == _arg_6 && _arg_5 == _arg_8) {
            _local10 = _arg_4[3].random();
            _local9 = GroundLibrary.getBitmapData(_arg_7);
        } else if(_arg_5 != _arg_6 && _arg_5 != _arg_8) {
            if(_arg_6 != _arg_8) {
                _arg_1.copyPixels(GroundLibrary.getBitmapData(_arg_6),_arg_2,_arg_3,_arg_4[4].random(),p0,true);
                _arg_1.copyPixels(GroundLibrary.getBitmapData(_arg_8),_arg_2,_arg_3,_arg_4[5].random(),p0,true);
                return;
            }
            _local10 = _arg_4[0].random();
            _local9 = GroundLibrary.getBitmapData(_arg_6);
        } else if(_arg_5 != _arg_6) {
            _local10 = _arg_4[1].random();
            _local9 = GroundLibrary.getBitmapData(_arg_6);
        } else {
            _local10 = _arg_4[2].random();
            _local9 = GroundLibrary.getBitmapData(_arg_8);
        }
        _arg_1.copyPixels(_local9,_arg_2,_arg_3,_local10,p0,true);
    }

    private static function getSig(_arg_1:Square) : Array {
        var _local10:int = 0;
        var _local7:int = 0;
        var _local4:int = 0;
        var _local3:Square = null;
        var _local6:* = [];
        var _local2:Map = _arg_1.map;
        var _local5:uint = _arg_1.tileType;
        var _local9:int = _arg_1.y_ + 1;
        var _local8:int = _arg_1.x_ + 1;
        _local4 = _arg_1.y_ - 1;
        while(_local4 <= _local9) {
            _local7 = _local4 * _local2.mapWidth;
            _local10 = _arg_1.x_ - 1;
            while(_local10 <= _local8) {
                if(_local10 < 0 || _local10 >= _local2.mapWidth || _local4 < 0 || _local4 >= _local2.mapHeight || _local10 == _arg_1.x_ && _local4 == _arg_1.y_) {
                    _local6.push(_local5);
                } else {
                    _local3 = _local2.squares[_local10 + _local7];
                    if(_local3 == null || _local3.props_.blendPriority_ <= _arg_1.props_.blendPriority_) {
                        _local6.push(_local5);
                    } else {
                        _local6.push(_local3.tileType);
                    }
                }
                _local10++;
            }
            _local4++;
        }
        return _local6;
    }

    private static function getMasks() : Vector.<Vector.<ImageSet>> {
        var _local1:Vector.<Vector.<ImageSet>> = new Vector.<Vector.<ImageSet>>();
        addMasks(_local1,AssetLibrary.getImageSet("inner_mask"),AssetLibrary.getImageSet("sides_mask"),AssetLibrary.getImageSet("outer_mask"),AssetLibrary.getImageSet("innerP1_mask"),AssetLibrary.getImageSet("innerP2_mask"));
        return _local1;
    }

    private static function addMasks(_arg_1:Vector.<Vector.<ImageSet>>, _arg_2:ImageSet, _arg_3:ImageSet, _arg_4:ImageSet, _arg_5:ImageSet, _arg_6:ImageSet) : void {
        var _local7:int = 0;
        var _local9:int = 0;
        var _local8:* = [-1,0,2,1];
        for each(_local7 in [-1,0,2,1]) {
            _arg_1.push(new <ImageSet>[rotateImageSet(_arg_2,_local7),rotateImageSet(_arg_3,_local7 - 1),rotateImageSet(_arg_3,_local7),rotateImageSet(_arg_4,_local7),rotateImageSet(_arg_5,_local7),rotateImageSet(_arg_6,_local7)]);
        }
    }

    private static function rotateImageSet(_arg_1:ImageSet, _arg_2:int) : ImageSet {
        var _local3:* = null;
        var _local4:ImageSet = new ImageSet();
        var _local6:int = 0;
        var _local5:* = _arg_1.images;
        for each(_local3 in _arg_1.images) {
            _local4.add(BitmapUtil.rotateBitmapData(_local3,_arg_2));
        }
        return _local4;
    }

    private static function getCompositeSig(_arg_1:Square) : Array {
        var _local4:Square = null;
        var _local3:Square = null;
        var _local6:Square = null;
        var _local11:Square = null;
        var _local8:* = [];
        _local8.length = 4;
        var _local9:Map = _arg_1.map;
        var _local7:int = _arg_1.x_;
        var _local10:int = _arg_1.y_;
        var _local16:Square = _local9.lookupSquare(_local7,_local10 - 1);
        var _local14:Square = _local9.lookupSquare(_local7 - 1,_local10);
        var _local13:Square = _local9.lookupSquare(_local7 + 1,_local10);
        var _local5:Square = _local9.lookupSquare(_local7,_local10 + 1);
        var _local12:int = !!_local16?_local16.props_.compositePriority_:-1;
        var _local17:int = !!_local14?_local14.props_.compositePriority_:-1;
        var _local15:int = !!_local13?_local13.props_.compositePriority_:-1;
        var _local2:int = !!_local5?_local5.props_.compositePriority_:-1;
        if(_local12 < 0 && _local17 < 0) {
            _local4 = _local9.lookupSquare(_local7 - 1,_local10 - 1);
            _local8[0] = _local4 == null || _local4.props_.compositePriority_ < 0?255:_local4.tileType;
        } else if(_local12 < _local17) {
            _local8[0] = _local14.tileType;
        } else {
            _local8[0] = _local16.tileType;
        }
        if(_local12 < 0 && _local15 < 0) {
            _local3 = _local9.lookupSquare(_local7 + 1,_local10 - 1);
            _local8[1] = _local3 == null || _local3.props_.compositePriority_ < 0?255:_local3.tileType;
        } else if(_local12 < _local15) {
            _local8[1] = _local13.tileType;
        } else {
            _local8[1] = _local16.tileType;
        }
        if(_local17 < 0 && _local2 < 0) {
            _local6 = _local9.lookupSquare(_local7 - 1,_local10 + 1);
            _local8[2] = _local6 == null || _local6.props_.compositePriority_ < 0?255:_local6.tileType;
        } else if(_local17 < _local2) {
            _local8[2] = _local5.tileType;
        } else {
            _local8[2] = _local14.tileType;
        }
        if(_local15 < 0 && _local2 < 0) {
            _local11 = _local9.lookupSquare(_local7 + 1,_local10 + 1);
            _local8[3] = _local11 == null || _local11.props_.compositePriority_ < 0?255:_local11.tileType;
        } else if(_local15 < _local2) {
            _local8[3] = _local5.tileType;
        } else {
            _local8[3] = _local13.tileType;
        }
        return _local8;
    }

    private static function buildComposite(_arg_1:Array) : BitmapData {
        var _local3:* = null;
        var _local2:BitmapData = new BitmapData(8,8,false,0);
        if(_arg_1[0] != 255) {
            _local3 = GroundLibrary.getBitmapData(_arg_1[0]);
            _local2.copyPixels(_local3,RECT0,POINT0);
        }
        if(_arg_1[1] != 255) {
            _local3 = GroundLibrary.getBitmapData(_arg_1[1]);
            _local2.copyPixels(_local3,RECT1,POINT1);
        }
        if(_arg_1[2] != 255) {
            _local3 = GroundLibrary.getBitmapData(_arg_1[2]);
            _local2.copyPixels(_local3,RECT2,POINT2);
        }
        if(_arg_1[3] != 255) {
            _local3 = GroundLibrary.getBitmapData(_arg_1[3]);
            _local2.copyPixels(_local3,RECT3,POINT3);
        }
        return _local2;
    }

    private static function getEdgeSig(_arg_1:Square) : Array {
        var _local9:* = 0;
        var _local11:Boolean = false;
        var _local8:Boolean = false;
        var _local12:Square = null;
        var _local4:* = [];
        var _local2:Map = _arg_1.map;
        var _local7:Boolean = _arg_1.props_.sameTypeEdgeMode_;
        var _local10:int = _arg_1.y_ - 1;
        var _local6:int = _arg_1.y_ + 1;
        var _local5:int = _arg_1.x_ - 1;
        var _local3:int = _arg_1.x_ + 1;
        while(_local10 <= _local6) {
            _local9 = _local5;
            while(_local9 <= _local3) {
                _local12 = _local2.lookupSquare(_local9,_local10);
                if(_local9 == _arg_1.x_ && _local10 == _arg_1.y_) {
                    _local4.push(_local12.tileType);
                } else {
                    if(_local7) {
                        _local11 = _local12 == null || _local12.tileType == _arg_1.tileType;
                    } else {
                        _local11 = _local12 == null || _local12.tileType != 255;
                    }
                    _local4.push(_local11);
                    _local8 = _local8 || !_local11;
                }
                _local9++;
            }
            _local10++;
        }
        return !!_local8?_local4:null;
    }

    private static function drawEdges(_arg_1:Array) : BitmapData {
        var _local2:BitmapData = GroundLibrary.getBitmapData(_arg_1[4]);
        var _local6:BitmapData = _local2.clone();
        var _local3:GroundProperties = GroundLibrary.propsLibrary_[_arg_1[4]];
        var _local7:Vector.<BitmapData> = _local3.getEdges();
        var _local5:Vector.<BitmapData> = _local3.getInnerCorners();
        var _local4:int = 1;
        while(_local4 < 8) {
            if(!_arg_1[_local4]) {
                _local6.copyPixels(_local7[_local4],_local7[_local4].rect,PointUtil.ORIGIN,null,null,true);
            }
            _local4 = _local4 + 2;
        }
        if(_local7[0]) {
            if(_arg_1[3] && _arg_1[1] && !_arg_1[0]) {
                _local6.copyPixels(_local7[0],_local7[0].rect,PointUtil.ORIGIN,null,null,true);
            }
            if(_arg_1[1] && _arg_1[5] && !_arg_1[2]) {
                _local6.copyPixels(_local7[2],_local7[2].rect,PointUtil.ORIGIN,null,null,true);
            }
            if(_arg_1[5] && _arg_1[7] && !_arg_1[8]) {
                _local6.copyPixels(_local7[8],_local7[8].rect,PointUtil.ORIGIN,null,null,true);
            }
            if(_arg_1[3] && _arg_1[7] && !_arg_1[6]) {
                _local6.copyPixels(_local7[6],_local7[6].rect,PointUtil.ORIGIN,null,null,true);
            }
        }
        if(_local5) {
            if(!_arg_1[3] && !_arg_1[1]) {
                _local6.copyPixels(_local5[0],_local5[0].rect,PointUtil.ORIGIN,null,null,true);
            }
            if(!_arg_1[1] && !_arg_1[5]) {
                _local6.copyPixels(_local5[2],_local5[2].rect,PointUtil.ORIGIN,null,null,true);
            }
            if(!_arg_1[5] && !_arg_1[7]) {
                _local6.copyPixels(_local5[8],_local5[8].rect,PointUtil.ORIGIN,null,null,true);
            }
            if(!_arg_1[3] && !_arg_1[7]) {
                _local6.copyPixels(_local5[6],_local5[6].rect,PointUtil.ORIGIN,null,null,true);
            }
        }
        return _local6;
    }
}
}