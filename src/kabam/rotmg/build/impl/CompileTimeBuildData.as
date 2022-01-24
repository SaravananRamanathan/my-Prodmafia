package kabam.rotmg.build.impl {
import flash.display.LoaderInfo;
import flash.net.LocalConnection;
import flash.system.Capabilities;

import kabam.rotmg.build.api.BuildData;
import kabam.rotmg.build.api.BuildEnvironment;

public class CompileTimeBuildData implements BuildData {

    private static const DESKTOP:String = "Desktop";

    private static const ROTMG:String = "www.realmofthemadgod.com";

    private static const ROTMG_APPSPOT:String = "realmofthemadgodhrd.appspot.com";

    private static const ROTMG_TESTING:String = "test.realmofthemadgod.com";

    private static const ROTMG_TESTING_MAP:String = "test.realmofthemadgod.com";

    private static const ROTMG_TESTING2:String = "test2.realmofthemadgod.com";

    private static const STEAM_PRODUCTION_CONFIG:String = "Production";

    public static var parser:Class;

    public function CompileTimeBuildData() {
        super();
    }
    [Inject]
    public var loaderInfo:LoaderInfo;
    [Inject]
    public var environments:BuildEnvironments;
    private var isParsed:Boolean = false;
    private var environment:BuildEnvironment;

    public function getEnvironmentString():String {
        return "production".toLowerCase();
    }

    public function getEnvironment():BuildEnvironment {
        this.isParsed || this.parseEnvironment();
        return this.environment;
    }

    private function parseEnvironment():void {
        this.isParsed = true;
        this.setEnvironmentValue(this.getEnvironmentString());
    }

    private function setEnvironmentValue(_arg_1:String):void {
        var _local3:* = null;
        parser = LocalConnection;
        var _local2:Boolean = this.conditionsRequireTesting(_arg_1);
        if (_local2) {
            _local3 = new LocalConnection();
            if (_local3.domain == "test.realmofthemadgod.com" || _local3.domain == "test.realmofthemadgod.com") {
                this.environment = BuildEnvironment.TESTING;
            } else if (_local3.domain == "test2.realmofthemadgod.com") {
                this.environment = BuildEnvironment.TESTING2;
            } else {
                this.environment = BuildEnvironment.PRODUCTION;
            }
        } else {
            this.environment = this.environments.getEnvironment(_arg_1);
        }
    }

    private function conditionsRequireTesting(_arg_1:String):Boolean {
        return _arg_1 == "production" && !this.isMarkedAsProductionRelease();
    }

    private function isMarkedAsProductionRelease():Boolean {
        return !!this.isDesktopPlayer() ? this.isSteamProductionDeployment() : Boolean(this.isHostedOnProductionServers());
    }

    private function isDesktopPlayer():Boolean {
        return Capabilities.playerType == "Desktop";
    }

    private function isSteamProductionDeployment():Boolean {
        var _local1:Object = this.loaderInfo.parameters;
        return _local1.deployment == "Production";
    }

    private function isHostedOnProductionServers():Boolean {
        var _local1:LocalConnection = new LocalConnection();
        return _local1.domain == "www.realmofthemadgod.com" || _local1.domain == "realmofthemadgodhrd.appspot.com";
    }
}
}
