package kabam.rotmg.stage3D.Object3D {
import flash.geom.Matrix3D;
import flash.utils.ByteArray;

public class Util {


    public static function perspectiveProjection(_arg_1:Number = 90, _arg_2:Number = 1, _arg_3:Number = 1, _arg_4:Number = 2048):Matrix3D {
        var _local6:Number = _arg_3 * Math.tan(_arg_1 * 0.00872664625997165);
        var _local11:Number = -_local6;
        var _local14:Number = _local11 * _arg_2;
        var _local8:Number = _local6 * _arg_2;
        var _local7:Number = 2 * _arg_3 / (_local8 - _local14);
        var _local9:Number = 2 * _arg_3 / (_local6 - _local11);
        var _local13:Number = (_local8 + _local14) / (_local8 - _local14);
        var _local10:Number = (_local6 + _local11) / (_local6 - _local11);
        var _local5:Number = -(_arg_4 + _arg_3) / (_arg_4 - _arg_3);
        var _local12:Number = -2 * (_arg_4 * _arg_3) / (_arg_4 - _arg_3);
        return new Matrix3D(Vector.<Number>([_local7, 0, 0, 0, 0, _local9, 0, 0, _local13, _local10, _local5, -1, 0, 0, _local12, 0]));
    }

    public static function readString(_arg_1:ByteArray, _arg_2:int):String {
        var _local4:int = 0;
        var _local3:* = 0;
        var _local5:String = "";
        _local4 = 0;
        while (_local4 < _arg_2) {
            _local3 = uint(_arg_1.readUnsignedByte());
            if (_local3 === 0) {
                _arg_1.position = _arg_1.position + Math.max(0, _arg_2 - (_local4 + 1));
                break;
            }
            _local5 = _local5 + String.fromCharCode(_local3);
            _local4++;
        }
        return _local5;
    }

    public static function upperPowerOfTwo(_arg_1:uint):uint {
        _arg_1--;
        _arg_1 = _arg_1 | _arg_1 >> 1;
        _arg_1 = _arg_1 | _arg_1 >> 2;
        _arg_1 = _arg_1 | _arg_1 >> 4;
        _arg_1 = _arg_1 | _arg_1 >> 8;
        _arg_1 = _arg_1 | _arg_1 >> 16;
        return _arg_1 + 1;
    }

    public function Util() {
        super();
    }
}
}
