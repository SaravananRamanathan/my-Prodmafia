 
package kabam.rotmg.account.core.services {
import com.company.util.MoreObjectUtil;

import kabam.lib.tasks.BaseTask;
import kabam.rotmg.account.core.Account;
import kabam.rotmg.appengine.api.AppEngineClient;
import kabam.rotmg.core.model.PlayerModel;

import robotlegs.bender.framework.api.ILogger;

public class GetIgnoreListTask extends BaseTask {
       
      
      [Inject]
      public var account:Account;
      
      [Inject]
      public var client:AppEngineClient;
      
      [Inject]
      public var model:PlayerModel;
      
      [Inject]
      public var logger:ILogger;
      
      private var requestData:Object;
      
      public function GetIgnoreListTask() {
         super();
      }
      
      override protected function startTask() : void {
         this.logger.info("GetIgnoreListTask start");
         this.requestData = this.makeRequestData();
         sendRequest();
      }
      
      public function makeRequestData() : Object {
         var _local1:Object = {};
         _local1.game_net_user_id = this.account.gameNetworkUserId();
         _local1.game_net = this.account.gameNetwork();
         _local1.play_platform = this.account.playPlatform();
         _local1.type = 1;
         MoreObjectUtil.addToObject(_local1,this.account.getCredentials());
         return _local1;
      }
      
      private function sendRequest() : void {
         this.client.complete.addOnce(this.onComplete);
         this.client.sendRequest("/account/list",this.requestData);
      }
      
      private function onComplete(param1:Boolean, param2:*) : void {
         if(param1) {
            this.onListComplete(param2);
         } else {
            model.ignoreList = new Vector.<String>(0);
         }
         completeTask(true);
      }
      
      private function onListComplete(param1:String) : void {
         var _local2:* = null;
         var _local4:* = undefined;
         var _local3:XML = new XML(param1);
         if("IgnoredAccounts" in _local3) {
            _local2 = _local3.IgnoredAccounts[0];
            _local4 = Vector.<String>(_local2.split(","));
            model.ignoreList = _local4;
         } else {
            model.ignoreList = new Vector.<String>(0);
         }
      }
   }
}
