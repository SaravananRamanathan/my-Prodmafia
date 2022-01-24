package io.decagames.rotmg.supportCampaign.data.vo {
public class RankVO {


    public function RankVO(_arg_1:int, _arg_2:String) {
        super();
        this._points = _arg_1;
        this._name = _arg_2;
    }

    private var _points:int;

    public function get points():int {
        return this._points;
    }

    private var _name:String;

    public function get name():String {
        return this._name;
    }
}
}
