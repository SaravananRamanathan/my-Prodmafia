package kabam.lib.json {
import com.hurlant.util.Base64;

public class Base64Decoder {

    public function Base64Decoder() {
        super();
    }

    public function decode(string: String):String {
        var _local2:RegExp = /-/g;
        var _local4:RegExp = /_/g;
        var _local3:int = 4 - string.length % 4;
        while (true) {
            _local3--;
            if (!_local3) {
                break;
            }
            string = string + "=";
        }
        string = string.replace(_local2, "+").replace(_local4, "/");
        return Base64.decode(string);
    }
}
}
