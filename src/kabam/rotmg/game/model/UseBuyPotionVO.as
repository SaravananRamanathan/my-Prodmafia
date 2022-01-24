package kabam.rotmg.game.model {
public class UseBuyPotionVO {

    public static var SHIFTCLICK:String = "shift_click";

    public static var CONTEXTBUY:String = "context_buy";

    public function UseBuyPotionVO(_arg_1:int, _arg_2:String) {
        super();
        this.objectId = _arg_1;
        this.source = _arg_2;
    }
    public var objectId:int;
    public var source:String;
}
}
