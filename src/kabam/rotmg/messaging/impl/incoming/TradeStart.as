 
package kabam.rotmg.messaging.impl.incoming {
import com.company.assembleegameclient.util.FreeList;

import flash.utils.IDataInput;

import kabam.rotmg.messaging.impl.data.TradeItem;

public class TradeStart extends IncomingMessage {
       
      
      public var myItems_:Vector.<TradeItem>;
      
      public var yourName_:String;
      
      public var yourItems_:Vector.<TradeItem>;

      public function TradeStart(param1:uint, param2:Function) {
         this.myItems_ = new Vector.<TradeItem>();
         this.yourItems_ = new Vector.<TradeItem>();
         super(param1,param2);
      }
      
      override public function parseFromInput(param1:IDataInput) : void {
         var _local3:* = 0;
         var _local2:int = param1.readShort();
         _local3 = _local2;
         while(_local3 < this.myItems_.length) {
            FreeList.deleteObject(this.myItems_[_local3]);
            _local3++;
         }
         this.myItems_.length = Math.min(_local2,this.myItems_.length);
         while(this.myItems_.length < _local2) {
            this.myItems_.push(FreeList.newObject(TradeItem) as TradeItem);
         }
         _local3 = 0;
         while(_local3 < _local2) {
            this.myItems_[_local3].parseFromInput(param1);
            _local3++;
         }
         this.yourName_ = param1.readUTF();
         _local2 = param1.readShort();
         _local3 = _local2;
         while(_local3 < this.yourItems_.length) {
            FreeList.deleteObject(this.yourItems_[_local3]);
            _local3++;
         }
         this.yourItems_.length = Math.min(_local2,this.yourItems_.length);
         while(this.yourItems_.length < _local2) {
            this.yourItems_.push(FreeList.newObject(TradeItem) as TradeItem);
         }
         _local3 = 0;
         while(_local3 < _local2) {
            this.yourItems_[_local3].parseFromInput(param1);
            _local3++;
         }
      }
      
      override public function toString() : String {
         return formatToString("TRADESTART","myItems_","yourName_","yourItems_");
      }
   }
}
