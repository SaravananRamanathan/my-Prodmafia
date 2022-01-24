package io.decagames.rotmg.characterMetrics.data {
import flash.utils.Dictionary;

public class CharacterMetricsData {


    public function CharacterMetricsData() {
        super();
        this.stats = new Dictionary();
    }
    private var stats:Dictionary;

    public function setStat(_arg_1:int, _arg_2:int):void {
        this.stats[_arg_1] = _arg_2;
    }

    public function getStat(_arg_1:int):int {
        if (!this.stats[_arg_1]) {
            return 0;
        }
        return this.stats[_arg_1];
    }
}
}
