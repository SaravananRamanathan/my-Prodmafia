package kabam.rotmg.util.graphics {
import flash.display.Graphics;

public class GraphicsHelper {


    public function GraphicsHelper() {
        super();
    }

    public function drawBevelRect(_arg_1:int, _arg_2:int, _arg_3:BevelRect, _arg_4:Graphics):void {
        var _local7:int = _arg_1 + _arg_3.width;
        var _local6:int = _arg_2 + _arg_3.height;
        var _local5:int = _arg_3.bevel;
        if (_arg_3.topLeftBevel) {
            _arg_4.moveTo(_arg_1, _arg_2 + _local5);
            _arg_4.lineTo(_arg_1 + _local5, _arg_2);
        } else {
            _arg_4.moveTo(_arg_1, _arg_2);
        }
        if (_arg_3.topRightBevel) {
            _arg_4.lineTo(_local7 - _local5, _arg_2);
            _arg_4.lineTo(_local7, _arg_2 + _local5);
        } else {
            _arg_4.lineTo(_local7, _arg_2);
        }
        if (_arg_3.bottomRightBevel) {
            _arg_4.lineTo(_local7, _local6 - _local5);
            _arg_4.lineTo(_local7 - _local5, _local6);
        } else {
            _arg_4.lineTo(_local7, _local6);
        }
        if (_arg_3.bottomLeftBevel) {
            _arg_4.lineTo(_arg_1 + _local5, _local6);
            _arg_4.lineTo(_arg_1, _local6 - _local5);
        } else {
            _arg_4.lineTo(_arg_1, _local6);
        }
    }
}
}
