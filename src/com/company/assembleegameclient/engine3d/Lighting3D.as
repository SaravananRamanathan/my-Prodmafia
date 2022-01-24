package com.company.assembleegameclient.engine3d {
import flash.geom.Vector3D;

public class Lighting3D {

    public static const LIGHT_VECTOR:Vector3D = createLightVector();

    public static function shadeValue(_arg_1:Vector3D, _arg_2:Number):Number {
        var _local3:Number = Math.max(0, _arg_1.dotProduct(Lighting3D.LIGHT_VECTOR));
        return _arg_2 + (1 - _arg_2) * _local3;
    }

    private static function createLightVector():Vector3D {
        var _local1:Vector3D = new Vector3D(1, 3, 2);
        _local1.normalize();
        return _local1;
    }

    public function Lighting3D() {
        super();
    }
}
}
