package io.decagames.rotmg.pets.commands {
    import io.decagames.rotmg.pets.data.PetsModel;
    
    import kabam.lib.net.api.MessageProvider;
    import kabam.lib.net.impl.SocketServer;
    import kabam.rotmg.messaging.impl.outgoing.ActivePetUpdateRequest;
    
    import robotlegs.bender.bundles.mvcs.Command;
    
    public class DeactivatePetCommand extends Command {
        
        
        public function DeactivatePetCommand() {
            super();
        }
        
        [Inject]
        public var instanceID: uint;
        [Inject]
        public var messages: MessageProvider;
        [Inject]
        public var server: SocketServer;
        [Inject]
        public var model: PetsModel;
        
        override public function execute(): void {
            var _local1: ActivePetUpdateRequest = this.messages.require(24) as ActivePetUpdateRequest;
            _local1.instanceid = this.instanceID;
            _local1.commandtype = 2;
            this.server.sendMessage(_local1);
        }
    }
}
