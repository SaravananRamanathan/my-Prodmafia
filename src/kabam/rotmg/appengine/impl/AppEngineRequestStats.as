package kabam.rotmg.appengine.impl {
import kabam.lib.console.signals.ConsoleWatchSignal;

public class AppEngineRequestStats {


    private const nameMap:Object = {};

    public function AppEngineRequestStats() {
        super();
    }
    [Inject]
    public var watch:ConsoleWatchSignal;

    public function recordStats(_arg_1:String, _arg_2:Boolean, _arg_3:int):void {
        var _local4:* = this.nameMap[_arg_1] || new StatsWatch(_arg_1);
        this.nameMap[_arg_1] = _local4;
        var _local5:StatsWatch = _local4;
        _local5.addResponse(_arg_2, _arg_3);
        this.watch.dispatch(_local5);
    }
}
}

import kabam.lib.console.model.Watch;

class StatsWatch extends Watch {

    private static const STATS_PATTERN:String = "[APPENGINE STATS] [0xFFEE00:{/x={MEAN}ms, ok={OK}/{COUNT}} {NAME}]";

    private static const MEAN:String = "{MEAN}";

    private static const COUNT:String = "{COUNT}";

    private static const OK:String = "{OK}";

    private static const NAME:String = "{NAME}";

    function StatsWatch(_arg_1:String) {
        super(_arg_1, "");
        this.count = 0;
        this.ok = 0;
        this.time = 0;
    }
    private var count:int;
    private var time:int;
    private var mean:int;
    private var ok:int;

    public function addResponse(_arg_1:Boolean, _arg_2:int):void {
        _arg_1 && _local3;
        this.time = this.time + _arg_2;
        var _local3:* = this.count + 1;
        this.count++;
        this.mean = this.time / _local3;
        data = this.report();
    }

    private function report():String {
        return "[APPENGINE STATS] [0xFFEE00:{/x={MEAN}ms, ok={OK}/{COUNT}} {NAME}]".replace("{MEAN}", this.mean).replace("{COUNT}", this.count).replace("{OK}", this.ok).replace("{NAME}", name);
    }
}
