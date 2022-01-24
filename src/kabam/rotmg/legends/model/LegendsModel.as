package kabam.rotmg.legends.model {
public class LegendsModel {


    private const map:Object = {};

    public function LegendsModel() {
        timespan = Timespan.WEEK;
        super();
    }
    private var timespan:Timespan;

    public function getTimespan():Timespan {
        return this.timespan;
    }

    public function setTimespan(_arg_1:Timespan):void {
        this.timespan = _arg_1;
    }

    public function hasLegendList():Boolean {
        return this.map[this.timespan.getId()] != null;
    }

    public function getLegendList():Vector.<Legend> {
        return this.map[this.timespan.getId()];
    }

    public function setLegendList(_arg_1:Vector.<Legend>):void {
        this.map[this.timespan.getId()] = _arg_1;
    }

    public function clear():void {
        var _local1:* = undefined;
        var _local3:int = 0;
        var _local2:* = this.map;
        for (_local1 in this.map) {
            this.dispose(this.map[_local1]);
            delete this.map[_local1];
        }
    }

    private function dispose(_arg_1:Vector.<Legend>):void {
        var _local2:* = null;
        var _local4:int = 0;
        var _local3:* = _arg_1;
        for each(_local2 in _arg_1) {
            _local2.character && this.removeLegendCharacter(_local2);
        }
    }

    private function removeLegendCharacter(_arg_1:Legend):void {
        _arg_1.character.dispose();
        _arg_1.character = null;
    }
}
}
