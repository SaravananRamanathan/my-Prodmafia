package com.company.assembleegameclient.map {
public class AnimateProperties {

    public static const NO_ANIMATE:int = 0;

    public static const WAVE_ANIMATE:int = 1;

    public static const FLOW_ANIMATE:int = 2;

    public function AnimateProperties() {
        super();
    }
    public var type_:int = 0;
    public var dx_:Number = 0;
    public var dy_:Number = 0;

    public function parseXML(_arg_1:XML):void {
        var _local2:String = _arg_1;
        switch (_local2) {
            case "Wave":
                this.type_ = 1;
                break;
            case "Flow":
                this.type_ = 2;
        }
        this.dx_ = _arg_1.@dx;
        this.dy_ = _arg_1.@dy;
    }
}
}
