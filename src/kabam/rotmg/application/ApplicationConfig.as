package kabam.rotmg.application {
import flash.display.DisplayObjectContainer;

import kabam.rotmg.application.api.ApplicationSetup;
import kabam.rotmg.application.api.DebugSetup;
import kabam.rotmg.application.impl.ProductionSetup;
import kabam.rotmg.application.model.PlatformModel;
import kabam.rotmg.build.api.BuildData;

import org.swiftsuspenders.Injector;

import robotlegs.bender.framework.api.IConfig;

public class ApplicationConfig implements IConfig {
    public function ApplicationConfig() {
        super();
    }
    [Inject]
    public var injector:Injector;
    [Inject]
    public var root:DisplayObjectContainer;
    [Inject]
    public var data:BuildData;

    public function configure():void {
        var _local1:ApplicationSetup = new ProductionSetup();
        this.injector.map(DebugSetup).toValue(_local1);
        this.injector.map(ApplicationSetup).toValue(_local1);
        this.injector.map(PlatformModel).asSingleton();
    }
}
}
