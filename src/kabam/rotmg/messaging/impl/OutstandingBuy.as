package kabam.rotmg.messaging.impl {
internal class OutstandingBuy {


    function OutstandingBuy(_arg_1:String, _arg_2:int, _arg_3:int, _arg_4:Boolean) {
        super();
        this.id_ = _arg_1;
        this.price_ = _arg_2;
        this.currency_ = _arg_3;
        this.converted_ = _arg_4;
    }
    private var id_:String;
    private var price_:int;
    private var currency_:int;
    private var converted_:Boolean;

    public function record():void {
        var _local1:* = this.currency_;
    }
}
}
