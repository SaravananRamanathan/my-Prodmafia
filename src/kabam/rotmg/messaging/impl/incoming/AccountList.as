 
package kabam.rotmg.messaging.impl.incoming {
import flash.utils.IDataInput;

public class AccountList extends IncomingMessage {
       
      
      public var accountListId_:int;
      
      public var accountIds_:Vector.<String>;
      
      public var lockAction_:int = -1;
      
      public function AccountList(param1:uint, param2:Function) {
         this.accountIds_ = new Vector.<String>();
         super(param1,param2);
      }
      
      override public function parseFromInput(param1:IDataInput) : void {
         this.accountListId_ = param1.readInt();
         this.accountIds_.length = 0;
         var _local3:int = param1.readShort();
         var _local2:int = 0;
         while(_local2 < _local3) {
            this.accountIds_.push(param1.readUTF());
            _local2++;
         }
         this.lockAction_ = param1.readInt();
      }
      
      override public function toString() : String {
         return formatToString("ACCOUNTLIST","accountListId_","accountIds_","lockAction_");
      }
   }
}
