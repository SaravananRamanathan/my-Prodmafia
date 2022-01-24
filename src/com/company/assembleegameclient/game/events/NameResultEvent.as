package com.company.assembleegameclient.game.events {
import flash.events.Event;

import kabam.rotmg.messaging.impl.incoming.NameResult;

public class NameResultEvent extends Event {

    public static const NAMERESULTEVENT:String = "NAMERESULTEVENT";

    public function NameResultEvent(_arg_1:NameResult) {
        super("NAMERESULTEVENT");
        this.m_ = _arg_1;
    }
    public var m_:NameResult;
}
}
