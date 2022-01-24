package io.decagames.rotmg.pets.commands {
    import com.company.assembleegameclient.editor.Command;
    
    import kabam.lib.net.api.MessageProvider;
    import kabam.lib.net.impl.SocketServer;
    import kabam.rotmg.messaging.impl.outgoing.ActivePetUpdateRequest;
    
    public class ReleasePetCommand extends Command {
        
        
        public function ReleasePetCommand() {
            super();
        }
        
        [Inject]
        public var messages: MessageProvider;
        [Inject]
        public var server: SocketServer;
        [Inject]
        public var instanceID: int;
        
        override public function execute(): void {
            var _local1: ActivePetUpdateRequest = this.messages.require(24) as ActivePetUpdateRequest;
            _local1.instanceid = this.instanceID;
            _local1.commandtype = 3;
            this.server.sendMessage(_local1);
        }
    }
}
