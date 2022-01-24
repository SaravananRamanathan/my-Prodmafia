package kabam.lib.ui {
import flash.events.Event;
import flash.events.IEventDispatcher;
import flash.utils.Dictionary;

import org.osflash.signals.Signal;

public class GroupMappedSignal extends Signal {

    public function GroupMappedSignal(eventType: String, ...rest) {
        this.eventType = eventType;
        this.mappedTargets = new Dictionary(true);
        super(rest);
    }

    private var eventType:String;
    private var mappedTargets:Dictionary;

    public function map(event: IEventDispatcher, func:*):void {
        this.mappedTargets[event] = func;
        event.addEventListener(this.eventType, this.onTarget, false, 0, true);
    }

    private function onTarget(event: Event):void {
        dispatch(this.mappedTargets[event.target]);
    }
}
}
