 
package kabam.rotmg.messaging.impl.outgoing {
import flash.utils.IDataOutput;

import kabam.rotmg.messaging.impl.data.MoveRecord;
import kabam.rotmg.messaging.impl.data.WorldPosData;

public class Move extends OutgoingMessage {
       
      
      public var tickId_:int;
      
      public var time_:int;
      
      public var serverRealTimeMSofLastNewTick_:uint;
      
      public var newPosition_:WorldPosData;
      
      public var records_:Vector.<MoveRecord>;
      
      public function Move(param1:uint, param2:Function) {
         this.newPosition_ = new WorldPosData();
         this.records_ = new Vector.<MoveRecord>();
         super(param1,param2);
      }
      
      override public function writeToOutput(param1:IDataOutput) : void {
         var _local3:* = 0;
         param1.writeInt(this.tickId_);
         param1.writeInt(this.time_);
         param1.writeUnsignedInt(this.serverRealTimeMSofLastNewTick_);
         this.newPosition_.writeToOutput(param1);
         var _local2:uint = this.records_.length;
         param1.writeShort(_local2);
         _local3 = uint(0);
         while(_local3 < _local2) {
            this.records_[_local3].writeToOutput(param1);
            _local3++;
         }
      }
      
      override public function toString() : String {
         return formatToString("MOVE","tickId_","time_","serverRealTimeMSofLastNewTick_","newPosition_","records_");
      }
   }
}
