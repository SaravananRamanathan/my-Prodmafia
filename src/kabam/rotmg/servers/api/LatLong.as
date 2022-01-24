package kabam.rotmg.servers.api {
public final class LatLong {

    private static const TO_DEGREES:Number = 57.2957795130823;

    private static const TO_RADIANS:Number = 0.0174532925199433;

    private static const DISTANCE_SCALAR:Number = 111189.57696;

    public static function distance(_arg_1:LatLong, _arg_2:LatLong):Number {
        var _local6:Number = 0.0174532925199433 * (_arg_1.longitude - _arg_2.longitude);
        var _local4:Number = 0.0174532925199433 * _arg_1.latitude;
        var _local3:Number = 0.0174532925199433 * _arg_2.latitude;
        var _local5:Number = Math.sin(_local4) * Math.sin(_local3) + Math.cos(_local4) * Math.cos(_local3) * Math.cos(_local6);
        _local5 = 57.2957795130823 * Math.acos(_local5) * 111189.57696;
        return _local5;
    }

    public function LatLong(_arg_1:Number, _arg_2:Number) {
        super();
        this.latitude = _arg_1;
        this.longitude = _arg_2;
    }
    public var latitude:Number;
    public var longitude:Number;

    public function toString():String {
        return "(" + this.latitude + ", " + this.longitude + ")";
    }
}
}
