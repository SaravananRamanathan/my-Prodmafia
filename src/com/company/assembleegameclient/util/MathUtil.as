package com.company.assembleegameclient.util {
public class MathUtil {

    public static const TO_DEG:Number = 57.2957795130823;

    public static const TO_RAD:Number = 0.0174532925199433;

    public static function round(_arg_1:Number, _arg_2:int = 0):Number {
        _arg_2 = Math.pow(10, _arg_2);
        return Math.round(_arg_1 * _arg_2) / _arg_2;
    }

    public function MathUtil() {
        super();
    }
}
}
