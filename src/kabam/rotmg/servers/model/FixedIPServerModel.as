package kabam.rotmg.servers.model {
import kabam.rotmg.servers.api.Server;
import kabam.rotmg.servers.api.ServerModel;

public class FixedIPServerModel implements ServerModel {


    public function FixedIPServerModel() {
        super();
        this.localhost = new Server().setName("localhost").setPort(2050);
    }
    private var localhost:Server;

    public function setIP(_arg_1:String):FixedIPServerModel {
        this.localhost.setAddress(_arg_1);
        return this;
    }

    public function getServers():Vector.<Server> {
        return new <Server>[this.localhost];
    }

    public function getServer():Server {
        return this.localhost;
    }

    public function isServerAvailable():Boolean {
        return true;
    }

    public function setServers(_arg_1:Vector.<Server>):void {
    }

    public function setAvailableServers(_arg_1:int):void {
    }

    public function getAvailableServers():Vector.<Server> {
        return new <Server>[this.localhost];
    }
}
}
