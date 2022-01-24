 
package kabam.rotmg.messaging.impl.incoming {
import com.company.assembleegameclient.util.FreeList;

import flash.utils.IDataInput;

import kabam.rotmg.messaging.impl.data.ObjectStatusData;

public class NewTick extends IncomingMessage {
       
      
      public var tickId_:int;
      
      public var tickTime_:int;
      
      public var serverRealTimeMS_:uint;
      
      public var serverLastRTTMS_:uint;
      
      public var statuses_:Vector.<ObjectStatusData>;
      
      public function NewTick(param1:uint, param2:Function) {
         this.statuses_ = new Vector.<ObjectStatusData>();
         super(param1,param2);
      }
      
      override public function parseFromInput(param1:IDataInput) : void {
         var _local4:* = 0;
         this.tickId_ = param1.readInt();
         this.tickTime_ = param1.readInt();
         this.serverRealTimeMS_ = param1.readUnsignedInt();
         this.serverLastRTTMS_ = param1.readUnsignedShort();
         var _local2:int = param1.readShort();
         var _local3:uint = this.statuses_.length;
         _local4 = uint(_local2);
         while(_local4 < _local3) {
            FreeList.deleteObject(this.statuses_[_local4]);
            _local4++;
         }
         this.statuses_.length = Math.min(_local2,_local3);
         while(this.statuses_.length < _local2) {
            this.statuses_.push(FreeList.newObject(ObjectStatusData) as ObjectStatusData);
         }
         _local4 = uint(0);
         while(_local4 < _local2) {
            this.statuses_[_local4].parseFromInput(param1);
            _local4++;
         }
      }
      
      override public function toString() : String {
         return formatToString("NEW_TICK","tickId_","tickTime_","serverRealTimeMS_","serverLastRTTMS_","statuses_");
      }
   }
}
