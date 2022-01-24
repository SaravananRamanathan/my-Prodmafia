package kabam.rotmg.servers.control {
import kabam.rotmg.servers.api.Server;
import kabam.rotmg.servers.api.ServerModel;

public class ParseServerDataCommand {


    public static function makeLocalhostServer():Server {
        return new Server().setName("Proxy").setAddress("127.0.0.1").setPort(2050).setLatLong(Infinity, Infinity).setUsage(0).setIsAdminOnly(false);
    }

    public function ParseServerDataCommand() {
        super();
    }
    [Inject]
    public var servers:ServerModel;
    [Inject]
    public var data:XML;

    public function execute():void {
        this.servers.setServers(this.makeListOfServers());
    }

    private function makeListOfServers():Vector.<Server> {
        var _local1:* = null;
        var _local3:XMLList = this.data.child("Servers").child("Server");
        var _local2:Vector.<Server> = new Vector.<Server>(0);
        _local2.push(makeLocalhostServer());
        for each(_local1 in _local3) {
            _local2.push(this.makeServer(_local1));
        }
        return _local2;
    }

    private function makeServer(_arg_1:XML):Server {
        return new Server().setName(_arg_1.Name).setAddress(_arg_1.DNS).setPort(2050).setLatLong(_arg_1.Lat, _arg_1.Long).setUsage(_arg_1.Usage).setIsAdminOnly("AdminOnly" in _arg_1);
    }
}
}
