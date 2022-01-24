package kabam.rotmg.arena.view {
import flash.events.TimerEvent;
import flash.utils.Timer;

import kabam.rotmg.arena.control.ArenaDeathSignal;
import kabam.rotmg.arena.control.ImminentArenaWaveSignal;

import robotlegs.bender.bundles.mvcs.Mediator;

public class ArenaTimerMediator extends Mediator {


    public function ArenaTimerMediator() {
        delayTimer = new Timer(100 * 60);
        super();
    }
    [Inject]
    public var view:ArenaTimer;
    [Inject]
    public var imminentWave:ImminentArenaWaveSignal;
    [Inject]
    public var arenaDeath:ArenaDeathSignal;
    private var delayTimer:Timer;

    override public function initialize():void {
        this.imminentWave.add(this.startView);
        this.arenaDeath.add(this.onArenaDeath);
        this.delayTimer.addEventListener("timer", this.onRestart);
    }

    override public function destroy():void {
        this.imminentWave.remove(this.startView);
        this.arenaDeath.remove(this.onArenaDeath);
        this.view.stop();
    }

    private function onArenaDeath():void {
        this.view.stop();
    }

    private function startView(_arg_1:int):void {
        this.delayTimer.start();
        this.view.stop();
    }

    private function onRestart(_arg_1:TimerEvent):void {
        this.delayTimer.stop();
        this.view.start();
        this.view.x = 300 - this.view.width / 2;
    }
}
}
