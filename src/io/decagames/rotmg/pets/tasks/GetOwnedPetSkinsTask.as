package io.decagames.rotmg.pets.tasks {
    import com.company.util.MoreObjectUtil;
    
    import io.decagames.rotmg.pets.data.PetsModel;
    import io.decagames.rotmg.seasonalEvent.data.SeasonalEventModel;
    
    import kabam.lib.tasks.BaseTask;
    import kabam.rotmg.account.core.Account;
    import kabam.rotmg.appengine.api.AppEngineClient;
    
    import robotlegs.bender.framework.api.ILogger;
    
    public class GetOwnedPetSkinsTask extends BaseTask {
        
        
        public function GetOwnedPetSkinsTask() {
            super();
        }
        
        [Inject]
        public var account: Account;
        [Inject]
        public var client: AppEngineClient;
        [Inject]
        public var logger: ILogger;
        [Inject]
        public var petModel: PetsModel;
        [Inject]
        public var seasonalEventModel: SeasonalEventModel;
        
        override protected function startTask(): void {
            this.logger.info("GetOwnedPetSkinsTask start");
            if (!this.account.isRegistered()) {
                this.logger.info("Guest account - skip skins check");
                completeTask(true, "");
            } else {
                this.client.complete.addOnce(this.onComplete);
                this.client.sendRequest("/account/getOwnedPetSkins", this.makeDataPacket());
            }
        }
        
        private function makeDataPacket(): Object {
            var _local1: * = {};
            MoreObjectUtil.addToObject(_local1, this.account.getCredentials());
            _local1.isChallenger = this.seasonalEventModel.isChallenger;
            return _local1;
        }
        
        private function onComplete(_arg_1: Boolean, _arg_2: *): void {
            var _local3: * = _arg_1;
            var _local4: * = _arg_2;
            _local3 = _local3 || _local4 == "<Success/>";
            if (_local3) {
                try {
                    this.petModel.parseOwnedSkins(XML(_local4));
                } catch (e: Error) {
                    logger.error(e.message + " " + e.getStackTrace());
                }
                this.petModel.parsePetsData();
            }
            completeTask(_local3, _local4);
        }
    }
}
