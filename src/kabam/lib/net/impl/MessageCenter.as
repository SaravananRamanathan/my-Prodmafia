package kabam.lib.net.impl {
import kabam.lib.net.api.MessageMap;
import kabam.lib.net.api.MessageMapping;
import kabam.lib.net.api.MessageProvider;

import org.swiftsuspenders.Injector;

public class MessageCenter implements MessageMap, MessageProvider {

    private static const MAX_ID:int = 256;
    private const maps:Vector.<MessageCenterMapping> = new Vector.<MessageCenterMapping>(MAX_ID, true);
    private const pools:Vector.<MessagePool> = new Vector.<MessagePool>(MAX_ID, true);
    private var injector:Injector;

    public function MessageCenter() {
        super();
    }

    public function setInjector(injector: Injector) : MessageCenter {
        this.injector = injector;
        return this;
    }

    public function map(packetId: int) : MessageMapping {
        var packetMap: * = this.maps[packetId] || this.makeMapping(packetId);
        this.maps[packetId] = packetMap;
        return packetMap;
    }

    public function unmap(packetId: int) : void {
        this.pools[packetId] && this.pools[packetId].dispose();
        this.pools[packetId] = null;
        this.maps[packetId] = null;
    }

    public function require(packetId: int) : Message {
        var packetPool: * = this.pools[packetId] || this.makePool(packetId);
        this.pools[packetId] = packetPool;
        var newPool: * = packetPool;
        if (!newPool) {
            trace('Could not find a packet mapping for packet ID: ' + packetId);
        }
        return newPool.require();
    }

    private function makeMapping(packetId: int): MessageCenterMapping {
        return new MessageCenterMapping().setInjector(this.injector).setID(packetId) as MessageCenterMapping;
    }

    private function makePool(packetId: uint) : MessagePool {
        var packetMap: MessageCenterMapping = this.maps[packetId];
        return !!packetMap ? packetMap.makePool() : null;
    }
}
}
